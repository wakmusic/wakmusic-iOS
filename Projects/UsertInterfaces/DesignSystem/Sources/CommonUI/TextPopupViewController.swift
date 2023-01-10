import UIKit
import Utility
import PanModal

public final class TextPopupViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!

    var contentString: String = ""
    var cancelButtonIsHidden: Bool = false

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    public static func viewController(text: String = "", cancelButtonIsHidden: Bool) -> TextPopupViewController {
        let viewController = TextPopupViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        viewController.contentString = text
        viewController.cancelButtonIsHidden = cancelButtonIsHidden
        return viewController
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func confirmButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension TextPopupViewController {

    private func configureUI() {

        cancelButton.layer.cornerRadius = 12
        cancelButton.clipsToBounds = true
        contentLabel.text = contentString
        confirmButton.layer.cornerRadius = cancelButton.layer.cornerRadius
        confirmButton.clipsToBounds = true
        contentLabel.font = DesignSystem.DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        cancelButton.titleLabel?.font = DesignSystem.DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        confirmButton.titleLabel?.font = DesignSystem.DesignSystemFontFamily.Pretendard.medium.font(size: 18)

        cancelButton.isHidden = cancelButtonIsHidden
    }
}

extension TextPopupViewController: PanModalPresentable {

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    public var panModalBackgroundColor: UIColor {
        return colorFromRGB(0x000000, alpha: 0.4)
    }

    public var panScrollable: UIScrollView? {
      return nil
    }

    public var longFormHeight: PanModalHeight {
         let stringHeight: CGFloat = contentString.heightConstraintAt(
            width: APP_WIDTH()-40,
            font: DesignSystem.DesignSystemFontFamily.Pretendard.medium.font(size: 18))
        
         let spacingHeight: CGFloat = 60 + 52 + 56 + 20
         return .contentHeight(spacingHeight + stringHeight)
     }

    public var cornerRadius: CGFloat {
        return 24.0
    }

    public var allowsExtendedPanScrolling: Bool {
        return true
    }

    public var showDragIndicator: Bool {
        return false
    }
}
