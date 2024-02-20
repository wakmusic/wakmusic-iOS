import ProjectDescription
import DependencyPlugin
import Foundation
import EnvironmentPlugin

public extension Project {
    
    static func module(
        name: String,
        options: Options = .options(),
        packages: [Package] = [],
        settings: Settings = .settings(
            base: env.baseSetting,
            configurations: [
                .debug(name: .debug),
                .release(name: .release)
            ], defaultSettings: .recommended),
        targets: [Target],
        fileHeaderTemplate: FileHeaderTemplate? = nil,
        additionalFiles: [FileElement] = [],
        resourceSynthesizers: [ResourceSynthesizer] = .default
    ) -> Project {
        return Project(
            name: name,
            organizationName: env.organizationName,
            options: options,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: targets.contains { $0.product == .app } ? [.makeScheme(target: .debug, name: name)] : [.makeScheme(target: .debug, name: name)] , //TODO: 백튼님 여기 스킴 한번 검토 좀 
            fileHeaderTemplate: fileHeaderTemplate,
            additionalFiles: additionalFiles,
            resourceSynthesizers: resourceSynthesizers
        )
        
        
        
    }
    
    @available(*, deprecated)
    static func makeModule(
        name: String,
        platform: Platform = .iOS,
        product: Product,
        packages: [Package] = [],
        dependencies: [TargetDependency] = [],
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        demoResources: ResourceFileElements? = nil,
        infoPlist: InfoPlist = .default,
        hasDemoApp: Bool = false
    ) -> Project {
        return project(
            name: name,
            platform: platform,
            product: product,
            packages: packages,
            dependencies: dependencies,
            sources: sources,
            resources: resources,
            infoPlist: infoPlist,
            hasDemoApp: hasDemoApp
        )
    }
}

public extension Project {
    @available(*, deprecated)
    static func project(
        name: String,
        platform: Platform,
        product: Product,
        organizationName: String = env.organizationName,
        packages: [Package] = [],
        deploymentTarget: DeploymentTarget? = env.deploymentTarget,
        dependencies: [TargetDependency] = [],
        sources: SourceFilesList,
        resources: ResourceFileElements? = nil,
        demoResources: ResourceFileElements? = nil,
        infoPlist: InfoPlist,
        hasDemoApp: Bool = false
    ) -> Project {
        let isForDev = (ProcessInfo.processInfo.environment["TUIST_ENV"] ?? "DEV") == "DEV" ? true : false
        let scripts: [TargetScript] = isForDev ? [.swiftLint] : [.firebaseCrashlytics]
        let settings: Settings = .settings(
            base: env.baseSetting,
            configurations: [
                .debug(name: .debug),
                .release(name: .release)
            ], defaultSettings: .recommended)
        let appTarget = Target(
            name: name,
            platform: platform,
            product: product,
            bundleId: "\(organizationName).\(name)",
            deploymentTarget: deploymentTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            scripts: scripts,
            dependencies: dependencies
        )
        let demoSource: SourceFilesList = ["Demo/Sources/**"]
        let demoSources: SourceFilesList = SourceFilesList(globs: sources.globs + demoSource.globs)
        
        let demoAppTarget = Target(
            name: "\(name)DemoApp",
            platform: platform,
            product: .app,
            bundleId: "\(organizationName).\(name)DemoApp",
            deploymentTarget: env.deploymentTarget,
            infoPlist: .extendingDefault(with: [
                "UIMainStoryboardFile": "",
                "UILaunchStoryboardName": "LaunchScreen",
                "ENABLE_TESTS": .boolean(true),
            ]),
            sources: demoSources,
            resources: ["Demo/Resources/**"],
            scripts: scripts,
            dependencies: [
                .target(name: name)
            ]
        )
        
        let testTargetDependencies: [TargetDependency] = hasDemoApp
        ? [.target(name: "\(name)DemoApp")]
        : [.target(name: name)]
        
        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "\(organizationName).\(name)Tests",
            deploymentTarget: deploymentTarget,
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: testTargetDependencies + [
            ]
        )
        
        let schemes: [Scheme] = hasDemoApp
        ? [.makeScheme(target: .debug, name: name), .makeDemoScheme(target: .debug, name: name)]
        : [.makeScheme(target: .debug, name: name)]
        
        let targets: [Target] = hasDemoApp
        ? [appTarget, testTarget, demoAppTarget]
        : [appTarget, testTarget]
        
        return Project(
            name: name,
            organizationName: organizationName,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: schemes
        )
    }
}

extension Scheme {
    static func makeScheme(target: ConfigurationName, name: String) -> Scheme {
        return Scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
            ),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }
    static func makeDemoScheme(target: ConfigurationName, name: String) -> Scheme {
        return Scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)DemoApp"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)DemoApp"])
            ),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }
}
