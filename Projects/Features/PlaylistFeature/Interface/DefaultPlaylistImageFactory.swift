import UIKit

public protocol DefaultPlaylistImageDelegate: AnyObject {
    func receive(url: String)
}

public protocol DefaultPlaylistImageFactory {
    func makeView(_ delegate: any DefaultPlaylistImageDelegate) -> UIViewController
}
