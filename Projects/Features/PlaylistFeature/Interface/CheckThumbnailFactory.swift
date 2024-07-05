import UIKit

public protocol CheckThumbnailDelegate: AnyObject {
    func receive(_ imageData: Data)
}

public protocol CheckThumbnailFactory {
    func makeView(delegate: any CheckThumbnailDelegate, imageData: Data) -> UIViewController
}
