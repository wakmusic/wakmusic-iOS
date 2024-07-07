import AuthDomainInterface
import BaseDomainInterface
import ErrorModule
import Foundation
import PlaylistDomainInterface
import RxRelay
import RxSwift
import UserDomainInterface
import Utility

public final class ContainSongsViewModel: ViewModelType {
    private let fetchPlayListUseCase: any FetchPlayListUseCase
    private let addSongIntoPlaylistUseCase: any AddSongIntoPlaylistUseCase
    private let createPlaylistUseCase: any CreatePlaylistUseCase
    private let logoutUseCase: LogoutUseCase
    var songs: [String]!
    let disposeBag = DisposeBag()

    public struct Input {
        let newPlayListTap: PublishSubject<Void> = PublishSubject()
        let playListLoad: BehaviorRelay<Void> = BehaviorRelay(value: ())
        let containSongWithKey: PublishSubject<String> = PublishSubject()
        let createPlaylist: PublishSubject<String> = PublishSubject()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[PlaylistEntity]> = BehaviorRelay(value: [])
        let showToastMessage: PublishSubject<BaseEntity> = PublishSubject()
        let onLogout: PublishRelay<Error>

        init(onLogout: PublishRelay<Error>) {
            self.onLogout = onLogout
        }
    }

    init(
        songs: [String],
        createPlaylistUseCase: any CreatePlaylistUseCase,
        fetchPlayListUseCase: any FetchPlayListUseCase,
        addSongIntoPlaylistUseCase: any AddSongIntoPlaylistUseCase,
        logoutUseCase: LogoutUseCase
    ) {
        self.createPlaylistUseCase = createPlaylistUseCase
        self.fetchPlayListUseCase = fetchPlayListUseCase
        self.addSongIntoPlaylistUseCase = addSongIntoPlaylistUseCase
        self.logoutUseCase = logoutUseCase
        self.songs = songs
    }

    public func transform(from input: Input) -> Output {
        let logoutRelay = PublishRelay<Error>()

        let output = Output(onLogout: logoutRelay)

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
                            return logoutUseCase.execute()
                                .asObservable()
                                .catch { error in
                                    let description = error.asWMError.errorDescription ?? ""
                                    output.showToastMessage.onNext(BaseEntity(status: 0, description: description))
                                    return Observable.never()
                                }
                                .flatMap { _ in
                                    Observable.never()
                                }
                        } else {
                            return Observable.error(wmError)
                        }
                    }
            }
            .do(onError: { error in
                let wmError: WMError = error.asWMError
                output.showToastMessage.onNext(BaseEntity(status: 400, description: wmError.errorDescription!))
            })
            .withLatestFrom(PreferenceManager.$userInfo) { ($0, $1) }
            .map { playlist, userInfo in
                #warning("복호화 추후 개선 예정")
                let id = AES256.decrypt(encoded: userInfo?.ID ?? "")

                return playlist.filter { $0.userId == id }
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        input.containSongWithKey
            .flatMap { [weak self] (key: String) -> Observable<AddSongEntity> in
                guard let self = self else {
                    return Observable.empty()
                }
                return self.addSongIntoPlaylistUseCase
                    .execute(key: key, songs: self.songs)
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

        input.createPlaylist
            .withUnretained(self) { ($0, $1) }
            .flatMap { owner, text -> Observable<PlaylistBaseEntity> in

                owner.createPlaylistUseCase.execute(title: text)
                    .asObservable()
                    .catch { (error: Error) in
                        let wmError = error.asWMError
                        if wmError == .tokenExpired {
                            logoutRelay.accept(wmError)
                            return owner.logoutUseCase.execute()
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
            .map { _ in BaseEntity(status: 201, description: "플레이리스트를 성곡적으로 생성했습니다.") }
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)

        return output
    }
}
