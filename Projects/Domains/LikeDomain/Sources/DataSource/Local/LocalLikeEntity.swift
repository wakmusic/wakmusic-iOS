import RealmSwift

final class LocalLikeEntity: Object {
    @Persisted(primaryKey: true) var songID: String

    init(songID: String) {
        super.init()
        self.songID = songID
    }
}
