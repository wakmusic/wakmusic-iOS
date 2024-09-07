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

// MARK: - CDN Domain
public func CDN_DOMAIN_URL() -> String {
    return config(key: "CDN_DOMAIN_URL")
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
