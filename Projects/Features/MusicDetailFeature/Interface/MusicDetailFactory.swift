import UIKit

public protocol MusicDetailFactory {
    func makeViewController(songIDs: [String], selectedID: String) -> UIViewController
}
