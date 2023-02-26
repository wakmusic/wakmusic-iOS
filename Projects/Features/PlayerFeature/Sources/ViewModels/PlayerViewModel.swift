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
//import YoutubeKit
import DomainModule
import Combine
import YouTubePlayerKit

final class PlayerViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let closeButtonDidTapEvent: Observable<Void>
        let playButtonDidTapEvent: Observable<Void>
        let prevButtonDidTapEvent: Observable<Void>
        let nextButtonDidTapEvent: Observable<Void>
        let sliderValueChangedEvent: Observable<Float>
        let repeatButtonDidTapEvent: Observable<Void>
        let shuffleButtonDidTapEvent: Observable<Void>
        let likeButtonDidTapEvent: Observable<Void>
        let addPlaylistButtonDidTapEvent: Observable<Void>
        let playlistButtonDidTapEvent: Observable<Void>
        let miniExtendButtonDidTapEvent: Observable<Void>
        let miniPlayButtonDidTapEvent: Observable<Void>
        let miniCloseButtonDidTapEvent: Observable<Void>
    }
    struct Output {
        var playerState = CurrentValueSubject<YouTubePlayer.PlaybackState, Never>(.unstarted)
        var titleText = CurrentValueSubject<String, Never>("")
        var artistText = CurrentValueSubject<String, Never>("")
        var thumbnailImageURL = CurrentValueSubject<String, Never>("")
        var lyricsArray = CurrentValueSubject<[String], Never>(["", "", "", "", ""])
        var playTimeValue = CurrentValueSubject<Float, Never>(0.0)
        var totalTimeValue = CurrentValueSubject<Float, Never>(0.0)
        var playTimeText = CurrentValueSubject<String, Never>("0:00")
        var totalTimeText = CurrentValueSubject<String, Never>("0:00")
        var likeCountText = CurrentValueSubject<String, Never>("")
        var viewsCountText = CurrentValueSubject<String, Never>("")
        var didPlay = PublishRelay<Bool>()
        var didClose = PublishRelay<Bool>()
        var didPrev = PublishRelay<Bool>()
        var didNext = PublishRelay<Bool>()
        var lyricsDidChangedEvent = PassthroughSubject<Bool, Never>()
    }
    
    var fetchLyricsUseCase: FetchLyricsUseCase!
    
    private let playState = PlayState.shared
    private let disposeBag = DisposeBag()
    private var subscription = Set<AnyCancellable>()
    internal var lyricsDict = [Float : String]()
    internal var sortedLyrics = [String]()
    internal var isLyricsScrolling = false
    
    init(fetchLyricsUseCase: FetchLyricsUseCase) {
        self.fetchLyricsUseCase = fetchLyricsUseCase
        print("✅ PlayerViewModel 생성")
    }
    
    func transform(from input: Input) -> Output {
        let output = Output()
        
        Observable.of(input.playButtonDidTapEvent, input.miniPlayButtonDidTapEvent).merge()
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                let state = self.playState.state
                state == .playing ? self.playState.pause() : self.playState.play()
            })
            .disposed(by: disposeBag)
        
        input.miniExtendButtonDidTapEvent.subscribe { _ in
            print("미니플레이어 확장버튼 눌림")
        }.disposed(by: disposeBag)
        
        input.miniCloseButtonDidTapEvent.subscribe { _ in
            print("미니플레이어 닫기버튼 눌림")
            output.didClose.accept(true)
        }.disposed(by: disposeBag)
        
        input.prevButtonDidTapEvent.subscribe { [weak self] _ in
            guard let self else { return }
            self.playState.backWard()
        }.disposed(by: disposeBag)
        
        input.nextButtonDidTapEvent.subscribe { [weak self] _ in
            guard let self else { return }
            self.playState.forWard()
        }.disposed(by: disposeBag)
        
        input.sliderValueChangedEvent.subscribe { [weak self] value in
            guard let self else { return }
            self.playState.player.seek(to: Double(value), allowSeekAhead: true)
        }.disposed(by: disposeBag)
        
        playState.$state.sink { [weak self] state in
            guard let self else { return }
            output.playerState.send(state)
            if state == .ended {
                self.playState.forWard()
            }
        }.store(in: &subscription)
        
        playState.$currentSong.sink { [weak self] song in
            guard let self else { return }
            guard let song = song else { return }
            output.thumbnailImageURL.send(self.thumbnailURL(from: song.id))
            output.titleText.send(song.title)
            output.artistText.send(song.artist)
            output.viewsCountText.send(self.formatNumber(song.views))
            output.likeCountText.send("준비중")
            
            // 곡이 변경되면 가사 불러오기
            self.fetchLyricsUseCase.execute(id: song.id)
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
//                self.sortedLyrics.insert("", at: 0)
//                self.sortedLyrics.insert("", at: 0)
//                self.sortedLyrics.append("")
//                self.sortedLyrics.append("")
                output.lyricsDidChangedEvent.send(true)
            }.disposed(by: self.disposeBag)

            
        }.store(in: &subscription)
        
        playState.$progress.sink { [weak self] progress in
            guard let self else { return }
            output.playTimeText.send(self.formatTime(progress.currentProgress))
            output.totalTimeText.send(self.formatTime(progress.endProgress))
            output.playTimeValue.send(Float(progress.currentProgress))
            output.totalTimeValue.send(Float(progress.endProgress))
        }.store(in: &subscription)
        
        return output
    }
    
    func formatTime(_ second: Double) -> String {
        let second = Int(floor(second))
        let min = second / 60
        let sec = String(format: "%02d", second % 60)
        return "\(min):\(sec)"
    }
    
    func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        
        switch number {
        case 1000..<10_000:
            let thousands = Double(number) / 1000.0
            return formatter.string(from: NSNumber(value: thousands))! + "천"
        case 10_000..<100_000_000:
            let tenThousands = Double(number) / 10000.0
            return formatter.string(from: NSNumber(value: tenThousands))! + "만"
        default:
            let millions = Double(number) / 100000000.0
            return formatter.string(from: NSNumber(value: millions))! + "억"
        }
    }
    
    func thumbnailURL(from id: String) -> String {
        return "https://i.ytimg.com/vi/\(id)/hqdefault.jpg"
    }
    
    func getCurrentLyricsIndex(_ currentTime: Float) -> Int {
        let times = lyricsDict.keys.sorted()
        let index = binarySearch(at: times, target: currentTime)
        return index
    }
    
    /// 이진탐색 O(log n)
    func binarySearch(at array: [Float], target: Float) -> Int {
        var left = 0
        var right = array.count - 1

        while left < right {
            let mid = (left + right) / 2
            if target < array[mid] {
                right = mid
            } else {
                left = mid + 1
            }
        }
        return max(left - 1, 0) // 0 이상 정수로만 반환
    }
    
}
