import DesignSystem
import UIKit

public class WarningView: UIView {
    @IBOutlet weak var superView: UIView!
    @IBOutlet weak var warningLabelView: UILabel!
    @IBOutlet weak var warningImageView: UIImageView!

    public var text: String = "" {
        didSet {
            warningLabelView.text = text
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

    private func setupView() {
        guard let view = Bundle.module.loadNibNamed("Warning", owner: self, options: nil)?.first as? UIView
        else { return }
        view.frame = self.bounds
        view.layoutIfNeeded()
        view.backgroundColor = .clear
        self.superView.backgroundColor = .clear
        self.addSubview(view)
        configureUI()
    }
}

private extension WarningView {
    func configureUI() {
        warningImageView.image = DesignSystemAsset.Search.warning.image
        warningLabelView.textColor = DesignSystemAsset.BlueGrayColor.gray900.color
        warningLabelView.font = UIFont.WMFontSystem.t6(weight: .light).font
        warningLabelView.setTextWithAttributes(kernValue: -0.5)
    }
}
