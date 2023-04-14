//
//  Secrets.swift
//  Utility
//
//  Created by KTH on 2023/04/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

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
