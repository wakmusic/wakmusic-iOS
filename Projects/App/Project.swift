import EnvironmentPlugin
import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let alternativeAppIconNames: [String] = ["HalloweenAppIcon", " XmasAppIcon"]

let settinges: Settings =
    .settings(
        base: env.baseSetting.merging(["ASSETCATALOG_COMPILER_ALTERNATE_APPICON_NAMES" : .array(alternativeAppIconNames)]),
        configurations: [
            .debug(name: .debug),
            .debug(name: .qa),
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
            .module(target: .ThirdPartyLib),
            .feature(target: .RootFeature),
            .feature(target: .PlaylistFeature),
            .feature(target: .MusicDetailFeature),
            .feature(target: .SongCreditFeature),
            .feature(target: .CreditSongListFeature),
            .domain(target: .AppDomain),
            .domain(target: .ArtistDomain),
            .domain(target: .AuthDomain),
            .domain(target: .ChartDomain),
            .domain(target: .FaqDomain),
            .domain(target: .LikeDomain),
            .domain(target: .NoticeDomain),
            .domain(target: .SongsDomain),
            .domain(target: .PlaylistDomain),
            .domain(target: .UserDomain),
            .domain(target: .SearchDomain),
            .domain(target: .ImageDomain),
            .domain(target: .NotificationDomain),
            .domain(target: .TeamDomain),
            .domain(target: .CreditDomain),
            .domain(target: .PriceDomain)
        ],
        settings: .settings(
            base: env.baseSetting,
            configurations: [
                .debug(name: .debug, xcconfig: "XCConfig/Secrets.xcconfig"),
                .debug(name: .qa, xcconfig: "XCConfig/Secrets.xcconfig"),
                .release(name: .release, xcconfig: "XCConfig/Secrets.xcconfig")
            ]
        ),
        environmentVariables: ["NETWORK_LOG_LEVEL": "short"]
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
        name: "\(env.name)-DEBUG",
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
        name: "\(env.name)-QA",
        shared: true,
        buildAction: .buildAction(targets: ["\(env.name)"]),
        testAction: nil,
        runAction: .runAction(configuration: .qa),
        archiveAction: .archiveAction(configuration: .qa),
        profileAction: .profileAction(configuration: .qa),
        analyzeAction: .analyzeAction(configuration: .qa)
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
        settings: settinges,
        targets: targets,
        schemes: schemes
    )
