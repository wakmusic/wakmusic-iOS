import BaseFeatureInterface
import DesignSystem
import LogManager
import RxCocoa
import RxKeyboard
import RxSwift
import UIKit
import Utility

public final class MultiPurposePopupViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var confirmLabel: UILabel!

    @IBAction func cancelAction(_ sender: UIButton) {
        textField.rx.text.onNext("")
        input.textString.accept("")
    }

    private var viewModel: MultiPurposePopupViewModel!
    private lazy var input = MultiPurposePopupViewModel.Input()
    private lazy var output = viewModel.transform(from: input)

    private var limitCount: Int = 12
    private var completion: ((String) -> Void)?
    private let disposeBag = DisposeBag()

    deinit { LogManager.printDebug("❌ \(Self.self) Deinit") }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        inputBind()
    }

    public static func viewController(
        viewModel: MultiPurposePopupViewModel,
        completion: ((String) -> Void)? = nil
    ) -> MultiPurposePopupViewController {
        let viewController = MultiPurposePopupViewController.viewController(
            storyBoardName: "Base",
            bundle: Bundle.module
        )
        viewController.viewModel = viewModel
        viewController.completion = completion
        return viewController
    }
}

private extension MultiPurposePopupViewController {
    func inputBind() {
        textField.rx.text.orEmpty
            .skip(1)
            .bind(to: input.textString)
            .disposed(by: disposeBag)

        saveButton.rx.tap
            .withLatestFrom(input.textString)
            .bind(with: self) { owner, text in
                owner.dismiss(animated: true) {
                    owner.completion?(text)
                }
            }
            .disposed(by: disposeBag)

        input.textString
            .bind(with: self) { owner, str in
                let errorColor = DesignSystemAsset.PrimaryColor.increase.color
                let passColor = DesignSystemAsset.PrimaryColor.decrease.color

                owner.countLabel.text = "\(str.count)자"

                if str.isEmpty {
                    owner.cancelButton.isHidden = true
                    owner.confirmLabel.isHidden = true
                    owner.saveButton.isEnabled = false
                    owner.dividerView.backgroundColor = DesignSystemAsset.BlueGrayColor.gray200.color
                    owner.countLabel.textColor = DesignSystemAsset.PrimaryColor.point.color
                    return

                } else {
                    owner.cancelButton.isHidden = false
                    owner.confirmLabel.isHidden = false
                    owner.countLabel.isHidden = false
                }

                if str.isWhiteSpace {
                    owner.dividerView.backgroundColor = errorColor
                    owner.confirmLabel.text = "제목이 비어있습니다."
                    owner.confirmLabel.textColor = errorColor
                    owner.countLabel.textColor = errorColor
                    owner.saveButton.isEnabled = false

                } else if str.count > owner.limitCount {
                    owner.dividerView.backgroundColor = errorColor
                    owner.confirmLabel.text = "글자 수를 초과하였습니다."
                    owner.confirmLabel.textColor = errorColor
                    owner.countLabel.textColor = errorColor
                    owner.saveButton.isEnabled = false

                } else {
                    owner.dividerView.backgroundColor = passColor
                    owner.confirmLabel.text = owner.viewModel.type == .nickname ? "사용할 수 있는 닉네임입니다." : "사용할 수 있는 제목입니다."
                    owner.confirmLabel.textColor = passColor
                    owner.countLabel.textColor = DesignSystemAsset.PrimaryColor.point.color
                    owner.saveButton.isEnabled = true
                }
            }
            .disposed(by: disposeBag)
    }
}

private extension MultiPurposePopupViewController {
    func configureUI() {
        limitCount = viewModel.type == .nickname ? 8 : 12
        limitLabel.text = "/\(limitCount)"

        titleLabel.text = viewModel.type.title
        titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        titleLabel.textColor = DesignSystemAsset.BlueGrayColor.gray900.color

        subTitleLabel.text = viewModel.type.subTitle
        subTitleLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 16)
        subTitleLabel.textColor = DesignSystemAsset.BlueGrayColor.gray400.color

        let headerFontSize: CGFloat = 20
        let focusedplaceHolderAttributes = [
            NSAttributedString.Key.foregroundColor: DesignSystemAsset.BlueGrayColor.gray400.color,
            NSAttributedString.Key.font: DesignSystemFontFamily.Pretendard.medium.font(size: headerFontSize)
        ]

        textField.attributedPlaceholder = NSAttributedString(
            string: viewModel.type == .creation || viewModel.type == .updatePlaylistTitle ?
                "리스트 제목을 입력하세요." : viewModel.type == .nickname ? "닉네임을 입력하세요." : "코드를 입력해주세요.",
            attributes: focusedplaceHolderAttributes
        )
        textField.font = DesignSystemFontFamily.Pretendard.medium.font(size: headerFontSize)
        textField.becomeFirstResponder()
        textField.delegate = self

        dividerView.backgroundColor = DesignSystemAsset.BlueGrayColor.gray200.color

        cancelButton.layer.cornerRadius = 12
        cancelButton.titleLabel?.text = "취소"
        cancelButton.titleLabel?.font = DesignSystemFontFamily.Pretendard.bold.font(size: 12)
        cancelButton.layer.cornerRadius = 4
        cancelButton.layer.borderColor = DesignSystemAsset.BlueGrayColor.gray200.color.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.backgroundColor = .white
        cancelButton.isHidden = true

        confirmLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        confirmLabel.isHidden = true

        limitLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        limitLabel.textColor = DesignSystemAsset.BlueGrayColor.gray500.color

        countLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        countLabel.textColor = DesignSystemAsset.PrimaryColor.point.color

        saveButton.layer.cornerRadius = 12
        saveButton.clipsToBounds = true
        saveButton.setAttributedTitle(NSMutableAttributedString(
            string: viewModel.type.btnText,
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray25.color
            ]
        ), for: .normal)

        saveButton.setBackgroundColor(DesignSystemAsset.PrimaryColor.point.color, for: .normal)
        saveButton.setBackgroundColor(DesignSystemAsset.BlueGrayColor.gray300.color, for: .disabled)
    }
}

extension MultiPurposePopupViewController: UITextFieldDelegate {
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let char = string.cString(using: String.Encoding.utf8) else { return false }
        let isBackSpace = strcmp(char, "\\b")

        guard isBackSpace == -92 || (textField.text?.count ?? 0) < limitCount else { return false }
        return true
    }
}
