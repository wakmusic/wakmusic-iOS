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

let scripts: [TargetScript] = generateEnvironment.appScripts

let targets: [Target] = [
    .target(
        name: env.name,
        destinations: [.iPhone],
        product: .app,
        productName: env.name,
        bundleId: "\(env.organizationName).\(env.previousName)",
        deploymentTargets: env.deploymentTargets,
        infoPlist: .file(path: "Support/Info.plist"),
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        entitlements: "Support/\(env.name).entitlements",
        scripts: scripts,
        dependencies: [
            .Project.Features.RootFeature,
            .Project.Module.ThirdPartyLib,
            .feature(target: .PlaylistFeature),
            .domain(target: .AppDomain),
            .domain(target: .ArtistDomain),
            .domain(target: .AuthDomain),
            .domain(target: .ChartDomain),
            .domain(target: .FaqDomain),
            .domain(target: .LikeDomain),
            .domain(target: .NoticeDomain),
            .domain(target: .SongsDomain),
            .domain(target: .PlayListDomain),
            .domain(target: .UserDomain)
        ],
        settings: .settings(
            base: env.baseSetting,
            configurations: [
                .debug(name: .debug, xcconfig: "XCConfig/Secrets.xcconfig"),
                .release(name: .release, xcconfig: "XCConfig/Secrets.xcconfig")
            ]
        )
    ),
    .target(
        name: "\(env.name)Tests",
        destinations: [.iPhone],
        product: .unitTests,
        bundleId: "\(env.organizationName).\(env.previousName)Tests",
        deploymentTargets: env.deploymentTargets,
        infoPlist: .default,
        sources: ["Tests/**"],
        dependencies: [
            .target(name: env.name)
        ]
    )
]

let schemes: [Scheme] = [
    .scheme(
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
    .scheme(
        name: "\(env.name)-RELEASE",
        shared: true,
        buildAction: .buildAction(targets: ["\(env.name)"]),
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
