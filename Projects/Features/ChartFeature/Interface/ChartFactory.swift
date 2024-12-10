import UIKit

@MainActor
public protocol ChartFactory {
    func makeView() -> UIViewController
}
