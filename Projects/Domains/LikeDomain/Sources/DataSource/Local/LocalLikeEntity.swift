import RealmSwift

final class LocalLikeEntity: Object {
    @Persisted(primaryKey: true) var songID: String

    convenience init(songID: String) {
        self.init()
        self.songID = songID
    }
}
