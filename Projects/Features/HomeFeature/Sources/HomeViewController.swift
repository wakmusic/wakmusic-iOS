import UIKit
import Utility
import DesignSystem
import PanModal

public final class HomeViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var tempView: UIView!
    @IBOutlet weak var gradationImageView: UIImageView! {
        didSet {
            gradationImageView.image = DesignSystemAsset.Home.gradationBg.image
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        configurePlayList()
    }

    public static func viewController() -> HomeViewController {
        let viewController = HomeViewController.viewController(storyBoardName: "Home", bundle: Bundle.module)
        return viewController
    }

    @IBAction func buttonAction(_ sender: Any) {
        let textPopupViewController = TextPopupViewController.viewController(
            text: "한 줄\n두 줄",
            cancelButtonIsHidden: false
        )
        let viewController: PanModalPresentable.LayoutType = textPopupViewController
        self.presentPanModal(viewController)
    }
}

extension HomeViewController {
    private func configurePlayList() {
        
        let dataSource = [RecommendPlayListDTO(title: "고멤가요제", image: DesignSystemAsset.RecommendPlayList.gomemSongFestival.image),
                          RecommendPlayListDTO(title: "연말공모전", image: DesignSystemAsset.RecommendPlayList.competition.image),
                          RecommendPlayListDTO(title: "상콘 OST", image: DesignSystemAsset.RecommendPlayList.situationalplayOST.image),
                          RecommendPlayListDTO(title: "힙합 SWAG", image: DesignSystemAsset.RecommendPlayList.hiphop.image),
                          RecommendPlayListDTO(title: "캐롤", image: DesignSystemAsset.RecommendPlayList.carol.image),
                          RecommendPlayListDTO(title: "노동요", image: DesignSystemAsset.RecommendPlayList.workSong.image)]
        
        let recommendView = RecommendPlayListView(frame: CGRect(x: 0,
                                                                y: 0,
                                                                width: APP_WIDTH(),
                                                                height: RecommendPlayListView.getViewHeight(model: dataSource)))
        recommendView.dataSource = dataSource
        recommendView.delegate = self
        self.tempView.addSubview(recommendView)
    }
}

extension HomeViewController: RecommendPlayListViewDelegate {
    public func itemSelected(model: RecommendPlayListDTO) {
        DEBUG_LOG(model)
    }
}
