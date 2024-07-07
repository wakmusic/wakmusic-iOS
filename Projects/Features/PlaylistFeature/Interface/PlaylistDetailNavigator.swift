import Foundation
import UIKit

public protocol PlaylistDetailNavigator {
    var playlistDetailFactory: any PlaylistDetailFactory { get }

    func navigatePlaylistDetail(key: String, isMine: Bool)
}

public extension PlaylistDetailNavigator where Self: UIViewController {
    func navigatePlaylistDetail(key: String, isMine: Bool) {
        let dest = playlistDetailFactory.makeView(key: key, isMine: isMine)

        self.navigationController?.pushViewController(dest, animated: true)
    }
}
