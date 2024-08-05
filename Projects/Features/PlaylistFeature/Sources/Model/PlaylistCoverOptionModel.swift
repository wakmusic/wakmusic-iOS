import Foundation

struct PlaylistCoverOptionModel: Hashable {
    var title: String
    var price: Int

    init(title: String, price: Int) {
        self.title = title
        self.price = price
    }
}
