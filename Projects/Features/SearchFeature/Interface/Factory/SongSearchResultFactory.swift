import UIKit

@MainActor
public protocol SongSearchResultFactory {
    func makeView(_ text: String) -> UIViewController
}
