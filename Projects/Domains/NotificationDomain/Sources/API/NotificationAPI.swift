import BaseDomain
import ErrorModule
import Foundation
import Moya
import NotificationDomainInterface

public enum NotificationAPI {
    case updateNotificationToken(type: NotificationUpdateType)
}

extension NotificationAPI: WMAPI {
    public var domain: WMDomain {
        return .notification
    }

    public var urlPath: String {
        switch self {
        case .updateNotificationToken:
            return "/token"
        }
    }

    public var method: Moya.Method {
        switch self {
        case let .updateNotificationToken(type):
            return type == .update ? .put : .delete
        }
    }

    #warning("TO-DO:: plugin으로 교체 예정")
    public var task: Moya.Task {
        switch self {
        case let .updateNotificationToken(type):
            if type == .update {
                return .requestParameters(
                    parameters: [
                        "uniqueDeviceId": "",
                        "token": ""
                    ],
                    encoding: URLEncoding.queryString
                )
            } else {
                return .requestParameters(
                    parameters: [
                        "uniqueDeviceId": ""
                    ],
                    encoding: URLEncoding.queryString
                )
            }
        }
    }

    public var jwtTokenType: JwtTokenType {
        switch self {
        case .updateNotificationToken:
            return .accessToken
        }
    }

    public var errorMap: [Int: WMError] {
        switch self {
        default:
            return [
                400: .badRequest,
                401: .tokenExpired,
                404: .notFound,
                429: .tooManyRequest,
                500: .internalServerError
            ]
        }
    }
}
