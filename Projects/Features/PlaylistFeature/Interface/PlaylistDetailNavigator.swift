import Foundation
import UIKit

public protocol PlaylistDetailNavigator {
    var playlistDetailFactory: any PlaylistDetailFactory { get }

    func navigatePlaylistDetail(key: String, ownerId: String)
    
    func navigatePlaylistDetail(key: String)
}

public extension PlaylistDetailNavigator where Self: UIViewController {
    func navigatePlaylistDetail(key: String, ownerId: String) {
        let dest = playlistDetailFactory.makeView(key: key, ownerId: ownerId)

        self.navigationController?.pushViewController(dest, animated: true)
    }
    
    func navigatePlaylistDetail(key: String) {
        let dest = playlistDetailFactory.makeView(key: key)

        self.navigationController?.pushViewController(dest, animated: true)
    }
}
