import Foundation
import UIKit

@MainActor
public protocol HomeFactory {
    func makeView() -> UIViewController
}
