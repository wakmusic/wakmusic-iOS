import UIKit

public protocol PlaylistCoverOptionPopupDelegate: AnyObject {
    func didTap(_ index: Int, _ price: Int)
}

public protocol PlaylistCoverOptionPopupFactory {
    func makeView(delegate: any PlaylistCoverOptionPopupDelegate) -> UIViewController
}
