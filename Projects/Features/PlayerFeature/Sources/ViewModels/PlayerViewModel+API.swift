//
//  PlayerViewModel+API.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/03/31.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DomainModule

// MARK: - 뷰모델 내 API를 사용하는 함수들을 모아놓은 곳입니다.
extension PlayerViewModel {
    /// 가사 불러오기
    func fetchLyrics(for song: SongEntity, output: Output) {
        fetchLyricsUseCase.execute(id: song.id)
            .retry(3)
            .subscribe { [weak self] lyricsEntityArray in
                guard let self else { return }
                self.lyricsDict.removeAll()
                self.sortedLyrics.removeAll()
                lyricsEntityArray.forEach { self.lyricsDict.updateValue($0.text, forKey: Float($0.start)) }
                self.sortedLyrics = self.lyricsDict.sorted { $0.key < $1.key }.map { $0.value }
            } onFailure: { [weak self] error in
                guard let self else { return }
                self.lyricsDict.removeAll()
                self.sortedLyrics.removeAll()
                self.sortedLyrics.append("가사가 없습니다.")
                print("title: \(song.title) id: \(song.id) 가사가 없습니다. error: \(error)")
            } onDisposed: {
                output.lyricsDidChangedEvent.send(true)
            }.disposed(by: self.disposeBag)
    }
    
    /// 좋아요 수 가져오기
    func fetchLikeCount(for song: SongEntity, output: Output) {
        fetchLikeNumOfSongUseCase.execute(id: song.id)
            .retry(3)
            .map { [weak self] song in
                self?.formatNumber(song.likes) ?? ""
            }
            .subscribe { likeCountText in
                output.likeCountText.send(likeCountText)
            } onFailure: { _ in
                output.likeCountText.send("좋아요")
            }.disposed(by: self.disposeBag)
    }
    
    /// 좋아요 상태 가져오기
    func fetchLikeState(for song: SongEntity, output: Output) {
        fetchFavoriteSongsUseCase.execute()
            .retry(3)
            .map { $0.contains { $0.song.id == song.id } }
            .subscribe { isLiked in
                output.likeState.send(isLiked)
            } onFailure: { _ in
                output.likeState.send(false)
            }.disposed(by: self.disposeBag)
    }
    
    /// 좋아요 취소
    func cancelLikeSong(for song: SongEntity, output: Output) {
        self.cancelLikeSongUseCase.execute(id: song.id)
            .retry(3)
            .subscribe(
                onSuccess: { _ in
                    output.likeState.send(false)
                },
                onFailure: { error in
                    output.showToastMessage.send(error.localizedDescription)
                }
            )
            .disposed(by: self.disposeBag)
    }
    
    /// 좋아요 추가
    func addLikeSong(for song: SongEntity, output: Output) {
        self.addLikeSongUseCase.execute(id: song.id)
            .retry(3)
            .subscribe(
                onSuccess: { _ in
                    output.likeState.send(true)
                },
                onFailure: { error in
                    output.showToastMessage.send(error.localizedDescription)
                }
            )
            .disposed(by: self.disposeBag)
    }
}
