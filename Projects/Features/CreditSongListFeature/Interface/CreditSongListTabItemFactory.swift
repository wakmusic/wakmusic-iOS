import UIKit

@MainActor
public protocol CreditSongListTabItemFactory {
    func makeViewController(workerName: String, sortType: CreditSongSortType) -> UIViewController
}
