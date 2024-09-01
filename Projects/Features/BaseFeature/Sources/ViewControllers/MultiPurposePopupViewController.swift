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

                owner.countLabel.text = "\(str.alphabetCharacterCeilCount)자"

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

                } else if str.alphabetCharacterCeilCount > owner.viewModel.type.textLimitCount {
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
        limitLabel.text = "/\(viewModel.type.textLimitCount)"

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
            string: viewModel.type.placeHolder,
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
        let isBackSpace: Bool = strcmp(char, "\\b") == -92

        let currentText = textField.text ?? ""
        let latinCharCount: Double = currentText.alphabetCharacterCount

        if let lastChar = currentText.last,
            latinCharCount <= Double(viewModel.type.textLimitCount) {
            // 완성되지 않은 한글인 경우
            if lastChar.isIncompleteHangul {
                return true
            }

            // 완성된 한글이지만, 추가로 자음이 결합될 수 있는 경우
            if !lastChar.isIncompleteHangul &&
                lastChar.canAddAdditionalJongseong {
                return true
            }
        }

        guard isBackSpace || latinCharCount < Double(viewModel.type.textLimitCount) else { return false }

        return true
    }
}

private extension String {
    var alphabetCharacterCount: Double {
        let count = reduce(0) { count, char in
            return count + (char.isAlphabetCharacter ? 0.5 : 1)
        }
        return count
    }

    var alphabetCharacterCeilCount: Int {
        let count = reduce(0) { count, char in
            return count + (char.isAlphabetCharacter ? 0.5 : 1)
        }
        return Int(ceil(count))
    }
}

private extension Character {
    var isAlphabetCharacter: Bool {
        return self.unicodeScalars.allSatisfy { $0.isASCII && $0.properties.isAlphabetic }
    }

    /// 완성되지 않은 한글 여부
    var isIncompleteHangul: Bool {
        guard let scalar = unicodeScalars.first else { return false }

        // 한글 범위에 있는지 확인 (유니코드 값 범위 체크)
        let hangulBase: UInt32 = 0xAC00
        let hangulEnd: UInt32 = 0xD7A3

        if scalar.value >= hangulBase && scalar.value <= hangulEnd {
            let syllableIndex = (scalar.value - hangulBase)
            let isCompleted = syllableIndex % 28 != 0
            return !isCompleted
        }

        // 완성되지 않은 자모나 조합 중인 경우
        return (scalar.value >= 0x1100 && scalar.value <= 0x11FF) || // 초성 자모 (현대 한글에서 사용하는 초성, 중성, 종성 등의 조합용 자모)
            (scalar.value >= 0x3130 && scalar.value <= 0x318F) || // 호환용 자모 (구성된 한글 자모, 옛 한글 자모 등)
            (scalar.value >= 0xA960 && scalar.value <= 0xA97F) || // 확장 A (옛 한글 자모의 일부)
            (scalar.value >= 0xD7B0 && scalar.value <= 0xD7FF) // 확장 B (옛 한글 자모의 일부)
    }

    /// 한글 음절이 종성을 가졌으나 추가적인 종성이 더 결합될 수 있는지 여부 확인
    var canAddAdditionalJongseong: Bool {
        guard let scalar = unicodeScalars.first else { return false }

        // 한글 음절 유니코드 범위: U+AC00 ~ U+D7A3
        let hangulBase: UInt32 = 0xAC00
        let hangulEnd: UInt32 = 0xD7A3

        guard scalar.value >= hangulBase && scalar.value <= hangulEnd else {
            return false
        }

        // 종성에 해당하는 인덱스를 계산
        let syllableIndex = scalar.value - hangulBase
        let jongseongIndex = Int(syllableIndex % 28)

        // 종성이 있을 때 추가 종성을 가질 수 있는 경우를 판별
        let canHaveDoubleJongseong: Bool

        switch jongseongIndex {
        case 1: // ㄱ (U+11A8)
            canHaveDoubleJongseong = true
        case 4: // ㄴ (U+11AB)
            canHaveDoubleJongseong = true
        case 8: // ㄹ (U+11AF)
            canHaveDoubleJongseong = true
        case 17: // ㅂ (U+11B7)
            canHaveDoubleJongseong = true
        default:
            canHaveDoubleJongseong = false
        }

        return canHaveDoubleJongseong
    }
}
