import UIKit
import SignInFeature
import Utility
import DesignSystem
import RxCocoa
import RxRelay
import RxSwift
import BaseFeature
import KeychainModule

public final class StorageViewController: BaseViewController, ViewControllerFromStoryBoard,ContainerViewType {
    
    @IBOutlet weak public var contentView: UIView!

    var signInComponent:SignInComponent!
    var afterLoginComponent:AfterLoginComponent!
    
    lazy var bfLoginView = signInComponent.makeView()
    lazy var afLoginView = afterLoginComponent.makeView()
    let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    
        configureUI()
        bindRx()
    }

    public static func viewController(signInComponent:SignInComponent,afterLoginComponent:AfterLoginComponent) -> StorageViewController {
        let viewController = StorageViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        
        viewController.signInComponent = signInComponent
        viewController.afterLoginComponent = afterLoginComponent
        
        return viewController
    }
}

extension StorageViewController{
    
    private func configureUI() {
    }
    
    private func bindRx() {
        
        Utility.PreferenceManager.$userInfo
            .debug("$userInfo")
            .subscribe(onNext: { [weak self] (model) in
                guard let self = self else{
                    return
                }
                let isLogin: Bool = model != nil

                if isLogin{
                    self.remove(asChildViewController: self.bfLoginView)
                    self.add(asChildViewController: self.afLoginView)
                    
                }else{
                    self.remove(asChildViewController: self.afLoginView)
                    self.add(asChildViewController:self.bfLoginView)
                }

            }).disposed(by: disposeBag)

    }
}
