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
public final class PreferenceManager: @unchecked Sendable {
    public static let shared: PreferenceManager = PreferenceManager()

    /// UserDefaults에 저장 된 데이터에 접근하기 위한 키 값의 나열.
    enum Constants: String {
        case user
        case recentRecords // 최근 검색어
        case startPage // 시작 페이지(탭)
        case appPermissionChecked // 앱 권한팝업 승인
        case ignoredPopupIDs // 다시보지 않는 팝업 IDs
        case readNoticeIDs // 이미 읽은 공지 IDs
        case pushNotificationAuthorizationStatus // 기기알림 on/off 상태
        case songPlayPlatformType // 유튜브뮤직으로 재생할지 여부
    }

    @UserDefaultWrapper(key: Constants.recentRecords.rawValue, defaultValue: nil)
    public var recentRecords: [String]?

    @UserDefaultWrapper(key: Constants.startPage.rawValue, defaultValue: nil)
    public var startPage: Int?

    @UserDefaultWrapper(key: Constants.user.rawValue, defaultValue: nil)
    public var userInfo: UserInfo?

    @UserDefaultWrapper(key: Constants.appPermissionChecked.rawValue, defaultValue: nil)
    public var appPermissionChecked: Bool?

    @UserDefaultWrapper(key: Constants.ignoredPopupIDs.rawValue, defaultValue: nil)
    public var ignoredPopupIDs: [Int]?

    @UserDefaultWrapper(key: Constants.readNoticeIDs.rawValue, defaultValue: nil)
    public var readNoticeIDs: [Int]?

    @UserDefaultWrapper(key: Constants.pushNotificationAuthorizationStatus.rawValue, defaultValue: nil)
    public var pushNotificationAuthorizationStatus: Bool?

    @UserDefaultWrapper(key: Constants.songPlayPlatformType.rawValue, defaultValue: YoutubePlayType.youtube)
    public var songPlayPlatformType: YoutubePlayType?
}

/// BehaviorSubject가 Sendable을 채택하지 않아 @unchecked
@propertyWrapper
public final class UserDefaultWrapper<T: Codable & Sendable>: @unchecked Sendable {
    private let lock = NSLock()
    private let key: String
    private let defaultValue: T?
    private let subject: BehaviorSubject<T?>

    init(key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue

        let initialValue: T?
        if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let lodedObejct = try? decoder.decode(T.self, from: savedData) {
                initialValue = lodedObejct
            } else {
                initialValue = nil
            }

        } else if UserDefaults.standard.array(forKey: key) != nil {
            initialValue = UserDefaults.standard.array(forKey: key) as? T
        } else {
            initialValue = defaultValue
        }
        self.subject = .init(value: initialValue)
    }

    public var wrappedValue: T? {
        get {
            if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let lodedObejct = try? decoder.decode(T.self, from: savedData) {
                    return lodedObejct
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

    public var projectedValue: Observable<T?> {
        return subject.asObservable()
    }
}
