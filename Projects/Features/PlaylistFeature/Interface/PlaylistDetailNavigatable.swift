import Foundation
import UIKit

public protocol PlaylistDetailNavigatable {
    var unknownPlaylistDetailFactory: any UnknownPlaylistDetailFactory { get }
    var myPlaylistDetailFactory: any MyPlaylistDetailFactory { get }

    func navigatePlaylistDetail(playlistKey: String, isMine: Bool)
}

public extension PlaylistDetailNavigatable where Self: UIViewController {
    func navigatePlaylistDetail(playlistKey: String, isMine: Bool) {
        let dest = isMine ? myPlaylistDetailFactory.makeView(key: playlistKey) : unknownPlaylistDetailFactory
            .makeView(key: playlistKey)

        self.navigationController?.pushViewController(dest, animated: true)
    }
}
