import Foundation

struct ThumbnailOptionModel: Hashable {
    
    var title: String
    var cost: Int

    init(title: String, cost: Int) {
        self.title = title
        self.cost = cost
    }

}
