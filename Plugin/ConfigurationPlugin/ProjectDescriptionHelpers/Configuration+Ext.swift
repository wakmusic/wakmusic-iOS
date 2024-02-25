import ProjectDescription

public extension Array where Element == Configuration {
    static let `default`: [Configuration] = [
        .debug(name: .debug, xcconfig: "XCConfig/Secrets.xcconfig"),
        .release(name: .release, xcconfig: "XCConfig/Secrets.xcconfig")
    ]
}
