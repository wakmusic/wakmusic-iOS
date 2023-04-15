import Foundation

public enum WMError: Error, Equatable {
    case unknown
    case custom(message: String = "알 수 없는 오류가 발생하였습니다", code: Int = 500)
    case badRequest
    case tokenExpired
    case notFound
    case tooManyRequest
    case internalServerError
}

extension WMError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "알 수 없는 오류가 발생하였습니다."

        case let .custom(message, _):
            return message

        case .badRequest:
            return "요청이 잘못되었습니다."

        case .notFound: //404
            return "요청한 것을 찾을 수 없습니다."

        case .tokenExpired: //401
            return "인증이 만료되었습니다.\n다시 로그인해 주세요."

        case .tooManyRequest:
            return "요청 횟수를 초과했습니다.\n잠시 후 다시 시도해주세요!"

        case .internalServerError:
            return "서버에서 문제가 발생하였습니다.\n잠시 후 다시 시도해주세요!"
        }
    }
}

public extension Error {
    var asWMError: WMError {
        self as? WMError ?? .unknown
    }
}
