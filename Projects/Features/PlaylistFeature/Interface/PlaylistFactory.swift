import UIKit

public protocol PlaylistFactory {
    func makeViewController() -> UIViewController
    func makeViewController(currentSongID: String) -> UIViewController
}
