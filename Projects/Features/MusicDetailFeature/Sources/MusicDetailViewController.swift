import BaseFeature
import DesignSystem
import LogManager
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

final class MusicDetailViewController: BaseReactorViewController<MusicDetailReactor> {
    private let musicDetailView = MusicDetailView()
    private let creditBarButton = UIBarButtonItem(
        image: DesignSystemAsset.MusicDetail.credit.image
            .withTintColor(DesignSystemAsset.PrimaryColorV2.white.color, renderingMode: .alwaysOriginal),
        style: .plain,
        target: nil,
        action: nil
    )

    override func loadView() {
        view = musicDetailView
    }

    override func configureNavigation() {
        self.navigationItem.setRightBarButton(creditBarButton, animated: true)
    }

    override func bindState(reactor: MusicDetailReactor) {
        let sharedState = reactor.state.share(replay: 8)
        let youtubeURLGenerator = YoutubeURLGenerator()

        sharedState.map(\.songs)
            .distinctUntilChanged()
            .map { songs in
                songs.map { youtubeURLGenerator.generateHDThumbnailURL(id: $0.videoID) }
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
            .bind(with: self) { owner, song in
                owner.musicDetailView.updateTitle(title: song.title)
                owner.musicDetailView.updateArtist(artist: song.artists.joined(separator: ", "))

                owner.musicDetailView.updateBackgroundImage(
                    imageURL: youtubeURLGenerator.generateHDThumbnailURL(id: song.videoID)
                )
            }
            .disposed(by: disposeBag)

        sharedState
            .filter { !$0.songs.isEmpty }
            .map(\.selectedIndex)
            .skip(1)
            .distinctUntilChanged()
            .bind(onNext: musicDetailView.updateSelectedIndex(index:))
            .disposed(by: disposeBag)

        sharedState
            .filter { !$0.songs.isEmpty }
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
                }
            }
            .disposed(by: disposeBag)
    }

    override func bindAction(reactor: MusicDetailReactor) {
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

        creditBarButton.rx.tap
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
    }
}

private extension MusicDetailViewController {
    func openYoutube(id: String) {
        let youtubeURLGenerator = YoutubeURLGenerator()

        guard
            let youtubeAppURL = URL(string: youtubeURLGenerator.generateYoutubeVideoAppURL(id: id))
        else { return }
        if UIApplication.shared.canOpenURL(youtubeAppURL) {
            UIApplication.shared.open(youtubeAppURL)
        } else if
            let youtubeWebURL = URL(string: youtubeURLGenerator.generateYoutubeVideoWebURL(id: id)),
            UIApplication.shared.canOpenURL(youtubeWebURL) {
            UIApplication.shared.open(youtubeWebURL)
        }
    }

    func navigateCredits(id: String) {
        LogManager.printDebug("Navigate Music Credit : id=\(id)")
    }
}
