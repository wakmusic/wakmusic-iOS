import Foundation
import FaqDomainInterface
@testable import MyInfoFeature
import MyInfoFeatureInterface
import UIKit

public final class FaqContentComponentStub: FaqContentFactory {
    public func makeView(dataSource: [FaqEntity]) -> UIViewController {
        return FaqContentViewController.viewController(viewModel: .init(dataSource: dataSource))
    }
}
