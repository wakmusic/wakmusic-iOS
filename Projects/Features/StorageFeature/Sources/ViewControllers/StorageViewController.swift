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
        
        bindRx()
    }
    
    private func bindRx() {
        
        Utility.PreferenceManager.$userInfo
            .map { $0 != nil }
            .subscribe(onNext: { [weak self] (isLogin) in
                guard let self = self else{
                    return
                }
                
                DEBUG_LOG(isLogin)

                if isLogin{
                    
                    if let _ = self.children.first as? LoginViewController {
                        self.remove(asChildViewController: self.bfLoginView)
                    }
                    
                    self.add(asChildViewController: self.afLoginView)
                    
                }else{
                    
                    if let _ = self.children.first as? AfterLoginViewController {
                        self.remove(asChildViewController: self.afLoginView)
                    }
 
                    self.add(asChildViewController:self.bfLoginView)
                }

            }).disposed(by: disposeBag)

    }
}
