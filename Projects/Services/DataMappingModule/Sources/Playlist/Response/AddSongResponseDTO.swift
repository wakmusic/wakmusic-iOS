import Foundation

public struct AddSongResponseDTO: Decodable {
    public let status: Int
    public let addedSongsLength: Int
    public let duplicated: Bool
}
