import DesignSystem
import SnapKit
import Then
import UIKit
import Utility

protocol BeforeSearchSectionHeaderViewDelegate: AnyObject {
    func tap(_ section: Int?)
}

final class BeforeSearchSectionHeaderView:
    UICollectionReusableView {
    static let kind = "before-search-section-header"

    weak var delegate: BeforeSearchSectionHeaderViewDelegate?

    var section: Int?

    private let label: WMLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t5(weight: .bold)
    )

    private let button: UIButton = UIButton().then {
        $0.setTitle("전체보기", for: .normal)

        $0.setTitleColor(DesignSystemAsset.BlueGrayColor.gray900.color.withAlphaComponent(0.6), for: .normal)

        $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)

        #warning("추후 히든 해제")
        $0.isHidden = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubviews(label, button)
        setLayout()

        button.addAction { [weak self] in

            guard let self else { return }

            self.delegate?.tap(self.section)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BeforeSearchSectionHeaderView {
    public func update(_ title: String, _ section: Int) {
        label.text = title
        self.section = section
    }

    private func setLayout() {
        label.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }

        button.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview()
        }
    }
}
