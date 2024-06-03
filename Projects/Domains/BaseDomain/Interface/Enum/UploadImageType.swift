import Foundation

public enum UploadImageType {
    case `default`(imageName: String)
    case custom (imageName: Data)
}
