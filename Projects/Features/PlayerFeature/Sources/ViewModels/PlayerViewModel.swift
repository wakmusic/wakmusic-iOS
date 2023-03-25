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

final class PlayerViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let closeButtonDidTapEvent: Observable<Void>
        let playButtonDidTapEvent: Observable<Void>
        let prevButtonDidTapEvent: Observable<Void>
        let nextButtonDidTapEvent: Observable<Void>
        let sliderValueChangedEvent: Observable<Float>
        let repeatButtonDidTapEvent: AnyPublisher<Void, Never>
        let shuffleButtonDidTapEvent: Observable<Void>
        let likeButtonDidTapEvent: AnyPublisher<Void, Never>
        let addPlaylistButtonDidTapEvent: AnyPublisher<Void, Never>
        let playlistButtonDidTapEvent: AnyPublisher<Void, Never>
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
        var repeatMode = CurrentValueSubject<RepeatMode, Never>(.none)
        var likeState = CurrentValueSubject<Bool, Never>(false)
        var didPlay = PublishRelay<Bool>()
        var didClose = PublishRelay<Bool>()
        var didPrev = PublishRelay<Bool>()
        var didNext = PublishRelay<Bool>()
        var lyricsDidChangedEvent = PassthroughSubject<Bool, Never>()
        var willShowPlaylist = PassthroughSubject<Bool, Never>()
        var showToastMessage = PassthroughSubject<String, Never>()
    }
    
    var fetchLyricsUseCase: FetchLyricsUseCase!
    var addLikeSongUseCase: AddLikeSongUseCase!
    var cancelLikeSongUseCase: CancelLikeSongUseCase!
    var fetchLikeNumOfSongUseCase: FetchLikeNumOfSongUseCase!
    var fetchFavoriteSongsUseCase: FetchFavoriteSongsUseCase!
    
    private let playState = PlayState.shared
    private let disposeBag = DisposeBag()
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
        
        input.repeatButtonDidTapEvent.sink { [weak self] _ in
            guard let self else { return }
            switch self.playState.repeatMode {
            case .none:
                self.playState.repeatMode = .repeatAll
            case .repeatAll:
                self.playState.repeatMode = .repeatOnce
            case .repeatOnce:
                self.playState.repeatMode = .none
            }
        }.store(in: &subscription)
        
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
        
        input.likeButtonDidTapEvent.sink { [weak self] _ in
            guard let self else { return }
            guard let currentSong = self.playState.currentSong else { return }
            let alreadyLiked = output.likeState.value
            
            if alreadyLiked {
                self.cancelLikeSong(for: currentSong, output: output)
            } else {
                self.addLikeSong(for: currentSong, output: output)
            }

        }.store(in: &subscription)
        
        input.playlistButtonDidTapEvent.sink { _ in
            output.willShowPlaylist.send(true)
        }.store(in: &subscription)
        
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
            let thumbnailURL = Utility.WMImageAPI.fetchYoutubeThumbnail(id: song.id).toString
            output.thumbnailImageURL.send(thumbnailURL)
            output.titleText.send(song.title)
            output.artistText.send(song.artist)
            output.viewsCountText.send(self.formatNumber(song.views))
            output.likeCountText.send("준비중")
            
            self.fetchLyrics(for: song, output: output)
            self.fetchLikeCount(for: song, output: output)
            self.fetchLikeState(for: song, output: output)
            
        }.store(in: &subscription)
        
        playState.$progress.sink { [weak self] progress in
            guard let self else { return }
            output.playTimeText.send(self.formatTime(progress.currentProgress))
            output.totalTimeText.send(self.formatTime(progress.endProgress))
            output.playTimeValue.send(Float(progress.currentProgress))
            output.totalTimeValue.send(Float(progress.endProgress))
        }.store(in: &subscription)
        
        playState.$repeatMode.sink { repeatMode in
            output.repeatMode.send(repeatMode)
        }.store(in: &subscription)
        
        return output
    }
    
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
    
    /// 좋아요를 누른 곡인지 여부 판별
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

// MARK: - 뷰모델 내 유틸리티 함수들을 모아놓은 곳입니다.
extension PlayerViewModel {
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
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        
        switch number {
        case 0..<1000:
            return String(number)
        case 1000..<10_000:
            let thousands = Double(number) / 1000.0
            return formatter.string(from: NSNumber(value: thousands))! + "천"
        case 10_000..<100_000_0:
            let tenThousands = Double(number) / 10000.0
            return formatter.string(from: NSNumber(value: tenThousands))! + "만"
        case 100_000_0..<100_000_000:
            let tenThousands = Int(number) / 10000
            return formatter.string(from: NSNumber(value: tenThousands))! + "만"
        default:
            let millions = Double(number) / 100000000.0
            return formatter.string(from: NSNumber(value: millions))! + "억"
        }
    }
    
    func getCurrentLyricsIndex(_ currentTime: Float) -> Int {
        let times = lyricsDict.keys.sorted()
        let index = closestIndex(to: currentTime, in: times)
        return index
    }
    
    /// target보다 작거나 같은 값 중에서 가장 가까운 값을 찾습니다. O(log n)
    func closestIndex(to target: Float, in arr: [Float]) -> Int {
        var left = 0
        var right = arr.count - 1
        var closestIndex = 0
        var closestDistance = Float.greatestFiniteMagnitude
        
        while left <= right {
            let mid = (left + right) / 2
            let midValue = arr[mid]
            
            if midValue <= target {
                let distance = target - midValue
                if distance < closestDistance {
                    closestDistance = distance
                    closestIndex = mid
                }
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
        
        return closestIndex
    }
}
