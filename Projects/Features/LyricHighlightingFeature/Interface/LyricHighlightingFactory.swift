import UIKit

public protocol LyricHighlightingFactory {
    func makeView(model: LyricHighlightingRequiredModel) -> UIViewController
}
