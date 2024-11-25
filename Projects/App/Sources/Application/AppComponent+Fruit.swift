import Foundation
import FruitDrawFeature
import FruitDrawFeatureInterface
@preconcurrency import NeedleFoundation

extension AppComponent {
    var fruitDrawFactory: any FruitDrawFactory {
        FruitDrawComponent(parent: self)
    }

    var fruitStorageFactory: any FruitStorageFactory {
        FruitStorageComponent(parent: self)
    }
}
