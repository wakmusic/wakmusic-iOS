import BaseFeature
import BaseFeatureInterface
import DesignSystem
import LogManager
import LyricHighlightingFeatureInterface
import RxSwift
import SnapKit
import SongCreditFeatureInterface
import Then
import UIKit
import Utility

final class MusicDetailViewController: BaseReactorViewController<MusicDetailReactor> {
    private let musicDetailView = MusicDetailView()
    private let lyricHighlightingFactory: any LyricHighlightingFactory
    private let songCreditFactory: any SongCreditFactory
    private let containSongsFactory: any ContainSongsFactory
    private let playlistPresenterGlobalState: any PlayListPresenterGlobalStateProtocol

    init(
        reactor: MusicDetailReactor,
        lyricHighlightingFactory: any LyricHighlightingFactory,
        songCreditFactory: any SongCreditFactory,
        containSongsFactory: any ContainSongsFactory,
        playlistPresenterGlobalState: any PlayListPresenterGlobalStateProtocol
    ) {
        self.lyricHighlightingFactory = lyricHighlightingFactory
        self.songCreditFactory = songCreditFactory
        self.containSongsFactory = containSongsFactory
        self.playlistPresenterGlobalState = playlistPresenterGlobalState
        super.init(reactor: reactor)
    }

    override func loadView() {
        view = musicDetailView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogManager.analytics(CommonAnalyticsLog.viewPage(pageName: .musicDetail))
    }

    override func configureNavigation() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func bindState(reactor: MusicDetailReactor) {
        let sharedState = reactor.state
            .subscribe(on: MainScheduler.asyncInstance)
            .share(replay: 2)
        let youtubeURLGenerator = YoutubeURLGenerator()

        sharedState.map(\.songIDs)
            .distinctUntilChanged()
            .map { songs in
                songs.map { youtubeURLGenerator.generateHDThumbnailURL(id: $0) }
            }
            .bind(onNext: musicDetailView.updateThumbnails(thumbnailURLs:))
            .disposed(by: disposeBag)

        sharedState.map(\.isFirstSong)
            .distinctUntilChanged()
            .bind(onNext: musicDetailView.updateIsDisabledPrevButton(isDisabled:))
            .disposed(by: disposeBag)

        sharedState.map(\.isLastSong)
            .distinctUntilChanged()
            .bind(onNext: musicDetailView.updateIsDisabledNextButton(isDisabled:))
            .disposed(by: disposeBag)

        sharedState
            .compactMap(\.selectedSong)
            .distinctUntilChanged()
            .bind(with: self) { owner, song in
                owner.musicDetailView.updateTitle(title: song.title)
                owner.musicDetailView.updateArtist(artist: song.artistString)
                owner.musicDetailView.updateViews(views: song.views)
                owner.musicDetailView.updateIsLike(likes: song.likes, isLike: song.isLiked)
            }
            .disposed(by: disposeBag)

        sharedState
            .compactMap(\.selectedSong)
            .map(\.videoID)
            .distinctUntilChanged()
            .bind(with: self) { owner, songID in
                owner.musicDetailView.updateBackgroundImage(
                    imageURL: youtubeURLGenerator.generateHDThumbnailURL(id: songID)
                )
            }
            .disposed(by: disposeBag)

        sharedState
            .filter { !$0.songIDs.isEmpty }
            .map(\.selectedIndex)
            .skip(1)
            .distinctUntilChanged()
            .bind(onNext: musicDetailView.updateSelectedIndex(index:))
            .disposed(by: disposeBag)

        sharedState
            .filter { !$0.songIDs.isEmpty }
            .map(\.selectedIndex)
            .take(1)
            .bind(onNext: musicDetailView.updateInitialSelectedIndex(index:))
            .disposed(by: disposeBag)

        sharedState.compactMap(\.navigateType)
            .bind(with: self) { owner, navigate in
                switch navigate {
                case let .youtube(id):
                    owner.openYoutube(id: id)
                case let .credit(id):
                    owner.navigateCredits(id: id)
                case let .lyricsHighlighting(model):
                    owner.navigateLyricsHighlighing(model: model)
                case let .musicPick(id):
                    owner.presentMusicPick(id: id)
                case .playlist:
                    owner.presentPlaylist()
                case .dismiss:
                    owner.dismiss()
                }
            }
            .disposed(by: disposeBag)
    }

    override func bindAction(reactor: MusicDetailReactor) {
        self.rx.methodInvoked(#selector(viewDidLoad))
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        musicDetailView.rx.prevMusicButtonDidTap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.asyncInstance)
            .map { Reactor.Action.prevButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        musicDetailView.rx.nextMusicButtonDidTap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.asyncInstance)
            .map { Reactor.Action.nextButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        musicDetailView.rx.playMusicButtonDidTap
            .map { Reactor.Action.playButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        musicDetailView.rx.creditButtonDidTap
            .map { Reactor.Action.creditButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        musicDetailView.rx.singingRoomButtonDidTap
            .map { Reactor.Action.singingRoomButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        musicDetailView.rx.lyricsButtonDidTap
            .map { Reactor.Action.lyricsButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        musicDetailView.rx.likeButtonDidTap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.asyncInstance)
            .map { Reactor.Action.likeButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        musicDetailView.rx.musicPickButtonDidTap
            .map { Reactor.Action.musicPickButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        musicDetailView.rx.playlistButtonDidTap
            .map { Reactor.Action.playListButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        musicDetailView.rx.dismissButtonDidTap
            .map { Reactor.Action.dismissButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

private extension MusicDetailViewController {
    func openYoutube(id: String) {
        WakmusicYoutubePlayer(id: id).play()
    }

    func navigateCredits(id: String) {
        let viewController = songCreditFactory.makeViewController(songID: id)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func navigateLyricsHighlighing(model: LyricHighlightingRequiredModel) {
        let viewController = lyricHighlightingFactory.makeView(model: model)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func presentMusicPick(id: String) {
        let viewController = containSongsFactory.makeView(
            songs: [id]
        )
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }

    func presentPlaylist() {
        self.dismiss(animated: true) { [playlistPresenterGlobalState] in
            playlistPresenterGlobalState.presentPlayList()
        }
    }

    func dismiss() {
        self.dismiss(animated: true)
    }
}
