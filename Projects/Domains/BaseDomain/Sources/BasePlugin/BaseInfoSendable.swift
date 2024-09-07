public enum BaseInfoType: String {
    case os
    case appVersion
    case deviceID
    case pushToken

    var apiKey: String {
        switch self {
        case .os:
            return "os"
        case .appVersion:
            return "version"
        case .deviceID:
            return "uniqueDeviceId"
        case .pushToken:
            return "token"
        }
    }
}

public protocol BaseInfoSendable {
    var baseInfoTypes: [BaseInfoType] { get }
}
