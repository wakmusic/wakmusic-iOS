import BaseFeatureInterface
import DesignSystem
import Lottie
import MainTabFeature
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

open class IntroViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var logoContentView: UIView!
    private let parableLogoImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Logo.splashParable.image
        $0.contentMode = .scaleAspectFit
    }

    private var mainContainerComponent: MainContainerComponent!
    private var permissionComponent: PermissionComponent!
    private var textPopupFactory: TextPopupFactory!

    private var viewModel: IntroViewModel!
    lazy var input = IntroViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    private let disposeBag = DisposeBag()

    override open func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        outputBind()
        inputBind()
    }

    public static func viewController(
        mainContainerComponent: MainContainerComponent,
        permissionComponent: PermissionComponent,
        textPopupFactory: TextPopupFactory,
        viewModel: IntroViewModel
    ) -> IntroViewController {
        let viewController = IntroViewController.viewController(storyBoardName: "Intro", bundle: Bundle.module)
        viewController.mainContainerComponent = mainContainerComponent
        viewController.permissionComponent = permissionComponent
        viewController.textPopupFactory = textPopupFactory
        viewController.viewModel = viewModel
        return viewController
    }
}

private extension IntroViewController {
    func inputBind() {
        input.fetchPermissionCheck.onNext(())
    }

    func outputBind() {
        permissionBind()
        appInfoBind()
        userInfoAndLottieEndedBind()
    }
}

private extension IntroViewController {
    func permissionBind() {
        output.confirmedPermission
            .do(onNext: { [weak self] permission in
                guard let self = self else { return }
                let show: Bool = !(permission ?? false)
                guard show else { return }
                let permission = self.permissionComponent.makeView()
                permission.modalTransitionStyle = .crossDissolve
                permission.modalPresentationStyle = .overFullScreen
                self.present(permission, animated: true)
            })
            .filter { return ($0 ?? false) == true }
            .map { _ in () }
            .bind(to: input.fetchAppCheck)
            .disposed(by: disposeBag)
    }

    func appInfoBind() {
        output.confirmedAppInfo
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case let .success(entity):
                    owner.lottiePlay(isSpecialLogo: entity.isSpecialLogo)

                    var textPopupVc: UIViewController
                    let updateTitle: String = "왁타버스 뮤직이 업데이트 되었습니다."
                    let updateMessage: String = "최신 버전으로 업데이트 후 이용하시기 바랍니다.\n감사합니다."

                    switch entity.flag {
                    case .normal:
                        owner.input.checkUserInfoPreference.onNext(())
                        return

                    case .offline:
                        owner.showBottomSheet(
                            content: owner.textPopupFactory.makeView(
                                text: entity.description,
                                cancelButtonIsHidden: true,
                                confirmButtonText: "재시도",
                                cancelButtonText: nil,
                                completion: {
                                    owner.input.fetchAppCheck.onNext(())
                                },
                                cancelCompletion: nil
                            ),
                            dismissOnOverlayTapAndPull: false
                        )
                        return

                    case .event:
                        textPopupVc = owner.textPopupFactory.makeView(
                            text: "\(entity.title)\(entity.description.isEmpty ? "" : "\n")\(entity.description)",
                            cancelButtonIsHidden: true,
                            confirmButtonText: nil,
                            cancelButtonText: nil,
                            completion: {
                                exit(0)
                            },
                            cancelCompletion: nil
                        )

                    case .update:
                        textPopupVc = owner.textPopupFactory.makeView(
                            text: "\(updateTitle)\n\(updateMessage)",
                            cancelButtonIsHidden: false,
                            confirmButtonText: "업데이트",
                            cancelButtonText: "나중에",
                            completion: {
                                owner.goAppStore()
                            },
                            cancelCompletion: {
                                owner.input.checkUserInfoPreference.onNext(())
                            }
                        )

                    case .forceUpdate:
                        textPopupVc = owner.textPopupFactory.makeView(
                            text: "\(updateTitle)\n\(updateMessage)",
                            cancelButtonIsHidden: true,
                            confirmButtonText: "업데이트",
                            cancelButtonText: nil,
                            completion: {
                                owner.goAppStore()
                            },
                            cancelCompletion: nil
                        )
                    }

                    owner.showBottomSheet(
                        content: textPopupVc,
                        dismissOnOverlayTapAndPull: false
                    )

                case let .failure(error):
                    owner.lottiePlay(isSpecialLogo: false)
                    owner.showBottomSheet(
                        content: owner.textPopupFactory.makeView(
                            text: error.asWMError.errorDescription ?? "",
                            cancelButtonIsHidden: true,
                            confirmButtonText: "재시도",
                            cancelButtonText: nil,
                            completion: {
                                owner.input.fetchAppCheck.onNext(())
                            },
                            cancelCompletion: nil
                        ),
                        dismissOnOverlayTapAndPull: false
                    )
                }
            })
            .disposed(by: disposeBag)
    }

    func userInfoAndLottieEndedBind() {
        Observable.zip(
            output.confirmedUserInfoPreference,
            output.endedLottieAnimation
        ) { result, _ -> Result<Void, Error> in
            return result
        }
        .withUnretained(self)
        .subscribe(onNext: { owner, result in
            switch result {
            case let .success(suc):
                DEBUG_LOG("success: \(suc)✅✅")
                owner.showTabBar()

            case let .failure(error):
                owner.showBottomSheet(
                    content: owner.textPopupFactory.makeView(
                        text: error.asWMError.errorDescription ?? error.localizedDescription,
                        cancelButtonIsHidden: true,
                        confirmButtonText: nil,
                        cancelButtonText: nil,
                        completion: {
                            owner.showTabBar()
                        },
                        cancelCompletion: nil
                    ),
                    dismissOnOverlayTapAndPull: false
                )
            }
        })
        .disposed(by: disposeBag)
    }
}

private extension IntroViewController {
    func configureUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubview(parableLogoImageView)
        parableLogoImageView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
            $0.centerX.equalToSuperview()
        }
    }

    func showTabBar() {
        let viewController = mainContainerComponent.makeView()
        self.navigationController?.pushViewController(viewController, animated: false)
    }

    func lottiePlay(isSpecialLogo: Bool) {
        var logoType: SplashLogoType

        if isSpecialLogo {
            switch Calendar.current.component(.month, from: Date()) {
            case 10:
                logoType = .halloween
            case 12:
                logoType = .xmas
            default:
                logoType = .usual
            }
        } else {
            logoType = .usual
        }

        changeAppIcon(logoType)
        self.view.backgroundColor = logoType == .halloween ? colorFromRGB(0x191A1C) : .white

        let animationView = LottieAnimationView(
            name: logoType.rawValue,
            bundle: DesignSystemResources.bundle
        )
        animationView.frame = self.logoContentView.bounds
        animationView.backgroundColor = .clear
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .playOnce
        animationView.clipsToBounds = false

        self.logoContentView.subviews.forEach { $0.removeFromSuperview() }
        self.logoContentView.addSubview(animationView)

        let originWidth: CGFloat = 156.0
        let originHeight: CGFloat = 160.0
        let rate: CGFloat = originHeight / max(1.0, originWidth)

        let width: CGFloat = (156.0 * APP_WIDTH()) / 375.0
        let height: CGFloat = width * rate

        animationView.snp.makeConstraints {
            $0.width.equalTo(width)
            $0.height.equalTo(height)
            $0.centerX.equalTo(self.logoContentView.snp.centerX)
            $0.centerY.equalTo(self.logoContentView.snp.centerY)
        }

        animationView.play { _ in
            self.output.endedLottieAnimation.onNext(())
        }
    }
}
