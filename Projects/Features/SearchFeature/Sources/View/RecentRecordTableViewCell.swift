import DesignSystem
import UIKit
import Utility

protocol RecentRecordDelegate: AnyObject {
    func selectedItems(_ keyword: String)
}

class RecentRecordTableViewCell: UITableViewCell {


    private let recentLabel: UILabel = UILabel().then {
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.setTextWithAttributes(kernValue: -0.5)
    }
    
    private let button: UIButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Search.keywordRemove.image, for: .normal)
        $0.addTarget(self, action: #selector(removeButtonDidTap), for: .touchUpInside)
    }
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubviews(recentLabel,button)
        
        recentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    



    @objc func removeButtonDidTap() {
        PreferenceManager.shared.removeRecentRecords(word: self.recentLabel.text!)
    }
}

extension RecentRecordTableViewCell {
    
    public func update(_ text:String) {
        recentLabel.text = text
    }
    
}
