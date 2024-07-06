//
//  RealmModel.swift
//  Utility
//
//  Created by KTH on 2023/04/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RealmSwift

@available(*, deprecated, message: "PlaylistLocalEntity로 전환. 해당 객체는 사용하지 말아주세요.")
public final class PlayedLists: Object {
    @objc public dynamic var id: String = ""
    @objc public dynamic var title: String = ""
    @objc public dynamic var artist: String = ""
    @objc public dynamic var remix: String = ""
    @objc public dynamic var reaction: String = ""
    @objc public dynamic var views: Int = 0
    @objc public dynamic var last: Int = 0
    @objc public dynamic var date: String = ""
    @objc public dynamic var likes: Int = 0
    @objc public dynamic var lastPlayed: Bool = false

    override public static func primaryKey() -> String? {
        return "id"
    }

    public convenience init(
        id: String,
        title: String,
        artist: String,
        remix: String,
        reaction: String,
        views: Int,
        last: Int,
        date: String,
        likes: Int = 0,
        lastPlayed: Bool
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
        self.likes = 0
        self.lastPlayed = lastPlayed
    }
}
