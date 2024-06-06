import BaseFeature
import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

final class IntegratedSearchResultViewController: BaseReactorViewController<IntegratedSearchResultReactor> {
    private let filterButton: UIButton = UIButton().then {
        $0.setTitle("최신순", for: .normal)
        $0.setImage(DesignSystemAsset.Search.arrowDown.image, for: .normal)
    }

    private lazy var collecionView: UICollectionView = createCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
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
    }

    override func setLayout() {
        super.setLayout()
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
        -> UICollectionViewDiffableDataSource<IntegratedSearchResultSection, IntegratedResultDataSource> {}

    public func scrollToTop() {}
}
