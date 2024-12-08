import UIKit

@MainActor
public protocol LyricHighlightingFactory {
    func makeView(model: LyricHighlightingRequiredModel) -> UIViewController
}
