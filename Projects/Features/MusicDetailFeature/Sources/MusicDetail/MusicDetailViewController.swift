import ArtistFeatureInterface
import BaseFeature
import BaseFeatureInterface
import DesignSystem
import LogManager
import LyricHighlightingFeatureInterface
import MusicDetailFeatureInterface
import RxSwift
import SignInFeatureInterface
import SnapKit
import SongCreditFeatureInterface
import Then
import UIKit
import Utility

final class MusicDetailViewController: BaseReactorViewController<MusicDetailReactor> {
    private let musicDetailView = MusicDetailView()
    private let lyricHighlightingFactory: any LyricHighlightingFactory
    private let songCreditFactory: any SongCreditFactory
    private let signInFactory: any SignInFactory
    private let containSongsFactory: any ContainSongsFactory
    private let textPopupFactory: any TextPopupFactory
    private let karaokeFactory: any KaraokeFactory
    private let artistDetailFactory: any ArtistDetailFactory
    private let playlistPresenterGlobalState: any PlayListPresenterGlobalStateProtocol

    init(
        reactor: MusicDetailReactor,
        lyricHighlightingFactory: any LyricHighlightingFactory,
        songCreditFactory: any SongCreditFactory,
        signInFactory: any SignInFactory,
        containSongsFactory: any ContainSongsFactory,
        textPopupFactory: any TextPopupFactory,
        karaokeFactory: any KaraokeFactory,
        artistDetailFactory: any ArtistDetailFactory,
        playlistPresenterGlobalState: any PlayListPresenterGlobalStateProtocol
    ) {
        self.lyricHighlightingFactory = lyricHighlightingFactory
        self.songCreditFactory = songCreditFactory
        self.signInFactory = signInFactory
        self.containSongsFactory = containSongsFactory
        self.textPopupFactory = textPopupFactory
        self.karaokeFactory = karaokeFactory
        self.artistDetailFactory = artistDetailFactory
        self.playlistPresenterGlobalState = playlistPresenterGlobalState
        super.init(reactor: reactor)
    }

    override func loadView() {
        view = musicDetailView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogManager.analytics(CommonAnalyticsLog.viewPage(pageName: .musicDetail))
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func configureNavigation() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func bindState(reactor: MusicDetailReactor) {
        let sharedState = reactor.state
            .subscribe(on: MainScheduler.asyncInstance)
            .share(replay: 8)
        let youtubeURLGenerator = YoutubeURLGenerator()

        sharedState.map(\.songIDs)
            .distinctUntilChanged()
            .map { songs in
                songs.map {
                    ThumbnailModel(
                        imageURL: youtubeURLGenerator.generateHDThumbnailURL(id: $0),
                        alternativeImageURL: youtubeURLGenerator.generateThumbnailURL(id: $0)
                    )
                }
                .uniqued()
                .toArray()
            }
            .bind { [musicDetailView] thumbnailModels in
                musicDetailView.updateThumbnails(thumbnailModels: thumbnailModels) {
                    musicDetailView.updateInitialSelectedIndex(index: reactor.initialState.selectedIndex)
                }
            }
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

                let isEnabled = song.karaokeNumber.ky != nil || song.karaokeNumber.tj != nil
                owner.musicDetailView.updateIsDisabledSingingRoom(isDisabled: !isEnabled)
            }
            .disposed(by: disposeBag)

        sharedState
            .compactMap(\.selectedSong)
            .map(\.videoID)
            .distinctUntilChanged()
            .bind(with: self) { owner, songID in
                owner.musicDetailView.updateBackgroundImage(
                    thumbnailModel: .init(
                        imageURL: youtubeURLGenerator.generateHDThumbnailURL(id: songID),
                        alternativeImageURL: youtubeURLGenerator.generateThumbnailURL(id: songID)
                    )
                )
            }
            .disposed(by: disposeBag)

        sharedState
            .filter { !$0.songIDs.isEmpty }
            .map(\.selectedIndex)
            .skip(3)
            .distinctUntilChanged()
            .bind(onNext: musicDetailView.updateSelectedIndex(index:))
            .disposed(by: disposeBag)

        sharedState.compactMap(\.navigateType)
            .bind(with: self) { owner, navigate in
                switch navigate {
                case let .youtube(id, playPlatform):
                    owner.openYoutube(id: id, playPlatform: playPlatform)
                case let .credit(id):
                    owner.navigateCredits(id: id)
                case let .lyricsHighlighting(model):
                    owner.navigateLyricsHighlighing(model: model)
                case let .musicPick(id):
                    owner.presentMusicPick(id: id)
                case let .playlist(id):
                    owner.presentPlaylist(id: id)
                case let .textPopup(text, completion):
                    owner.presentTextPopup(text: text, completion: completion)
                case .signin:
                    owner.presentSignIn()
                case let .karaoke(ky, tj):
                    owner.presentKaraokeSheet(ky: ky, tj: tj)
                case let .artist(artistID):
                    owner.navigateArtist(artistID: artistID)
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

        self.rx.methodInvoked(#selector(viewWillDisappear))
            .map { _ in Reactor.Action.viewWillDisappear }
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

        musicDetailView.rx.didTapArtistLabel
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.asyncInstance)
            .map { Reactor.Action.didTapArtistLabel }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

private extension MusicDetailViewController {
    func openYoutube(id: String, playPlatform: WakmusicYoutubePlayer.PlayPlatform = .automatic) {
        WakmusicYoutubePlayer(id: id, playPlatform: playPlatform).play()
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

    func presentPlaylist(id: String) {
        self.dismiss(animated: true) { [playlistPresenterGlobalState] in
            playlistPresenterGlobalState.presentPlayList(currentSongID: id)
        }
    }

    func presentTextPopup(text: String, completion: @escaping () -> Void) {
        let viewController = textPopupFactory.makeView(
            text: text,
            cancelButtonIsHidden: false,
            confirmButtonText: "확인",
            cancelButtonText: "취소",
            completion: completion,
            cancelCompletion: nil
        )
        self.showBottomSheet(content: viewController)
    }

    func presentKaraokeSheet(ky: Int?, tj: Int?) {
        let viewController = karaokeFactory.makeViewController(ky: ky, tj: tj)
        self.showBottomSheet(content: viewController)
    }

    func presentSignIn() {
        let viewController = signInFactory.makeView()
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true)
    }

    func navigateArtist(artistID: String) {
        let viewController = artistDetailFactory.makeView(artistID: artistID)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func dismiss() {
        self.dismiss(animated: true)
    }
}

extension MusicDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
