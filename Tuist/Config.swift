import ProjectDescription

let config = Config(
    plugins: [
        .local(path: .relativeToRoot("Plugin/DependencyPlugin")),
        .local(path: .relativeToRoot("Plugin/UtilityPlugin"))
    ],
    generationOptions: .options()
)
