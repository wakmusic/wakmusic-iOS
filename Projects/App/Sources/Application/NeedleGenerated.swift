

import DataModule
import DomainModule
import Foundation
import KeychainModule
import MainTabFeature
import NeedleFoundation
import NetworkModule
import PlayerFeature
import RootFeature
import UIKit

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Traversal Helpers

private func parent1(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent
}

// MARK: - Providers

#if !NEEDLE_DYNAMIC

private class PlayerDependencyf8a3d594cc3b9254f8adProvider: PlayerDependency {


    init() {

    }
}
/// ^->AppComponent->PlayerComponent
private func factorybc7f802f601dd5913533e3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return PlayerDependencyf8a3d594cc3b9254f8adProvider()
}
private class MainTabBarDependencycd05b79389a6a7a6c20fProvider: MainTabBarDependency {


    init() {

    }
}
/// ^->AppComponent->MainTabBarComponent
private func factorye547a52b3fce5887c8c7e3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return MainTabBarDependencycd05b79389a6a7a6c20fProvider()
}
private class BottomTabBarDependency237c2bd1c7be62020295Provider: BottomTabBarDependency {


    init() {

    }
}
/// ^->AppComponent->BottomTabBarComponent
private func factoryd34fa9e493604a6295bde3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return BottomTabBarDependency237c2bd1c7be62020295Provider()
}
private class MainContainerDependencyd9d908a1d0cf8937bbadProvider: MainContainerDependency {
    var bottomTabBarComponent: BottomTabBarComponent {
        return appComponent.bottomTabBarComponent
    }
    var mainTabBarComponent: MainTabBarComponent {
        return appComponent.mainTabBarComponent
    }
    var playerComponent: PlayerComponent {
        return appComponent.playerComponent
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->MainContainerComponent
private func factory8e19f48d5d573d3ea539f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return MainContainerDependencyd9d908a1d0cf8937bbadProvider(appComponent: parent1(component) as! AppComponent)
}
private class RootDependency3944cc797a4a88956fb5Provider: RootDependency {
    var mainContainerComponent: MainContainerComponent {
        return appComponent.mainContainerComponent
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->RootComponent
private func factory264bfc4d4cb6b0629b40f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return RootDependency3944cc797a4a88956fb5Provider(appComponent: parent1(component) as! AppComponent)
}

#else
extension AppComponent: Registration {
    public func registerItems() {

        localTable["keychain-any Keychain"] = { self.keychain as Any }
        localTable["mainContainerComponent-MainContainerComponent"] = { self.mainContainerComponent as Any }
        localTable["bottomTabBarComponent-BottomTabBarComponent"] = { self.bottomTabBarComponent as Any }
        localTable["mainTabBarComponent-MainTabBarComponent"] = { self.mainTabBarComponent as Any }
        localTable["playerComponent-PlayerComponent"] = { self.playerComponent as Any }
        localTable["remoteChartDataSource-any RemoteSearchDataSource"] = { self.remoteChartDataSource as Any }
        localTable["searchRepository-any SearchRepository"] = { self.searchRepository as Any }
        localTable["fetchSearchSongUseCase-any FetchSearchSongUseCase"] = { self.fetchSearchSongUseCase as Any }
    }
}
extension PlayerComponent: Registration {
    public func registerItems() {

    }
}
extension MainTabBarComponent: Registration {
    public func registerItems() {

    }
}
extension BottomTabBarComponent: Registration {
    public func registerItems() {

    }
}
extension MainContainerComponent: Registration {
    public func registerItems() {
        keyPathToName[\MainContainerDependency.bottomTabBarComponent] = "bottomTabBarComponent-BottomTabBarComponent"
        keyPathToName[\MainContainerDependency.mainTabBarComponent] = "mainTabBarComponent-MainTabBarComponent"
        keyPathToName[\MainContainerDependency.playerComponent] = "playerComponent-PlayerComponent"
    }
}
extension RootComponent: Registration {
    public func registerItems() {
        keyPathToName[\RootDependency.mainContainerComponent] = "mainContainerComponent-MainContainerComponent"
    }
}


#endif

private func factoryEmptyDependencyProvider(_ component: NeedleFoundation.Scope) -> AnyObject {
    return EmptyDependencyProvider(component: component)
}

// MARK: - Registration
private func registerProviderFactory(_ componentPath: String, _ factory: @escaping (NeedleFoundation.Scope) -> AnyObject) {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: componentPath, factory)
}

#if !NEEDLE_DYNAMIC

@inline(never) private func register1() {
    registerProviderFactory("^->AppComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->AppComponent->PlayerComponent", factorybc7f802f601dd5913533e3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->MainTabBarComponent", factorye547a52b3fce5887c8c7e3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->BottomTabBarComponent", factoryd34fa9e493604a6295bde3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->MainContainerComponent", factory8e19f48d5d573d3ea539f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->RootComponent", factory264bfc4d4cb6b0629b40f47b58f8f304c97af4d5)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
