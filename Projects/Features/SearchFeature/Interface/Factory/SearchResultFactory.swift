import Foundation
import UIKit

public protocol SearchResultFactory {
    func makeIntegratedView(type: TabPosition, dataSource: [Int]) -> UIViewController
    func makeSingleView(type: TabPosition, dataSource: [Int]) -> UIViewController
}
