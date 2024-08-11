import ArtistDomainInterface
import Foundation
import UIKit

public protocol ArtistDetailFactory {
    func makeView(artistID: String) -> UIViewController
}
