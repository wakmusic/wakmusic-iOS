import ArtistDomainInterface
import Foundation
import UIKit

@MainActor
public protocol ArtistDetailFactory {
    func makeView(artistID: String) -> UIViewController
}
