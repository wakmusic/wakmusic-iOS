import DesignSystem
import RxSwift
import SearchDomainInterface
import SnapKit
import Then
import UIKit
import Utility

private protocol SearchOptionHeaderStateProtocol {
    func updateSortState(_ sortType: SortType)
}

private protocol SearchOptionHeaderActionProtocol {
    var selectedFilterItem: Observable<FilterType> { get }
    var didTapSortButton: Observable<Void> { get }
}

final class SearchOptionHeaderView: UIView {
    private let searchFilterCellRegistration = UICollectionView.CellRegistration<
        SearchFilterCell, FilterType
    > { cell, indexPath, itemIdentifier in

        cell.update(itemIdentifier)
    }

    fileprivate let dataSource: [FilterType] = [.all, .title, .artist, .credit]
    private var disposeBag = DisposeBag()
    private lazy var searchFilterDiffableDataSource = UICollectionViewDiffableDataSource<Int, FilterType>(
        collectionView: collectionView
    ) { [searchFilterCellRegistration] collectionView, indexPath, itemIdentifier in
        let cell = collectionView.dequeueConfiguredReusableCell(
            using: searchFilterCellRegistration,
            for: indexPath,
            item: itemIdentifier
        )

        if indexPath.row == .zero {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }

        return cell
    }

    fileprivate lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: SearchFilterOptionCollectionViewLayout()
    ).then {
        $0.backgroundColor = .clear
        $0.bounces = false
    }

    private let dimView = UIView()

    fileprivate let sortButton: OptionButton = OptionButton(.latest)

    init(_ isContainFilter: Bool) {
        super.init(frame: .zero)
        addSubviews()
        setLayout()
        initDataSource()
        bindAction()
        dimView.isHidden = !isContainFilter
        collectionView.isHidden = !isContainFilter
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchOptionHeaderView {
    private func addSubviews() {
        self.addSubviews(collectionView, dimView, sortButton)
    }

    private func setLayout() {
        dimView.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(collectionView.snp.trailing)
        }

        collectionView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }

        sortButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(70)
            $0.leading.equalTo(collectionView.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().inset(20)
        }
    }

    private func configureUI() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = dimView.bounds
        gradientLayer.colors = [colorFromRGB("F2F4F7", alpha: .zero).cgColor, colorFromRGB("F2F4F7").cgColor]
        gradientLayer.type = .axial
        gradientLayer.startPoint = .init(x: .zero, y: 0.5)
        gradientLayer.endPoint = .init(x: 1.0, y: 0.5)
        dimView.layer.addSublayer(gradientLayer)
    }

    private func initDataSource() {
        var snapShot = NSDiffableDataSourceSnapshot<Int, FilterType>()

        snapShot.appendSections([0])
        snapShot.appendItems(dataSource, toSection: 0)

        searchFilterDiffableDataSource.apply(snapShot)
    }

    private func bindAction() {
        collectionView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                owner.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension SearchOptionHeaderView: SearchOptionHeaderStateProtocol {
    func updateSortState(_ sortType: SortType) {
        sortButton.updateSortrState(sortType)
    }
}

extension Reactive: SearchOptionHeaderActionProtocol where Base: SearchOptionHeaderView {
    var selectedFilterItem: Observable<FilterType> {
        base.collectionView.rx.itemSelected
            .map { base.dataSource[$0.row] }
            .asObservable()
    }

    var didTapSortButton: Observable<Void> {
        base.sortButton.rx.didTap
    }
}
