//
//  PlaylistViewModel.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/02/28.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import Combine
import BaseFeature
import YouTubePlayerKit

final class PlaylistViewModel: ViewModelType {
    struct Input {
        let closeButtonDidTapEvent: AnyPublisher<Void, Never>
        let editButtonDidTapEvent: AnyPublisher<Void, Never>
        let repeatButtonDidTapEvent: AnyPublisher<Void, Never>
        let prevButtonDidTapEvent: AnyPublisher<Void, Never>
        let playButtonDidTapEvent: AnyPublisher<Void, Never>
        let nextButtonDidTapEvent: AnyPublisher<Void, Never>
        let shuffleButtonDidTapEvent: AnyPublisher<Void, Never>
        
    }
    struct Output {
        var playerState = CurrentValueSubject<YouTubePlayer.PlaybackState, Never>(.unstarted)
        var willClosePlaylist = PassthroughSubject<Bool, Never>()
        var editState = CurrentValueSubject<Bool, Never>(false)
        var thumbnailImageURL = CurrentValueSubject<String, Never>("")
        var playTimeValue = CurrentValueSubject<Float, Never>(0.0)
        var totalTimeValue = CurrentValueSubject<Float, Never>(0.0)
        var currentSongIndex = CurrentValueSubject<Int, Never>(0)
    }
    
    private let playState = PlayState.shared
    private var isEditing = false
    private var subscription = Set<AnyCancellable>()
    
    init() {
        print("✅ PlaylistViewModel 생성")
    }
    
    deinit {
        print("❌ PlaylistViewModel deinit")
    }
    
    func transform(from input: Input) -> Output {
        let output = Output()
        
        input.closeButtonDidTapEvent.sink { _ in
            output.willClosePlaylist.send(true)
        }.store(in: &subscription)
        
        input.editButtonDidTapEvent.sink { [weak self] _ in
            guard let self else { return }
            self.isEditing.toggle()
            output.editState.send(self.isEditing)
        }.store(in: &subscription)
        
        input.repeatButtonDidTapEvent.sink { _ in
            print("repeat 버튼 누름")
        }.store(in: &subscription)
        
        input.prevButtonDidTapEvent.sink { [weak self] _ in
            guard let self else { return }
            self.playState.backWard()
        }.store(in: &subscription)
        
        input.playButtonDidTapEvent.sink { [weak self] _ in
            guard let self else { return }
            let state = self.playState.state
            state == .playing ? self.playState.pause() : self.playState.play()
        }.store(in: &subscription)
        
        input.nextButtonDidTapEvent.sink { [weak self] _ in
            guard let self else { return }
            self.playState.forWard()
        }.store(in: &subscription)
        
        input.shuffleButtonDidTapEvent.sink { _ in
            print("shuffle 버튼 누름")
        }.store(in: &subscription)
        
        playState.$state.sink { state in
            output.playerState.send(state)
        }.store(in: &subscription)
        
        playState.$currentSong.sink { [weak self] song in
            guard let self else { return }
            guard let song = song else { return }
            output.thumbnailImageURL.send(self.thumbnailURL(from: song.id))
            guard let currentSongIndex = self.playState.playList.uniqueIndex(of: song) else { return }
            output.currentSongIndex.send(currentSongIndex)
        }.store(in: &subscription)
        
        playState.$progress.sink { progress in
            output.playTimeValue.send(Float(progress.currentProgress))
            output.totalTimeValue.send(Float(progress.endProgress))
        }.store(in: &subscription)
        
        return output
    }
    
    func thumbnailURL(from id: String) -> String {
        return "https://i.ytimg.com/vi/\(id)/hqdefault.jpg"
    }
}
