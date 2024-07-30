import UIKit

public protocol CreditSongListTabFactory {
    func makeViewController(workerName: String) -> UIViewController
}
