import Foundation

public struct TeamListEntity {
    public let team: String
    public let part: String
    public let name: String
    public let position: String
    public let profile: String
    public let isLead: Bool
    public let isManager: Bool

    public init(
        team: String,
        part: String,
        name: String,
        position: String,
        profile: String,
        isLead: Bool,
        isManager: Bool
    ) {
        self.team = team
        self.part = part
        self.name = name
        self.position = position
        self.profile = profile
        self.isLead = isLead
        self.isManager = isManager
    }
}
