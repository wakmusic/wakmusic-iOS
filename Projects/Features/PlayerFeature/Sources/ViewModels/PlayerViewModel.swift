//
//  PlayerViewModel.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/01/13.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Utility
import BaseFeature
import DomainModule
import Combine
import YouTubePlayerKit
import CommonFeature

final class PlayerViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let closeButtonDidTapEvent: AnyPublisher<Void, Never>
        let playButtonDidTapEvent: AnyPublisher<Void, Never>
        let prevButtonDidTapEvent: Observable<Void>
        let nextButtonDidTapEvent: Observable<Void>
        let sliderValueChangedEvent: Observable<Float>
        let repeatButtonDidTapEvent: AnyPublisher<Void, Never>
        let shuffleButtonDidTapEvent: AnyPublisher<Void, Never>
        let likeButtonDidTapEvent: AnyPublisher<Void, Never>
        let addPlaylistButtonDidTapEvent: AnyPublisher<Void, Never>
        let playlistButtonDidTapEvent: AnyPublisher<Void, Never>
        let miniExtendButtonDidTapEvent: AnyPublisher<Void, Never>
        let miniPlayButtonDidTapEvent: AnyPublisher<Void, Never>
        let miniCloseButtonDidTapEvent: AnyPublisher<Void, Never>
    }
    struct Output {
        var playerState = CurrentValueSubject<YouTubePlayer.PlaybackState, Never>(.unstarted)
        var titleText = CurrentValueSubject<String, Never>("")
        var artistText = CurrentValueSubject<String, Never>("")
        var thumbnailImageURL = CurrentValueSubject<String, Never>("")
        var playTimeValue = CurrentValueSubject<Float, Never>(0.0)
        var totalTimeValue = CurrentValueSubject<Float, Never>(0.0)
        var playTimeText = CurrentValueSubject<String, Never>("0:00")
        var totalTimeText = CurrentValueSubject<String, Never>("0:00")
        var likeCountText = CurrentValueSubject<String, Never>("")
        var viewsCountText = CurrentValueSubject<String, Never>("")
        var repeatMode = CurrentValueSubject<RepeatMode, Never>(.none)
        var shuffleMode = CurrentValueSubject<ShuffleMode, Never>(.off)
        var likeState = CurrentValueSubject<Bool, Never>(false)
        var didPlay = PublishRelay<Bool>()
        //var didClose = PublishRelay<Bool>()
        var didPrev = PublishRelay<Bool>()
        var didNext = PublishRelay<Bool>()
        var lyricsDidChangedEvent = PassthroughSubject<Bool, Never>()
        var willShowPlaylist = PassthroughSubject<Bool, Never>()
        var showToastMessage = PassthroughSubject<String, Never>()
        var showConfirmModal = PassthroughSubject<String, Never>()
        var showContainSongsViewController = PassthroughSubject<String, Never>()
    }
    
    var fetchLyricsUseCase: FetchLyricsUseCase!
    var addLikeSongUseCase: AddLikeSongUseCase!
    var cancelLikeSongUseCase: CancelLikeSongUseCase!
    var fetchLikeNumOfSongUseCase: FetchLikeNumOfSongUseCase!
    var fetchFavoriteSongsUseCase: FetchFavoriteSongsUseCase!
    
    let disposeBag = DisposeBag()
    private let playState = PlayState.shared
    private var subscription = Set<AnyCancellable>()
    internal var lyricsDict = [Float : String]()
    internal var sortedLyrics = [String]()
    internal var isLyricsScrolling = false
    
    init(fetchLyricsUseCase: FetchLyricsUseCase, addLikeSongUseCase: AddLikeSongUseCase, cancelLikeSongUseCase: CancelLikeSongUseCase, fetchLikeNumOfSongUseCase: FetchLikeNumOfSongUseCase, fetchFavoriteSongsUseCase: FetchFavoriteSongsUseCase) {
        self.fetchLyricsUseCase = fetchLyricsUseCase
        self.addLikeSongUseCase = addLikeSongUseCase
        self.cancelLikeSongUseCase = cancelLikeSongUseCase
        self.fetchLikeNumOfSongUseCase = fetchLikeNumOfSongUseCase
        self.fetchFavoriteSongsUseCase = fetchFavoriteSongsUseCase
        print("✅ PlayerViewModel 생성")
    }
    
    deinit {
        print("❌ PlayerViewModel deinit")
    }
    
    func transform(from input: Input) -> Output {
        let output = Output()
        
        bindInput(input: input, output: output)
        bindPlayStateChanged(output: output)
        bindCurrentSongChanged(output: output)
        bindProgress(output: output)
        bindRepeatMode(output: output)
        bindShuffleMode(output: output)
        bindLoginStateChanged(output: output)
        
        return output
    }
    
    private func bindInput(input: Input, output: Output) {
        input.playButtonDidTapEvent.merge(with: input.miniPlayButtonDidTapEvent).sink { [weak self] _ in
            guard let self else { return }
            let state = self.playState.state
            state == .playing ? self.playState.pause() : self.playState.play()
        }.store(in: &subscription)
        
        input.closeButtonDidTapEvent.sink { [weak self] _ in
            self?.playState.switchPlayerMode(to: .mini)
        }.store(in: &subscription)
        
        input.miniExtendButtonDidTapEvent.sink { [weak self] _ in
            self?.playState.switchPlayerMode(to: .full)
        }.store(in: &subscription)
        
        input.miniCloseButtonDidTapEvent.sink { [weak self] _ in
            self?.playState.switchPlayerMode(to: .close)
            self?.playState.stop()
        }.store(in: &subscription)
        
        input.repeatButtonDidTapEvent.sink { [weak self] _ in
            guard let self else { return }
            self.playState.repeatMode.rotate()
        }.store(in: &subscription)
        
        input.shuffleButtonDidTapEvent.sink { [weak self] _ in
            guard let self else { return }
            self.playState.shuffleMode.toggle()
        }.store(in: &subscription)
        
        input.prevButtonDidTapEvent.subscribe { [weak self] _ in
            guard let self else { return }
            switch self.playState.shuffleMode {
            case .off:
                self.playState.backward()
            case .on:
                self.playState.shufflePlay()
            }
        }.disposed(by: disposeBag)
        
        input.nextButtonDidTapEvent.subscribe { [weak self] _ in
            guard let self else { return }
            switch self.playState.shuffleMode {
            case .off:
                self.playState.forward()
            case .on:
                self.playState.shufflePlay()
            }
        }.disposed(by: disposeBag)
        
        input.sliderValueChangedEvent.subscribe { [weak self] value in
            guard let self else { return }
            self.playState.player.seek(to: Double(value), allowSeekAhead: true)
        }.disposed(by: disposeBag)
        
        input.likeButtonDidTapEvent
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .map {
                Utility.PreferenceManager.userInfo != nil
            }
            .sink { [weak self] isLoggedIn in
                guard let self else { return }
                guard let currentSong = self.playState.currentSong else { return }
                let alreadyLiked = output.likeState.value
                
                if !isLoggedIn {
                    output.showConfirmModal.send("로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?")
                    return
                }
                if alreadyLiked {
                    self.cancelLikeSong(for: currentSong, output: output)
                } else {
                    self.addLikeSong(for: currentSong, output: output)
                }
                
            }.store(in: &subscription)
        
        input.addPlaylistButtonDidTapEvent
            .map {
                Utility.PreferenceManager.userInfo != nil
            }
            .sink { isLoggedIn in
                if !isLoggedIn {
                    output.showConfirmModal.send("로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?")
                    return
                }
                if let currentSong = self.playState.currentSong {
                    output.showContainSongsViewController.send(currentSong.id)
                }
            }.store(in: &subscription)
        
        input.playlistButtonDidTapEvent.sink { _ in
            output.willShowPlaylist.send(true)
        }.store(in: &subscription)
    }
    
    private func bindLoginStateChanged(output: Output) {
        Utility.PreferenceManager.$userInfo
            .skip(1)
            .subscribe { [weak self] _ in
                guard let self else { return }
                guard let currentSong = self.playState.currentSong else { return }
                self.fetchLikeState(for: currentSong, output: output)
                self.fetchLikeCount(for: currentSong, output: output)
            }.disposed(by: disposeBag)
    }
    
    private func bindPlayStateChanged(output: Output) {
        playState.$state.sink { [weak self] state in
            guard let self else { return }
            output.playerState.send(state)
            if state == .ended {
                self.handlePlaybackEnded()
            }
        }.store(in: &subscription)
    }
    
    private func bindCurrentSongChanged(output: Output) {
        playState.$currentSong.sink { [weak self] song in
            self?.handleCurrentSongChanged(song: song, output: output)
            if let song = song {
                self?.fetchLyrics(for: song, output: output)
                self?.fetchLikeCount(for: song, output: output)
                self?.fetchLikeState(for: song, output: output)
            }
        }.store(in: &subscription)
    }
    
    private func bindProgress(output: Output) {
        playState.$progress.sink { [weak self] progress in
            guard let self else { return }
            self.handleProgress(progress: progress, output: output)
        }.store(in: &subscription)
    }
    
    private func bindRepeatMode(output: Output) {
        playState.$repeatMode.sink { repeatMode in
            output.repeatMode.send(repeatMode)
        }.store(in: &subscription)
    }
    
    private func bindShuffleMode(output: Output) {
        playState.$shuffleMode.sink { shuffleMode in
            output.shuffleMode.send(shuffleMode)
        }.store(in: &subscription)
    }
    
    private func handlePlaybackEnded() {
        if playState.shuffleMode.isOn {
            handleShuffleWithRepeatOnce()
        } else {
            switch playState.repeatMode {
            case .none:
                handleNoneRepeat()
            case .repeatAll:
                playState.forward()
            case .repeatOnce:
                playState.play()
            }
        }
    }
    
    private func handleShuffleWithRepeatOnce() {
        if playState.repeatMode == .repeatOnce {
            playState.play()
        } else {
            playState.shufflePlay()
        }
    }
    
    private func handleNoneRepeat() {
        if !playState.playList.isLast {
            playState.forward()
        }
    }
    
    private func handleCurrentSongChanged(song: SongEntity?, output: Output) {
        if let song = song {
            let thumbnailURL = Utility.WMImageAPI.fetchYoutubeThumbnail(id: song.id).toString
            output.thumbnailImageURL.send(thumbnailURL)
            output.titleText.send(song.title)
            output.artistText.send(song.artist)
            output.viewsCountText.send(self.formatNumber(song.views))
            output.likeCountText.send("준비중")
        } else {
            output.thumbnailImageURL.send("")
            output.titleText.send("")
            output.artistText.send("")
            output.viewsCountText.send("조회수")
            output.likeCountText.send("좋아요")
            output.likeState.send(false)
            lyricsDict.removeAll()
            sortedLyrics.removeAll()
            output.lyricsDidChangedEvent.send(true)
        }
        
    }
    
    private func handleProgress(progress: PlayState.PlayProgress, output: Output) {
        output.playTimeText.send(self.formatTime(progress.currentProgress))
        output.totalTimeText.send(self.formatTime(progress.endProgress))
        output.playTimeValue.send(Float(progress.currentProgress))
        output.totalTimeValue.send(Float(progress.endProgress))
    }
    
}
