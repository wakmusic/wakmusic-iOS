//
//  WMImageAPI.swift
//  Utility
//
//  Created by KTH on 2023/02/10.
//  Copyright Â© 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public enum WMImageAPI {
    case fetchNewsThumbnail(time: String)
    case fetchArtistWithRound(id: String, version: Int)
    case fetchArtistWithSquare(id: String, version: Int)
    case fetchPlayList(id: String, version: Int)
    case fetchRecommendPlaylistWithRound(id: String, version: Int)
    case fetchRecommendPlaylistWithSquare(id: String, version: Int)
    case fetchYoutubeThumbnail(id: String)
    case fetchYoutubeThumbnailHD(id: String)
    case fetchNotice(id: String)
}

public extension WMImageAPI {
    var baseURLString: String {
        return BASE_IMAGE_URL()
    }

    var youtubeBaseURLString: String {
        return "https://i.ytimg.com"
    }

    var path: String {
        switch self {
        case let .fetchNewsThumbnail(time):
            return WMDOMAIN_IMAGE_NEWS() + "/\(time).png"

        case let .fetchArtistWithRound(id, version):
            return WMDOMAIN_IMAGE_ARTIST_ROUND() + "/\(id).png?v=\(version)"

        case let .fetchArtistWithSquare(id, version):
            return WMDOMAIN_IMAGE_ARTIST_SQUARE() + "/\(id).png?v=\(version)"

        case let .fetchPlayList(id, version):
            return WMDOMAIN_IMAGE_PLAYLIST() + "/\(id).png?v=\(version)"

        case let .fetchRecommendPlaylistWithSquare(id, version):
            return WMDOMAIN_IMAGE_RECOMMEND_PLAYLIST_SQUARE() + "/\(id).png?v=\(version)"

        case let .fetchRecommendPlaylistWithRound(id, version):
            return WMDOMAIN_IMAGE_RECOMMEND_PLAYLIST_ROUND() + "/\(id).png?v=\(version)"

        case let .fetchYoutubeThumbnail(id):
            return "vi/\(id)/mqdefault.jpg"

        case let .fetchYoutubeThumbnailHD(id):
            return "vi/\(id)/maxresdefault.jpg"

        case let .fetchNotice(id):
            return WMDOMAIN_IMAGE_NOTICE() + "/\(id)"
        }
    }

    var toString: String {
        switch self {
        case .fetchYoutubeThumbnail:
            return youtubeBaseURLString + "/" + path
        case .fetchYoutubeThumbnailHD:
            return youtubeBaseURLString + "/" + path
        default:
            return baseURLString + "/" + path
        }
    }

    var toURL: URL? {
        switch self {
        case .fetchYoutubeThumbnail:
            return URL(string: youtubeBaseURLString + "/" + path)
        case .fetchYoutubeThumbnailHD:
            return URL(string: youtubeBaseURLString + "/" + path)
        default:
            return URL(string: baseURLString + "/" + path)
        }
    }
}
