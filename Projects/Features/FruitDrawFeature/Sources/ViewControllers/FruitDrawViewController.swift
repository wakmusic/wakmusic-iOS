import BaseFeatureInterface
import DesignSystem
import FruitDrawFeatureInterface
import LogManager
import Lottie
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

public final class FruitDrawViewController: UIViewController {
    private let backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.FruitDraw.fruitDrawBg.image
    }

    private let navigationBarView = WMNavigationBarView()

    private let dismissButton = UIButton().then {
        let dismissImage = DesignSystemAsset.MusicDetail.dismiss.image
            .withTintColor(DesignSystemAsset.PrimaryColorV2.white.color, renderingMode: .alwaysOriginal)
        $0.setImage(dismissImage, for: .normal)
    }

    private let componentContentView = UIView()

    private let descriptioniLabel = WMLabel(
        text: "두근.. 두근...\n열매를 뽑아주세요!",
        textColor: .white,
        font: .t4(weight: .medium),
        alignment: .center,
        lineHeight: 28
    ).then {
        $0.numberOfLines = 0
    }

    private let drawMachineImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.FruitDraw.fruitDrawMachine.image
    }

    private let drawOrConfirmButton = UIButton(type: .system).then {
        $0.setTitleColor(DesignSystemAsset.BlueGrayColor.blueGray25.color, for: .normal)
        $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        $0.titleLabel?.setTextWithAttributes(alignment: .center)
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.gray300.color
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.isEnabled = false
    }

    private lazy var activityIndicator = NVActivityIndicatorView(frame: .zero).then {
        $0.color = .white
        $0.type = .circleStrokeSpin
    }

    private lazy var lottieAnimationView =
        LottieAnimationView(
            name: "Fruit_Draw",
            bundle: DesignSystemResources.bundle
        ).then {
            $0.loopMode = .playOnce
            $0.contentMode = .scaleAspectFit
        }

    private let rewardDescriptioniLabel = WMLabel(
        text: "",
        textColor: .white,
        font: .t2(weight: .bold),
        alignment: .center
    ).then {
        $0.numberOfLines = 0
        $0.alpha = 0
    }

    private let rewardFruitImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.alpha = 0
    }

    /// Left Component
    private let purpleHeartImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.FruitDraw.fruitDrawPurpleHeart.image
    }

    private let leftNoteImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.FruitDraw.fruitDrawLeftNote.image
    }

    private let greenHeartImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.FruitDraw.fruitDrawGreenHeart.image
    }

    private let cloudImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.FruitDraw.fruitDrawCloud.image
    }

    private let pickBallImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.FruitDraw.fruitDrawPinkBall.image
    }

    /// Right Component
    private let yellowHeartImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.FruitDraw.fruitDrawYellowHeart.image
    }

    private let rightTopNoteImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.FruitDraw.fruitDrawRightTopNote.image
    }

    private let purpleBallImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.FruitDraw.fruitDrawPurpleBall.image
    }

    private let magentaBallImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.FruitDraw.fruitDrawMagentaBall.image
    }

    private let orangeBallImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.FruitDraw.fruitDrawOrangeBall.image
    }

    private let redHeartImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.FruitDraw.fruitDrawRedHeart.image
    }

    private let rightBottomNoteImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.FruitDraw.fruitDrawRightBottomNote.image
    }

    private let deepGreenHeartImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.FruitDraw.fruitDrawDeepGreenHeart.image
    }

    private let viewModel: FruitDrawViewModel
    private let textPopupFactory: TextPopupFactory
    private weak var delegate: FruitDrawViewControllerDelegate?

    lazy var input = FruitDrawViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init(
        viewModel: FruitDrawViewModel,
        textPopupFactory: TextPopupFactory,
        delegate: FruitDrawViewControllerDelegate
    ) {
        self.viewModel = viewModel
        self.textPopupFactory = textPopupFactory
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("\(Self.self) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setLayout()
        configureUI()
        outputBind()
        inputBind()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogManager.analytics(FruitDrawAnalyticsLog.viewPage(pageName: "fruit_draw"))
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

private extension FruitDrawViewController {
    func outputBind() {
        output.canDraw
            .skip(1)
            .bind(with: self) { owner, canDraw in
                owner.drawOrConfirmButton.isEnabled = true
                owner.drawOrConfirmButton.setTitle(canDraw ? "음표 열매 뽑기" : "오늘 뽑기 완료", for: .normal)
                owner.drawOrConfirmButton.backgroundColor = canDraw ?
                    DesignSystemAsset.PrimaryColorV2.point.color :
                    DesignSystemAsset.BlueGrayColor.gray300.color
                owner.activityIndicator.stopAnimating()
            }
            .disposed(by: disposeBag)

        output.showRewardNote
            .bind(with: self) { owner, entity in
                owner.drawOrConfirmButton.setTitle("확인", for: .normal)
                owner.drawOrConfirmButton.backgroundColor = DesignSystemAsset.PrimaryColorV2.point.color
                owner.rewardDescriptioniLabel.text = "\(entity.name)를 획득했어요!"

                if let data = entity.imageData {
                    owner.rewardFruitImageView.image = UIImage(data: data)
                }

                UIView.animate(withDuration: 0.3) {
                    owner.lottieAnimationView.alpha = 0
                    owner.drawOrConfirmButton.alpha = 1
                    owner.rewardDescriptioniLabel.alpha = 1
                    owner.rewardFruitImageView.alpha = 1
                }
            }
            .disposed(by: disposeBag)

        output.showToast
            .bind(with: self) { owner, message in
                owner.showToast(text: message, options: [.tabBar])
            }
            .disposed(by: disposeBag)

        output.occurredError
            .bind(with: self) { owner, message in
                owner.showBottomSheet(
                    content: owner.textPopupFactory.makeView(
                        text: message,
                        cancelButtonIsHidden: true,
                        confirmButtonText: "확인",
                        cancelButtonText: nil,
                        completion: {
                            owner.dismiss(animated: true)
                        },
                        cancelCompletion: nil
                    ),
                    dismissOnOverlayTapAndPull: false
                )
            }
            .disposed(by: disposeBag)
    }

    func inputBind() {
        input.fetchFruitDrawStatus.onNext(())

        dismissButton.rx.tap
            .withLatestFrom(output.fruitSource)
            .bind(with: self) { owner, fruit in
                let drawCompleted: Bool = fruit.quantity > 0
                if drawCompleted {
                    owner.delegate?.completedFruitDraw(itemCount: fruit.quantity)
                    owner.dismiss(animated: true)
                } else {
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)

        drawOrConfirmButton.rx.tap
            .withLatestFrom(output.canDraw)
            .filter { [output] canDraw in
                guard canDraw else {
                    output.showToast.onNext("오늘은 더 이상 뽑을 수 없어요.")
                    return false
                }
                return true
            }
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(output.fruitSource)
            .bind(with: self) { owner, fruit in
                let drawCompleted: Bool = fruit.quantity > 0

                if drawCompleted {
                    owner.delegate?.completedFruitDraw(itemCount: fruit.quantity)
                    owner.dismiss(animated: true)
                } else {
                    LogManager.analytics(FruitDrawAnalyticsLog.clickFruitDrawButton)
                    owner.input.didTapFruitDraw.onNext(())
                    owner.startLottieAnimation()
                    UIView.animate(
                        withDuration: 0.3,
                        delay: 0.5
                    ) {
                        owner.showHideComponent(isHide: true)
                    }
                }
            }
            .disposed(by: disposeBag)

        Observable.merge(
            NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification)
                .map { _ in UIApplication.didEnterBackgroundNotification },
            NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
                .map { _ in UIApplication.willEnterForegroundNotification }
        )
        .bind(with: self, onNext: { owner, notification in
            if notification == UIApplication.didEnterBackgroundNotification {
                owner.removeComponentAnimation()
            } else {
                owner.startComponentAnimation()
            }
        })
        .disposed(by: disposeBag)
    }
}

private extension FruitDrawViewController {
    func addSubViews() {
        view.addSubviews(
            backgroundImageView,
            drawMachineImageView,
            componentContentView
        )

        // Left Component
        componentContentView.addSubviews(
            purpleHeartImageView,
            leftNoteImageView,
            greenHeartImageView,
            pickBallImageView,
            cloudImageView
        )

        // Right Component
        componentContentView.addSubviews(
            yellowHeartImageView,
            purpleBallImageView,
            rightTopNoteImageView,
            magentaBallImageView,
            orangeBallImageView,
            redHeartImageView,
            deepGreenHeartImageView,
            rightBottomNoteImageView
        )

        view.addSubviews(
            navigationBarView,
            descriptioniLabel,
            rewardFruitImageView,
            rewardDescriptioniLabel,
            drawOrConfirmButton,
            activityIndicator
        )
        navigationBarView.setLeftViews([dismissButton])
    }

    func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        componentContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }

        drawMachineImageView.snp.makeConstraints {
            $0.top.equalTo(218.0.correctTop)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180 * APP_WIDTH() / 375)
            $0.height.equalTo(300 * APP_HEIGHT() / 812)
        }

        descriptioniLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(drawMachineImageView.snp.top).offset(-14)
            $0.height.equalTo(56)
        }

        drawOrConfirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(56)
        }

        activityIndicator.snp.makeConstraints {
            $0.center.equalTo(drawOrConfirmButton.snp.center)
            $0.size.equalTo(20)
        }

        rewardFruitImageView.snp.makeConstraints {
            $0.top.equalTo(276.0.correctTop)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(275)
            $0.height.equalTo(200)
        }

        rewardDescriptioniLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(32)
            $0.bottom.equalTo(rewardFruitImageView.snp.top).offset(60.0.correctBottom)
        }

        // Left Component
        purpleHeartImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(40.0.correctLeading)
            $0.top.equalToSuperview().offset(140.0.correctTop)
        }

        leftNoteImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(29.0.correctLeading)
            $0.top.equalToSuperview().offset(234.0.correctTop)
        }

        greenHeartImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25.0.correctLeading)
            $0.top.equalToSuperview().offset(362.0.correctTop)
        }

        cloudImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(-31)
            $0.bottom.equalToSuperview().offset(153.56.correctBottom)
        }

        pickBallImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(6)
            $0.bottom.equalTo(cloudImageView.snp.bottom).offset(-80.44)
        }

        // Right Component
        yellowHeartImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(104.0.correctTop)
            $0.trailing.equalToSuperview().offset(108.0.correctTrailing)
        }

        rightTopNoteImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(132.0.correctTop)
            $0.trailing.equalToSuperview().offset(38.61.correctTrailing)
        }

        purpleBallImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(159.0.correctTop)
            $0.trailing.equalToSuperview().offset(26.47.correctTrailing)
        }

        magentaBallImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(259.0.correctTop)
            $0.trailing.equalToSuperview().offset(-5.94)
        }

        orangeBallImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(342.0.correctTop)
            $0.trailing.equalToSuperview().offset(48.61.correctTrailing)
        }

        redHeartImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(34.52.correctTrailing)
            $0.bottom.equalToSuperview().offset(326.38.correctBottom)
        }

        rightBottomNoteImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(82.24.correctTrailing)
            $0.bottom.equalToSuperview().offset(160.66.correctBottom)
        }

        deepGreenHeartImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(84.67.correctTrailing)
            $0.bottom.equalToSuperview().offset(158.22.correctBottom)
        }
    }

    func configureUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        perform(#selector(startComponentAnimation), with: nil, afterDelay: 0.3)
        rewardFruitImageView.addShadow(
            offset: CGSize(width: 0, height: 2.5),
            color: UIColor.black,
            opacity: 0.1,
            radius: 50
        )
        activityIndicator.startAnimating()
    }
}

private extension FruitDrawViewController {
    func startLottieAnimation() {
        view.addSubview(lottieAnimationView)
        lottieAnimationView.snp.makeConstraints {
            $0.width.equalTo(APP_WIDTH())
            $0.height.equalTo(200 * APP_WIDTH() / 275)
            $0.center.equalToSuperview()
        }
        lottieAnimationView.play { _ in
            self.input.endedLottieAnimation.onNext(())
        }
    }

    @objc func startComponentAnimation() {
        // Left Component
        purpleHeartImageView.moveAnimate(duration: 5.0, amount: 30, direction: .up)
        leftNoteImageView.moveAnimate(duration: 3.0, amount: 30, direction: .up)
        greenHeartImageView.moveAnimate(duration: 4.0, amount: 20, direction: .down)
        [cloudImageView, pickBallImageView].forEach {
            $0.moveAnimate(duration: 3.0, amount: 30, direction: .down)
        }

        // Right Component
        yellowHeartImageView.moveAnimate(duration: 3.0, amount: 20, direction: .down)
        [rightTopNoteImageView, purpleBallImageView].forEach {
            $0.moveAnimate(duration: 5.0, amount: 30, direction: .up)
        }
        magentaBallImageView.moveAnimate(duration: 5.0, amount: 20, direction: .down)
        orangeBallImageView.moveAnimate(duration: 3.0, amount: 30, direction: .up)
        redHeartImageView.moveAnimate(duration: 4.0, amount: 15, direction: .up)
        [rightBottomNoteImageView, deepGreenHeartImageView].forEach {
            $0.moveAnimate(duration: 5.0, amount: 20, direction: .up)
        }
    }

    func removeComponentAnimation() {
        componentContentView.subviews.forEach {
            $0.transform = .identity
            $0.layer.removeAllAnimations()
        }
    }

    func showHideComponent(isHide: Bool) {
        componentContentView.subviews.forEach {
            $0.alpha = isHide ? 0 : 1
        }
        descriptioniLabel.alpha = isHide ? 0 : 1
        drawMachineImageView.alpha = descriptioniLabel.alpha
        drawOrConfirmButton.alpha = descriptioniLabel.alpha
        navigationBarView.alpha = descriptioniLabel.alpha
    }
}
