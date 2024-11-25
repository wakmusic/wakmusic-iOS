import UIKit

@MainActor
public protocol MusicDetailFactory {
    func makeViewController(songIDs: [String], selectedID: String) -> UIViewController
}
