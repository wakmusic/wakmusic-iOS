import BaseFeature
import BaseFeatureInterface
import StorageFeature
import StorageFeatureInterface
@preconcurrency import NeedleFoundation

// MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수  이름 같아야함

public extension AppComponent {
    var storageFactory: any StorageFactory {
        StorageComponent(parent: self)
    }

    var listStorageComponent: ListStorageComponent {
        ListStorageComponent(parent: self)
    }

    var likeStorageComponent: LikeStorageComponent {
        LikeStorageComponent(parent: self)
    }
}
