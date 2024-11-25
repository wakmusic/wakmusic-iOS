import UIKit

public protocol DefaultPlaylistCoverDelegate: AnyObject {
    func receive(url: String, imageName: String)
}

@MainActor
public protocol DefaultPlaylistCoverFactory {
    func makeView(_ delegate: any DefaultPlaylistCoverDelegate) -> UIViewController
}
