import Foundation
import TeamDomainInterface

public typealias TeamInfoSectionModel = (title: String, model: TeamInfoModel)

public struct TeamInfoModel {
    public let members: [TeamListEntity]
    public var isOpen: Bool

    public init(members: [TeamListEntity], isOpen: Bool) {
        self.members = members
        self.isOpen = isOpen
    }
}
