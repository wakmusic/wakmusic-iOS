import Foundation
@testable import MyInfoFeature
import MyInfoFeatureInterface
import UIKit

public final class FaqContentComponentStub: FaqContentFactory {
    public func makeView(dataSource: [FaqModel]) -> UIViewController {
        return FaqContentViewController.viewController(viewModel: .init(dataSource: dataSource))
    }
}
