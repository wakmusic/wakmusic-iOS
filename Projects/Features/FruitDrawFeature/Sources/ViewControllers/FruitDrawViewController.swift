import DesignSystem
import LogManager
import Lottie
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

    private let drawButton = UIButton(type: .system).then {
        $0.setTitle("음표 열매 뽑기", for: .normal)
        $0.setTitleColor(DesignSystemAsset.BlueGrayColor.blueGray25.color, for: .normal)
        $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        $0.titleLabel?.setTextWithAttributes(alignment: .center)
        $0.backgroundColor = DesignSystemAsset.PrimaryColorV2.point.color
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    private lazy var lottieAnimationView =
        LottieAnimationView(
            name: "Splash_Logo_Main",
            bundle: DesignSystemResources.bundle
        ).then {
            $0.loopMode = .playOnce
            $0.contentMode = .scaleAspectFit
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

    private var viewModel: FruitDrawViewModel
    lazy var input = FruitDrawViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init(viewModel: FruitDrawViewModel) {
        self.viewModel = viewModel
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
        bind()
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

private extension FruitDrawViewController {
    func bind() {
        dismissButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        drawButton.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.startLottieAnimation()
                UIView.animate(
                    withDuration: 0.3,
                    delay: 0.5
                ) {
                    owner.showHideComponent(isHide: true)
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
            drawButton
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

        drawButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(56)
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
        startComponentAnimation()
    }
}

private extension FruitDrawViewController {
    func startLottieAnimation() {
        view.addSubview(lottieAnimationView)
        lottieAnimationView.snp.makeConstraints {
            $0.width.equalTo(275)
            $0.height.equalTo(200)
            $0.center.equalToSuperview()
        }
        lottieAnimationView.play { _ in
            self.input.endedLottieAnimation.onNext(())
        }
    }

    func startComponentAnimation() {
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
        drawButton.alpha = descriptioniLabel.alpha
    }
}
