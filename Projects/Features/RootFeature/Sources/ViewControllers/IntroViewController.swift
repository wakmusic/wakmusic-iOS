import UIKit
import Utility
import DesignSystem
import BaseFeature
import MainTabFeature
import CommonFeature
import Lottie
import RxSwift

open class IntroViewController: BaseViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var logoContentView: UIView!

    var mainContainerComponent: MainContainerComponent!
    var permissionComponent: PermissionComponent!

    private var viewModel: IntroViewModel!
    lazy var input = IntroViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    var disposeBag = DisposeBag()

    open override func viewDidLoad() {
        super.viewDidLoad()
        outputBind()
        inputBind()
    }
    
    public static func viewController(
        mainContainerComponent: MainContainerComponent,
        permissionComponent: PermissionComponent,
        viewModel: IntroViewModel
    ) -> IntroViewController {
        let viewController = IntroViewController.viewController(storyBoardName: "Intro", bundle: Bundle.module)
        viewController.mainContainerComponent = mainContainerComponent
        viewController.permissionComponent = permissionComponent
        viewController.viewModel = viewModel
        return viewController
    }
}

extension IntroViewController {
    private func inputBind() {
        input.fetchPermissionCheck.onNext(())
    }
    
    private func outputBind() {
        output.permissionResult
            .do(onNext: { [weak self] (permission) in
                guard let self = self else { return }
                let show: Bool = !(permission ?? false)
                guard show else { return }
                let permission = self.permissionComponent.makeView()
                permission.modalTransitionStyle = .crossDissolve
                permission.modalPresentationStyle = .overFullScreen
                self.present(permission, animated: true)
            })
            .filter { return ($0 ?? false) == true }
            .do(onNext: { [weak self] (_) in
                guard let self = self else { return }
                self.lottiePlay()
                self.input.startLottieAnimation.onNext(())
            })
            .map{ _ in () }
            .bind(to: input.fetchAppCheck)
            .disposed(by: disposeBag)
                
        output.appInfoResult
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case let .success(entity):
                    var textPopupVc: TextPopupViewController
                    let updateTitle: String = "왁타버스 뮤직이 업데이트 되었습니다."
                    let updateMessage: String = "최신 버전으로 업데이트 후 이용하시기 바랍니다.\n감사합니다."

                    switch entity.flag {
                    case .normal:
                        owner.input.fetchUserInfoCheck.onNext(())
                        return

                    case .event:
                        textPopupVc = TextPopupViewController.viewController(
                            text:"\(entity.title)\n\(entity.description)",
                            cancelButtonIsHidden: true,
                            allowsDragAndTapToDismiss: false,
                            completion: {
                                exit(0)
                            }
                        )

                    case .update:
                        textPopupVc = TextPopupViewController.viewController(
                            text:"\(updateTitle)\n\(updateMessage)",
                            cancelButtonIsHidden: false,
                            allowsDragAndTapToDismiss: false,
                            confirmButtonText: "업데이트",
                            cancelButtonText: "나중에",
                            completion: {
                                owner.goAppStore()
                            },
                            cancelCompletion: {
                                owner.input.fetchUserInfoCheck.onNext(())
                            }
                        )

                    case .forceUpdate:
                        textPopupVc = TextPopupViewController.viewController(
                            text:"\(updateTitle)\n\(updateMessage)",
                            cancelButtonIsHidden: true,
                            allowsDragAndTapToDismiss: false,
                            confirmButtonText: "업데이트",
                            completion: {
                                owner.goAppStore()
                            }
                        )
                    }
                    owner.showPanModal(content: textPopupVc)

                case let .failure(error):
                    owner.showPanModal(
                        content: TextPopupViewController.viewController(
                            text: error.asWMError.errorDescription ?? "",
                            cancelButtonIsHidden: true,
                            allowsDragAndTapToDismiss: false
                        )
                    )
                }
            })
            .disposed(by: disposeBag)
        
        Observable.zip(
            output.userInfoResult,
            output.endLottieAnimation
        ) { (result, _) -> Result<String, Error> in
            return result
        }
        .withUnretained(self)
        .subscribe(onNext: { (owner, result) in
            switch result{
            case .success(_):
                owner.showTabBar()
                
            case .failure(let error):
                owner.showPanModal(
                    content: TextPopupViewController.viewController(
                        text: error.asWMError.errorDescription ?? "",
                        cancelButtonIsHidden: true,
                        allowsDragAndTapToDismiss: false,
                        completion: { () in
                            owner.showTabBar()
                        }
                    )
                )
            }
        })
        .disposed(by: disposeBag)
    }
}

extension IntroViewController {
    private func showTabBar() {
        let viewController = mainContainerComponent!.makeView()
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    private func lottiePlay() {
        let animationView = LottieAnimationView(name: "Splash_Logo_Main", bundle: DesignSystemResources.bundle)
        animationView.frame = self.logoContentView.bounds
        animationView.backgroundColor = .clear
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .playOnce

        self.logoContentView.addSubview(animationView)
        
        let originWidth: CGFloat = 156.0
        let originHeight: CGFloat = 160.0
        let rate: CGFloat = originHeight/max(1.0, originWidth)

        let width: CGFloat = (156.0 * APP_WIDTH()) / 375.0
        let height: CGFloat = width * rate

        animationView.snp.makeConstraints {
            $0.width.equalTo(width)
            $0.height.equalTo(height)
            $0.centerX.equalTo(self.logoContentView.snp.centerX)
            $0.centerY.equalTo(self.logoContentView.snp.centerY)
        }
        animationView.play()
    }
}
