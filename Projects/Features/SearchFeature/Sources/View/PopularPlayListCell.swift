import DesignSystem
import UIKit

final class PopularPlayListCell: UICollectionViewCell {
    private let imageView: UIImageView = UIImageView().then {
        $0.image = DesignSystemAsset.PlayListTheme.theme10.image
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel: UILabel = UILabel().then {
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
        $0.backgroundColor = .red
    }

    private let nickNameLabel: UILabel = UILabel().then {
        $0.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubviews(imageView, titleLabel, nickNameLabel)
        configureUI()
        self.contentView.backgroundColor = .blue
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PopularPlayListCell {
    public func update(_ model: Model) {
        self.titleLabel.text = model.title
        self.nickNameLabel.text = "Hamp"
    }

    private func configureUI() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
        }

        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
