import Foundation

public enum ImageType {
    case `default`(image: String)
    case custom (image: String)

    var data: ImageEntity {
        switch self {
        case let .default(image: image):
            return ImageEntity(type: 1, imageName: image)
        case let .custom(image: image):
            return ImageEntity(type: 2, file: image)
        }
    }
}

public struct ImageEntity {
    let type: Int
    var imageName: String?
    var file: String?
}
