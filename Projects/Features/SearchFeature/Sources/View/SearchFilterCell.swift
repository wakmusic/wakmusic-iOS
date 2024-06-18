import DesignSystem
import RxCocoa
import SearchDomainInterface
import SnapKit
import Then
import UIKit

final class SearchFilterCell: UICollectionViewCell {
    override var isSelected: Bool {
        willSet(newState) {
            if newState == true {
                label.font = .setFont(.t6(weight: .medium))
                label.textColor = .white
            } else {
                label.font = .setFont(.t6(weight: .light))
                label.textColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
            }
        }
    }

    private var label: WMLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t6(weight: .light)
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayout()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchFilterCell {
    private func addSubviews() {
        self.contentView.addSubview(label)
    }

    private func setLayout() {
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(4)
        }
    }

    private func configureUI() {
        self.backgroundColor = .orange
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }

    public func update(_ filterType: FilterType) {
        self.label.text = filterType.title
    }
}
