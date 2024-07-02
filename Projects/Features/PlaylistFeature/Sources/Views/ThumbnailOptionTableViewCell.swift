import UIKit
import SnapKit
import Then
import DesignSystem

final class ThumbnailOptionTableViewCell: UITableViewCell {

    static let identifier: String = "ThumbnailOptionTableViewCell"
    
    private let superView: UIView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = DesignSystemAsset.BlueGrayColor.blueGray100.color.cgColor
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray50.color
        $0.clipsToBounds = true
        
    }
    private let titleLabel: WMLabel = WMLabel(text: "", textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color ,font: .t5(weight: .medium))
    
    private let costLabel: WMLabel = WMLabel(text: "", textColor: .white, font: .t6(weight: .medium), alignment: .center).then {
        $0.layer.cornerRadius = 4
        $0.backgroundColor = DesignSystemAsset.PrimaryColorV2.point.color
        $0.clipsToBounds = true
    }
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        self.contentView.addSubviews(superView)
        self.superView.addSubviews(titleLabel, costLabel)
    }
    
    func setLayout() {
        superView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview()
        }
        
        costLabel.snp.makeConstraints {
            $0.width.equalTo(72)
            $0.height.equalTo(30)
            $0.trailing.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview()
        }
    }
    
}


extension ThumbnailOptionTableViewCell {
    public func update(_ model: ThumbnailOptionModel) {
        
        titleLabel.text = model.title
        
        let attributedString = NSMutableAttributedString(string: "")
        
        let image = DesignSystemAsset.Playlist.miniNote.image
        
        let padding = NSTextAttachment()
        padding.bounds = CGRect(x: 0, y: -2, width: 1, height: 0)
        
        let padding2 = NSTextAttachment()
        padding2.bounds = CGRect(x: 0, y: -2, width: 5, height: 0)
        let imageAttachment = NSTextAttachment()
        
        imageAttachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
        imageAttachment.image = image
        
    
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        attributedString.append(NSAttributedString(attachment: padding))
        attributedString.append(NSAttributedString(string:"\(model.cost)"))
        attributedString.append(NSAttributedString(attachment: padding2))
        attributedString.append(NSAttributedString(string:model.cost == .zero ? "무료" : "구매", attributes: [.font: DesignSystemFontFamily.Pretendard.bold.font(size: 12.18) ]))
        attributedString.append(NSAttributedString(attachment: padding))
        
        costLabel.attributedText = attributedString
        
    }
}
