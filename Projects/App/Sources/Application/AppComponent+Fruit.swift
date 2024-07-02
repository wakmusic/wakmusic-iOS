import Foundation
import FruitDrawFeature
import FruitDrawFeatureInterface

extension AppComponent {
    var fruitDrawFactory: any FruitDrawFactory {
        FruitDrawComponent(parent: self)
    }

    var fruitStorageFactory: any FruitStorageFactory {
        FruitStorageComponent(parent: self)
    }
}
