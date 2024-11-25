import Foundation
import UIKit

@MainActor
public protocol PlaylistDetailNavigator {
    var playlistDetailFactory: any PlaylistDetailFactory { get }

    func navigateWMPlaylistDetail(key: String)

    func navigatePlaylistDetail(key: String)
}

public extension PlaylistDetailNavigator where Self: UIViewController {
    @MainActor
    func navigateWMPlaylistDetail(key: String) {
        let dest = playlistDetailFactory.makeWmView(key: key)

        self.navigationController?.pushViewController(dest, animated: true)
    }

    @MainActor
    func navigatePlaylistDetail(key: String) {
        let dest = playlistDetailFactory.makeView(key: key)

        self.navigationController?.pushViewController(dest, animated: true)
    }
}
