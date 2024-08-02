import Foundation
import Kingfisher
import LikeDomainInterface
import Localization
import LogManager
import LyricHighlightingFeatureInterface
import ReactorKit
import RxSwift
import SongsDomainInterface
import Utility

final class MusicDetailReactor: Reactor {
    private typealias Log = MusicDetailAnalyticsLog

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
        case textPopup(text: String, completion: () -> Void)
        case signin
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

    private let signInIsRequiredSubject = PublishSubject<Void>()

    var initialState: State
    private let youtubeURLGenerator = YoutubeURLGenerator()
    private let fetchSongUseCase: any FetchSongUseCase
    private let addLikeSongUseCase: any AddLikeSongUseCase
    private let cancelLikeSongUseCase: any CancelLikeSongUseCase

    init(
        songIDs: [String],
        selectedID: String,
        fetchSongUseCase: any FetchSongUseCase,
        addLikeSongUseCase: any AddLikeSongUseCase,
        cancelLikeSongUseCase: any CancelLikeSongUseCase
    ) {
        let selectedIndex = songIDs.firstIndex(of: selectedID) ?? 0
        self.initialState = .init(
            songIDs: songIDs,
            selectedIndex: selectedIndex
        )

        self.fetchSongUseCase = fetchSongUseCase
        self.addLikeSongUseCase = addLikeSongUseCase
        self.cancelLikeSongUseCase = cancelLikeSongUseCase

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
            return navigateMutation(navigate: .dismiss)
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

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let signInIsRequired = signInIsRequiredSubject
            .map { _ in Mutation.navigate(.signin) }

        return Observable.merge(mutation, signInIsRequired)
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
                    .map { $0.toModel() }
                    .map { Mutation.updateSongDictionary(key: index, value: $0) }
                    .asObservable()
            }

        let songMutationObservable = fetchSongUseCase.execute(id: selectedSongID)
            .map { $0.toModel() }
            .map { Mutation.updateSongDictionary(key: selectedSongID, value: $0) }
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

        return .concat(
            .just(.updateSelectedIndex(newIndex)),
            fetchSongDetailWith(index: newIndex)
        )
    }

    func playButtonDidTap() -> Observable<Mutation> {
        guard let song = currentState.selectedSong else { return .empty() }
        if let song = currentState.selectedSong {
            let log = Log.clickPlaylistButton(
                id: song.videoID
            )
            LogManager.analytics(log)
        }
        return navigateMutation(navigate: .youtube(id: song.videoID))
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

        return .concat(
            .just(.updateSelectedIndex(newIndex)),
            fetchSongDetailWith(index: newIndex)
        )
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
        return navigateMutation(navigate: .lyricsHighlighting(model: lyricHighlightingModel))
    }

    func creditButtonDidTap() -> Observable<Mutation> {
        guard let song = currentState.selectedSong else { return .empty() }
        let log = Log.clickCreditButton(id: song.videoID)
        LogManager.analytics(log)
        return navigateMutation(navigate: .credit(id: song.videoID))
    }

    func likeButtonDidTap() -> Observable<Mutation> {
        guard PreferenceManager.userInfo != nil else {
            return navigateMutation(
                navigate: NavigateType.textPopup(
                    text: LocalizationStrings.needLoginWarning,
                    completion: { [signInIsRequiredSubject] in
                        signInIsRequiredSubject.onNext(())
                    }
                )
            )
        }

        guard let song = currentState.selectedSong else { return .empty() }
        let isLike = currentState.selectedSong?.isLiked ?? false
        let log = Log.clickLikeMusicButton(
            id: song.videoID,
            like: isLike
        )

        let newLike = !isLike
        let newSong = if newLike {
            song.updateIsLiked(likes: song.likes + 1, isLiked: newLike)
        } else {
            song.updateIsLiked(likes: song.likes - 1, isLiked: newLike)
        }
        LogManager.analytics(log)

        return if newLike {
            .concat(
                .just(.updateSongDictionary(key: newSong.videoID, value: newSong)),
                addLikeSongUseCase.execute(id: newSong.videoID)
                    .asObservable()
                    .flatMap { _ in Observable.empty() }
            )
        } else {
            .concat(
                .just(.updateSongDictionary(key: newSong.videoID, value: newSong)),
                cancelLikeSongUseCase.execute(id: newSong.videoID)
                    .asObservable()
                    .flatMap { _ in Observable.empty() }
            )
        }
    }

    func musicPickButtonDidTap() -> Observable<Mutation> {
        guard PreferenceManager.userInfo != nil else {
            return navigateMutation(
                navigate: NavigateType.textPopup(
                    text: LocalizationStrings.needLoginWarning,
                    completion: { [signInIsRequiredSubject] in
                        signInIsRequiredSubject.onNext(())
                    }
                )
            )
        }
        guard let song = currentState.selectedSong else { return .empty() }
        let log = Log.clickMusicPickButton(id: song.videoID)
        LogManager.analytics(log)
        return navigateMutation(navigate: .musicPick(id: song.videoID))
    }

    func playListButtonDidTap() -> Observable<Mutation> {
        guard let song = currentState.selectedSong else { return .empty() }
        let log = Log.clickPlaylistButton(id: song.videoID)
        LogManager.analytics(log)
        return navigateMutation(navigate: .playlist)
    }
}

// MARK: - Private Methods

private extension MusicDetailReactor {
    func navigateMutation(navigate: NavigateType) -> Observable<Mutation> {
        return .concat(
            .just(.navigate(navigate)),
            .just(.navigate(nil))
        )
    }

    func prefetchThumbnailImage(index: Int) {
        let prefetchingSongImageURLs = [
            currentState.songIDs[safe: index - 1],
            currentState.songIDs[safe: index],
            currentState.songIDs[safe: index + 1]
        ].compactMap { $0 }
            .compactMap { URL(string: youtubeURLGenerator.generateHDThumbnailURL(id: $0)) }
        ImagePrefetcher(urls: prefetchingSongImageURLs).start()
    }

    func fetchSongDetailWith(index: Int) -> Observable<Mutation> {
        let prefetchingSongMutationObservable = [
            currentState.songIDs[safe: index - 1],
            currentState.songIDs[safe: index + 1]
        ].compactMap { $0 }
            .filter { currentState.songDictionary[$0] == nil }
            .map { index in
                fetchSongUseCase.execute(id: index)
                    .map { $0.toModel() }
                    .map { Mutation.updateSongDictionary(key: index, value: $0) }
                    .asObservable()
            }

        guard let songID = currentState.songIDs[safe: index] else {
            return Observable.merge(
                prefetchingSongMutationObservable
            )
        }

        guard currentState.songDictionary[songID] == nil else {
            return Observable.merge(
                prefetchingSongMutationObservable
            )
        }

        let currentSongMutationObservable = fetchSongUseCase.execute(id: songID)
            .map { $0.toModel() }
            .map { Mutation.updateSongDictionary(key: songID, value: $0) }
            .asObservable()

        return Observable.merge(
            [currentSongMutationObservable] + prefetchingSongMutationObservable
        )
    }
}
