import Foundation

final class KeychainFake: Keychain, @unchecked Sendable {
    var store: [String: String] = [:]

    func save(type: KeychainType, value: String) {
        store[type.rawValue] = value
    }

    func load(type: KeychainType) -> String {
        store[type.rawValue] ?? ""
    }

    func delete(type: KeychainType) {
        store[type.rawValue] = nil
    }
}
