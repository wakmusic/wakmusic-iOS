import Foundation

public struct ImageModel {
    private let type: Int // 1: default, 2: custom
    private var imageName: String?
    private var file: String?

    public init(type: Int, imageName: String? = nil, file: String? = nil) {
        self.type = type
        self.imageName = imageName
        self.file = file
    }

    var toMultipartFormData: {
        switch self.type {
        case 1: break

        default: break
        }
    }
}
