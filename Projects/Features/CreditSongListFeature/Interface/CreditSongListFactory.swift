import UIKit

public protocol CreditSongListFactory {
    func makeViewController(workerName: String) -> UIViewController
}
