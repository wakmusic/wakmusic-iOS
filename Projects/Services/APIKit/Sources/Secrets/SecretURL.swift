//
//  SecretURL.swift
//  APIKit
//
//  Created by KTH on 2023/04/25.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

//MARK: - BASE_URL
public func BASE_URL() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["BASE_URL"] as? String ?? "not found key"
}

//MARK: - WAKENTER_BASE_URL
public func WAKENTER_BASE_URL() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WAKENTER_BASE_URL"] as? String ?? "not found key"
}

//MARK: - WMDomain
public func WMDOMAIN_AUTH() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WMDOMAIN_AUTH"] as? String ?? "not found key"
}
public func WMDOMAIN_CHARTS() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WMDOMAIN_CHARTS"] as? String ?? "not found key"
}
public func WMDOMAIN_SONGS() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WMDOMAIN_SONGS"] as? String ?? "not found key"
}
public func WMDOMAIN_ARTIST() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WMDOMAIN_ARTIST"] as? String ?? "not found key"
}
public func WMDOMAIN_USER() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WMDOMAIN_USER"] as? String ?? "not found key"
}
public func WMDOMAIN_PLAYLIST() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WMDOMAIN_PLAYLIST"] as? String ?? "not found key"
}
public func WMDOMAIN_LIKE() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WMDOMAIN_LIKE"] as? String ?? "not found key"
}
public func WMDOMAIN_QNA() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WMDOMAIN_QNA"] as? String ?? "not found key"
}
public func WMDOMAIN_NOTICE() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WMDOMAIN_NOTICE"] as? String ?? "not found key"
}
public func WMDOMAIN_SUGGEST() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WMDOMAIN_SUGGEST"] as? String ?? "not found key"
}
public func WMDOMAIN_APP() -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets["WMDOMAIN_VERSION"] as? String ?? "not found key"
}
