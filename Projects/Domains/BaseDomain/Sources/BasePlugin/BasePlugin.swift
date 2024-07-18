import Foundation
import KeychainModule
import Moya
import UIKit

public struct BasePlugin: PluginType {
    private let keychain: any Keychain

    public init(keychain: any Keychain) {
        self.keychain = keychain
    }

    public func prepare(
        _ request: URLRequest,
        target: TargetType
    ) -> URLRequest {
        guard let baseInfoTypes = (target as? BaseInfoSendable)?.baseInfoTypes,
              baseInfoTypes.isEmpty == false else {
            return request
        }
        var newRequest = request

        if request.httpMethod == "GET" {
            guard let url = request.url,
                  var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                return request
            }

            var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []

            for type in baseInfoTypes {
                let queryItem = URLQueryItem(name: type.apiKey, value: typeToValue(with: type))
                queryItems.append(queryItem)
            }

            urlComponents.queryItems = queryItems
            newRequest.url = urlComponents.url

        } else {
            guard let bodyData = request.httpBody,
                  var json = try? JSONSerialization.jsonObject(with: bodyData, options: []) as? [String: Any] else {
                return request
            }

            for type in baseInfoTypes {
                json[type.apiKey] = typeToValue(with: type)
            }

            guard let newBodyData = try? JSONSerialization.data(withJSONObject: json, options: []) else {
                return request
            }
            newRequest.httpBody = newBodyData
        }

        return newRequest
    }
}

private extension BasePlugin {
    func typeToValue(with type: BaseInfoType) -> String {
        switch type {
        case .os:
            return "ios"
        case .appVersion:
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        case .deviceID:
            return fetchDeviceID()
        case .pushToken:
            return fetchPushToken()
        }
    }

    func fetchDeviceID() -> String {
        let deviceIDFromKeychain: String = keychain.load(type: .deviceID)
        let uuidString: String = UIDevice.current.identifierForVendor?.uuidString ?? ""

        if deviceIDFromKeychain.isEmpty {
            keychain.save(type: .deviceID, value: uuidString)
            return uuidString

        } else {
            return deviceIDFromKeychain
        }
    }

    #warning("FCM SDK 셋업 이후 작업")
    func fetchPushToken() -> String {
        return ""
    }
}
