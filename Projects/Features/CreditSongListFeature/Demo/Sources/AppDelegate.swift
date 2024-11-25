import BaseFeature
import BaseFeatureInterface
import CreditDomainTesting
@testable import CreditSongListFeature
import CreditSongListFeatureInterface
import Inject
import RxSwift
import SignInFeatureInterface
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let creditSongListTabFactory = FakeCreditSongListTabFactory()
        let reactor = CreditSongListReactor(
            workerName: "CLTH",
            fetchCreditProfileUseCase: FetchCreditProfileUseCaseSpy()
        )
        let viewController = CreditSongListViewController(
            reactor: reactor,
            creditSongListTabFactory: creditSongListTabFactory
        )
        window?.rootViewController = Inject.ViewControllerHost(viewController)
        window?.makeKeyAndVisible()

        return true
    }
}

final class FakeCreditSongListTabFactory: CreditSongListTabFactory {
    func makeViewController(workerName: String) -> UIViewController {
        let creditSongListTabItemFactory = FakeCreditSongListTabItemFactory()
        return CreditSongListTabViewController(
            workerName: workerName,
            creditSongListTabItemFactory: creditSongListTabItemFactory
        )
    }
}

final class FakeCreditSongListTabItemFactory: CreditSongListTabItemFactory {
    func makeViewController(workerName: String, sortType: CreditSongSortType) -> UIViewController {
        let fetchCreditSongListUseCase = FetchCreditSongListUseCaseSpy()
        fetchCreditSongListUseCase.handler = { _, _, _, _ in
            .just([
                .init(id: "6GQV6lhwgNs", title: "팬섭", artist: "세구", views: 100_000_000, date: "2024"),
                .init(id: "5qUwMpUWNLQ", title: "신시대", artist: "세구", views: 100_000_000, date: "2024"),
                .init(id: "5qUwMpUWNQ", title: "신시대", artist: "세구", views: 100_000_000, date: "2024"),
                .init(id: "5qUwMpUWLQ", title: "신시대", artist: "세구", views: 100_000_000, date: "2024"),
                .init(id: "5qUwMpUNLQ", title: "신시대", artist: "세구", views: 100_000_000, date: "2024"),
                .init(id: "5qUwMpWNLQ", title: "신시대", artist: "세구", views: 100_000_000, date: "2024"),
                .init(id: "5qUwMUWNLQ", title: "신시대", artist: "세구", views: 100_000_000, date: "2024"),
                .init(id: "5qUwpUWNLQ", title: "신시대", artist: "세구", views: 100_000_000, date: "2024"),
                .init(id: "5qUMpUWNLQ", title: "신시대", artist: "세구", views: 100_000_000, date: "2024"),
                .init(id: "5qwMpUWNLQ", title: "신시대", artist: "세구", views: 100_000_000, date: "2024"),
                .init(id: "5UwMpUWNLQ", title: "신시대", artist: "세구", views: 100_000_000, date: "2024"),
                .init(id: "qUwMpUWNLQ", title: "신시대", artist: "세구", views: 100_000_000, date: "2024"),
                .init(id: "UwMpUWNLQ", title: "신시대", artist: "세구", views: 100_000_000, date: "2024")
            ])
        }

        let reactor = CreditSongListTabItemReactor(
            workerName: workerName,
            creditSortType: sortType,
            songDetailPresenter: DummySongDetailPresenter(),
            fetchCreditSongListUseCase: fetchCreditSongListUseCase
        )
        return Inject.ViewControllerHost(
            CreditSongListTabItemViewController(
                reactor: reactor,
                containSongsFactory: DummyContainSongsFactory(),
                textPopupFactory: DummyTextPopupFactory(),
                signInFactory: DummySignInFactory()
            )
        )
    }
}

final class DummySongDetailPresenter: SongDetailPresentable, @unchecked Sendable {
    var presentSongDetailObservable: RxSwift.Observable<(ids: [String], selectedID: String)> {
        .empty()
    }

    func present(id: String) {}

    func present(ids: [String], selectedID: String) {}
}

final class DummyContainSongsFactory: ContainSongsFactory, @unchecked Sendable {
    func makeView(songs: [String]) -> UIViewController {
        let viewController = UIViewController()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            viewController.dismiss(animated: true)
        }
        return viewController
    }
}

final class DummySignInFactory: SignInFactory, @unchecked Sendable {
    func makeView() -> UIViewController {
        return UIViewController()
    }
}

final class DummyTextPopupFactory: TextPopupFactory, @unchecked Sendable {
    func makeView(
        text: String?,
        cancelButtonIsHidden: Bool,
        confirmButtonText: String?,
        cancelButtonText: String?,
        completion: (() -> Void)?,
        cancelCompletion: (() -> Void)?
    ) -> UIViewController {
        return UIViewController()
    }
}
