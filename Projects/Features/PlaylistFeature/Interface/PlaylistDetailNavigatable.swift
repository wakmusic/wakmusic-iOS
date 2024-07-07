import Foundation
import UIKit

public protocol PlaylistDetailNavigatable {
    var playlistDetailFactory: any PlaylistDetailFactory { get }

    func navigatePlaylistDetail(key: String, isMine: Bool)
}

public extension PlaylistDetailNavigatable where Self: UIViewController {
    func navigatePlaylistDetail(key: String, isMine: Bool) {
        let dest = playlistDetailFactory.makeView(key: key, isMine: isMine)

        self.navigationController?.pushViewController(dest, animated: true)
    }
}
