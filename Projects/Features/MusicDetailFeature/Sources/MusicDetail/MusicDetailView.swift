import DesignSystem
import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

@MainActor
private protocol MusicDetailStateProtocol {
    func updateTitle(title: String)
    func updateArtist(artist: String)
    func updateSelectedIndex(index: Int)
    func updateInitialSelectedIndex(index: Int)
    func updateThumbnails(thumbnailModels: [ThumbnailModel], completion: @escaping () -> Void)
    func updateBackgroundImage(thumbnailModel: ThumbnailModel)
    func updateIsDisabledSingingRoom(isDisabled: Bool)
    func updateIsDisabledPrevButton(isDisabled: Bool)
    func updateIsDisabledNextButton(isDisabled: Bool)
    func updateViews(views: Int)
    func updateIsLike(likes: Int, isLike: Bool)
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
    var creditButtonDidTap: Observable<Void> { get }
    var dismissButtonDidTap: Observable<Void> { get }
    var didTapArtistLabel: Observable<Void> { get }
}

final class MusicDetailView: UIView {
    private typealias SectionType = Int
    private typealias ItemType = ThumbnailModel

    private let thumbnailCellRegistration = UICollectionView.CellRegistration<
        ThumbnailCell, ItemType
    > { cell, _, itemIdentifier in
        cell.configure(thumbnailModel: itemIdentifier)
    }

    private lazy var thumbnailDiffableDataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>(
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

    fileprivate let dismissButton = UIButton().then {
        let dismissImage = DesignSystemAsset.MusicDetail.dismiss.image
            .withTintColor(DesignSystemAsset.PrimaryColorV2.white.color, renderingMode: .alwaysOriginal)
        $0.setImage(dismissImage, for: .normal)
    }

    fileprivate let creditButton = UIButton().then {
        let creditImage = DesignSystemAsset.MusicDetail.credit.image
            .withTintColor(DesignSystemAsset.PrimaryColorV2.white.color, renderingMode: .alwaysOriginal)
        $0.setImage(creditImage, for: .normal)
    }

    private let dimmedBackgroundView = UIView()
    private var dimmedLayer: DimmedGradientLayer?
    private let wmNavigationbarView = WMNavigationBarView()
    fileprivate let musicControlView = MusicControlView()
    fileprivate let musicToolbarView = MusicToolbarView()

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
            let dimmedLayer = DimmedGradientLayer(frame: dimmedBackgroundView.bounds)
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
            wmNavigationbarView,
            musicControlView,
            musicToolbarView
        )
    }

    func setLayout() {
        thumbnailCollectionView.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(wmNavigationbarView.snp.bottom).offset(44)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(thumbnailCollectionView.snp.width).multipliedBy(9.0 / 16.0)
        }

        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        wmNavigationbarView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }
        wmNavigationbarView.setLeftViews([dismissButton])
        wmNavigationbarView.setRightViews([creditButton])

        musicControlView.snp.makeConstraints {
            $0.top.equalTo(thumbnailCollectionView.snp.bottom).offset(20).priority(.required)
            $0.leading.trailing.equalToSuperview().inset(36)
            $0.bottom.lessThanOrEqualTo(musicToolbarView.snp.top)
            $0.height.equalTo(musicControlView.snp.width).multipliedBy(1.0 / 1.0)
        }

        musicToolbarView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-56)
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
        DispatchQueue.main.async {
            self.thumbnailCollectionView.scrollToItem(
                at: .init(row: index, section: 0),
                at: .centeredHorizontally,
                animated: false
            )
        }
    }

    func updateThumbnails(
        thumbnailModels: [ThumbnailModel],
        completion: @escaping () -> Void
    ) {
        var snapshot = thumbnailDiffableDataSource.snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(thumbnailModels, toSection: 0)
        thumbnailDiffableDataSource.apply(snapshot, completion: completion)
    }

    func updateBackgroundImage(thumbnailModel: ThumbnailModel) {
        let alternativeSources = [thumbnailModel.alternativeImageURL]
            .compactMap { URL(string: $0) }
            .map { Source.network($0) }

        backgroundImageView.kf.setImage(
            with: URL(string: thumbnailModel.imageURL),
            options: [
                .waitForCache,
                .transition(.fade(0.5)),
                .forceTransition,
                .processor(
                    DownsamplingImageProcessor(
                        size: .init(width: 10, height: 10)
                    )
                ),
                .alternativeSources(alternativeSources)
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

    func updateViews(views: Int) {
        musicToolbarView.updateViews(views: views)
    }

    func updateIsLike(likes: Int, isLike: Bool) {
        musicToolbarView.updateIsLike(likes: likes, isLike: isLike)
    }
}

extension Reactive: @preconcurrency MusicDetailActionProtocol where Base: MusicDetailView {
    var prevMusicButtonDidTap: Observable<Void> { base.musicControlView.rx.prevMusicButtonDidTap }
    var playMusicButtonDidTap: Observable<Void> { base.musicControlView.rx.playMusicButtonDidTap }
    var nextMusicButtonDidTap: Observable<Void> { base.musicControlView.rx.nextMusicButtonDidTap }
    var singingRoomButtonDidTap: Observable<Void> { base.musicControlView.rx.singingRoomButtonDidTap }
    var lyricsButtonDidTap: Observable<Void> { base.musicControlView.rx.lyricsButtonDidTap }
    @MainActor
    var likeButtonDidTap: Observable<Void> { base.musicToolbarView.rx.likeButtonDidTap }
    @MainActor
    var musicPickButtonDidTap: Observable<Void> { base.musicToolbarView.rx.musicPickButtonDidTap }
    @MainActor
    var playlistButtonDidTap: Observable<Void> { base.musicToolbarView.rx.playlistButtonDidTap }
    var creditButtonDidTap: Observable<Void> { base.creditButton.rx.tap.asObservable() }
    var dismissButtonDidTap: Observable<Void> { base.dismissButton.rx.tap.asObservable() }
    var didTapArtistLabel: Observable<Void> { base.musicControlView.rx.didTapArtistLabel }
}
