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
        inputBind()
        outputBind()
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
            .debug("Permission2")
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
            })
            .delay(RxTimeInterval.milliseconds(1200), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _  in
                guard let `self` = self else { return }
                
            }).disposed(by: disposeBag)
        
        // 앱 종료 exit(0)
//                if message.isEmpty {
//                    self.showTabBar()
//
//                }else{
//                    self.showPanModal(content: TextPopupViewController.viewController(
//                        text: message,
//                        cancelButtonIsHidden: true,
//                        allowsDragAndTapToDismiss: false,
//                        completion: { [weak self] () in
//                            guard let `self` = self else { return }
//                            self.showTabBar()
//                        })
//                    )
//                }

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
