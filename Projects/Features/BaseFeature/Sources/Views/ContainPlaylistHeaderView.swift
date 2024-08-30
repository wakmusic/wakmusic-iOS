import DesignSystem
import UIKit

public protocol ContainPlaylistHeaderViewDelegate: AnyObject {
    func action()
}

class ContainPlaylistHeaderView: UIView {
    @IBOutlet weak var superView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonImageView: UIImageView!

    @IBOutlet weak var blurEffectViews: UIVisualEffectView!

    weak var delegate: ContainPlaylistHeaderViewDelegate?

    @IBAction func buttonAction(_ sender: Any) {
        self.delegate?.action()
    }

    override init(frame: CGRect) { // 코드쪽에서 생성 시 호출
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) // StoryBoard에서 호출됨
    {
        super.init(coder: aDecoder)
        self.setupView()
    }

    private func setupView() {
        if let view = Bundle.module.loadNibNamed("ContainPlaylistHeaderView", owner: self, options: nil)!
            .first as? UIView {
            view.frame = self.bounds
            view.layoutIfNeeded() // 드로우 사이클을 호출할 때 쓰임
            self.addSubview(view)
        }

        self.buttonImageView.image = DesignSystemAsset.Storage.storageNewPlaylistAdd.image

        let attr = NSMutableAttributedString(
            string: "새 리스트 만들기",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray900.color,
                .kern: -0.5
            ]
        )
        self.backgroundColor = .clear
        superView.backgroundColor = .white.withAlphaComponent(0.4)
        superView.layer.cornerRadius = 8
        superView.layer.borderColor = DesignSystemAsset.BlueGrayColor.gray200.color.withAlphaComponent(0.4).cgColor
        superView.layer.borderWidth = 1

        blurEffectViews.layer.cornerRadius = 8
        blurEffectViews.clipsToBounds = true

        self.button.setAttributedTitle(attr, for: .normal)
    }
}
