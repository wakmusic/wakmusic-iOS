import DesignSystem
import RxSwift
import SearchDomainInterface
import SnapKit
import Then
import UIKit

private protocol SearchResultHeaderView

final class SearchOptionHeaderView:
    UIView {


    var disposeBag = DisposeBag()
    
    private let sortButton: OptionButton = OptionButton()

    private lazy var stackView: UIStackView = UIStackView().then {
        $0.addArrangedSubviews(sortButton)
        $0.axis = .horizontal
        $0.spacing = 20
        $0.distribution = .equalSpacing
        $0.backgroundColor = .yellow
    }
    
    init(sortType: SortType, filterType: FilterType? = nil) {
        super.init(frame: .zero)
        self.backgroundColor = .orange
        self.addSubviews(stackView)
        setLayout()
        bindAction()
        
    }



    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchResultHeaderView {
    public func update(sortType: SortType, filterType: FilterType? = nil) {
          sortButton.setTitle(sortType.title)
      }

    private func bindAction() {


    }

    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.bottom.trailing.equalToSuperview()
        }
    }
}
