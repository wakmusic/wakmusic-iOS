//
//  ContainSongsViewModel.swift
//  CommonFeature
//
//  Created by yongbeomkwak on 2023/03/11.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AuthDomainInterface
import BaseFeature
import ErrorModule
import Foundation
import PlayListDomainInterface
import RxRelay
import RxSwift
import UserDomainInterface

public final class ContainSongsViewModel: ViewModelType {
    var fetchPlayListUseCase: FetchPlayListUseCase!
    var addSongIntoPlayListUseCase: AddSongIntoPlayListUseCase!
    private let logoutUseCase: LogoutUseCase
    var songs: [String]!
    let disposeBag = DisposeBag()

    public struct Input {
        let newPlayListTap: PublishSubject<Void> = PublishSubject()
        let playListLoad: BehaviorRelay<Void> = BehaviorRelay(value: ())
        let containSongWithKey: PublishSubject<String> = PublishSubject()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[PlayListEntity]> = BehaviorRelay(value: [])
        let showToastMessage: PublishSubject<AddSongEntity> = PublishSubject()
        let onLogout: PublishRelay<Error>

        init(onLogout: PublishRelay<Error> = PublishRelay()) {
            self.onLogout = onLogout
        }
    }

    init(
        songs: [String],
        fetchPlayListUseCase: FetchPlayListUseCase!,
        addSongIntoPlayListUseCase: AddSongIntoPlayListUseCase!,
        logoutUseCase: LogoutUseCase
    ) {
        self.fetchPlayListUseCase = fetchPlayListUseCase
        self.addSongIntoPlayListUseCase = addSongIntoPlayListUseCase
        self.logoutUseCase = logoutUseCase
        self.songs = songs
    }

    public func transform(from input: Input) -> Output {
        let logoutRelay = PublishRelay<Error>()

        let output = Output(onLogout: logoutRelay)

        input.playListLoad
            .flatMap { [weak self] () -> Observable<[PlayListEntity]> in
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
                                .andThen(.never())
                        } else {
                            return Observable.never()
                        }
                    }
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        input.containSongWithKey
            .flatMap { [weak self] (key: String) -> Observable<AddSongEntity> in
                guard let self = self else {
                    return Observable.empty()
                }
                return self.addSongIntoPlayListUseCase
                    .execute(key: key, songs: self.songs)
                    .catch { (error: Error) in
                        let wmError = error.asWMError

                        if wmError == .tokenExpired {
                            logoutRelay.accept(wmError)
                            return Single.never()
                        } else if wmError == .badRequest {
                            return Single<AddSongEntity>.create { single in
                                single(.success(AddSongEntity(
                                    status: 400,
                                    added_songs_length: 0,
                                    duplicated: false,
                                    description: wmError.errorDescription ?? ""
                                )))
                                return Disposables.create {}
                            }
                        } else if wmError == .conflict {
                            return Single<AddSongEntity>.create { single in
                                single(.success(AddSongEntity(
                                    status: 409,
                                    added_songs_length: 0,
                                    duplicated: true,
                                    description: "이미 내 리스트에 담긴 곡들입니다."
                                )))
                                return Disposables.create {}
                            }
                        } else {
                            return Single<AddSongEntity>.create { single in
                                single(.success(AddSongEntity(
                                    status: 500,
                                    added_songs_length: 0,
                                    duplicated: false,
                                    description: "서버에서 문제가 발생하였습니다.\n잠시 후 다시 시도해주세요!"
                                )))
                                return Disposables.create {}
                            }
                        }
                    }
                    .asObservable()
            }
            .map { (entity: AddSongEntity) -> AddSongEntity in
                if entity.status == 200 {
                    if entity.duplicated {
                        return AddSongEntity(
                            status: 200,
                            added_songs_length: entity.added_songs_length,
                            duplicated: true,
                            description: "\(entity.added_songs_length)곡이 내 리스트에 담겼습니다. 중복 곡은 제외됩니다."
                        )
                    } else {
                        return AddSongEntity(
                            status: 200,
                            added_songs_length: entity.added_songs_length,
                            duplicated: false,
                            description: "\(entity.added_songs_length)곡이 내 리스트에 담겼습니다."
                        )
                    }
                } else {
                    return entity
                }
            }
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)

        return output
    }
}
