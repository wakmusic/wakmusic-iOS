import BaseFeature
import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility
import SongsDomainInterface

final class IntegratedSearchResultViewController: BaseReactorViewController<IntegratedSearchResultReactor> {
    private lazy var collectionView: UICollectionView = createCollectionView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
    }

    private lazy var dataSource: UICollectionViewDiffableDataSource<IntegratedSearchResultSection, IntegratedResultDataSource> = createDataSource()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDataSource()
    }

    override func bind(reactor: IntegratedSearchResultReactor) {
        super.bind(reactor: reactor)
    }

    override func bindAction(reactor: IntegratedSearchResultReactor) {
        super.bindAction(reactor: reactor)
    }

    override func bindState(reactor: IntegratedSearchResultReactor) {
        super.bindState(reactor: reactor)
    }

    override func addView() {
        super.addView()
        self.view.addSubviews(collectionView)
    }

    override func setLayout() {
        super.setLayout()
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }

    override func configureUI() {
        super.configureUI()
    }

    deinit {
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }
}

extension IntegratedSearchResultViewController {
    private func createCollectionView() -> UICollectionView {
        return UICollectionView(frame: .zero, collectionViewLayout: IntegratedSearchResultCollectionViewLayout())
    }

    private func createDataSource()
        -> UICollectionViewDiffableDataSource<IntegratedSearchResultSection, IntegratedResultDataSource> {
            
            let songCellRegistration = UICollectionView.CellRegistration<SongResultCell, SongEntity> { cell, _, item in
                cell.update(item)
            }
            
            
            let dataSource = UICollectionViewDiffableDataSource<
                IntegratedSearchResultSection,
                IntegratedResultDataSource
            >(collectionView: collectionView) {
                (
                    collectionView: UICollectionView,
                    indexPath: IndexPath,
                    item: IntegratedResultDataSource
                ) -> UICollectionViewCell? in

                switch item {
                    
                case .song(model: let model):
                    return collectionView.dequeueConfiguredReusableCell(
                        using: songCellRegistration,
                        for: indexPath,
                        item: model
                    )
                case .list(model: let model):
                    break
                }
                #warning("list 셀 이후 제거")
                    return nil
            }
            
            
            
            return dataSource
        }
    
    
    private func initDataSource() {
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<IntegratedSearchResultSection, IntegratedResultDataSource>()
        
        snapshot.appendSections([.song, .artist, .credit, .list])
        

        let model = SongEntity(id: "8KTFf2X-ago", title: "Another World", artist: "이세계아이돌", remix: "", reaction: "", views: 0, last: 0, date: "2020.12.12")
        
        snapshot.appendItems([.song(model: model)], toSection: .song)
//        snapshot.appendItems([.song(model: model)], toSection: .song)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    public func scrollToTop() {}
}
