import Foundation
import UIKit

public protocol SearchResultFactory {
    func  makeView(type: TabPosition, dataSource: [Int]) -> UIViewController
}
