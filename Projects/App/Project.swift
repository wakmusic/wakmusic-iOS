import ProjectDescriptionHelpers
import ProjectDescription
import UtilityPlugin
import Foundation

let settinges: Settings =
    .settings(base: Environment.baseSetting,
              configurations: [
                .debug(name: .debug),
                .release(name: .release)
              ],
              defaultSettings: .recommended)

let isForDev = (ProcessInfo.processInfo.environment["TUIST_DEV"] ?? "0") == "1" ? true : false

let scripts: [TargetScript] = isForDev ? [.swiftLint, .needle] : []

let targets: [Target] = [
    .init(
        name: Environment.targetName,
        platform: .iOS,
        product: .app,
        productName: Environment.appName,
        bundleId: "\(Environment.organizationName).\(Environment.beforeName)",
        deploymentTarget: Environment.deploymentTarget,
        infoPlist: .file(path: "Support/Info.plist"),
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        entitlements: "Support/\(Environment.appName).entitlements",
        scripts: scripts,
        dependencies: [
            .Project.Features.RootFeature,
            .Project.Module.ThirdPartyLib,
            .Project.Service.Data,
            .SPM.Firebase,
            .SPM.Nimble,
            .SPM.Quick
        ],
        settings: .settings(base: Environment.baseSetting)
    ),
    .init(
        name: Environment.targetTestName,
        platform: .iOS,
        product: .unitTests,
        bundleId: "\(Environment.organizationName).\(Environment.beforeName)Tests",
        deploymentTarget: Environment.deploymentTarget,
        infoPlist: .default,
        sources: ["Tests/**"],
        dependencies: [
            .target(name: Environment.targetName)
        ]
    )
]

let schemes: [Scheme] = [
    .init(
      name: "\(Environment.targetName)-DEBUG",
      shared: true,
      buildAction: .buildAction(targets: ["\(Environment.targetName)"]),
      testAction: TestAction.targets(
          ["\(Environment.targetTestName)"],
          configuration: .debug,
          options: TestActionOptions.options(
              coverage: true,
              codeCoverageTargets: ["\(Environment.targetName)"]
          )
      ),
      runAction: .runAction(configuration: .debug),
      archiveAction: .archiveAction(configuration: .debug),
      profileAction: .profileAction(configuration: .debug),
      analyzeAction: .analyzeAction(configuration: .debug)
    ),
    .init(
      name: "\(Environment.targetName)-RELEASE",
      shared: true,
      buildAction: BuildAction(targets: ["\(Environment.targetName)"]),
      testAction: nil,
      runAction: .runAction(configuration: .release),
      archiveAction: .archiveAction(configuration: .release),
      profileAction: .profileAction(configuration: .release),
      analyzeAction: .analyzeAction(configuration: .release)
    )
]

let project: Project =
    .init(
        name: Environment.targetName,
        organizationName: Environment.organizationName,
        settings: settinges,
        targets: targets,
        schemes: schemes
    )
