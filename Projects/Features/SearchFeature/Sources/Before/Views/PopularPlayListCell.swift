import DesignSystem
import UIKit

final class PopularPlayListCell: UICollectionViewCell {
    private let imageView: UIImageView = UIImageView().then {
        $0.image = DesignSystemAsset.PlayListTheme.theme10.image
        $0.contentMode = .scaleAspectFill
    }

    private let titleLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.NewGrayColor.gray900.color,
        font: .t6(weight: .medium),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t6().lineHeight,
        kernValue: -0.5
    ).then {
        $0.numberOfLines = 1
    }

    private let nickNameLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.NewGrayColor.gray900.color,
        font: .t7(weight: .light),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t7(weight: .light).lineHeight,
        kernValue: -0.5
    ).then {
        $0.numberOfLines = 1
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubviews(imageView, titleLabel, nickNameLabel)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PopularPlayListCell {
    #warning("추후 업데이트 시 사용")
//    public func update(_ model: Model) {
//        self.titleLabel.text = model.title
//        self.nickNameLabel.text = "Hamp"
//    }

    private func configureUI() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.height.equalTo(140)
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
