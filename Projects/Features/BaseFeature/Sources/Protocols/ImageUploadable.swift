import BaseDomainInterface
import Foundation
import UIKit

extension String {
    func convertImageModel(_ image: String, isCustom: Bool = false) -> ImageModel {
        return isCustom ? ImageModel(type: 2, file: image) : ImageModel(type: 1, imageName: image)
    }
}

public protocol ImageUploadable {
    /// 1 ~ 11
    func uploadImage(_ image: String) -> ImageModel
}

public extension ImageUploadable where Self: UIViewController {
    #warning("Sheet 구현 시 연결")
}
