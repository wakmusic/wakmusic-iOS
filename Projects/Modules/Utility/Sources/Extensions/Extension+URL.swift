import Foundation

public extension URL {
    func params() -> [String: Any] {
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
