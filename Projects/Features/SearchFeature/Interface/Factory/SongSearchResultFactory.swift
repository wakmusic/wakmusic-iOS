import UIKit

public protocol SongSearchResultFactory {
    func makeView(_ text: String) -> UIViewController
}
