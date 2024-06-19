import Foundation
import PlayListDomainInterface
import ChartDomainInterface

#warning("실제 데이터 entity로 바꾸기")

enum BeforeVcDataSoruce: Hashable {
    case youtube(model: CurrentVideoEntity)
    case recommend(model: RecommendPlayListEntity)
    case popularList(model: Model)

    var title: String {
        switch self {
        case let .youtube(model):
            return ""
        case let .recommend(model):
            return model.title
        case let .popularList(model):
            return model.title
        }
    }
}
