public enum DeviceInfoType: String {
    case os
    case version
    case deviceID
    case pushToken

    var apiKey: String {
        switch self {
        case .os:
            return "os"
        case .version:
            return "version"
        case .deviceID:
            return "uniqueDeviceId"
        case .pushToken:
            return "token"
        }
    }
}

public protocol DeviceInfoSendable {
    var deviceInfoType: DeviceInfoType { get }
}
