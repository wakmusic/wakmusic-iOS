import ProjectDescription

public extension Array where Element == Configuration {
    static let `default`: [Configuration] = [
        .debug(name: .debug, xcconfig: .relativeToRoot("Projects/App/XCConfig/Secrets.xcconfig")),
        .release(name: .release, xcconfig: .relativeToRoot("Projects/App/XCConfig/Secrets.xcconfig"))
    ]
}
