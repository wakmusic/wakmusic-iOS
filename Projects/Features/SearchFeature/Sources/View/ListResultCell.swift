import DesignSystem
import Kingfisher
import LogManager
import SongsDomainInterface
import UIKit
import Utility

final class ListResultCell: UICollectionViewCell {
    private let thumbnailView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = DesignSystemAsset.PlayListTheme.theme10.image
        $0.layer.cornerRadius = 4
    }

    private let titleLabel  =  WMLabel(
        text: "",
        textColor: DesignSystemAsset.NewGrayColor.gray900.color,
        font: .t6(weight: .medium),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t6().lineHeight,
        kernValue: -0.5
    ).then {
        $0.numberOfLines = 1
    }
    
    private let creatorLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.NewGrayColor.gray900.color,
        font: .t7(weight: .light),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t7().lineHeight,
        kernValue: -0.5
    ).then {
        $0.numberOfLines = 1
    }
    
    private let dateLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.NewGrayColor.gray900.color,
        font: .sc7(weight: .score3Light),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t7().lineHeight,
        kernValue: -0.5
    ).then {
        $0.numberOfLines = 1
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListResultCell {
    private func addSubview() {
        self.contentView.addSubviews(thumbnailView, titleLabel, creatorLabel, dateLabel)
    }

    private func setLayout() {
        let height = frame.height - 20

        thumbnailView.snp.makeConstraints {
            $0.width.equalTo(height)
            $0.height.equalTo(height)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailView.snp.top).offset(-1)
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(8)
        }

        creatorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.bottom.equalTo(thumbnailView.snp.bottom)
        }

        dateLabel.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.centerY.equalTo(thumbnailView.snp.centerY)
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
        }
    }

    public func update(_ model: TmpPlaylistModel) {
        #warning("플레이 리스트 이미지")
        titleLabel.text = model.name
        creatorLabel.text = model.creator
        dateLabel.text = model.date
    }
}
