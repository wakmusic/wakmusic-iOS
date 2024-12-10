import Foundation
import UIKit

@MainActor
public protocol ArtistFactory {
    func makeView() -> UIViewController
}
