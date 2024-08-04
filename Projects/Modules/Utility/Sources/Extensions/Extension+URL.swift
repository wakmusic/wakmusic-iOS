import Foundation

public extension URL {
    func parseToParams() -> [String: Any] {
        var dict: [String: Any] = [:]

        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return [:]
        }

        for item in queryItems {
            dict[item.name] = item.value
        }

        return dict
    }
}
