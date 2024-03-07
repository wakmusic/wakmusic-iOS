import Foundation

public struct EditState {
    public var isEditing: Bool
    public var force: Bool

    public init(isEditing: Bool, force: Bool) {
        self.isEditing = isEditing
        self.force = force
    }
}
