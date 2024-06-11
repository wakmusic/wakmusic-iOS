import Foundation

#warning("실제 데이터 entity로 바꾸기")

enum BeforeVcDataSoruce: Hashable {
    case youtube(model: Model)
    case recommend(model2: Model)
    case popularList(model: Model)

    var title: String {
        switch self {
        case let .youtube(model):
            return model.title
        case let .recommend(model2):
            return model2.title
        case let .popularList(model):
            return model.title
        }
    }
}
