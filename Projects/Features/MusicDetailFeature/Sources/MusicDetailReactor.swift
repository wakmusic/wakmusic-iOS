import Foundation
import Kingfisher
import LogManager
import ReactorKit
import Utility

final class MusicDetailReactor: Reactor {
    enum Action {
        case prevButtonDidTap
        case playButtonDidTap
        case nextButtonDidTap
        case singingRoomButtonDiTap
        case lyricsButtonDidTap
        case creditButtonDidTap
        case likeButtonDidTap
        case musicPickButtonDidTap
        case playListButtonDidTap
    }

    enum Mutation {
        case updateSelectedIndex(Int)
        case navigate(NavigateType?)
    }

    enum NavigateType {
        case youtube(id: String)
        case credit(id: String)
    }

    struct State {
        var playlist: PlaylistModel
        var selectedIndex: Int
        var songs: [PlaylistModel.SongModel] { playlist.songs }
        var selectedSong: PlaylistModel.SongModel? {
            guard selectedIndex >= 0, selectedIndex < songs.count else { return nil }
            return songs[selectedIndex]
        }

        var isFirstSong: Bool { selectedIndex == 0 }
        var isLastSong: Bool { selectedIndex == songs.count - 1 }
        var navigateType: NavigateType?
    }

    private typealias Log = MusicDetailAnalyticsLog

    var initialState: State
    private let youtubeURLGenerator = YoutubeURLGenerator()

    init(
        playlist: PlaylistModel,
        selectedIndex: Int
    ) {
        #warning("'PlayState' 클래스가 v3 대응 완료 시 실제 로직 추가")
        self.initialState = .init(
            playlist: playlist,
            selectedIndex: selectedIndex
        )

        let urls = playlist.songs.map(\.videoID)
            .map { youtubeURLGenerator.generateHDThumbnailURL(id: $0) }
            .compactMap { URL(string: $0) }
        ImagePrefetcher(urls: urls).start()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .prevButtonDidTap:
            return prevButtonDidTap()
        case .playButtonDidTap:
            return playButtonDidTap()
        case .nextButtonDidTap:
            return nextButtonDidTap()
        case .singingRoomButtonDiTap:
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
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .updateSelectedIndex(index):
            newState.selectedIndex = index
        case let .navigate(navigate):
            newState.navigateType = navigate
        }
        return newState
    }
}

// MARK: - Mutate
private extension MusicDetailReactor {
    func prevButtonDidTap() -> Observable<Mutation> {
        guard !currentState.isFirstSong else { return .empty() }
        if let song = currentState.selectedSong {
            let log = Log.clickPrevMusicButton(
                key: currentState.playlist.key,
                id: song.videoID
            )
            LogManager.analytics(log)
        }
        let newIndex = currentState.selectedIndex - 1
        return .just(.updateSelectedIndex(newIndex))
    }

    func playButtonDidTap() -> Observable<Mutation> {
        guard let song = currentState.selectedSong else { return .empty() }
        if let song = currentState.selectedSong {
            let log = Log.clickPlaylistButton(
                key: currentState.playlist.key,
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
                key: currentState.playlist.key,
                id: song.videoID
            )
            LogManager.analytics(log)
        }
        let newIndex = currentState.selectedIndex + 1
        return .just(.updateSelectedIndex(newIndex))
    }

    func singingRoomButtonDiTap() -> Observable<Mutation> {
        guard let song = currentState.selectedSong else { return .empty() }
        let log = Log.clickSingingRoomButton(key: currentState.playlist.key, id: song.videoID)
        LogManager.analytics(log)
        return .empty()
    }

    func lyricsButtonDidTap() -> Observable<Mutation> {
        guard let song = currentState.selectedSong else { return .empty() }
        let log = Log.clickLyricsButton(key: currentState.playlist.key, id: song.videoID)
        LogManager.analytics(log)
        return .empty()
    }

    func creditButtonDidTap() -> Observable<Mutation> {
        guard let song = currentState.selectedSong else { return .empty() }
        let log = Log.clickCreditButton(key: currentState.playlist.key, id: song.videoID)
        LogManager.analytics(log)
        return .just(.navigate(.credit(id: song.videoID)))
    }

    func likeButtonDidTap() -> Observable<Mutation> {
        let isLike = currentState.selectedSong?.isLiked ?? false
        guard let song = currentState.selectedSong else { return .empty() }
        let log = Log.clickLikeMusicButton(
            key: currentState.playlist.key,
            id: song.videoID,
            like: !isLike
        )
        LogManager.analytics(log)
        return .empty()
    }

    func musicPickButtonDidTap() -> Observable<Mutation> {
        guard let song = currentState.selectedSong else { return .empty() }
        let log = Log.clickMusicPickButton(key: currentState.playlist.key, id: song.videoID)
        LogManager.analytics(log)
        return .empty()
    }

    func playListButtonDidTap() -> Observable<Mutation> {
        guard let song = currentState.selectedSong else { return .empty() }
        let log = Log.clickPlaylistButton(key: currentState.playlist.key, id: song.videoID)
        LogManager.analytics(log)
        return .empty()
    }
}
