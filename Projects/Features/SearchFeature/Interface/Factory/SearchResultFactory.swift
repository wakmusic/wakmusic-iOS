import Foundation
import UIKit

public protocol SongSearchResultFactory {
    func makeView() -> UIViewController
}
