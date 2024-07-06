import BaseFeature
import DesignSystem
import SnapKit
import Then
import UIKit

#warning("델리게이트 만들기")

final class DefaultPlaylistImageViewController: BaseReactorViewController<DefaultPlaylistImageReactor> {
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
        DefaultThumbnailCell, String
    > { cell, _, itemIdentifier in
        cell.configure(itemIdentifier)
    }

    private lazy var thumbnailDiffableDataSource = UICollectionViewDiffableDataSource<Int, String>(
        collectionView: collectionView
    ) { [thumbnailCellRegistration] collectionView, indexPath, itemIdentifier in
        let cell = collectionView.dequeueConfiguredReusableCell(
            using: thumbnailCellRegistration,
            for: indexPath,
            item: itemIdentifier
        )
        return cell
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        reactor?.action.onNext(.viewDidload)

        #warning("리엑터로 액션 보내줘야함")
        // 미리 최초 선택하는 이벤트 여기 맞을지..
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
    }

    override func addView() {
        super.addView()

        self.view.addSubviews(wmNavigationbarView, collectionView, buttonContainerView)
        wmNavigationbarView.setLeftViews([dismissButton])

        buttonContainerView.addSubviews(shadowImageVIew,confirmButton)
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

    override func bind(reactor: DefaultPlaylistImageReactor) {
        super.bind(reactor: reactor)

        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }

    override func bindAction(reactor: DefaultPlaylistImageReactor) {
        super.bindAction(reactor: reactor)

        dismissButton.rx
            .tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        confirmButton.rx
            .tap
            .bind(with: self) { owner, _ in
                #warning("추후 델리기에트로 dismiss 후 전달")
            }
            .disposed(by: disposeBag)
    }

    override func bindState(reactor: DefaultPlaylistImageReactor) {
        let sharedState = reactor.state.share()

        sharedState.map(\.dataSource)
            .distinctUntilChanged()
            .bind(with: self) { owner, dataSource in

                var snapShot = NSDiffableDataSourceSnapshot<Int, String>()

                snapShot.appendSections([0])

                snapShot.appendItems(dataSource)

                owner.thumbnailDiffableDataSource.apply(snapShot)
            }
            .disposed(by: disposeBag)

        sharedState.map(\.selectedIndex)
            .distinctUntilChanged()
            .bind(with: self) { owner, index in

                print("Item: \(index)")
            }
            .disposed(by: disposeBag)
    }
}

extension DefaultPlaylistImageViewController {
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
                heightDimension: .absolute(76.0)
            )

            var group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 4)
            group.interItemSpacing = .fixed(10)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: .zero, trailing: 20)

            section.interGroupSpacing = 10.0

            return section
        }
        return layout
    }
}

extension DefaultPlaylistImageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        reactor?.action.onNext(.selectedIndex(indexPath.row))
    }
}
