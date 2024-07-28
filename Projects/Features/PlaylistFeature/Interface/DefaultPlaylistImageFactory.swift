import UIKit

public protocol DefaultPlaylistCoverDelegate: AnyObject {
    func receive(url: String, imageName: String)
}

public protocol DefaultPlaylistCoverFactory {
    func makeView(_ delegate: any DefaultPlaylistCoverDelegate) -> UIViewController
}
