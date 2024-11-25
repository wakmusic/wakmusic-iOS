import UIKit

@MainActor
public protocol SongCreditFactory {
    func makeViewController(songID: String) -> UIViewController
}
