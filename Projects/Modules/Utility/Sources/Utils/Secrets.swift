//
//  Secrets.swift
//  Utility
//
//  Created by KTH on 2023/04/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public func config(key: String) -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets[key] as? String ?? "not found key"
}

// MARK: - BASE_IMAGE_URL
public func BASE_IMAGE_URL() -> String {
    return config(key: "BASE_IMAGE_URL")
}

// MARK: - WMDomain > Image
public func WMDOMAIN_IMAGE_NEWS() -> String {
    return config(key: "WMDOMAIN_IMAGE_NEWS")
}

public func WMDOMAIN_IMAGE_ARTIST_ROUND() -> String {
    return config(key: "WMDOMAIN_IMAGE_ARTIST_ROUND")
}

public func WMDOMAIN_IMAGE_ARTIST_SQUARE() -> String {
    return config(key: "WMDOMAIN_IMAGE_ARTIST_SQUARE")
}

public func WMDOMAIN_IMAGE_PROFILE() -> String {
    return config(key: "WMDOMAIN_IMAGE_PROFILE")
}

public func WMDOMAIN_IMAGE_PLAYLIST() -> String {
    return config(key: "WMDOMAIN_IMAGE_PLAYLIST")
}

public func WMDOMAIN_IMAGE_RECOMMEND_PLAYLIST_SQUARE() -> String {
    return config(key: "WMDOMAIN_IMAGE_RECOMMEND_PLAYLIST_SQUARE")
}

public func WMDOMAIN_IMAGE_RECOMMEND_PLAYLIST_ROUND() -> String {
    return config(key: "WMDOMAIN_IMAGE_RECOMMEND_PLAYLIST_ROUND")
}

public func WMDOMAIN_IMAGE_NOTICE() -> String {
    return config(key: "WMDOMAIN_IMAGE_NOTICE")
}

// MARK: - NAVER
public func NAVER_URL_SCHEME() -> String {
    return config(key: "NAVER_URL_SCHEME")
}

public func NAVER_CONSUMER_KEY() -> String {
    return config(key: "NAVER_CONSUMER_KEY")
}

public func NAVER_CONSUMER_SECRET() -> String {
    return config(key: "NAVER_CONSUMER_SECRET")
}

public func NAVER_APP_NAME() -> String {
    return config(key: "NAVER_APP_NAME")
}

// MARK: - GOOGLE
public func GOOGLE_URL_SCHEME() -> String {
    return config(key: "GOOGLE_URL_SCHEME")
}

public func GOOGLE_CLIENT_ID() -> String {
    return config(key: "GOOGLE_CLIENT_ID")
}

/// WAKTAVERSEMUSIC
public func WM_APP_ID() -> String {
    return config(key: "WM_APP_ID")
}

public func WM_URI_SCHEME() -> String {
    return config(key: "WM_URI_SCHEME")
}

public func WM_UNIVERSALLINK_DOMAIN() -> String {
    #if DEBUG || QA
        return config(key: "WM_UNIVERSALLINK_TEST_DOMAIN")
    #else
        return config(key: "WM_UNIVERSALLINK_DOMAIN")
    #endif
}
