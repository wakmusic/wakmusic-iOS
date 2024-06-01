import BaseDomainInterface
import Foundation

public protocol ImageUploadable {
    /// 1 ~ 11
    func uploadDefaultImage(_ image: String) -> ImageType

    func uploadCustomImage(_ image: String) -> ImageType
}
