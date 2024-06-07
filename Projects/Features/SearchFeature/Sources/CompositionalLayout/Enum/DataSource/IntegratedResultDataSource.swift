import Foundation
import SongsDomainInterface


#warning("실제 데이터 entitiy로 바꾸기")



enum IntegratedResultDataSource: Hashable {
    case song(model: SongEntity)
    case list(model: String)
}
