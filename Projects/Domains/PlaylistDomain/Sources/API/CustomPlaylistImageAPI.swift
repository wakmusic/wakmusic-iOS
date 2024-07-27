import Foundation
import Moya

enum CustomPlaylistImageAPI {
    case uploadCustomImage(url: String, data: Data)
}

extension CustomPlaylistImageAPI: TargetType {
    var baseURL: URL {
        switch self {
        case let .uploadCustomImage(url, _):
            return URL(string: url)!
        }
    }

    var path: String {
        return ""
    }

    var method: Moya.Method {
        return .put
    }

    // var sampleData: Data { ... }

    var task: Task {
        switch self {
        case let .uploadCustomImage(url: _, data):
            return .requestData(data)
        }
    }

    var headers: [String: String]? {
        switch self {
        case let .uploadCustomImage(url: _, data):
            return ["Content-Type": "image/jpeg", " Contnet-Length": "\(data.count)"]
        }
    }

    var validationType: ValidationType {
        return .successCodes
    }
}
