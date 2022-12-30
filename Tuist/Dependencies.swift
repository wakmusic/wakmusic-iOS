import ProjectDescription

let dependencies = Dependencies(
    carthage: nil,
    swiftPackageManager: [
        .remote(url: "https://github.com/Quick/Quick.git", requirement: .upToNextMajor(from: "5.0.1")),
        .remote(url: "https://github.com/Quick/Nimble.git", requirement: .upToNextMajor(from: "10.0.0")),
        .remote(url: "https://github.com/uber/needle.git", requirement: .upToNextMajor(from: "0.19.0"))
    ],
    platforms: [.iOS]
)
