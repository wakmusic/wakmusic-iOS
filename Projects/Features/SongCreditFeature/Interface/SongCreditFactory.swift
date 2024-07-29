import UIKit

public protocol SongCreditFactory {
    func makeViewController(songID: String) -> UIViewController
}
