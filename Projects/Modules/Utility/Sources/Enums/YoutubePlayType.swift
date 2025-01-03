import Foundation

public enum YoutubePlayType: Codable, Sendable {
    case youtube
    case youtubeMusic

    public var display: String {
        switch self {
        case .youtube: "YouTube"
        case .youtubeMusic: "YouTube Music"
        }
    }
}
