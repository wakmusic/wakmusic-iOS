import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import PlayListDomainInterface
import PlaylistFeatureInterface
import UIKit

public protocol PlayListDetailDependency: Dependency {
    var fetchPlayListDetailUseCase: any FetchPlayListDetailUseCase { get }

    var editPlayListUseCase: any EditPlayListUseCase { get }
    var removeSongsUseCase: any RemoveSongsUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }

    var multiPurposePopUpFactory: any MultiPurposePopUpFactory { get }
    var containSongsFactory: any ContainSongsFactory { get }

    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class PlayListDetailComponent: Component<PlayListDetailDependency>, PlaylistDetailFactory {
    public func makeView(id: String, isCustom: Bool) -> UIViewController {
        return PlayListDetailViewController.viewController(
            reactor: PlaylistDetailReactor(
                key: id,
                type: isCustom ? .custom : .wmRecommend,
                fetchPlayListDetailUseCase: dependency.fetchPlayListDetailUseCase,
                editPlayListUseCase: dependency.editPlayListUseCase,
                removeSongsUseCase: dependency.removeSongsUseCase,
                logoutUseCase: dependency.logoutUseCase
            ),
            multiPurposePopUpFactory: dependency.multiPurposePopUpFactory,
            containSongsFactory: dependency.containSongsFactory,
            textPopUpFactory: dependency.textPopUpFactory
        )
    }
}
