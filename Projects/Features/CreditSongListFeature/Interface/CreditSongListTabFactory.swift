import UIKit

@MainActor
public protocol CreditSongListTabFactory {
    func makeViewController(workerName: String) -> UIViewController
}
