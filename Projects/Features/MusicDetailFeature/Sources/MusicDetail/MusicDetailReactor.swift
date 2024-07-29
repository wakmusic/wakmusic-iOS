import Foundation
import Kingfisher
import LogManager
import LyricHighlightingFeatureInterface
import ReactorKit
import SongsDomainInterface
import Utility

final class MusicDetailReactor: Reactor {
    enum Action {
        case viewDidLoad
        case prevButtonDidTap
        case playButtonDidTap
        case nextButtonDidTap
        case singingRoomButtonDidTap
        case lyricsButtonDidTap
        case creditButtonDidTap
        case likeButtonDidTap
        case musicPickButtonDidTap
        case playListButtonDidTap
        case dismissButtonDidTap
    }

    enum Mutation {
        case updateSelectedIndex(Int)
        case navigate(NavigateType?)
        case updateSongDictionary(key: String, value: SongModel)
    }

    enum NavigateType {
        case youtube(id: String)
        case credit(id: String)
        case lyricsHighlighting(model: LyricHighlightingRequiredModel)
        case musicPick(id: String)
        case playlist
        case dismiss
    }

    struct State {
        var songIDs: [String]
        var selectedIndex: Int
        var songDictionary: [String: SongModel] = [:]
        var selectedSong: SongModel? {
            guard selectedIndex >= 0, selectedIndex < songIDs.count else { return nil }
            return songDictionary[songIDs[selectedIndex]]
        }

        var isFirstSong: Bool { selectedIndex == 0 }
        var isLastSong: Bool { selectedIndex == songIDs.count - 1 }
        var navigateType: NavigateType?
    }

    private typealias Log = MusicDetailAnalyticsLog

    var initialState: State
    private let youtubeURLGenerator = YoutubeURLGenerator()
    private let fetchSongUseCase: any FetchSongUseCase

    init(
        songIDs: [String],
        selectedID: String,
        fetchSongUseCase: any FetchSongUseCase
    ) {
        let selectedIndex = songIDs.firstIndex(of: selectedID) ?? 0
        self.initialState = .init(
            songIDs: songIDs,
            selectedIndex: selectedIndex
        )

        self.fetchSongUseCase = fetchSongUseCase

        let urls = [
            songIDs[safe: selectedIndex - 1],
            songIDs[safe: selectedIndex],
            songIDs[safe: selectedIndex + 1]
        ]
        .compactMap { $0 }
        .map { youtubeURLGenerator.generateHDThumbnailURL(id: $0) }
        .compactMap { URL(string: $0) }

        ImagePrefetcher(urls: urls).start()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return viewDidLoad()
        case .prevButtonDidTap:
            return prevButtonDidTap()
        case .playButtonDidTap:
            return playButtonDidTap()
        case .nextButtonDidTap:
            return nextButtonDidTap()
        case .singingRoomButtonDidTap:
            return singingRoomButtonDiTap()
        case .lyricsButtonDidTap:
            return lyricsButtonDidTap()
        case .creditButtonDidTap:
            return creditButtonDidTap()
        case .likeButtonDidTap:
            return likeButtonDidTap()
        case .musicPickButtonDidTap:
            return musicPickButtonDidTap()
        case .playListButtonDidTap:
            return playListButtonDidTap()
        case .dismissButtonDidTap:
            return .just(.navigate(.dismiss))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .updateSelectedIndex(index):
            newState.selectedIndex = index
        case let .navigate(navigate):
            newState.navigateType = navigate
        case let .updateSongDictionary(key, value):
            newState.songDictionary[key] = value
        }
        return newState
    }
}

// MARK: - Mutate
private extension MusicDetailReactor {
    func viewDidLoad() -> Observable<Mutation> {
        let selectedIndex = currentState.selectedIndex
        guard let selectedSongID = currentState.songIDs[safe: selectedIndex] else { return .empty() }
        let prefetchingSongMutationObservable = [
            currentState.songIDs[safe: selectedIndex - 1],
            currentState.songIDs[safe: selectedIndex + 1]
        ].compactMap { $0 }
            .map { index in
                fetchSongUseCase.execute(id: index)
                    .map { Mutation.updateSongDictionary(key: index, value: $0.toModel(isLiked: false)) }
                    .asObservable()
            }

        let songMutationObservable = fetchSongUseCase.execute(id: selectedSongID)
            .map { Mutation.updateSongDictionary(key: selectedSongID, value: $0.toModel(isLiked: false)) }
            .asObservable()

        return Observable.merge(
            [songMutationObservable] + prefetchingSongMutationObservable
        )
    }

    func prevButtonDidTap() -> Observable<Mutation> {
        guard !currentState.isFirstSong else { return .empty() }
        if let song = currentState.selectedSong {
            let log = Log.clickPrevMusicButton(id: song.videoID)
            LogManager.analytics(log)
        }
        let newIndex = currentState.selectedIndex - 1
        prefetchThumbnailImage(index: newIndex)

        return .just(.updateSelectedIndex(newIndex))
    }

    func playButtonDidTap() -> Observable<Mutation> {
        guard let song = currentState.selectedSong else { return .empty() }
        if let song = currentState.selectedSong {
            let log = Log.clickPlaylistButton(
                id: song.videoID
            )
            LogManager.analytics(log)
        }
        return .concat(
            .just(.navigate(.youtube(id: song.videoID))),
            .just(.navigate(nil))
        )
    }

    func nextButtonDidTap() -> Observable<Mutation> {
        guard !currentState.isLastSong else { return .empty() }
        if let song = currentState.selectedSong {
            let log = Log.clickNextMusicButton(
                id: song.videoID
            )
            LogManager.analytics(log)
        }
        let newIndex = currentState.selectedIndex + 1
        prefetchThumbnailImage(index: newIndex)

        return .just(.updateSelectedIndex(newIndex))
    }

    func singingRoomButtonDiTap() -> Observable<Mutation> {
        guard let song = currentState.selectedSong else { return .empty() }
        let log = Log.clickSingingRoomButton(id: song.videoID)
        LogManager.analytics(log)
        return .empty()
    }

    func lyricsButtonDidTap() -> Observable<Mutation> {
        guard let song = currentState.selectedSong else { return .empty() }
        let log = Log.clickLyricsButton(id: song.videoID)
        LogManager.analytics(log)

        let lyricHighlightingModel = LyricHighlightingRequiredModel(
            songID: song.videoID,
            title: song.title,
            artist: song.artistString
        )
        return .concat(
            .just(.navigate(.lyricsHighlighting(model: lyricHighlightingModel))),
            .just(.navigate(nil))
        )
    }

    func creditButtonDidTap() -> Observable<Mutation> {
        guard let song = currentState.selectedSong else { return .empty() }
        let log = Log.clickCreditButton(id: song.videoID)
        LogManager.analytics(log)
        return .just(.navigate(.credit(id: song.videoID)))
    }

    func likeButtonDidTap() -> Observable<Mutation> {
        let isLike = currentState.selectedSong?.isLiked ?? false
        guard let song = currentState.selectedSong else { return .empty() }
        let log = Log.clickLikeMusicButton(
            id: song.videoID,
            like: isLike
        )
        LogManager.analytics(log)
        return .empty()
    }

    func musicPickButtonDidTap() -> Observable<Mutation> {
        guard let song = currentState.selectedSong else { return .empty() }
        let log = Log.clickMusicPickButton(id: song.videoID)
        LogManager.analytics(log)
        return .concat(
            .just(.navigate(.musicPick(id: song.videoID))),
            .just(.navigate(nil))
        )
    }

    func playListButtonDidTap() -> Observable<Mutation> {
        guard let song = currentState.selectedSong else { return .empty() }
        let log = Log.clickPlaylistButton(id: song.videoID)
        LogManager.analytics(log)
        return .concat(
            .just(.navigate(.playlist)),
            .just(.navigate(nil))
        )
    }
}

private extension MusicDetailReactor {
    func prefetchThumbnailImage(index: Int) {
        if let songID = currentState.songIDs[safe: index],
           let thumbnailPrefetchingSongID = currentState.songDictionary[songID]?.videoID,
           let thumbnailURL = URL(
               string: youtubeURLGenerator.generateHDThumbnailURL(id: thumbnailPrefetchingSongID)
           ) {
            ImagePrefetcher(urls: [thumbnailURL]).start()
        }
    }
}
