//
//  RealmManager.swift
//  Utility
//
//  Created by KTH on 2023/04/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import LogManager
import Realm
import RealmSwift

/**
 schemaVersion 업데이트 기록
 v1
 - PlayedLists 엔티티 추가
    - 재생목록 저장을 위한 엔티티

 v2
 - PlaylistLocalEntity 엔티티 추가
    - 재생목록 저장을 위한 엔티티 (리팩토링 버전)
 - 기존 PlayedList는 레거시로 판정하여 migration 과정에서 데이터 모두 제거
 */
// Realm이 Sendable을 채택하지 않아서 @unchecked 표시
public class RealmManager: NSObject, @unchecked Sendable {
    public static let shared = RealmManager()
    private let realm: Realm

    override init() {
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { database, oldSchemaVersion in
                if oldSchemaVersion < 1 {}
                if oldSchemaVersion < 2 {
                    database.deleteData(forType: PlayedLists.className())
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config

        do {
            realm = try Realm()
        } catch {
            LogManager.printError(error.localizedDescription)
            fatalError()
        }
        LogManager.printDebug(Realm.Configuration.defaultConfiguration.fileURL ?? "")

        super.init()
        DEBUG_LOG("✅ \(Self.self) init")
    }
}

public extension RealmManager {
    func addRealmDB<T>(model: T, update: Realm.UpdatePolicy = .all) {
        do {
            try self.realm.write {
                if let object = model as? Object {
                    self.realm.add(object, update: update)
                } else if let object = model as? [Object] {
                    self.realm.add(object, update: update)
                } else {
                    LogManager.printError("Object Casting Failed")
                }
            }
        } catch {
            LogManager.printError(error.localizedDescription)
        }
    }

    func fetchRealmDB<T: Object>() -> Results<T> {
        self.realm.objects(T.self)
    }

    func fetchRealmDB<T: Object>(_ type: T.Type) -> Results<T> {
        self.realm.objects(type)
    }

    func fetchRealmDB<T: Object, KeyType>(_ type: T.Type, primaryKey: KeyType) -> T? {
        self.realm.object(ofType: type, forPrimaryKey: primaryKey)
    }

    func deleteRealmDB<T: Object>(model: Results<T>) {
        do {
            try self.realm.write {
                self.realm.delete(model)
            }
        } catch {
            LogManager.printError(error.localizedDescription)
        }
    }

    func deleteRealmDB<T: Object>(model: [T]) {
        do {
            try self.realm.write {
                self.realm.delete(model)
            }
        } catch {
            LogManager.printError(error.localizedDescription)
        }
    }
}

public extension Results {
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}
