import DesignSystem
import RxSwift
import SearchDomainInterface
import SnapKit
import Then
import UIKit
import Utility

private protocol SearchOptionHeaderStateProtocol {
    func updateFilterState(_ filter: FilterType)
}

private protocol SearchOptionHeaderActionProtocol {}

final class SearchOptionHeaderView:
    UIView {
    private let searchFilterCellRegistration = UICollectionView.CellRegistration<
        SearchFilterCell, FilterType
    > { cell, _, itemIdentifier in
        cell.update(itemIdentifier)
    }

    private lazy var searchFilterDiffableDataSource = UICollectionViewDiffableDataSource<Int, FilterType>(
        collectionView: collectionView
    ) { [searchFilterCellRegistration] collectionView, indexPath, itemIdentifier in
        let cell = collectionView.dequeueConfiguredReusableCell(
            using: searchFilterCellRegistration,
            for: indexPath,
            item: itemIdentifier
        )
        return cell
    }

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: SearchOptionCollectionViewLayout()
    ).then {
        $0.backgroundColor = .clear
    }

    private let dimView = UIView()

    private let sortButton: OptionButton = OptionButton(.latest)

    init(_ isContainFilter: Bool) {
        super.init(frame: .zero)
        addSubviews()
        setLayout()
        initDataSource()

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
            $0.top.bottom.trailing.equalToSuperview()
            $0.width.equalTo(60)
            $0.leading.equalTo(collectionView.snp.trailing).offset(4)
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

    func initDataSource() {
        var snapShot = NSDiffableDataSourceSnapshot<Int, FilterType>()

        snapShot.appendSections([0])
        snapShot.appendItems([.all, .title, .artist, .credit], toSection: 0)

        searchFilterDiffableDataSource.apply(snapShot)
    }
}
