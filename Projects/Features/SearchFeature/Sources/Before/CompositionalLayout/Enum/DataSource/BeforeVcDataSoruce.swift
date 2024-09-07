import ChartDomainInterface
import Foundation
import PlaylistDomainInterface

#warning("실제 데이터 entity로 바꾸기")

enum BeforeVcDataSoruce: Hashable {
    case youtube(model: CurrentVideoEntity)
    case recommend(model: RecommendPlaylistEntity)
//    case popularList(model: Model)
    #warning("추후 업데이트 시 사용")
    var title: String {
        switch self {
        case let .youtube(model):
            return ""
        case let .recommend(model):
            return model.title
//        case let .popularList(model):
//            return model.title
        }
    }
}
