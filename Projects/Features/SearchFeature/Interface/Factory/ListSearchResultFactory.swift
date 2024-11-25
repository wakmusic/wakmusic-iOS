import UIKit

@MainActor
public protocol ListSearchResultFactory {
    func makeView(_ text: String) -> UIViewController
}
