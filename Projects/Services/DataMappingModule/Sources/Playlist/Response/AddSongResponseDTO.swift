import Foundation


public struct AddSongResponseDTO: Decodable {
    
    public let status: Int
    public let added_songs_length: Int
    public let duplicated: Bool
}
