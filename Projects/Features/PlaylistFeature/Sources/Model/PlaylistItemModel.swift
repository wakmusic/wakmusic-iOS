import Foundation

struct PlaylistItemModel: Hashable, Equatable {
    let id: String
    let title: String
    let artist: String
    let isSelected: Bool // selected 판별 방식 전환 고려

    func updateIsSelected(isSelected: Bool) -> PlaylistItemModel {
        PlaylistItemModel(
            id: self.id,
            title: self.title,
            artist: self.artist,
            isSelected: isSelected
        )
    }
}
