//
//  PreferenceManager.swift
//  Utility
//
//  Created by KTH on 2023/01/09.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift

/// UserDefaults에 편리하게 접근하기 위한 클래스 정의
public final class PreferenceManager {
    public static let shared: PreferenceManager = PreferenceManager()

    /// UserDefaults에 저장 된 데이터에 접근하기 위한 키 값의 나열.
    enum Constants: String {
        case user
        case recentRecords // 최근 검색어
        case startPage // 시작 페이지(탭)
        case appPermissionChecked // 앱 권한팝업 승인
        case ignoredNoticeIDs // 다시보지 않는 공지 IDs
    }

    @UserDefaultWrapper(key: Constants.recentRecords.rawValue, defaultValue: nil)
    public static var recentRecords: [String]?

    @UserDefaultWrapper(key: Constants.startPage.rawValue, defaultValue: nil)
    public static var startPage: Int?

    @UserDefaultWrapper(key: Constants.user.rawValue, defaultValue: nil)
    public static var userInfo: UserInfo?

    @UserDefaultWrapper(key: Constants.appPermissionChecked.rawValue, defaultValue: nil)
    public static var appPermissionChecked: Bool?

    @UserDefaultWrapper(key: Constants.ignoredNoticeIDs.rawValue, defaultValue: nil)
    public static var ignoredNoticeIDs: [Int]?
}

@propertyWrapper
public final class UserDefaultWrapper<T: Codable> {
    private let key: String
    private let defaultValue: T?

    init(key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T? {
        get {
            if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let lodedObejct = try? decoder.decode(T.self, from: savedData) {
                    return lodedObejct

                    // v2.2.1 > v2.2.2 업데이트 유저 로그아웃 방지 대응
                } else if let loadedObject = try? JSONSerialization
                    .jsonObject(with: savedData, options: []) as? [String: Any] {
                    return UserInfo(
                        ID: loadedObject["ID"] as? String ?? "",
                        platform: loadedObject["platform"] as? String ?? "",
                        profile: loadedObject["profile"] as? String ?? "",
                        name: loadedObject["displayName"] as? String ?? "",
                        version: loadedObject["version"] as? Int ?? 0
                    ) as? T
                }

            } else if UserDefaults.standard.array(forKey: key) != nil {
                return UserDefaults.standard.array(forKey: key) as? T
            }
            return defaultValue
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.setValue(encoded, forKey: key)
            }
            subject.onNext(newValue)
        }
    }

    private lazy var subject = BehaviorSubject<T?>(value: wrappedValue)
    public var projectedValue: Observable<T?> {
        return subject.asObservable()
    }
}
