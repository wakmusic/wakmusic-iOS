import Foundation

public struct CreditProfileEntity {
    public init(name: String, imageURL: String?) {
        self.name = name
        self.imageURL = imageURL
    }

    public let name: String
    public let imageURL: String?
}
