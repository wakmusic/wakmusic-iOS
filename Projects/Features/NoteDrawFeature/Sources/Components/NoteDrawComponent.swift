import Foundation
import NeedleFoundation
import NoteDrawFeatureInterface
import UIKit

public protocol NoteDrawDependency: Dependency {}

public final class NoteDrawComponent: Component<NoteDrawDependency>, NoteDrawFactory {
    public func makeView() -> UIViewController {
        return NoteDrawViewController()
    }
}
