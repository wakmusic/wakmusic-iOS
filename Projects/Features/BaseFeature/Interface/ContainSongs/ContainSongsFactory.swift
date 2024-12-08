import UIKit

@MainActor
public protocol ContainSongsFactory {
    func makeView(songs: [String]) -> UIViewController
}
