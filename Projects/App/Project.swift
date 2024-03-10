import EnvironmentPlugin
import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let settinges: Settings =
    .settings(
        base: env.baseSetting,
        configurations: [
            .debug(name: .debug),
            .release(name: .release)
        ],
        defaultSettings: .recommended
    )

let isForDev = (ProcessInfo.processInfo.environment["TUIST_ENV"] ?? "DEV") == "DEV" ? true : false

let scripts: [TargetScript] = isForDev ? [.swiftLint, .needle] : [.firebaseCrashlytics]

let targets: [Target] = [
    .init(
        name: env.name,
        platform: .iOS,
        product: .app,
        productName: env.name,
        bundleId: "\(env.organizationName).\(env.previousName)",
        deploymentTarget: env.deploymentTarget,
        infoPlist: .file(path: "Support/Info.plist"),
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        entitlements: "Support/\(env.name).entitlements",
        scripts: scripts,
        dependencies: [
            .Project.Features.RootFeature,
            .Project.Module.ThirdPartyLib,
            .Project.Service.Data,
            .domain(target: .AppDomain),
            .domain(target: .ArtistDomain),
            .domain(target: .AuthDomain),
            .domain(target: .ChartDomain),
            .domain(target: .FaqDomain),
            .domain(target: .LikeDomain),
            .domain(target: .NoticeDomain)
        ],
        settings: .settings(
            base: env.baseSetting,
            configurations: [
                .debug(name: .debug, xcconfig: "XCConfig/Secrets.xcconfig"),
                .release(name: .release, xcconfig: "XCConfig/Secrets.xcconfig")
            ]
        )
    ),

    .init(
        name: "\(env.name)Tests",
        platform: .iOS,
        product: .unitTests,
        bundleId: "\(env.organizationName).\(env.previousName)Tests",
        deploymentTarget: env.deploymentTarget,
        infoPlist: .default,
        sources: ["Tests/**"],
        dependencies: [
            .target(name: env.name)
        ]
    )
]

let schemes: [Scheme] = [
    .init(
        name: "\(env.name)Tests-DEBUG",
        shared: true,
        buildAction: .buildAction(targets: ["\(env.name)"]),
        testAction: TestAction.targets(
            ["\(env.name)"],
            configuration: .debug,
            options: TestActionOptions.options(
                coverage: true,
                codeCoverageTargets: ["\(env.name)"]
            )
        ),
        runAction: .runAction(configuration: .debug),
        archiveAction: .archiveAction(configuration: .debug),
        profileAction: .profileAction(configuration: .debug),
        analyzeAction: .analyzeAction(configuration: .debug)
    ),
    .init(
        name: "\(env.name)-RELEASE",
        shared: true,
        buildAction: BuildAction(targets: ["\(env.name)"]),
        testAction: nil,
        runAction: .runAction(configuration: .release),
        archiveAction: .archiveAction(configuration: .release),
        profileAction: .profileAction(configuration: .release),
        analyzeAction: .analyzeAction(configuration: .release)
    )
]

let project: Project =
    .init(
        name: env.name,
        organizationName: env.organizationName,
        packages: [],
        // packages: [.Amplify],
        settings: settinges,
        targets: targets,
        schemes: schemes
    )
