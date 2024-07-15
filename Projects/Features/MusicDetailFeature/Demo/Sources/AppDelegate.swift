import Inject
@testable import MusicDetailFeature
import UIKit
import Utility

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

//        let playListModel = PlaylistModel(
//            key: "key",
//            title: "플리1",
//            isPrivate: false,
//            imageURL: "https://google.com",
//            songs: [
//                .init(
//                    videoID: "fgSXAKsq-Vo",
//                    title: "리와인드",
//                    artistString: "이세계아이돌",
//                    date: "2024.10.10",
//                    likes: 1_000_000,
//                    isLiked: true,
//                    karaokeNumber: .init(tj: 0, ky: 0)
//                ),
//                .init(
//                    videoID: "DPEtmqvaKqY",
//                    title: "팬서비스",
//                    artistString: "고세구",
//                    date: "2024.10.10",
//                    likes: 1_000_000,
//                    isLiked: true,
//                    karaokeNumber: .init(tj: 0, ky: 0)
//                ),
//                .init(
//                    videoID: "KQa297hRop0",
//                    title: "UP!",
//                    artistString: "징버거",
//                    date: "2024.10.10",
//                    likes: 1_000_000,
//                    isLiked: false,
//                    karaokeNumber: .init(tj: 0, ky: 0)
//                ),
//                .init(
//                    videoID: "qZi1Xh0_8q4",
//                    title: "긍지높은 아이돌",
//                    artistString: "고세구",
//                    date: "2024.10.10",
//                    likes: 1_000_000,
//                    isLiked: true,
//                    karaokeNumber: .init(tj: 0, ky: 0)
//                )
//            ],
//            createdAt: 0,
//            modifiedAt: 0
//        )
//        let reactor = MusicDetailReactor(
//            playlist: playListModel,
//            selectedIndex: 0
//        )
        
        let karaokeModel = PlaylistModel.SongModel.KaraokeNumber(tj: 84250, ky: 84250)
        
        var rootVc = UIViewController()
        
        var button: UIButton = UIButton().then {
            $0.backgroundColor = .red
        }
        
        let vc = KaraokeViewController(karaoke: karaokeModel)
        
        rootVc.view.addSubview(button)
        
        
        
        button.addAction {
            vc.showBottomSheet(content: vc, size: .fixed(268 + SAFEAREA_BOTTOM_HEIGHT() ))
        }
        
   
        let viewController = Inject.ViewControllerHost(
            UINavigationController(rootViewController: rootVc)
        )
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}
