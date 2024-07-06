//
//  PlayState+Playlist.swift
//  CommonFeature
//
//  Created by YoungK on 2023/04/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Combine
import Foundation
import SongsDomainInterface
import Utility

public struct PlaylistItem: Equatable {
    public let id: String
    public let title: String
    public let artist: String
    public let date: Date

    public init(
        id: String,
        title: String,
        artist: String,
        date: Date
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.date = date
    }

    public init(item: SongEntity) {
        self.id = item.id
        self.title = item.title
        self.artist = item.artist
        self.date = item.date.toDateCustomFormat(format: "yyyy.MM.dd")
    }
}

public class Playlist {
    public var list: [PlaylistItem] {
        didSet(oldValue) {
            listChanged.send(list)
        }
    }

    public var listChanged = PassthroughSubject<[PlaylistItem], Never>()
    public var listAppended = PassthroughSubject<[PlaylistItem], Never>()
    public var listRemoved = PassthroughSubject<[PlaylistItem], Never>()
    public var listReordered = PassthroughSubject<[PlaylistItem], Never>()
    public var currentPlayIndexChanged = PassthroughSubject<[PlaylistItem], Never>()

    public init(list: [PlaylistItem] = []) {
        self.list = list
    }

    public var count: Int { return list.count }
    public var isEmpty: Bool { return list.isEmpty }

    public func append(_ item: PlaylistItem) {
        list.append(item)
        listAppended.send(list)
    }

    public func append(_ items: [PlaylistItem]) {
        list.append(contentsOf: items)
        listAppended.send(list)
    }

    public func insert(_ newElement: PlaylistItem, at: Int) {
        list.insert(newElement, at: at)
        listAppended.send(list)
    }

    private func remove(at index: Int) {
        list.remove(at: index)
    }

    public func remove(indexs: [Int]) {
        let sortedIndexs = indexs.sorted(by: >) // 앞에서부터 삭제하면 인덱스 순서가 바뀜
        sortedIndexs.forEach { index in
            remove(at: index)
        }
        listRemoved.send(list)
    }

    public func removeAll() {
        list.removeAll()
        listRemoved.send(list)
    }

    public func contains(_ item: PlaylistItem) -> Bool {
        return list.contains(item)
    }

    public func reorderPlaylist(from: Int, to: Int) {
        let movedData = list[from]
        list.remove(at: from)
        list.insert(movedData, at: to)
    }

    /// 해당 곡이 이미 재생목록에 있으면 재생목록 속 해당 곡의 index, 없으면 nil 리턴
    public func uniqueIndex(of item: PlaylistItem) -> Int? {
        return list.firstIndex(of: item)
    }
}
