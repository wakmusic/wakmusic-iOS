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
    case fetchArtistWithRound(id: String)
    case fetchArtistWithSquare(id: String)
    case fetchProfile(name: String, version: Int)
    case fetchPlayList(id: String, version: Int)
    case fetchRecommendPlayListWithRound(id: String, version: Int)
    case fetchRecommendPlayListWithSquare(id: String, version: Int)
    case fetchYoutubeThumbnail(id: String)
}

extension WMImageAPI {
    public var baseURLString: String {
        return "https://static.wakmusic.xyz"
    }

    public var youtubeBaseURLString: String {
        return "https://i.ytimg.com"
    }
    
    public var path: String {
        switch self {
        case let .fetchNewsThumbnail(time):
            return "/static/news/\(time).png"
            
        case let .fetchArtistWithRound(id):
            return "/static/artist/round/\(id).png"
            
        case let .fetchArtistWithSquare(id):
            return "/static/artist/square/\(id).png"
            
        case let .fetchProfile(name,version):
            return "/static/profile/\(name).png?v=\(version)"
            
        case let .fetchPlayList(id,version):
            return "/static/playlist/\(id).png?v=\(version)"
            
        case let .fetchRecommendPlayListWithSquare(id,version):
            return "/static/playlist/icon/square/\(id).png?v=\(version)"
            
        case let .fetchRecommendPlayListWithRound(id,version):
            return "/static/playlist/icon/round/\(id).png?v=\(version)"
            
        case let .fetchYoutubeThumbnail(id):
            return "/vi/\(id)/hqdefault.jpg"
        }
    }
    
    public var toString: String {
        switch self {
        case .fetchYoutubeThumbnail:
            return youtubeBaseURLString + path
        default:
            return baseURLString + path
        }
    }
    
    public var toURL: URL? {
        switch self {
        case .fetchYoutubeThumbnail:
            return URL(string: youtubeBaseURLString + path)
        default:
            return URL(string: baseURLString + path)
        }
    }
}
