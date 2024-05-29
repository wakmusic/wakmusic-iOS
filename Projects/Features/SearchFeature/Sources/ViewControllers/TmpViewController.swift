import BaseFeature
import LogManager
import PlayListDomainInterface
import SnapKit
import Then
import UIKit
import Utility

struct Model: Hashable {
    var title: String

    init(title: String) {
        self.title = title
    }
}

struct Model2: Hashable {
    var title2: String

    init(title2: String) {
        self.title2 = title2
    }
}

class TmpViewController: UIViewController {
    fileprivate enum Section: Int {
        case top
        case mid
        case bottom
    }

    enum DataSource: Hashable {
        case youtube(model: Model)
        case recommand(model2: Model)
        case popularList(model: Model)

        var title: String {
            switch self {
            case let .youtube(model):
                return model.title
            case let .recommand(model2):
                return model2.title
            case let .popularList(model):
                return model.title
            }
        }
    }

    fileprivate var dataSource: UICollectionViewDiffableDataSource<Section, DataSource>! = nil
    var collectionView: UICollectionView! = nil

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createCollectionView()

        collectionView.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview()
        }

//        collectionView.register(
//            UINib(nibName: "RecommendPlayListCell", bundle: BaseFeatureResources.bundle),
//            forCellWithReuseIdentifier: "RecommendPlayListCell"
//        )

        configureDataSource()
    }
}

extension TmpViewController {
    func createCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

        view.addSubview(collectionView)
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self]
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

                guard let self else { return nil }

                guard let layoutKind = Section(rawValue: sectionIndex) else { return nil }

                return self.configureSection(layoutKind)
        }

        return layout
    }

    private func configureSection(_ layout: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        var item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: 8, bottom: 0, trailing: 8)

        var group: NSCollectionLayoutGroup! = nil
        var section: NSCollectionLayoutSection! = nil

        switch layout {
        case .top:

            let width = APP_WIDTH() - 40
            let height = (width * 292) / 335

            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .absolute(height))
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        case .mid:
            let groupWidth: CGFloat = (APP_WIDTH() - (20 + 8 + 20)) / 2.0
            let groupeight: CGFloat = (80.0 * groupWidth) / 164.0

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(groupWidth),
                heightDimension: .absolute(groupeight)
            )
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        case .bottom:

            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .absolute(190))
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        }

        section.orthogonalScrollingBehavior = .continuous

        return section
    }

    private func configureDataSource() {
        let youtubeCellRegistration = UICollectionView
            .CellRegistration<YoutubeThumbnailView, Model> { cell, indexPath, item in
            }

        let recommandCellRegistration = UICollectionView.CellRegistration<RecommendPlayListCell, Model>
            .init(cellNib: UINib(
                nibName: "RecommendPlayListCell",
                bundle: BaseFeatureResources.bundle
            )) { cell, indexPath, itemIdentifier in
                cell.update(model: RecommendPlayListEntity(
                    key: "bset",
                    title: "임시 플레이리스트",
                    image_round_version: 1,
                    image_sqaure_version: 1
                ))
            }

        dataSource = UICollectionViewDiffableDataSource<Section, DataSource>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: DataSource) -> UICollectionViewCell? in

            switch item {
            case let .youtube(model: model):
                return collectionView.dequeueConfiguredReusableCell(
                    using: youtubeCellRegistration,
                    for: indexPath,
                    item: model
                )
            case let .recommand(model2: model2):
                return
                    collectionView.dequeueConfiguredReusableCell(
                        using: recommandCellRegistration,
                        for: indexPath,
                        item: model2
                    )

            case let .popularList(model: model):
                return collectionView.dequeueConfiguredReusableCell(
                    using: youtubeCellRegistration,
                    for: indexPath,
                    item: model
                )
            }
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, DataSource>()
        snapshot.appendSections([.top, .mid, .bottom])
        snapshot.appendItems([.youtube(model: Model(title: "Hello"))], toSection: .top)
        snapshot.appendItems(
            [
                .recommand(model2: Model(title: "123")),
                .recommand(model2: Model(title: "456")),
                .recommand(model2: Model(title: "4564")),
                .recommand(model2: Model(title: "4516")),
            ],
            toSection: .mid
        )
        snapshot.appendItems(
            [
                .popularList(model: Model(title: "Hello1")),
                .popularList(model: Model(title: "Hello2")),
                .popularList(model: Model(title: "Hello3")),
            ],
            toSection: .bottom
        )
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
