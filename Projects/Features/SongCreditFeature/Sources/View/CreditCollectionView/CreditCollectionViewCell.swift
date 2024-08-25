import DesignSystem
import SnapKit
import Then
import UIKit

final class CreditCollectionViewCell: UICollectionViewCell {
    private let nameLabel = UILabel().then {
        $0.font = .setFont(.t5(weight: .medium))
        $0.textColor = DesignSystemAsset.PrimaryColorV2.white.color
        $0.alpha = 0.8
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

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = DesignSystemAsset.PrimaryColorV2.white.color
            .withAlphaComponent(0.4)
            .cgColor
        self.contentView.layer.cornerRadius = self.contentView.frame.height / 2.0
    }

    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let collectionViewWidth = superview?.bounds.width ?? UIScreen.main.bounds.width

        let maxWidth = collectionViewWidth * 0.6

        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size = .init(
            width: min(maxWidth, size.width),
            height: size.height
        )
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }

    func configure(name: String) {
        self.nameLabel.text = name
    }
}

private extension CreditCollectionViewCell {
    func addView() {
        self.contentView.addSubview(self.nameLabel)
    }

    func setLayout() {
        nameLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(4)
        }
    }
}
