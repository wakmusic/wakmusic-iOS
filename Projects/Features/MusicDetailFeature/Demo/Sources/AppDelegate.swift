import Inject
@testable import MusicDetailFeature
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let playListModel = PlaylistModel(
            key: "key",
            title: "플리1",
            isPrivate: false,
            imageURL: "https://google.com",
            songs: [
                .init(
                    videoID: "fgSXAKsq-Vo",
                    title: "리와인드",
                    artists: ["이세계아이돌"],
                    date: 0,
                    start: 0,
                    end: 0,
                    likes: 1_000_000,
                    isLiked: true
                ),
                .init(
                    videoID: "DPEtmqvaKqY",
                    title: "팬서비스",
                    artists: ["고세구"],
                    date: 1,
                    start: 1,
                    end: 1,
                    likes: 1_000_000,
                    isLiked: true
                ),
                .init(
                    videoID: "KQa297hRop0",
                    title: "UP!",
                    artists: ["징버거"],
                    date: 1,
                    start: 1,
                    end: 1,
                    likes: 1_000_000,
                    isLiked: false
                ),
                .init(
                    videoID: "qZi1Xh0_8q4",
                    title: "긍지높은 아이돌",
                    artists: ["고세구"],
                    date: 1,
                    start: 1,
                    end: 1,
                    likes: 1_000_000,
                    isLiked: true
                )
            ],
            createdAt: 0,
            modifiedAt: 0
        )
        let reactor = MusicDetailReactor(
            playlist: playListModel,
            selectedIndex: 0
        )
        let viewController = Inject.ViewControllerHost(
            UINavigationController(rootViewController: MusicDetailViewController(reactor: reactor))
        )
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}
