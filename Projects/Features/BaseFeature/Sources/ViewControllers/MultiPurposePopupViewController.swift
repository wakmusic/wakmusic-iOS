import BaseFeatureInterface
import DesignSystem
import NVActivityIndicatorView
import RxCocoa
import RxKeyboard
import RxSwift
import SwiftEntryKit
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

    @IBOutlet weak var indicator: NVActivityIndicatorView!

    @IBOutlet weak var confireLabelGap: NSLayoutConstraint!

    @IBOutlet weak var cancelButtonHeight: NSLayoutConstraint!

    @IBOutlet weak var cancelButtonWidth: NSLayoutConstraint!

    @IBAction func cancelAction(_ sender: UIButton) {
        textField.rx.text.onNext("")
        input.textString.accept("")
    }

    var viewModel: MultiPurposePopupViewModel!
    lazy var input = MultiPurposePopupViewModel.Input()
    lazy var output = viewModel.transform(from: input)

    var limitCount: Int = 12
    var completion: ((String) -> Void)?
    public var disposeBag = DisposeBag()

    deinit { DEBUG_LOG("❌ \(Self.self) Deinit") }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindInput()
        bindAction()
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

extension MultiPurposePopupViewController {
    private func configureUI() {
        self.view.layer.cornerRadius = 24
        self.view.clipsToBounds = true

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
        ] // 포커싱 플레이스홀더 폰트 및 color 설정

//        textField.becomeFirstResponder()
        self.textField.attributedPlaceholder = NSAttributedString(
            string: viewModel.type == .creation || viewModel.type == .updatePlaylistTile ?
                "리스트 제목을 입력하세요." : viewModel.type == .nickname ? "닉네임을 입력하세요." : "코드를 입력해주세요.",
            attributes: focusedplaceHolderAttributes
        ) // 플레이스 홀더 설정
        self.textField.font = DesignSystemFontFamily.Pretendard.medium.font(size: headerFontSize)

        self.dividerView.backgroundColor = DesignSystemAsset.BlueGrayColor.gray200.color

        self.cancelButton.layer.cornerRadius = 12
        self.cancelButton.titleLabel?.text = "취소"
        self.cancelButton.titleLabel?.font = DesignSystemFontFamily.Pretendard.bold.font(size: 12)
        self.cancelButton.layer.cornerRadius = 4
        self.cancelButton.layer.borderColor = DesignSystemAsset.BlueGrayColor.gray200.color.cgColor
        self.cancelButton.layer.borderWidth = 1
        self.cancelButton.backgroundColor = .white
        self.cancelButton.isHidden = true

        self.confirmLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        self.confirmLabel.isHidden = true

        self.limitLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        self.limitLabel.textColor = DesignSystemAsset.BlueGrayColor.gray500.color

        self.countLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        self.countLabel.textColor = DesignSystemAsset.PrimaryColor.point.color

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

        self.indicator.type = .circleStrokeSpin
        self.indicator.color = .white
    }

    private func bindInput() {
        limitCount = viewModel.type == .nickname ? 8 : 12
        limitLabel.text = "/\(limitCount)"

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

            }.disposed(by: disposeBag)
    }

    private func bindAction() {
        textField.rx.text.orEmpty
            .skip(1) // 바인드 할 때 발생하는 첫 이벤트를 무시
            .bind(to: input.textString)
            .disposed(by: disposeBag)

        saveButton.rx
            .tap
            .withLatestFrom(input.textString)
            .asDriver(onErrorJustReturn: "")
            .bind(with: self) { owner, text in

                #warning("디스미스 안됨 큰일났ㄸ")
                SwiftEntryKit.dismiss {
                    guard let completion = owner.completion else {
                        return
                    }
                    completion(text)
                }
            }
            .disposed(by: disposeBag)
    }
}
