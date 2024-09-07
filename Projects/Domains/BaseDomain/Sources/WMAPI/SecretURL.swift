//
//  SecretURL.swift
//  BaseDomain
//
//  Created by KTH on 2024/03/04.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation

public func config(key: String) -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets[key] as? String ?? "not found key"
}

// MARK: - BASE_URL
public func BASE_URL() -> String {
    #if DEBUG || QA
        return config(key: "BASE_DEV_URL")
    #else
        return config(key: "BASE_PROD_URL")
    #endif
}

// MARK: - WMDomain
public func WMDOMAIN_AUTH() -> String {
    return config(key: "WMDOMAIN_AUTH")
}

public func WMDOMAIN_CHARTS() -> String {
    return config(key: "WMDOMAIN_CHARTS")
}

public func WMDOMAIN_SONGS() -> String {
    return config(key: "WMDOMAIN_SONGS")
}

public func WMDOMAIN_ARTIST() -> String {
    return config(key: "WMDOMAIN_ARTIST")
}

public func WMDOMAIN_USER() -> String {
    return config(key: "WMDOMAIN_USER")
}

public func WMDOMAIN_PLAYLIST() -> String {
    return config(key: "WMDOMAIN_PLAYLIST")
}

public func WMDOMAIN_LIKE() -> String {
    return config(key: "WMDOMAIN_LIKE")
}

public func WMDOMAIN_FAQ() -> String {
    return config(key: "WMDOMAIN_FAQ")
}

public func WMDOMAIN_NOTICE() -> String {
    return config(key: "WMDOMAIN_NOTICE")
}

public func WMDOMAIN_APP() -> String {
    return config(key: "WMDOMAIN_APP")
}

public func WMDOMAIN_SEARCH() -> String {
    return config(key: "WMDOMAIN_SEARCH")
}

public func WMDOMAIN_IMAGE() -> String {
    return config(key: "WMDOMAIN_IMAGE")
}

public func WMDOMAIN_NOTIFICATION() -> String {
    return config(key: "WMDOMAIN_NOTIFICATION")
}

public func WMDOMAIN_TEAM() -> String {
    return config(key: "WMDOMAIN_TEAM")
}

public func WMDOMAIN_PRICE() -> String {
    return config(key: "WMDOMAIN_PRICE")
}

public func WMDOMAIN_CREDIT() -> String {
    return config(key: "WMDOMAIN_CREDIT")
}
