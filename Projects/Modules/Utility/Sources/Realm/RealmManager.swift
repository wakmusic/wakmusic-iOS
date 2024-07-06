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

public class RealmManager: NSObject {
    public static let shared = RealmManager()
    private var realm: Realm!

    override init() {
        super.init()
        DEBUG_LOG("✅ \(Self.self) init")
    }

    public func register() {
        // Realm DataBase Migration 하려면 아래의 schemaVersion을 +1 해줘야 합니다.
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

        // init
        do {
            realm = try Realm()
        } catch {
            LogManager.printError(error.localizedDescription)
        }
        LogManager.printDebug(Realm.Configuration.defaultConfiguration.fileURL ?? "")
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

    func deleteRealmDB<T: Object>(model: Results<T>) {
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
