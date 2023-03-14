import UIKit
import CommonFeature
import Utility
import DesignSystem
import PanModal
import BaseFeature

public final class HomeViewController: BaseViewController, ViewControllerFromStoryBoard {

    var viewModel: HomeViewModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public static func viewController(viewModel: HomeViewModel) -> HomeViewController {
        let viewController = HomeViewController.viewController(storyBoardName: "Home", bundle: Bundle.module)
        viewController.viewModel = viewModel
        return viewController
    }
}


//        let recommendView = RecommendPlayListView(frame: CGRect(x: 0,
//                                                                y: 0,
//                                                                width: APP_WIDTH(),
//                                                                height: RecommendPlayListView.getViewHeight(model: dataSource)))
//        recommendView.dataSource = dataSource
//        recommendView.delegate = self

//extension HomeViewController: RecommendPlayListViewDelegate {
//    public func itemSelected(model: RecommendPlayListDTO) {
//        DEBUG_LOG(model)
//    }
//}
