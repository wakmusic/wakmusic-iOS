import Foundation

public struct ArtistSubscriptionStatusEntity {
    public init(isSubscription: Bool) {
        self.isSubscription = isSubscription
    }

    public let isSubscription: Bool
}
