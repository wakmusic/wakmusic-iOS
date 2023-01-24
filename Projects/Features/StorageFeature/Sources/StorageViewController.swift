import UIKit
import Utility
import DesignSystem
import RxCocoa
import RxRelay
import RxSwift

public final class StorageViewController: UIViewController, ViewControllerFromStoryBoard,ContainerViewType {
    
    @IBOutlet weak public var contentView: UIView!
    
    var isLogin:BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    lazy var bfLoginView = BeforeLoginStorageViewController.viewController()
    let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    
        
        configureUI()
        
    }

    public static func viewController() -> StorageViewController {
        let viewController = StorageViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        return viewController
    }
}


extension StorageViewController{
    
    private func configureUI() {
    
        self.view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        
        
        bindSubView()
    }
    
    private func bindSubView()
    {
        
        isLogin.subscribe { [weak self] (login:Bool) in
            
            guard let self = self else{
                return
            }
            
            if(login)
            {
                
            }
            else
            {
                print("HELLo")
                self.add(asChildViewController:self.bfLoginView)
            }
            
            
            
        }.disposed(by: disposeBag)
        
        
    }
    
}
