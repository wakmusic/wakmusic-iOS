import DesignSystem
import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

private protocol MusicDetailStateProtocol {
    func updateTitle(title: String)
    func updateArtist(artist: String)
    func updateSelectedIndex(index: Int)
    func updateInitialSelectedIndex(index: Int)
    func updateThumbnails(thumbnailURLs: [String])
    func updateBackgroundImage(imageURL: String)
    func updateIsDisabledSingingRoom(isDisabled: Bool)
    func updateIsDisabledPrevButton(isDisabled: Bool)
    func updateIsDisabledNextButton(isDisabled: Bool)
    func updateIsLike(isLike: Bool)
}

private protocol MusicDetailActionProtocol {
    var prevMusicButtonDidTap: Observable<Void> { get }
    var playMusicButtonDidTap: Observable<Void> { get }
    var nextMusicButtonDidTap: Observable<Void> { get }
    var singingRoomButtonDidTap: Observable<Void> { get }
    var lyricsButtonDidTap: Observable<Void> { get }
    var likeButtonDidTap: Observable<Void> { get }
    var musicPickButtonDidTap: Observable<Void> { get }
    var playlistButtonDidTap: Observable<Void> { get }
}

final class MusicDetailView: UIView {
    private let thumbnailCellRegistration = UICollectionView.CellRegistration<
        ThumbnailCell, String
    > { cell, _, itemIdentifier in
        cell.configure(thumbnailImageURL: itemIdentifier)
    }

    private lazy var thumbnailDiffableDataSource = UICollectionViewDiffableDataSource<Int, String>(
        collectionView: thumbnailCollectionView
    ) { [thumbnailCellRegistration] collectionView, indexPath, itemIdentifier in
        let cell = collectionView.dequeueConfiguredReusableCell(
            using: thumbnailCellRegistration,
            for: indexPath,
            item: itemIdentifier
        )
        return cell
    }

    private let thumbnailCollectionView = ThumbnailCollectionView()
    private let backgroundImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    private let dimmedBackgroundView = UIView()
    fileprivate let musicControlView = MusicControlView()
    fileprivate let musicToolbarView = MusicToolbarView()
    private var dimmedLayer: MusicDetailDimmedGradientLayer?

    init() {
        super.init(frame: .zero)
        addView()
        setLayout()
        self.backgroundColor = .white
        thumbnailCollectionView.delegate = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if dimmedLayer == nil {
            let dimmedLayer = MusicDetailDimmedGradientLayer(frame: dimmedBackgroundView.bounds)
            self.dimmedLayer = dimmedLayer
            dimmedBackgroundView.layer.addSublayer(dimmedLayer)
        }
    }
}

extension MusicDetailView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        collectionView.frame.size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {}
}

private extension MusicDetailView {
    func addView() {
        self.addSubviews(
            backgroundImageView,
            dimmedBackgroundView,
            thumbnailCollectionView,
            musicControlView,
            musicToolbarView
        )
    }

    func setLayout() {
        thumbnailCollectionView.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(self.safeAreaLayoutGuide.snp.top).offset(52)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(thumbnailCollectionView.snp.width).multipliedBy(9.0 / 16.0)
        }

        backgroundImageView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalToSuperview()
        }

        musicControlView.snp.makeConstraints {
            $0.top.equalTo(thumbnailCollectionView.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(36)
            $0.bottom.lessThanOrEqualTo(musicToolbarView.snp.top)
            $0.height.equalTo(musicControlView.snp.width).multipliedBy(1.0 / 1.0)
        }

        let safeAreaBottomHeight: CGFloat
        if #available(iOS 15.0, *) {
            safeAreaBottomHeight = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .filter { $0.activationState == .foregroundActive }
                .first?
                .keyWindow?
                .safeAreaInsets
                .bottom ?? 0
        } else {
            safeAreaBottomHeight = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .filter { $0.activationState == .foregroundActive }
                .first?
                .windows
                .first(where: \.isKeyWindow)?
                .safeAreaInsets
                .bottom ?? 0
        }
        musicToolbarView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(safeAreaBottomHeight + 56)
        }

        dimmedBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(musicToolbarView.snp.top)
        }
    }
}

extension MusicDetailView: MusicDetailStateProtocol {
    func updateTitle(title: String) {
        musicControlView.updateTitle(title: title)
    }

    func updateArtist(artist: String) {
        musicControlView.updateArtist(artist: artist)
    }

    func updateSelectedIndex(index: Int) {
        thumbnailCollectionView.scrollToItem(
            at: .init(row: index, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
    }

    func updateInitialSelectedIndex(index: Int) {
        thumbnailCollectionView.scrollToItem(
            at: .init(row: index, section: 0),
            at: .centeredHorizontally,
            animated: false
        )
    }

    func updateThumbnails(thumbnailURLs: [String]) {
        var snapshot = thumbnailDiffableDataSource.snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(thumbnailURLs, toSection: 0)
        thumbnailDiffableDataSource.apply(snapshot)
    }

    func updateBackgroundImage(imageURL: String) {
        backgroundImageView.kf.setImage(
            with: URL(string: imageURL),
            options: [
                .waitForCache,
                .onlyFromCache,
                .transition(.fade(0.5)),
                .forceTransition,
                .processor(
                    DownsamplingImageProcessor(
                        size: .init(width: 10, height: 10)
                    )
                )
            ]
        )
    }

    func updateIsDisabledSingingRoom(isDisabled: Bool) {
        musicControlView.updateIsDisabledSingingRoom(isDisabled: isDisabled)
    }

    func updateIsDisabledPrevButton(isDisabled: Bool) {
        musicControlView.updateIsDisabledPrevButton(isDisabled: isDisabled)
    }

    func updateIsDisabledNextButton(isDisabled: Bool) {
        musicControlView.updateIsDisabledNextButton(isDisabled: isDisabled)
    }

    func updateIsLike(isLike: Bool) {
        musicToolbarView.updateIsLike(isLike: isLike)
    }
}

extension Reactive: MusicDetailActionProtocol where Base: MusicDetailView {
    var prevMusicButtonDidTap: Observable<Void> { base.musicControlView.rx.prevMusicButtonDidTap }
    var playMusicButtonDidTap: Observable<Void> { base.musicControlView.rx.playMusicButtonDidTap }
    var nextMusicButtonDidTap: Observable<Void> { base.musicControlView.rx.nextMusicButtonDidTap }
    var singingRoomButtonDidTap: Observable<Void> { base.musicControlView.rx.singingRoomButtonDidTap }
    var lyricsButtonDidTap: Observable<Void> { base.musicControlView.rx.lyricsButtonDidTap }
    var likeButtonDidTap: Observable<Void> { base.musicToolbarView.rx.likeButtonDidTap }
    var musicPickButtonDidTap: Observable<Void> { base.musicToolbarView.rx.musicPickButtonDidTap }
    var playlistButtonDidTap: Observable<Void> { base.musicToolbarView.rx.playlistButtonDidTap }
}
