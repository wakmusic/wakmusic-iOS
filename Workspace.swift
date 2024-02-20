import ProjectDescription
import ProjectDescriptionHelpers
import EnvironmentPlugin

let workspace = Workspace(
    name: env.name,
    projects: [
        "Projects/App"
    ]
)
