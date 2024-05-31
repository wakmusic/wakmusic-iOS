import BaseFeature
import LogManager
import PlayListDomainInterface
import SnapKit
import Then
import UIKit
import Utility

// TODO: 코드 정리

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
        configureDataSource()

        collectionView.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview()
        }
    }
}

/// collectionView 셋팅 관련
extension TmpViewController {
    func createCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

        collectionView.backgroundColor = .systemGray
        collectionView.delegate = self
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
        let headerLayout = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerLayout,
            elementKind: BeforeSearchSectionHeaderView.kind,
            alignment: .top
        )

        header.contentInsets = .init(top: .zero, leading: 8, bottom: .zero, trailing: 8)

        switch layout {
        case .top:

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.87)
            )
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: .zero, bottom: 20, trailing: .zero)

        case .mid:

            let groupWidth: CGFloat = (APP_WIDTH() - (20 + 8 + 20)) / 2.0
            let groupeight: CGFloat = (80.0 * groupWidth) / 164.0

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(groupWidth),
                heightDimension: .absolute(groupeight)
            )
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 40, trailing: 20)

        case .bottom:

            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .absolute(190))

            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        }

        section.orthogonalScrollingBehavior = .continuous

        return section
    }

    private func configureDataSource() {
        let youtubeCellRegistration = UICollectionView
            .CellRegistration<YoutubeThumbnailCell, Model> { cell, indexPath, item in
            }

        let recommandCellRegistration = UICollectionView.CellRegistration<RecommendPlayListCell, Model>(cellNib: UINib(
            nibName: "RecommendPlayListCell",
            bundle: BaseFeatureResources.bundle
        )) { cell, indexPath, itemIdentifier in
            cell.update(
                model:

                RecommendPlayListEntity(key: "best", title: "임시 플레이리스트", image: "", private: true, count: 0)
            )
        }

        let popularListCellRegistration = UICollectionView
            .CellRegistration<PopularPlayListCell, Model> { cell, indexPath, item in

                cell.update(item)
            }

        let headerRegistration = UICollectionView
            .SupplementaryRegistration<BeforeSearchSectionHeaderView>(
                elementKind: BeforeSearchSectionHeaderView
                    .kind
            ) { [weak self] supplementaryView, string, indexPath in

                guard let self else { return }
                supplementaryView.delegate = self
                supplementaryView.update("임시 타이틀", indexPath.section)
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
                    using: popularListCellRegistration,
                    for: indexPath,
                    item: model
                )
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, index in

            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
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

extension TmpViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = dataSource.itemIdentifier(for: indexPath) as? DataSource else {
            return
        }

        switch model {
        case let .youtube(model: model):
            LogManager.printDebug("youtube \(model)")
        case let .recommand(model2: model2):
            LogManager.printDebug("recommand \(model2)")
        case let .popularList(model: model):
            LogManager.printDebug("popular \(model)")
        }
    }
}

extension TmpViewController: BeforeSearchSectionHeaderViewDelegate {
    func tap(_ section: Int?) {
        if let section = section, let layoutKind = Section(rawValue: section) {
            print(layoutKind)
        }
    }
}
