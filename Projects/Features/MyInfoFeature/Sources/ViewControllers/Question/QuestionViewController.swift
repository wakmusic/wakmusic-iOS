import BaseFeature
import BaseFeatureInterface
import DesignSystem
import LogManager
import MessageUI
import RxSwift
import SafariServices
import UIKit
import Utility

public final class QuestionViewController: BaseViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bugReportSuperView: UIView!
    @IBOutlet weak var bugReportButton: UIButton!
    @IBOutlet weak var bugReportCheckImageView: UIImageView!

    @IBOutlet weak var suggestFunctionSuperView: UIView!
    @IBOutlet weak var suggestFunctionButton: UIButton!
    @IBOutlet weak var suggestFunctionCheckImageView: UIImageView!

    @IBOutlet weak var addSongSuperView: UIView!
    @IBOutlet weak var addSongButton: UIButton!
    @IBOutlet weak var addSongCheckImageView: UIImageView!

    @IBOutlet weak var editSongSuperView: UIView!
    @IBOutlet weak var editSongButton: UIButton!
    @IBOutlet weak var editSongCheckImageView: UIImageView!

    @IBOutlet weak var wakMusicFeedbackSuperView: UIView!
    @IBOutlet weak var wakMusicFeedbackButton: UIButton!
    @IBOutlet weak var wakMusicFeedbackCheckImageView: UIImageView!

    @IBOutlet weak var creditSuperView: UIView!
    @IBOutlet weak var creditButton: UIButton!
    @IBOutlet weak var creditCheckImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!

    let selectedColor: UIColor = DesignSystemAsset.PrimaryColor.decrease.color
    let unSelectedTextColor: UIColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
    let unSelectedColor: UIColor = DesignSystemAsset.BlueGrayColor.blueGray200.color
    let disposeBag = DisposeBag()
    var viewModel: QuestionViewModel!
    var textPopupFactory: TextPopupFactory!
    lazy var input = QuestionViewModel.Input()
    lazy var output = viewModel.transform(from: input)

    deinit {
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindRx()
    }

    public static func viewController(
        viewModel: QuestionViewModel,
        textPopupFactory: TextPopupFactory
    ) -> QuestionViewController {
        let viewController = QuestionViewController.viewController(storyBoardName: "Question", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.textPopupFactory = textPopupFactory
        return viewController
    }
}

extension QuestionViewController {
    private func configureUI() {
        self.titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        self.titleLabel.textColor = DesignSystemAsset.BlueGrayColor.gray900.color
        self.titleLabel.text = "문의하기"
        self.titleLabel.setTextWithAttributes(kernValue: -0.5)

        self.closeButton.setImage(DesignSystemAsset.Navigation.crossClose.image, for: .normal)

        self.descriptionLabel.text = "어떤 것 관련해서 문의주셨나요?"
        self.descriptionLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 20)
        self.descriptionLabel.textColor = DesignSystemAsset.BlueGrayColor.gray900.color
        self.descriptionLabel.setTextWithAttributes(kernValue: -0.5)

        self.nextButton.layer.cornerRadius = 12
        self.nextButton.clipsToBounds = true
        self.nextButton.isEnabled = false
        self.nextButton.setBackgroundColor(DesignSystemAsset.PrimaryColor.point.color, for: .normal)
        self.nextButton.setBackgroundColor(DesignSystemAsset.BlueGrayColor.gray300.color, for: .disabled)
        self.nextButton.setAttributedTitle(
            NSMutableAttributedString(
                string: "다음",
                attributes: [
                    .font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                    .foregroundColor: DesignSystemAsset.BlueGrayColor.gray25.color,
                    .kern: -0.5
                ]
            ), for: .normal
        )

        let superViews: [UIView] = [
            self.bugReportSuperView,
            self.suggestFunctionSuperView,
            self.addSongSuperView,
            self.editSongSuperView,
            self.wakMusicFeedbackSuperView,
            self.creditSuperView
        ]

        let buttons: [UIButton] = [
            self.bugReportButton,
            self.suggestFunctionButton,
            self.addSongButton,
            self.editSongButton,
            self.wakMusicFeedbackButton,
            self.creditButton
        ]

        let imageViews: [UIImageView] = [
            self.bugReportCheckImageView,
            self.suggestFunctionCheckImageView,
            self.addSongCheckImageView,
            self.editSongCheckImageView,
            self.wakMusicFeedbackCheckImageView,
            self.creditCheckImageView
        ]

        for i in 0 ..< superViews.count {
            superViews[i].layer.cornerRadius = 12
            superViews[i].layer.borderColor = unSelectedColor.cgColor
            superViews[i].layer.borderWidth = 1
            imageViews[i].image = DesignSystemAsset.Storage.checkBox.image
            imageViews[i].isHidden = true

            guard let type = InquiryType(rawValue: i) else { return }

            buttons[i].setAttributedTitle(
                NSMutableAttributedString(
                    string: type.title,
                    attributes: [
                        .font: DesignSystemFontFamily.Pretendard.light.font(size: 16),
                        .foregroundColor: unSelectedTextColor,
                        .kern: -0.5
                    ]
                ), for: .normal
            )
        }
    }

    private func bindRx() {
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)

        Observable.merge(
            bugReportButton.rx.tap.map { _ -> Int in 0 },
            suggestFunctionButton.rx.tap.map { _ -> Int in 1 },
            addSongButton.rx.tap.map { _ -> Int in 2 },
            editSongButton.rx.tap.map { _ -> Int in 3 },
            wakMusicFeedbackButton.rx.tap.map { _ -> Int in 4 },
            creditButton.rx.tap.map { _ -> Int in 5 }
        )
        .bind(to: input.selectedIndex)
        .disposed(by: disposeBag)

        output.mailSource
            .filter { $0 != .unknown }
            .map { $0.rawValue }
            .subscribe(onNext: { [weak self] (index: Int) in
                guard let self = self else {
                    return
                }

                if !self.nextButton.isEnabled {
                    self.nextButton.isEnabled = true
                }
                let superViews: [UIView] = [
                    self.bugReportSuperView,
                    self.suggestFunctionSuperView,
                    self.addSongSuperView,
                    self.editSongSuperView,
                    self.wakMusicFeedbackSuperView,
                    self.creditSuperView
                ]

                let buttons: [UIButton] = [
                    self.bugReportButton,
                    self.suggestFunctionButton,
                    self.addSongButton,
                    self.editSongButton,
                    self.wakMusicFeedbackButton,
                    self.creditButton
                ]

                let imageViews: [UIImageView] = [
                    self.bugReportCheckImageView,
                    self.suggestFunctionCheckImageView,
                    self.addSongCheckImageView,
                    self.editSongCheckImageView,
                    self.wakMusicFeedbackCheckImageView,
                    self.creditCheckImageView
                ]

                for i in 0 ..< superViews.count {
                    guard let type = InquiryType(rawValue: i) else { return }

                    buttons[i].setAttributedTitle(
                        NSMutableAttributedString(
                            string: type.title,
                            attributes: [
                                .font: i == index ? DesignSystemFontFamily.Pretendard.medium.font(size: 16) :
                                    DesignSystemFontFamily.Pretendard.light.font(size: 16),
                                .foregroundColor: i == index ? self.selectedColor : self.unSelectedTextColor,
                                .kern: -0.5
                            ]
                        ), for: .normal
                    )
                    imageViews[i].isHidden = i == index ? false : true
                    superViews[i].layer.borderColor = i == index ? self.selectedColor.cgColor : self.unSelectedColor
                        .cgColor
                    superViews[i].addShadow(
                        offset: CGSize(width: 0, height: 2),
                        color: colorFromRGB("080F34"),
                        opacity: i == index ? 0.08 : 0
                    )
                }
            })
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .withLatestFrom(output.mailSource)
            .filter { $0 != .unknown }
            .subscribe(onNext: { [weak self] source in
                let logInquiryType: InquiryAnalyticsLog.LogInquiryType = .init(mailSource: source)
                let log = InquiryAnalyticsLog.clickInquirySubmitButton(type: logInquiryType)
                LogManager.analytics(log)

                guard let self = self else { return }
                self.goToMail(source: source)
            })
            .disposed(by: disposeBag)

        output.showToastWithDismiss
            .filter { !$0.0.isEmpty }
            .withUnretained(self)
            .subscribe(onNext: { owner, params in
                let (text, toDismiss) = params
                owner.showToast(
                    text: text, options: [.tabBar]
                )
                guard toDismiss else { return }
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension QuestionViewController {
    private func goToMail(source: InquiryType) {
        if MFMailComposeViewController.canSendMail() {
            let compseVC = MFMailComposeViewController()
            compseVC.mailComposeDelegate = self
            compseVC.setToRecipients([source.receiver])
            compseVC.setSubject(source.title)
            compseVC.setMessageBody(source.body + source.suffix, isHTML: false)
            self.present(compseVC, animated: true, completion: nil)

        } else {
            guard let textPopupViewController = self.textPopupFactory.makeView(
                text: "메일 계정이 설정되어 있지 않습니다.\n설정 > Mail 앱 > 계정을 설정해주세요.",
                cancelButtonIsHidden: true,
                confirmButtonText: "확인",
                cancelButtonText: nil,
                completion: nil,
                cancelCompletion: nil
            ) as? TextPopupViewController else {
                return
            }

            self.showBottomSheet(content: textPopupViewController)
        }
    }
}

extension QuestionViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true) {
            if let error = error {
                self.input.mailComposeResult.onNext(.failure(error))
            } else {
                self.input.mailComposeResult.onNext(.success(result))
            }
        }
    }
}
