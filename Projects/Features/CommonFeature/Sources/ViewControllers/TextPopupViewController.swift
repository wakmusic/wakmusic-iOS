import UIKit
import Utility
import PanModal
import DesignSystem
public final class TextPopupViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!

    var contentString: String = ""
    var cancelButtonIsHidden: Bool = false
    var completion: (() -> Void)?
    var cancelCompletion: (() -> Void)?
    var allowsDragAndTapToDismiss: Bool = true
    var cancelButtonText: String = ""
    var confirmButtonText: String = ""
    
    deinit {
        DEBUG_LOG("❌ \(Self.self) Deinit")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    public static func viewController(
        text: String = "",
        cancelButtonIsHidden: Bool,
        allowsDragAndTapToDismiss: Bool = true,
        confirmButtonText:String = "확인",
        cancelButtonText:String = "취소",
        completion: (() -> Void)? = nil,
        cancelCompletion: (() -> Void)? = nil
        
    ) -> TextPopupViewController {
        let viewController = TextPopupViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        viewController.contentString = text
        viewController.cancelButtonIsHidden = cancelButtonIsHidden
        viewController.allowsDragAndTapToDismiss = allowsDragAndTapToDismiss
        viewController.completion = completion
        viewController.cancelCompletion = cancelCompletion
        viewController.confirmButtonText = confirmButtonText
        viewController.cancelButtonText = cancelButtonText
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

        // 취소
        cancelButton.layer.cornerRadius = 12
        cancelButton.clipsToBounds = true
        cancelButton.isHidden = cancelButtonIsHidden

        let cancelAttributedString = NSMutableAttributedString(
            string: cancelButtonText,
            attributes: [
                .font: DesignSystem.DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                .foregroundColor: DesignSystemAsset.GrayColor.gray25.color,
                .kern: -0.5]
        )
        cancelButton.setAttributedTitle(cancelAttributedString, for: .normal)

        confirmButton.backgroundColor = DesignSystemAsset.PrimaryColor.point.color
        confirmButton.layer.cornerRadius = cancelButton.layer.cornerRadius
        confirmButton.clipsToBounds = true

        // 확인
        let confirmAttributedString = NSMutableAttributedString(
            string: confirmButtonText,
            attributes: [
                .font: DesignSystem.DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                .foregroundColor: DesignSystemAsset.GrayColor.gray25.color,
                .kern: -0.5]
        )
        confirmButton.setAttributedTitle(confirmAttributedString, for: .normal)

        // 내용
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakStrategy = .hangulWordPriority

        let contentAttributedString = NSMutableAttributedString(
            string: contentString,
            attributes: [
                .font: DesignSystem.DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                .kern: -0.5,
                .paragraphStyle: paragraphStyle]
        )
        contentLabel.attributedText = contentAttributedString
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
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        paragraphStyle.alignment = .center

        let contentAttributedString = NSMutableAttributedString(
            string: contentString,
            attributes: [
                .font: DesignSystem.DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                .kern: -0.5,
                .paragraphStyle: paragraphStyle]
        )

        let contentHeight: CGFloat = contentAttributedString.height(containerWidth: APP_WIDTH()-40)
        let spacingHeight: CGFloat = 60 + 52 + 56 + 10
        return .contentHeight(spacingHeight + contentHeight)
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
    
    public var allowsDragToDismiss: Bool {
        return allowsDragAndTapToDismiss
    }

    public var allowsTapToDismiss: Bool {
        return allowsDragAndTapToDismiss
    }
}
