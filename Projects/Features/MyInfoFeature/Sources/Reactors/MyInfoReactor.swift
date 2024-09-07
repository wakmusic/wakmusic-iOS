import BaseFeature
import Foundation
import Localization
import LogManager
import NoticeDomainInterface
import ReactorKit
import UserDomainInterface
import Utility

final class MyInfoReactor: Reactor {
    enum Action {
        case viewDidLoad
        case loginButtonDidTap
        case profileImageDidTap
        case drawButtonDidTap
        case fruitNavigationDidTap
        case faqNavigationDidTap
        case notiNavigationDidTap
        case mailNavigationDidTap
        case teamNavigationDidTap
        case settingNavigationDidTap
        case completedFruitDraw
        case completedSetProfile
        case changeNicknameButtonDidTap(String)
        case requiredLogin(CommonAnalyticsLog.LoginButtonEntry)
    }

    enum Mutation {
        case loginButtonDidTap
        case profileImageDidTap
        case navigate(NavigateType?)
        case updateIsLoggedIn(Bool)
        case updateProfileImage(String)
        case updateNickname(String)
        case updatePlatform(String)
        case updateFruitCount(Int)
        case updateIsAllNoticesRead(Bool)
        case showToast(String)
        case dismissEditSheet
    }

    enum NavigateType {
        case draw
        case fruit
        case faq
        case noti
        case mail
        case team
        case setting
        case login(entry: CommonAnalyticsLog.LoginButtonEntry)
    }

    struct State {
        var isLoggedIn: Bool
        var profileImage: String
        var nickname: String
        var platform: String
        var fruitCount: Int
        var isAllNoticesRead: Bool
        @Pulse var loginButtonDidTap: Bool?
        @Pulse var profileImageDidTap: Bool?
        @Pulse var navigateType: NavigateType?
        @Pulse var showToast: String?
        @Pulse var dismissEditSheet: Bool?
    }

    var initialState: State
    private let fetchNoticeIDListUseCase: any FetchNoticeIDListUseCase
    private let setUsernameUseCase: any SetUserNameUseCase
    private let fetchUserInfoUseCase: any FetchUserInfoUseCase
    private let myInfoCommonService: any MyInfoCommonService
    private let disposeBag = DisposeBag()

    init(
        fetchNoticeIDListUseCase: any FetchNoticeIDListUseCase,
        setUserNameUseCase: any SetUserNameUseCase,
        fetchUserInfoUseCase: any FetchUserInfoUseCase,
        myInfoCommonService: any MyInfoCommonService = DefaultMyInfoCommonService.shared
    ) {
        self.fetchNoticeIDListUseCase = fetchNoticeIDListUseCase
        self.setUsernameUseCase = setUserNameUseCase
        self.fetchUserInfoUseCase = fetchUserInfoUseCase
        self.myInfoCommonService = myInfoCommonService
        self.initialState = .init(
            isLoggedIn: false,
            profileImage: "",
            nickname: "",
            platform: "",
            fruitCount: 0,
            isAllNoticesRead: false
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return viewDidLoad()
        case .loginButtonDidTap:
            return loginButtonDidTap()
        case .profileImageDidTap:
            return profileImageDidTap()
        case .drawButtonDidTap:
            return drawButtonDidTap()
        case .fruitNavigationDidTap:
            return fruitNavigationDidTap()
        case .faqNavigationDidTap:
            return faqNavigationDidTap()
        case .notiNavigationDidTap:
            return notiNavigationDidTap()
        case .mailNavigationDidTap:
            return mailNavigationDidTap()
        case .teamNavigationDidTap:
            return teamNavigationDidTap()
        case .settingNavigationDidTap:
            return settingNavigationDidTap()
        case let .requiredLogin(entry):
            return navigateLogin(entry: entry)
        case .completedFruitDraw:
            return mutateFetchUserInfo()
        case .completedSetProfile:
            return mutateFetchUserInfo()
        case let .changeNicknameButtonDidTap(newNickname):
            return mutateSetRemoteUserName(newNickname)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .loginButtonDidTap:
            newState.loginButtonDidTap = true

        case .profileImageDidTap:
            newState.profileImageDidTap = true

        case let .navigate(navigate):
            newState.navigateType = navigate

        case let .updateIsLoggedIn(isLoggedIn):
            newState.isLoggedIn = isLoggedIn

        case let .updateProfileImage(image):
            newState.profileImage = image

        case let .updateNickname(nickname):
            newState.nickname = nickname

        case let .updatePlatform(platform):
            newState.platform = platform

        case let .updateIsAllNoticesRead(isAllNoticesRead):
            newState.isAllNoticesRead = isAllNoticesRead

        case let .updateFruitCount(count):
            newState.fruitCount = count

        case let .showToast(message):
            newState.showToast = message

        case .dismissEditSheet:
            newState.dismissEditSheet = true
        }
        return newState
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let willRefreshUserInfoMutation = myInfoCommonService.willRefreshUserInfoEvent
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<Mutation> in
                return owner.mutateFetchUserInfo()
            }

        let didChangedUserInfoMutation = myInfoCommonService.didChangedUserInfoEvent
            .withUnretained(self)
            .flatMap { owner, userInfo -> Observable<Mutation> in
                return .concat(
                    owner.updateNickname(userInfo),
                    owner.updatePlatform(userInfo),
                    owner.updateFruitCount(userInfo),
                    owner.updateIsLoggedIn(userInfo),
                    owner.updateProfileImage(userInfo)
                )
            }

        let didChangedReadNoticeIDsMutation = myInfoCommonService.didChangedReadNoticeIDsEvent
            .withUnretained(self)
            .flatMap { owner, readIDs -> Observable<Mutation> in
                return owner.mutateFetchNoticeIDList(readIDs ?? [])
            }

        return Observable.merge(
            mutation,
            willRefreshUserInfoMutation,
            didChangedUserInfoMutation,
            didChangedReadNoticeIDsMutation
        )
    }
}

private extension MyInfoReactor {
    func viewDidLoad() -> Observable<Mutation> {
        guard PreferenceManager.userInfo != nil else { return .empty() }
        return mutateFetchUserInfo()
    }

    func updateIsLoggedIn(_ userInfo: UserInfo?) -> Observable<Mutation> {
        return .just(.updateIsLoggedIn(userInfo != nil))
    }

    func updateProfileImage(_ userInfo: UserInfo?) -> Observable<Mutation> {
        guard let profile = userInfo?.profile else { return .empty() }
        return .just(.updateProfileImage(profile))
    }

    func updateNickname(_ userInfo: UserInfo?) -> Observable<Mutation> {
        guard let userInfo = userInfo else { return .empty() }
        return .just(.updateNickname(userInfo.decryptedName))
    }

    func updatePlatform(_ userInfo: UserInfo?) -> Observable<Mutation> {
        guard let platform = userInfo?.platform else { return .empty() }
        return .just(.updatePlatform(platform))
    }

    func updateFruitCount(_ userInfo: UserInfo?) -> Observable<Mutation> {
        guard let count = userInfo?.itemCount else {
            return .just(.updateFruitCount(-1))
        }
        return .just(.updateFruitCount(count))
    }

    func loginButtonDidTap() -> Observable<Mutation> {
        return .just(.loginButtonDidTap)
    }

    func profileImageDidTap() -> Observable<Mutation> {
        return .just(.profileImageDidTap)
    }

    func drawButtonDidTap() -> Observable<Mutation> {
        return .just(.navigate(.draw))
    }

    func fruitNavigationDidTap() -> Observable<Mutation> {
        return .just(.navigate(.fruit))
    }

    func faqNavigationDidTap() -> Observable<Mutation> {
        return .just(.navigate(.faq))
    }

    func notiNavigationDidTap() -> Observable<Mutation> {
        return .just(.navigate(.noti))
    }

    func mailNavigationDidTap() -> Observable<Mutation> {
        return .just(.navigate(.mail))
    }

    func teamNavigationDidTap() -> Observable<Mutation> {
        return .just(.navigate(.team))
    }

    func settingNavigationDidTap() -> Observable<Mutation> {
        return .just(.navigate(.setting))
    }

    func navigateLogin(entry: CommonAnalyticsLog.LoginButtonEntry) -> Observable<Mutation> {
        return .just(.navigate(.login(entry: entry)))
    }
}

private extension MyInfoReactor {
    func mutateFetchUserInfo() -> Observable<Mutation> {
        return fetchUserInfoUseCase.execute()
            .asObservable()
            .flatMap { _ in Observable.empty() }
            .catch { error in
                let error = error.asWMError
                return Observable.just(.showToast(error.errorDescription ?? LocalizationStrings.unknownErrorWarning))
            }
    }

    func mutateSetRemoteUserName(_ newNickname: String) -> Observable<Mutation> {
        setUsernameUseCase.execute(name: newNickname)
            .andThen(
                fetchUserInfoUseCase.execute()
                    .asObservable()
                    .flatMap { _ -> Observable<Mutation> in
                        return .concat(
                            .just(.showToast("닉네임이 변경되었습니다.")),
                            .just(.dismissEditSheet)
                        )
                    }
            )
            .catch { error in
                let error = error.asWMError
                if error == .conflict {
                    return .just(.showToast("키워드 혹은 중복된 닉네임은 사용할 수 없습니다."))
                } else {
                    return .concat(
                        .just(.showToast(error.errorDescription ?? LocalizationStrings.unknownErrorWarning)),
                        .just(.dismissEditSheet)
                    )
                }
            }
    }

    func mutateFetchNoticeIDList(_ readIDs: [Int]) -> Observable<Mutation> {
        return fetchNoticeIDListUseCase.execute()
            .catchAndReturn(FetchNoticeIDListEntity(status: "404", data: []))
            .asObservable()
            .map {
                let readIDsSet = Set(readIDs)
                let allNoticeIDsSet = Set($0.data)
                return allNoticeIDsSet.isSubset(of: readIDsSet)
            }
            .map { Mutation.updateIsAllNoticesRead($0) }
    }
}
