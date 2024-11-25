import UIKit

public protocol CheckPlaylistCoverDelegate: AnyObject {
    func receive(_ imageData: Data)
}

@MainActor
public protocol CheckPlaylistCoverFactory {
    func makeView(delegate: any CheckPlaylistCoverDelegate, imageData: Data) -> UIViewController
}
