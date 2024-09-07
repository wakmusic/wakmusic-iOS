import DesignSystem
import UIKit

final class CreditCollectionViewPositionHeaderView: UICollectionReusableView {
    private let positionLabel = UILabel().then {
        $0.font = .setFont(.t6(weight: .light))
        $0.textColor = DesignSystemAsset.PrimaryColorV2.white.color
        $0.textAlignment = .left
        $0.alpha = 0.6
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(position: String) {
        self.positionLabel.text = position
    }
}

private extension CreditCollectionViewPositionHeaderView {
    func addView() {
        self.addSubview(self.positionLabel)
    }

    func setLayout() {
        positionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
