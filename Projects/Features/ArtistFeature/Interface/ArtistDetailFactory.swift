import ArtistDomainInterface
import Foundation
import UIKit

public protocol ArtistDetailFactory {
    func makeView(model: ArtistListEntity) -> UIViewController
}
