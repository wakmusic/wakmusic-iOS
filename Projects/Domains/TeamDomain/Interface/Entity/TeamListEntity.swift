import Foundation

public struct TeamListEntity {
    public let team: String
    public let name: String
    public let position: String
    public let profile: String
    public let isLead: Bool

    public init(
        team: String,
        name: String,
        position: String,
        profile: String,
        isLead: Bool
    ) {
        self.team = team
        self.name = name
        self.position = position
        self.profile = profile
        self.isLead = isLead
    }
}