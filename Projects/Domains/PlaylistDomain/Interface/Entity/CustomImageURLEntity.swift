public struct CustomImageURLEntity {
    public let imageURL, presignedURL: String

    public init(imageURL: String, presignedURL: String) {
        self.imageURL = imageURL
        self.presignedURL = presignedURL
    }
}
