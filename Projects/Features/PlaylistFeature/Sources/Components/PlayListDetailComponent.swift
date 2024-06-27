import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import PlaylistDomainInterface
import PlaylistFeatureInterface
import UIKit

public protocol PlaylistDetailDependency: Dependency {
    var fetchPlaylistDetailUseCase: any FetchPlaylistDetailUseCase { get }

    var updatePlaylistUseCase: any UpdatePlaylistUseCase { get }
    var removeSongsUseCase: any RemoveSongsUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }

    var multiPurposePopUpFactory: any MultiPurposePopupFactory { get }
    var containSongsFactory: any ContainSongsFactory { get }

    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class PlaylistDetailComponent: Component<PlaylistDetailDependency>, PlaylistDetailFactory {
    public func makeView(id: String, isCustom: Bool) -> UIViewController {
        return UIViewController()
    }
}
