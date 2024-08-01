import Foundation
import UIKit

public protocol PlaylistDetailNavigator {
    var playlistDetailFactory: any PlaylistDetailFactory { get }

    func navigateWmPlaylistDetail(key: String)

    func navigatePlaylistDetail(key: String)
}

public extension PlaylistDetailNavigator where Self: UIViewController {
    func navigateWmPlaylistDetail(key: String) {
        let dest = playlistDetailFactory.makeWmView(key: key)

        self.navigationController?.pushViewController(dest, animated: true)
    }

    func navigatePlaylistDetail(key: String) {
        let dest = playlistDetailFactory.makeView(key: key)

        self.navigationController?.pushViewController(dest, animated: true)
    }
}
