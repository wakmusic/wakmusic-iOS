import DesignSystem
import UIKit
import Utility

final class RecentRecordHeaderView: UIView {
    @IBOutlet weak var removeAllButton: UIButton!
    @IBOutlet weak var removeAllLabel: UILabel!
    @IBOutlet weak var recentLabel: UILabel!

    /// 1. 넘겨주는 연결통로
    var completionHandler: (() -> Void)?

    @IBAction func removeAll(_ sender: UIButton) {
        completionHandler?()
    }

    override init(frame: CGRect) { // 코드쪽에서 생성 시 호출
        super.init(frame: frame)
        self.configureUI()
    }

    required init?(coder aDecoder: NSCoder) { // StoryBoard에서 호출됨
        super.init(coder: aDecoder)
        self.configureUI()
    }

    private func configureUI() {
        if let view = Bundle.module.loadNibNamed("RecentRecordHeaderView", owner: self, options: nil)!
            .first as? UIView {
            view.frame = self.bounds
            view.layoutIfNeeded() // 드로우 사이클을 호출할 때 쓰임
            view.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
            self.addSubview(view)
        }

        self.recentLabel.text = "최근 검색어"
        self.recentLabel.font = DesignSystemFontFamily.Pretendard.bold.font(size: 16)
        self.recentLabel.textColor = DesignSystemAsset.NewGrayColor.gray900.color
        self.recentLabel.setTextWithAttributes(kernValue: -0.5)

        self.removeAllLabel.text = "전체삭제"
        self.removeAllLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        self.removeAllLabel.textColor = DesignSystemAsset.NewGrayColor.gray400.color
        self.removeAllLabel.setTextWithAttributes(kernValue: -0.5)
    }
}
