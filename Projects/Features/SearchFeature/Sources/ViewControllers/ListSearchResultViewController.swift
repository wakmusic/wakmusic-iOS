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

final class ListSearchResultViewController: BaseReactorViewController<ListSearchResultReactor> {
    var songCartView: SongCartView!

    var bottomSheetView: BottomSheetView!

    private lazy var collectionView: UICollectionView = createCollectionView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
    }

    private lazy var dataSource: UICollectionViewDiffableDataSource<
        ListSearchResultSection,
        String
    > = createDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        initDataSource()
    }

    override func bind(reactor: ListSearchResultReactor) {
        super.bind(reactor: reactor)
    }

    override func bindAction(reactor: ListSearchResultReactor) {
        super.bindAction(reactor: reactor)
    }

    override func bindState(reactor: ListSearchResultReactor) {
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

extension ListSearchResultViewController {
    private func createCollectionView() -> UICollectionView {
        return UICollectionView(frame: .zero, collectionViewLayout: ListSearchResultCollectionViewLayout())
    }

    #warning("Playlist Entity로 변경하기")
    private func createDataSource()
        -> UICollectionViewDiffableDataSource<ListSearchResultSection, String> {
            
        let songCellRegistration = UICollectionView.CellRegistration<SongResultCell, String> { cell, _, item in
           // cell.update(item)
        }

        // MARK: Header

        let headerRegistration = UICollectionView
            .SupplementaryRegistration<SearchResultHeaderView>(
                elementKind: SearchResultHeaderView
                    .kind
            ) { [weak self] supplementaryView, string, indexPath in

                guard let self else { return }

                supplementaryView.delegate = self
                supplementaryView.update(sortType: .newest, filterType: .all)
            }

        let dataSource = UICollectionViewDiffableDataSource<
            ListSearchResultSection,
            String
        >(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: String) -> UICollectionViewCell? in

            return collectionView.dequeueConfiguredReusableCell(
                using: songCellRegistration,
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
        var snapshot = NSDiffableDataSourceSnapshot<ListSearchResultSection, String>()

        snapshot.appendSections([.list])

        snapshot.appendItems(["Hello"], toSection: .list)

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    public func scrollToTop() {}
}

extension ListSearchResultViewController: SearchResultHeaderViewDelegate {
    func tapFilter() {
        LogManager.printDebug("filter")
    }

    func tapSort() {
        LogManager.printDebug("sort")
    }
}
