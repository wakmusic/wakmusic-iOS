import Foundation
import PlayListDomainInterface

struct MyPlaylistModel: Hashable {
    var id: UUID
    var data: PlayListDetailEntity
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        
    }
    
    init(id: UUID = UUID() ,_ data: PlayListDetailEntity) {
        self.id = id
        self.data = data
    }
    
}
