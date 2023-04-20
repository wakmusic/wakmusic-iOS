//
//  RealmModel.swift
//  Utility
//
//  Created by KTH on 2023/04/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RealmSwift

public final class PlayedLists: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var artist: String = ""
    @objc dynamic var remix: String = ""
    @objc dynamic var reaction: String = ""
    @objc dynamic var views: Int = 0
    @objc dynamic var last: Int = 0
    @objc dynamic var date: String = ""

    public override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(
        id: String,
        title: String,
        artist: String,
        remix: String,
        reaction: String,
        views: Int,
        last: Int,
        date: String
    ) {
        self.init()
        self.id = id
        self.title = title
        self.artist = artist
        self.remix = remix
        self.reaction = reaction
        self.views = views
        self.last = last
        self.date = date
    }
}
