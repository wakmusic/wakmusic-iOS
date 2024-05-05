import UIKit

public protocol ContainSongsFactory {
    func makeView(songs: [String]) -> UIViewController
}
