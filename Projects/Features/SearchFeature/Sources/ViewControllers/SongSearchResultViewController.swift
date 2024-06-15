import BaseFeature
import DesignSystem
import LogManager
import RxCocoa
import RxSwift
import SnapKit
import SongsDomainInterface
import Then
import UIKit
import Utility
import SearchDomainInterface

final class SongSearchResultViewController: BaseReactorViewController<SongSearchResultReactor>, SongCartViewType {
    var songCartView: SongCartView!

    var bottomSheetView: BottomSheetView!

    private lazy var collectionView: UICollectionView = createCollectionView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
    }

    private lazy var dataSource: UICollectionViewDiffableDataSource<
        SongSearchResultSection,
        SongEntity
    > = createDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        initDataSource()
    }

    override func bind(reactor: SongSearchResultReactor) {
        super.bind(reactor: reactor)
    }

    override func bindAction(reactor: SongSearchResultReactor) {
        super.bindAction(reactor: reactor)
    }

    override func bindState(reactor: SongSearchResultReactor) {
        super.bindState(reactor: reactor)
    }

    override func addView() {
        super.addView()
        self.view.addSubviews(collectionView)
    }

    override func setLayout() {
        super.setLayout()

        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
    }

    override func configureUI() {
        super.configureUI()
    }

    deinit {
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }
}

extension SongSearchResultViewController {
    private func createCollectionView() -> UICollectionView {
        return UICollectionView(frame: .zero, collectionViewLayout: SongSearchResultCollectionViewLayout())
    }

    private func createDataSource()
        -> UICollectionViewDiffableDataSource<SongSearchResultSection, SongEntity> {
        let cellRegistration = UICollectionView.CellRegistration<SongResultCell, SongEntity> { cell, _, item in
            cell.update(item)
        }

        // MARK: Header

        let headerRegistration = UICollectionView
            .SupplementaryRegistration<SearchResultHeaderView>(
                elementKind: SearchResultHeaderView
                    .kind
            ) { [weak self] supplementaryView, _, _ in

                guard let self else { return }

                supplementaryView.delegate = self
                supplementaryView.update(sortType: .lastest, filterType: .all)
            }

        let dataSource = UICollectionViewDiffableDataSource<
            SongSearchResultSection,
            SongEntity
        >(collectionView: collectionView) { (
            collectionView: UICollectionView,
            indexPath: IndexPath,
            item: SongEntity
        ) -> UICollectionViewCell? in

            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }

        dataSource.supplementaryViewProvider = { collectionView, _, index in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }

        return dataSource
    }

    private func initDataSource() {
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<SongSearchResultSection, SongEntity>()

        snapshot.appendSections([.song])

        let model = SongEntity(
            id: "8KTFf2X-ago",
            title: "Another World",
            artist: "이세계아이돌",
            remix: "",
            reaction: "",
            views: 0,
            last: 0,
            date: "2020.12.12"
        )

        snapshot.appendItems([model], toSection: .song)

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    public func scrollToTop() {}
}

extension SongSearchResultViewController: SearchResultHeaderViewDelegate {
    func tapFilter() {
        LogManager.printDebug("filter")
    }

    func tapSort() {
        LogManager.printDebug("sort")
    }
}

extension SongSearchResultViewController: SongCartViewDelegate {
    func buttonTapped(type: SongCartSelectType) {
        #warning("유즈 케이스 연결 시 구현")
        switch type {
        case let .allSelect(flag: flag):
            break
        case .addSong:
            break
        case .addPlayList:
            break
        case .play:
            break
        case .remove:
            break
        }
    }
}
