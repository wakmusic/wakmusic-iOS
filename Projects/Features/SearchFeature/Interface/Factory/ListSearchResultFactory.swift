import UIKit

public protocol ListSearchResultFactory {
    func makeView(_ text: String) -> UIViewController
}
