import UIKit

@MainActor
public protocol CreditSongListFactory {
    func makeViewController(workerName: String) -> UIViewController
}
