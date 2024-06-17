import BaseFeature
import BaseFeatureInterface
import DesignSystem
import RxSwift
import UIKit
import Utility
import MyInfoFeatureInterface

public final class RequestViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var questionImageview: UIImageView!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var questionSuperView: UIView!

    @IBOutlet weak var qnaSuperView: UIView!
    @IBOutlet weak var qnaSuperImageview: UIImageView!
    @IBOutlet weak var qnaButton: UIButton!

    @IBOutlet weak var noticeSuperView: UIView!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var noticeImageView: UIImageView!

    @IBOutlet weak var serviceSuperView: UIView!
    @IBOutlet weak var serviceButton: UIButton!
    @IBOutlet weak var serviceImageView: UIImageView!

    /// 폭탄
    @IBOutlet weak var bombSuperView: UIView!
    @IBOutlet weak var bombButton: UIButton!
    @IBOutlet weak var bombImageView: UIImageView!

    @IBOutlet weak var dotLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var fakeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var withdrawButton: UIButton!

    var textPopUpFactory: TextPopUpFactory!

    @IBAction func pressBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func moveQnaAction(_ sender: UIButton) {
        let vc = faqFactory.makeView()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func moveQuestionAction(_ sender: Any) {
        let vc = questionComponent.makeView().wrapNavigationController
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }

    @IBAction func movenoticeAction(_ sender: Any) {
        let viewController = noticeFactory.makeView()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func presswithDrawAction(_ sender: UIButton) {
        guard let secondConfirmVc = textPopUpFactory.makeView(
            text: "정말 탈퇴하시겠습니까?",
            cancelButtonIsHidden: false,
            allowsDragAndTapToDismiss: nil,
            confirmButtonText: nil,
            cancelButtonText: nil,
            completion: { [weak self] in

                guard let self else { return }

                self.input.pressWithdraw.onNext(())
            },
            cancelCompletion: nil
        ) as? TextPopupViewController else {
            return
        }

        guard let firstConfirmVc = textPopUpFactory.makeView(
            text: "회원탈퇴 신청을 하시겠습니까?",
            cancelButtonIsHidden: false,
            allowsDragAndTapToDismiss: nil,
            confirmButtonText: nil,
            cancelButtonText: nil,
            completion: { [weak self] in

                guard let self else { return }

                self.showPanModal(content: secondConfirmVc)
            },
            cancelCompletion: nil
        ) as? TextPopupViewController else {
            return
        }

        self.showPanModal(content: firstConfirmVc)
    }

    var viewModel: RequestViewModel!
    lazy var input = RequestViewModel.Input()
    lazy var output = viewModel.transform(from: input)

    var faqFactory: FaqFactory!
    var questionComponent: QuestionComponent!
    var noticeFactory: NoticeFactory!
    var serviceInfoComponent: ServiceInfoComponent!

    var disposeBag = DisposeBag()
    deinit { DEBUG_LOG("❌ \(Self.self) Deinit") }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindRx()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil // 스와이프로 뒤로가기
    }

    public static func viewController(
        viewModel: RequestViewModel,
        faqFactory: FaqFactory,
        questionComponent: QuestionComponent,
        noticeFactory: NoticeFactory,
        serviceInfoComponent: ServiceInfoComponent,
        textPopUpFactory: TextPopUpFactory
    ) -> RequestViewController {
        let viewController = RequestViewController.viewController(storyBoardName: "Request", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.faqFactory = faqFactory
        viewController.questionComponent = questionComponent
        viewController.noticeFactory = noticeFactory
        viewController.serviceInfoComponent = serviceInfoComponent
        viewController.textPopUpFactory = textPopUpFactory
        return viewController
    }
}

extension RequestViewController {
    private func configureUI() {
        self.backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        self.titleLabel.text = "건의사항"
        self.titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        self.titleLabel.setTextWithAttributes(kernValue: -0.5)

        let buttons: [UIButton] = [
            self.questionButton,
            self.qnaButton,
            self.noticeButton,
            self.serviceButton,
            self.bombButton
        ]
        let superViews: [UIView] = [
            self.questionSuperView,
            self.qnaSuperView,
            self.noticeSuperView,
            self.serviceSuperView,
            self.bombSuperView
        ]
        let imageViews: [UIImageView] = [
            self.questionImageview,
            self.qnaSuperImageview,
            self.noticeImageView,
            self.serviceImageView,
            self.bombImageView
        ]

        for i in 0 ..< buttons.count {
            var title = ""
            switch i {
            case 0:
                title = "문의하기"
                imageViews[i].image = DesignSystemAsset.Storage.question.image
            case 1:
                title = "자주 묻는 질문"
                imageViews[i].image = DesignSystemAsset.Storage.qna.image
            case 2:
                title = "공지사항"
                imageViews[i].image = DesignSystemAsset.Storage.notice.image
            case 3:
                title = "서비스 정보"
                imageViews[i].image = DesignSystemAsset.Storage.document.image
            case 4:
                title = "💣 앱 터트리기"
                imageViews[i].image = DesignSystemAsset.Storage.question.image
            default:
                return
            }

            let attr: NSAttributedString = NSAttributedString(
                string: title,
                attributes: [
                    .font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
                    .foregroundColor: DesignSystemAsset.BlueGrayColor.gray900.color,
                    .kern: -0.5
                ]
            )
            buttons[i].setAttributedTitle(attr, for: .normal)
            superViews[i].backgroundColor = .white.withAlphaComponent(0.4)
            superViews[i].layer.borderWidth = 1
            superViews[i].layer.cornerRadius = 12
            superViews[i].layer.borderColor = DesignSystemAsset.BlueGrayColor.gray200.color.cgColor
        }

        dotLabel.layer.cornerRadius = 2
        dotLabel.clipsToBounds = true

        descriptionLabel.text = "왁타버스 뮤직 팀에 속한 모든 팀원들은 부아내비 (부려먹는 게 아니라 내가 비빈거다)라는 모토를 가슴에 새기고 일하고 있습니다."
        descriptionLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        descriptionLabel.setTextWithAttributes(kernValue: -0.5, lineHeightMultiple: 1.26)

        let withDrawAttributedString = NSMutableAttributedString.init(string: "회원탈퇴")
        withDrawAttributedString.addAttributes(
            [
                .font: DesignSystemFontFamily.Pretendard.bold.font(size: 12),
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray400.color,
                .kern: -0.5
            ],
            range: NSRange(location: 0, length: withDrawAttributedString.string.count)
        )
        withdrawButton.layer.borderWidth = 1
        withdrawButton.layer.cornerRadius = 4
        withdrawButton.layer.borderColor = DesignSystemAsset.BlueGrayColor.gray300.color.cgColor
        withdrawButton.setAttributedTitle(withDrawAttributedString, for: .normal)

        #if DEBUG
            self.bombSuperView.isHidden = false
        #else
            self.bombSuperView.isHidden = true
        #endif
    }

    private func bindRx() {
        output.withDrawResult.subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }

            let status: Int = $0.status

            guard let textPopUpViewController = textPopUpFactory.makeView(
                text: (status == 200) ? "회원탈퇴가 완료되었습니다.\n이용해주셔서 감사합니다." : $0.description,
                cancelButtonIsHidden: true,
                allowsDragAndTapToDismiss: nil,
                confirmButtonText: nil,
                cancelButtonText: nil,
                completion: { [weak self] in

                    guard let self else { return }

                    if status == 200 {
                        self.navigationController?.popViewController(animated: true)
                    }
                },
                cancelCompletion: nil
            ) as? TextPopupViewController else {
                return
            }

            self.showPanModal(content: textPopUpViewController)
        })
        .disposed(by: disposeBag)

        serviceButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let viewController = owner.serviceInfoComponent.makeView()
                owner.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: disposeBag)

        bombButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _, _ in
                let array: [Int] = [0]
                let _ = array[1]
            }).disposed(by: disposeBag)
    }
}
