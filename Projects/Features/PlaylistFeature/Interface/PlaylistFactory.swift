import UIKit

@MainActor
public protocol PlaylistFactory {
    func makeViewController() -> UIViewController
    func makeViewController(currentSongID: String) -> UIViewController
}
