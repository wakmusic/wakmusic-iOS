import Foundation

public struct AuthLoginEntity: Equatable {
    public init(
        token: String
    ) {
        self.token = token
    }

    public let token: String
}
