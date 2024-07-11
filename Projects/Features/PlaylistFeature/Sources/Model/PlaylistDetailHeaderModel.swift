import Foundation

struct PlaylistDetailHeaderModel: Hashable {
    var key: String
    var title: String
    var image: String
    var `private`: Bool
    var userName: String
    var songCount: Int

    init(key: String, title: String, image: String, userName: String, private: Bool, songCount: Int) {
        self.key = key
        self.title = title
        self.image = image
        self.userName = userName
        self.private = `private`
        self.songCount = songCount
    }

    mutating func updatePrivate() {
        self.private = !self.private
    }

    mutating func updateTitle(_ title: String) {
        self.title = title
    }

    mutating func updateImage(_ image: String) {
        self.image = image
    }

    mutating func updateSongCount(_ songCount: Int) {
        self.songCount = songCount
    }
}
