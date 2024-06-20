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

public struct PlayListItem: Equatable {
    public var item: SongEntity
    public var isPlaying: Bool

    public init(item: SongEntity, isPlaying: Bool = false) {
        self.item = item
        self.isPlaying = isPlaying
    }

    public static func == (lhs: PlayListItem, rhs: PlayListItem) -> Bool {
        return lhs.item == rhs.item && lhs.item.isSelected == rhs.item.isSelected && lhs.isPlaying == rhs.isPlaying
    }
}

public class PlayList {
    public var list: [PlayListItem] {
        didSet(oldValue) {
            listChanged.send(list)
        }
    }

    public var listChanged = PassthroughSubject<[PlayListItem], Never>()
    public var listAppended = PassthroughSubject<[PlayListItem], Never>()
    public var listRemoved = PassthroughSubject<[PlayListItem], Never>()
    public var listReordered = PassthroughSubject<[PlayListItem], Never>()
    public var currentPlayIndexChanged = PassthroughSubject<[PlayListItem], Never>()
    public var currentPlaySongChanged = PassthroughSubject<SongEntity, Never>()

    public init(list: [PlayListItem] = []) {
        self.list = list
    }

    public var count: Int { return list.count }
    public var isEmpty: Bool { return list.isEmpty }

    public func append(_ item: PlayListItem) {
        list.append(item)
        listAppended.send(list)
    }

    public func append(_ items: [PlayListItem]) {
        list.append(contentsOf: items)
        listAppended.send(list)
    }

    public func insert(_ newElement: PlayListItem, at: Int) {
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

    public func contains(_ item: PlayListItem) -> Bool {
        return list.contains(item)
    }

    public func reorderPlaylist(from: Int, to: Int) {
        let movedData = list[from]
        list.remove(at: from)
        list.insert(movedData, at: to)
    }

    /// 해당 곡이 이미 재생목록에 있으면 재생목록 속 해당 곡의 index, 없으면 nil 리턴
    public func uniqueIndex(of item: PlayListItem) -> Int? {
        return list.firstIndex(where: { $0.item == item.item })
    }
}
