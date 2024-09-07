import Foundation

public extension Dictionary where Key == AnyHashable, Value == Any {
    var parseNotificationInfo: [String: Any] {
        guard let data = self["data"] as? String,
              let jsonData = data.data(using: .utf8),
              let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
              as? [String: Any] else {
            return [:]
        }
        return dict
    }
}
