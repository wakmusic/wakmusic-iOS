import UIKit

public protocol KaraokeFactory {
    func makeViewController(tj: Int?, ky: Int?) -> UIViewController
}
