import UIKit

@MainActor
public protocol KaraokeFactory {
    func makeViewController(ky: Int?, tj: Int?) -> UIViewController
}
