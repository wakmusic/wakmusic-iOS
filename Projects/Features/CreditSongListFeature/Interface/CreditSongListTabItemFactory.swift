import UIKit

public protocol CreditSongListTabItemFactory {
    func makeViewController(workerName: String, sortType: CreditSongSortType) -> UIViewController
}
