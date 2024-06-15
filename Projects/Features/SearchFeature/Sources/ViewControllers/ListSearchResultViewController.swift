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

struct TmpPlaylistModel: Hashable {
    let name: String
    let date: String
    let creator: String
}

final class ListSearchResultViewController: BaseReactorViewController<ListSearchResultReactor> {
    var songCartView: SongCartView!

    var bottomSheetView: BottomSheetView!

    private lazy var collectionView: UICollectionView = createCollectionView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
    }

    private lazy var dataSource: UICollectionViewDiffableDataSource<
        ListSearchResultSection,
        TmpPlaylistModel
    > = createDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        initDataSource()
    }

    override func bind(reactor: ListSearchResultReactor) {
        super.bind(reactor: reactor)
        collectionView.delegate = self
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
        -> UICollectionViewDiffableDataSource<ListSearchResultSection, TmpPlaylistModel> {
        let cellRegistration = UICollectionView.CellRegistration<ListResultCell, TmpPlaylistModel> { cell, _, item in
            cell.update(item)
        }

        // MARK: Header

        let headerRegistration = UICollectionView
            .SupplementaryRegistration<SearchResultHeaderView>(
                elementKind: SearchResultHeaderView
                    .kind
            ) { [weak self] supplementaryView, string, indexPath in

                guard let self else { return }

                supplementaryView.delegate = self
                supplementaryView.update(sortType: .latest)
            }

        let dataSource = UICollectionViewDiffableDataSource<
            ListSearchResultSection,
            TmpPlaylistModel
        >(collectionView: collectionView) { (
            collectionView: UICollectionView,
            indexPath: IndexPath,
            item: TmpPlaylistModel
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
        var snapshot = NSDiffableDataSourceSnapshot<ListSearchResultSection, TmpPlaylistModel>()

        snapshot.appendSections([.list])

        snapshot.appendItems(
            [
                TmpPlaylistModel(name: "임시 플리이름", date: "2012.12.12", creator: "우왁굳"),
                TmpPlaylistModel(name: "임시 플리이름", date: "2012.12.12", creator: "우왁굳2")
            ],
            toSection: .list
        )

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    public func scrollToTop() {}
}

extension ListSearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        #warning("플레이리스트 상세로 이동")
        guard let model = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        LogManager.printDebug(model)
    }
}

extension ListSearchResultViewController: SearchResultHeaderViewDelegate {
    func tapFilter() {
        LogManager.printDebug("filter")
    }

    func tapSort() {
        LogManager.printDebug("sort")
    }
}
