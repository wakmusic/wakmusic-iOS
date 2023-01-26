public enum KeychainType: String {
    case accessToken = "ACCESS-TOKEN"
}

public protocol Keychain {
    func save(type: KeychainType, value: String)
    func load(type: KeychainType) -> String
    func delete(type: KeychainType)
}
