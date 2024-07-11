import Foundation
import RealmSwift

final class PlaylistLocalEntity: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var artist: String

    convenience init(
        id: String,
        title: String,
        artist: String
    ) {
        self.init()
        self.id = id
        self.title = title
        self.artist = artist
    }
}
