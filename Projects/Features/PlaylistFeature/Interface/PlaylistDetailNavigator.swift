import Foundation
import UIKit

public protocol PlaylistDetailNavigator {
    var playlistDetailFactory: any PlaylistDetailFactory { get }

    func navigatePlaylistDetail(key: String, kind: PlaylistDetailKind)
}

public extension PlaylistDetailNavigator where Self: UIViewController {
    func navigatePlaylistDetail(key: String, kind: PlaylistDetailKind) {
        let dest = playlistDetailFactory.makeView(key: key, kind: kind)

        self.navigationController?.pushViewController(dest, animated: true)
    }
}
