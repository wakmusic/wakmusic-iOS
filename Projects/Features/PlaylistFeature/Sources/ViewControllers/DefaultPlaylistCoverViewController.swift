import BaseFeature
import DesignSystem
import ImageDomainInterface
import PlaylistFeatureInterface
import SnapKit
import Then
import UIKit

final class DefaultPlaylistCoverViewController: BaseReactorViewController<DefaultPlaylistCoverReactor> {
    weak var delegate: DefaultPlaylistCoverDelegate?

    private var wmNavigationbarView: WMNavigationBarView = WMNavigationBarView().then {
        $0.setTitle("이미지 선택")
    }

    private let dismissButton = UIButton().then {
        let dismissImage = DesignSystemAsset.MusicDetail.dismiss.image
            .withTintColor(DesignSystemAsset.BlueGrayColor.blueGray900.color, renderingMode: .alwaysOriginal)
        $0.setImage(dismissImage, for: .normal)
    }

    private let shadowImageVIew: UIImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = DesignSystemAsset.LyricHighlighting.lyricDecoratingBottomShadow.image
    }

    private let buttonContainerView: UIView = UIView().then {
        $0.backgroundColor = .white
    }

    private let confirmButton: UIButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .setFont(.t4(weight: .medium))
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.backgroundColor = DesignSystemAsset.PrimaryColorV2.point.color
    }

    private lazy var collectionView: UICollectionView = createCollectionView()

    private let thumbnailCellRegistration = UICollectionView.CellRegistration<
        DefaultThumbnailCell, DefaultImageEntity
    > { cell, _, itemIdentifier in
        cell.configure(itemIdentifier)
    }

    private lazy var thumbnailDiffableDataSource = UICollectionViewDiffableDataSource<Int, DefaultImageEntity>(
        collectionView: collectionView
    ) { [thumbnailCellRegistration] collectionView, indexPath, itemIdentifier in
        let cell = collectionView.dequeueConfiguredReusableCell(
            using: thumbnailCellRegistration,
            for: indexPath,
            item: itemIdentifier
        )
        return cell
    }

    init(delegate: DefaultPlaylistCoverDelegate? = nil, reactor: DefaultPlaylistCoverReactor) {
        self.delegate = delegate
        super.init(reactor: reactor)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        reactor?.action.onNext(.viewDidload)
    }

    override func addView() {
        super.addView()

        self.view.addSubviews(wmNavigationbarView, collectionView, buttonContainerView)
        wmNavigationbarView.setLeftViews([dismissButton])

        buttonContainerView.addSubviews(shadowImageVIew, confirmButton)
    }

    override func setLayout() {
        super.setLayout()

        wmNavigationbarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(wmNavigationbarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        buttonContainerView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }

        shadowImageVIew.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-14)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom)
        }

        confirmButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.top.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    override func bind(reactor: DefaultPlaylistCoverReactor) {
        super.bind(reactor: reactor)

        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }

    override func bindAction(reactor: DefaultPlaylistCoverReactor) {
        super.bindAction(reactor: reactor)

        let sharedState = reactor.state.share()

        dismissButton.rx
            .tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        confirmButton.rx
            .tap
            .withLatestFrom(sharedState.map(\.dataSource))
            .withLatestFrom(sharedState.map(\.selectedIndex)) { ($0, $1) }
            .bind(with: self) { owner, info in

                let (dataSource, index) = (info.0, info.1)

                let (url, imageName) = (dataSource[index].url, dataSource[index].name)

                owner.dismiss(animated: true) {
                    owner.delegate?.receive(url: url, imageName: imageName)
                }
            }
            .disposed(by: disposeBag)
    }

    override func bindState(reactor: DefaultPlaylistCoverReactor) {
        let sharedState = reactor.state.share()

        sharedState.map(\.dataSource)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .bind(with: self) { owner, dataSource in

                var snapShot = NSDiffableDataSourceSnapshot<Int, DefaultImageEntity>()

                snapShot.appendSections([0])

                snapShot.appendItems(dataSource)

                owner.thumbnailDiffableDataSource.apply(snapShot) {
                    owner.collectionView.selectItem(
                        at: IndexPath(row: 0, section: 0),
                        animated: false,
                        scrollPosition: .top
                    )
                }
            }
            .disposed(by: disposeBag)

        sharedState.map(\.isLoading)
            .distinctUntilChanged()
            .bind(with: self) { owner, flag in

                if flag {
                    owner.indicator.startAnimating()
                } else {
                    owner.indicator.stopAnimating()
                }
            }
            .disposed(by: disposeBag)
    }
}

extension DefaultPlaylistCoverViewController {
    private func createCollectionView() -> UICollectionView {
        return UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (
            sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment
        ) -> NSCollectionLayoutSection? in

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.25),
                heightDimension: .fractionalWidth(0.25)
            )

            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.25)
            )

            var group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 4)

            group.interItemSpacing = .fixed(10)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 20, trailing: 20)

            return section
        }
        return layout
    }
}

extension DefaultPlaylistCoverViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reactor?.action.onNext(.selectedIndex(indexPath.row))
    }
}
