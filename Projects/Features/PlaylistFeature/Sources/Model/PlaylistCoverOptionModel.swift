import Foundation

struct PlaylistCoverOptionModel: Hashable {
    var title: String
    var cost: Int

    init(title: String, cost: Int) {
        self.title = title
        self.cost = cost
    }
}
