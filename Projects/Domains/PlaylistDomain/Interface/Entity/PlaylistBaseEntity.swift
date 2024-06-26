

import Foundation

public struct PlaylistBaseEntity: Equatable {
    public init(
        key: String,
        image: String
    ) {
        self.key = key
        self.image = image
    }

    public let key, image: String
}
