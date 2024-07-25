public struct CustomImageUrlEntity {
    public let imageUrl , presignedUrl: String
    
    public init(imageUrl: String, presignedUrl: String) {
        self.imageUrl = imageUrl
        self.presignedUrl = presignedUrl
    }
}
