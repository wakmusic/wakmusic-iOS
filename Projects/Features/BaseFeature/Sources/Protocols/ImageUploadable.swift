import BaseDomainInterface
import Foundation
import UIKit

public protocol ImageUploadable {
    #warning("이미지 선택 Sheet")
}

public extension ImageUploadable where Self: UIViewController {
    #warning("Sheet 구현 시 연결")
}
