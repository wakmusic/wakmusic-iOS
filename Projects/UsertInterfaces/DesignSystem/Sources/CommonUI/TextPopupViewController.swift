import UIKit
import Utility
import PanModal

public final class TextPopupViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!

    var contentString: String = ""
    var cancelButtonIsHidden: Bool = false
    var completion: (() -> Void)?
    var cancelCompletion: (() -> Void)?
    
    deinit {
        DEBUG_LOG("\(Self.self) Deinit")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    public static func viewController(text: String = "", cancelButtonIsHidden: Bool, completion: (() -> Void)? = nil, cancelCompletion: (() -> Void)? = nil) -> TextPopupViewController {
        let viewController = TextPopupViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        viewController.contentString = text
        viewController.cancelButtonIsHidden = cancelButtonIsHidden
        viewController.completion = completion
        viewController.cancelCompletion = cancelCompletion
        return viewController
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true)
        cancelCompletion?()
    }

    @IBAction func confirmButtonAction(_ sender: Any) {
        dismiss(animated: true)
        completion?()
    }
}

extension TextPopupViewController {

    private func configureUI() {

        cancelButton.layer.cornerRadius = 12
        cancelButton.clipsToBounds = true
        cancelButton.isHidden = cancelButtonIsHidden
        cancelButton.titleLabel?.font = DesignSystem.DesignSystemFontFamily.Pretendard.medium.font(size: 18)

        confirmButton.layer.cornerRadius = cancelButton.layer.cornerRadius
        confirmButton.clipsToBounds = true
        confirmButton.titleLabel?.font = DesignSystem.DesignSystemFontFamily.Pretendard.medium.font(size: 18)

        contentLabel.font = DesignSystem.DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        contentLabel.text = contentString
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
