import DesignSystem
import SnapKit
import Then
import UIKit

protocol IntegratedSearchResultHeaderViewDelegate: AnyObject {
    func tap(_ section: IntegratedSearchResultSection?)
}

final class IntegratedSearchResultHeaderView:
    UICollectionReusableView {
    static let kind = "search-result-section-header"

    weak var delegate: IntegratedSearchResultHeaderViewDelegate?

    var section: IntegratedSearchResultSection?

    private let titleLabel: UILabel = UILabel().then {
        $0.font = .setFont(.t5(weight: .medium))

        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
    }
    
    private let countLabel: UILabel = UILabel().then {
        $0.font = .setFont(.t5(weight: .medium))

        $0.textColor = DesignSystemAsset.PrimaryColorV2.point.color
    }

    private let button: UIButton = UIButton().then {
        $0.setTitle("전체보기", for: .normal)

        $0.setTitleColor(DesignSystemAsset.BlueGrayColor.gray900.color, for: .normal)

        $0.titleLabel?.font = .setFont(.t6(weight: .medium))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubviews(titleLabel, countLabel, button)
        setLayout()

        button.addAction { [delegate] in
            delegate?.tap(self.section)
        }
        
        self.backgroundColor = .orange

    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension IntegratedSearchResultHeaderView {
    public func update(count: Int, section: IntegratedSearchResultSection) {
        titleLabel.text = section.title
        countLabel.text = "\(count)"
        self.section = section
    }

    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
            $0.top.bottom.equalTo(titleLabel)
        }

        button.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview()
        }
    }
}
