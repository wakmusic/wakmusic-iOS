import BaseFeature
import Foundation
import LogManager
import ReactorKit
import UserDomainInterface
import Utility

final class MyInfoReactor: Reactor {
    enum Action {
        case loginButtonDidTap
        case profileImageDidTap
        case drawButtonDidTap
        case likeNavigationDidTap
        case faqNavigationDidTap
        case notiNavigationDidTap
        case mailNavigationDidTap
        case teamNavigationDidTap
        case settingNavigationDidTap
        case changeUserInfo(UserInfo?)
        case changeReadNoticeIDs([Int])
    }

    enum Mutation {
        case loginButtonDidTap
        case profileImageDidTap
        case navigate(NavigateType?)
        case updateIsLoggedIn(Bool)
        case updateProfileImage(String)
        case updateNickname(String)
        case updatePlatform(String)
        case updateIsAllNoticesRead(Bool)
    }

    enum NavigateType {
        case draw
        case like
        case faq
        case noti
        case mail
        case team
        case setting
    }

    struct State {
        var isLoggedIn: Bool
        var profileImage: String
        var nickname: String
        var platform: String
        var isAllNoticesRead: Bool
        @Pulse var loginButtonDidTap: Bool?
        @Pulse var profileImageDidTap: Bool?
        @Pulse var navigateType: NavigateType?
    }

    var initialState: State
    private var disposeBag = DisposeBag()

    init() {
        self.initialState = .init(
            isLoggedIn: false,
            profileImage: "",
            nickname: "",
            platform: "",
            isAllNoticesRead: false
        )
        observeUserInfoChanges()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loginButtonDidTap:
            return loginButtonDidTap()
        case .profileImageDidTap:
            return profileImageDidTap()
        case .drawButtonDidTap:
            return drawButtonDidTap()
        case .likeNavigationDidTap:
            return likeNavigationDidTap()
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
        case let .changeUserInfo(userInfo):
            return .concat(
                updateIsLoggedIn(userInfo),
                updateProfileImage(userInfo),
                updateNickname(userInfo),
                updatePlatform(userInfo)
            )
        case let .changeReadNoticeIDs(readIDs):
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
        }
        return newState
    }
}

private extension MyInfoReactor {
    func observeUserInfoChanges() {
        PreferenceManager.$userInfo
            .bind(with: self) { owner, userInfo in
                owner.action.onNext(.changeUserInfo(userInfo))
            }
            .disposed(by: disposeBag)
    }

    func observeReadNoticeIdChanges() {
//        PreferenceManager.$readNoticeIDs
//            .compactMap { $0 }
//            .bind(with: self) { owner, readIDs in
//                owner.action.onNext(.changeReadNoticeIDs(readIDs))
//            }
//            .disposed(by: disposeBag)
    }

    func updateIsAllNoticesRead(_ readIDs: [Int]) -> Observable<Mutation> {}

    func updateIsLoggedIn(_ userInfo: UserInfo?) -> Observable<Mutation> {
        return .just(.updateIsLoggedIn(userInfo != nil))
    }

    func updateProfileImage(_ userInfo: UserInfo?) -> Observable<Mutation> {
        guard let profile = userInfo?.profile else { return .empty() }
        return .just(.updateProfileImage(profile))
    }

    func updateNickname(_ userInfo: UserInfo?) -> Observable<Mutation> {
        guard let nickname = userInfo?.name else { return .empty() }
        let decrypt = AES256.decrypt(encoded: nickname)
        return .just(.updateNickname(decrypt))
    }

    func updatePlatform(_ userInfo: UserInfo?) -> Observable<Mutation> {
        guard let platform = userInfo?.platform else { return .empty() }
        return .just(.updatePlatform(platform))
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

    func likeNavigationDidTap() -> Observable<Mutation> {
        return .just(.navigate(.like))
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
}
