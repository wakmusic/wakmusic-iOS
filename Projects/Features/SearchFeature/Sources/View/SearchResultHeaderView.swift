import DesignSystem
import RxSwift
import SnapKit
import Then
import UIKit

protocol SearchResultHeaderViewDelegate: AnyObject {
    func tapFilter()
    func tapSort()
}

final class SearchResultHeaderView:
    UICollectionReusableView {
    static let kind = "search-result-section-header"

    weak var delegate: SearchResultHeaderViewDelegate?

    var disposeBag = DisposeBag()

    private let filterButton: OptionButton = OptionButton()

    private let sortButton: OptionButton = OptionButton()

    private lazy var stackView: UIStackView = UIStackView().then {
        $0.addArrangedSubviews(filterButton, sortButton)
        $0.axis = .horizontal
        $0.spacing = 20
        $0.distribution = .equalSpacing
        $0.backgroundColor = .yellow
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubviews(stackView)
        setLayout()
        bindAction()

        self.backgroundColor = .orange
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchResultHeaderView {
    public func update(sortType: SortType, filterType: FilterType?) {
        sortButton.setLeftTitle(sortType.title)

        guard let filterType = filterType else {
            filterButton.isHidden = true
            return
        }
        filterButton.setLeftTitle(filterType.title)
    }

    private func bindAction() {
        filterButton.rx.didTap
            .withUnretained(self)
            .bind { owner, _ in
                owner.delegate?.tapFilter()
            }
            .disposed(by: disposeBag)

        sortButton.rx.didTap
            .withUnretained(self)
            .bind { owner, _ in
                owner.delegate?.tapSort()
            }
            .disposed(by: disposeBag)
    }

    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
        }
    }
}
