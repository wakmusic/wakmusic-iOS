import UIKit

@MainActor
public protocol PlaylistCoverOptionPopupDelegate: AnyObject {
    func didTap(_ index: Int, _ price: Int)
}

@MainActor
public protocol PlaylistCoverOptionPopupFactory {
    func makeView(delegate: any PlaylistCoverOptionPopupDelegate) -> UIViewController
}
