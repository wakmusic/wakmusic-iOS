import UIKit
import CommonFeature
import Utility
import DesignSystem
import PanModal
import BaseFeature

public final class HomeViewController: BaseViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var tempView: UIView!
    @IBOutlet weak var gradationImageView: UIImageView! {
        didSet {
            gradationImageView.image = DesignSystemAsset.Home.gradationBg.image
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configurePlayList()
    }

    public static func viewController() -> HomeViewController {
        let viewController = HomeViewController.viewController(storyBoardName: "Home", bundle: Bundle.module)
        return viewController
    }

    @IBAction func buttonAction(_ sender: Any) {
        self.showPanModal(content: NoticePopupViewController())
    }
}

extension HomeViewController {
    private func configurePlayList() {
        
//        let dataSource = [RecommendPlayListDTO(title: "고멤가요제", image: DesignSystemAsset.RecommendPlayList.gomemSongFestival.image),
//                          RecommendPlayListDTO(title: "연말공모전", image: DesignSystemAsset.RecommendPlayList.competition.image),
//                          RecommendPlayListDTO(title: "상콘 OST", image: DesignSystemAsset.RecommendPlayList.situationalplayOST.image),
//                          RecommendPlayListDTO(title: "힙합 SWAG", image: DesignSystemAsset.RecommendPlayList.hiphop.image),
//                          RecommendPlayListDTO(title: "캐롤", image: DesignSystemAsset.RecommendPlayList.carol.image),
//                          RecommendPlayListDTO(title: "노동요", image: DesignSystemAsset.RecommendPlayList.workSong.image)]
//
//
//        let recommendView = RecommendPlayListView(frame: CGRect(x: 0,
//                                                                y: 0,
//                                                                width: APP_WIDTH(),
//                                                                height: RecommendPlayListView.getViewHeight(model: dataSource)))
//        recommendView.dataSource = dataSource
//        recommendView.delegate = self
//        self.tempView.addSubview(recommendView)
    }
}

//extension HomeViewController: RecommendPlayListViewDelegate {
//    public func itemSelected(model: RecommendPlayListDTO) {
//        DEBUG_LOG(model)
//    }
//}
