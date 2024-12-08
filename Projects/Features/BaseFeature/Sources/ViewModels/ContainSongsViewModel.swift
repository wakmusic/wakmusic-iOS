import AuthDomainInterface
import BaseDomainInterface
import ErrorModule
import Foundation
import Localization
import LogManager
import PlaylistDomainInterface
import PriceDomainInterface
import RxRelay
import RxSwift
import UserDomainInterface
import Utility

#warning("커스텀 에러 리스폰스 후추..")
public final class ContainSongsViewModel: ViewModelType {
    private let fetchPlayListUseCase: any FetchPlaylistUseCase
    private let addSongIntoPlaylistUseCase: any AddSongIntoPlaylistUseCase
    private let createPlaylistUseCase: any CreatePlaylistUseCase
    private let fetchPlaylistCreationPriceUsecase: any FetchPlaylistCreationPriceUseCase
    private let logoutUseCase: LogoutUseCase
    var songs: [String]!
    let disposeBag = DisposeBag()
    let limit: Int = 50

    public struct Input {
        let viewDidLoad: PublishSubject<Void> = PublishSubject<Void>()
        let newPlayListTap: PublishSubject<Void> = PublishSubject()
        let playListLoad: BehaviorRelay<Void> = BehaviorRelay(value: ())
        let itemDidTap: PublishSubject<PlaylistEntity> = PublishSubject()
        let createPlaylist: PublishSubject<String> = PublishSubject()
        let creationButtonDidTap: PublishSubject<Void> = PublishSubject()
        let payButtonDidTap: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[PlaylistEntity]> = BehaviorRelay(value: [])
        let showToastMessage: PublishSubject<BaseEntity> = PublishSubject()
        let creationPrice: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 2)
        let showPricePopup: PublishSubject<Void> = PublishSubject()
        let showCreationPopup: PublishSubject<Void> = PublishSubject()
        let onLogout: PublishRelay<Error>

        init(onLogout: PublishRelay<Error>) {
            self.onLogout = onLogout
        }
    }

    init(
        songs: [String],
        createPlaylistUseCase: any CreatePlaylistUseCase,
        fetchPlayListUseCase: any FetchPlaylistUseCase,
        addSongIntoPlaylistUseCase: any AddSongIntoPlaylistUseCase,
        fetchPlaylistCreationPriceUsecase: any FetchPlaylistCreationPriceUseCase,
        logoutUseCase: LogoutUseCase
    ) {
        self.createPlaylistUseCase = createPlaylistUseCase
        self.fetchPlayListUseCase = fetchPlayListUseCase
        self.addSongIntoPlaylistUseCase = addSongIntoPlaylistUseCase
        self.fetchPlaylistCreationPriceUsecase = fetchPlaylistCreationPriceUsecase
        self.logoutUseCase = logoutUseCase
        self.songs = songs
    }

    public func transform(from input: Input) -> Output {
        let logoutRelay = PublishRelay<Error>()

        let output = Output(onLogout: logoutRelay)

        input.viewDidLoad
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<Int> in

                owner.fetchPlaylistCreationPriceUsecase
                    .execute()
                    .asObservable()
                    .map(\.price)
            }
            .bind(to: output.creationPrice)
            .disposed(by: disposeBag)

        input.playListLoad
            .flatMap { [weak self] () -> Observable<[PlaylistEntity]> in
                guard let self = self else {
                    return Observable.empty()
                }
                return self.fetchPlayListUseCase.execute()
                    .asObservable()
                    .catch { [logoutUseCase] (error: Error) in
                        let wmError = error.asWMError
                        if wmError == .tokenExpired {
                            logoutRelay.accept(wmError)
                            return logoutUseCase.execute(localOnly: false)
                                .andThen(Observable.error(wmError))
                        } else {
                            return Observable.error(wmError)
                        }
                    }
            }
            .do(onError: { (error: Error) in
                let wmError = error.asWMError
                output.showToastMessage.onNext(BaseEntity(
                    status: 401,
                    description: wmError.errorDescription ?? LocalizationStrings.unknownErrorWarning
                ))
            })
            .catchAndReturn([])
            .withLatestFrom(PreferenceManager.shared.$userInfo) { ($0, $1) }
            .map { playlist, userInfo in

                return playlist.filter { $0.userId == userInfo?.decryptedID }
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        input.itemDidTap
            .flatMap { [weak self] (model: PlaylistEntity) -> Observable<AddSongEntity> in
                guard let self = self else {
                    return Observable.empty()
                }

                let count = model.songCount + self.songs.count

                guard count <= limit else {
                    output.showToastMessage.onNext(
                        BaseEntity(
                            status: -1,
                            description: LocalizationStrings.overFlowAddPlaylistWarning(count - limit)
                        )
                    )
                    return .empty()
                }

                return self.addSongIntoPlaylistUseCase
                    .execute(key: model.key, songs: self.songs)
                    .do(onSuccess: { _ in
                        let log = ContainSongsAnalyticsLog.completeAddMusics(
                            playlistId: model.key,
                            count: self.songs.count
                        )
                        LogManager.analytics(log)
                    })
                    .catch { (error: Error) in
                        let wmError = error.asWMError

                        switch wmError {
                        case .tokenExpired:
                            logoutRelay.accept(wmError)
                            output.showToastMessage.onNext(BaseEntity(
                                status: 401,
                                description: wmError.errorDescription ?? wmError.localizedDescription
                            ))
                        case .conflict:

                            output.showToastMessage.onNext(BaseEntity(
                                status: 409,
                                description: "이미 내 리스트에 담긴 곡들입니다."
                            ))

                        default:
                            output.showToastMessage.onNext(BaseEntity(status: 400, description: "잘못된 요청입니다."))
                        }

                        return .never()
                    }
                    .asObservable()
            }
            .map { (entity: AddSongEntity) -> BaseEntity in
                if entity.duplicated {
                    return BaseEntity(
                        status: 200,
                        description: "\(entity.addedSongCount)곡이 내 리스트에 담겼습니다. 중복 곡은 제외됩니다."
                    )
                } else {
                    return BaseEntity(status: 200, description: "\(entity.addedSongCount)곡이 내 리스트에 담겼습니다.")
                }
            }
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)

        input.creationButtonDidTap
            .bind(to: output.showPricePopup)
            .disposed(by: disposeBag)

        input.payButtonDidTap
            .bind(to: output.showCreationPopup)
            .disposed(by: disposeBag)

        input.createPlaylist
            .withUnretained(self) { ($0, $1) }
            .flatMap { owner, text -> Observable<PlaylistBaseEntity> in

                owner.createPlaylistUseCase.execute(title: text)
                    .asObservable()
                    .catch { (error: Error) in
                        let wmError = error.asWMError
                        if wmError == .tokenExpired {
                            logoutRelay.accept(wmError)
                            return owner.logoutUseCase.execute(localOnly: false)
                                .andThen(Observable.error(wmError))
                        } else {
                            return Observable.error(wmError)
                        }
                    }
            }
            .do(onError: { error in
                let wmError: WMError = error.asWMError
                output.showToastMessage.onNext(BaseEntity(status: 400, description: wmError.errorDescription!))
            })
            .map { _ in BaseEntity(status: 201, description: "플레이리스트를 성공적으로 생성했습니다.") }
            .do(onNext: { _ in
                NotificationCenter.default.post(name: .willRefreshUserInfo, object: nil)
            })
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)

        return output
    }
}
