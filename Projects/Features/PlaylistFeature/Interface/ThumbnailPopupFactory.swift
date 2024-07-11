import UIKit

public protocol ThumbnailPopupDelegate: AnyObject {
    func didTap(_ index: Int, _ cost: Int)
}

public protocol ThumbnailPopupFactory {
    func makeView(delegate: any ThumbnailPopupDelegate) -> UIViewController
}
