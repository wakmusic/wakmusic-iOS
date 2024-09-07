import UIKit

public protocol CheckPlaylistCoverDelegate: AnyObject {
    func receive(_ imageData: Data)
}

public protocol CheckPlaylistCoverFactory {
    func makeView(delegate: any CheckPlaylistCoverDelegate, imageData: Data) -> UIViewController
}
