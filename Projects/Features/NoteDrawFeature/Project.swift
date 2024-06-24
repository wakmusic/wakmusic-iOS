import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.NoteDrawFeature.rawValue,
    targets: [
        .interface(module: .feature(.NoteDrawFeature)),
        .implements(
            module: .feature(.NoteDrawFeature),
            dependencies: [
                .feature(target: .NoteDrawFeature, type: .interface),
                .feature(target: .BaseFeature)
            ]
        ),
        .demo(
            module: .feature(.NoteDrawFeature),
            dependencies: [
                .feature(target: .NoteDrawFeature)
            ]
        )
    ]
)
