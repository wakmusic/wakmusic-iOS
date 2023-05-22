//
//  Secrets.swift
//  Utility
//
//  Created by KTH on 2023/04/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

//MARK: - BASE_IMAGE_URL
public func BASE_IMAGE_URL() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["BASE_IMAGE_URL"] as? String ?? "not found key"
}

//MARK: - WMDomain > Image
public func WMDOMAIN_IMAGE_NEWS() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WMDOMAIN_IMAGE_NEWS"] as? String ?? "not found key"
}
public func WMDOMAIN_IMAGE_ARTIST_ROUND() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WMDOMAIN_IMAGE_ARTIST_ROUND"] as? String ?? "not found key"
}
public func WMDOMAIN_IMAGE_ARTIST_SQUARE() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WMDOMAIN_IMAGE_ARTIST_SQUARE"] as? String ?? "not found key"
}
public func WMDOMAIN_IMAGE_PROFILE() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WMDOMAIN_IMAGE_PROFILE"] as? String ?? "not found key"
}
public func WMDOMAIN_IMAGE_PLAYLIST() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WMDOMAIN_IMAGE_PLAYLIST"] as? String ?? "not found key"
}
public func WMDOMAIN_IMAGE_RECOMMEND_PLAYLIST_SQUARE() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WMDOMAIN_IMAGE_RECOMMEND_PLAYLIST_SQUARE"] as? String ?? "not found key"
}
public func WMDOMAIN_IMAGE_RECOMMEND_PLAYLIST_ROUND() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WMDOMAIN_IMAGE_RECOMMEND_PLAYLIST_ROUND"] as? String ?? "not found key"
}
public func WMDOMAIN_IMAGE_NOTICE() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WMDOMAIN_IMAGE_NOTICE"] as? String ?? "not found key"
}

//MARK: - NAVER
public func NAVER_URL_SCHEME() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["NAVER_URL_SCHEME"] as? String ?? "not found key"
}
public func NAVER_CONSUMER_KEY() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["NAVER_CONSUMER_KEY"] as? String ?? "not found key"
}
public func NAVER_CONSUMER_SECRET() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["NAVER_CONSUMER_SECRET"] as? String ?? "not found key"
}
public func NAVER_APP_NAME() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["NAVER_APP_NAME"] as? String ?? "not found key"
}

//MARK: - GOOGLE
public func GOOGLE_URL_SCHEME() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["GOOGLE_URL_SCHEME"] as? String ?? "not found key"
}
public func GOOGLE_CLIENT_ID() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["GOOGLE_CLIENT_ID"] as? String ?? "not found key"
}
public func GOOGLE_SECRET_KEY() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["GOOGLE_SECRET_KEY"] as? String ?? "not found key"
}

//WAKTAVERSEMUSIC
public func WM_APP_ID() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WM_APP_ID"] as? String ?? ""
}
