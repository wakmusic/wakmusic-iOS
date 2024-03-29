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

            let allItemsNotPlaying = list.allSatisfy { $0.isPlaying == false }
            if oldValue.isEmpty && !list.isEmpty && allItemsNotPlaying {
                changeCurrentPlayIndex(to: 0)
            }
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

    public var currentPlayIndex: Int? { return list.firstIndex(where: { $0.isPlaying == true }) }
    public var currentPlaySong: SongEntity? { list[safe: currentPlayIndex ?? -1]?.item }
    public var first: SongEntity? { return list.first?.item }
    public var last: SongEntity? { return list.last?.item }
    public var count: Int { return list.count }
    public var lastIndex: Int { return list.count - 1 }
    public var isEmpty: Bool { return list.isEmpty }
    public var isFirst: Bool { return currentPlayIndex == 0 }
    public var isLast: Bool { return currentPlayIndex == lastIndex }

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
        // 재생중인 곡을 삭제하는 경우 CurrentPlayIndex를 다음으로 옮기고, 옮겨진 currentPlayIndex에 해당하는 곡을 재생
        if let currentPlayIndex = currentPlayIndex, index == currentPlayIndex {
            changeCurrentPlayIndexToNext()
            if let currentPlayIndex = self.currentPlayIndex,
               let song = list[safe: currentPlayIndex]?.item {
                currentPlaySongChanged.send(song)
            }
        }

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
        PlayState.shared.stop()
        PlayState.shared.switchPlayerMode(to: .mini)
        listRemoved.send(list)
    }

    public func contains(_ item: PlayListItem) -> Bool {
        return list.contains(item)
    }

    public func changeCurrentPlayIndex(to index: Int) {
        let currentPlayIndex = currentPlayIndex ?? 0
        list[currentPlayIndex].isPlaying = false
        list[index].isPlaying = true
        currentPlayIndexChanged.send(list)
    }

    public func changeCurrentPlayIndexToPrevious() {
        guard let currentPlayIndex = currentPlayIndex else { return }
        let previousIndex = (currentPlayIndex - 1 + list.count) % list.count
        changeCurrentPlayIndex(to: previousIndex)
    }

    public func changeCurrentPlayIndexToNext() {
        guard let currentPlayIndex = currentPlayIndex else { return }
        let nextIndex = (currentPlayIndex + 1 + list.count) % list.count
        changeCurrentPlayIndex(to: nextIndex)
    }

    public func reorderPlaylist(from: Int, to: Int) {
        let movedData = list[from]
        list.remove(at: from)
        list.insert(movedData, at: to)
        // Comment: 순서가 변경되어도 DB를 업데이트 하지 않음
        // listReordered.send(list)
    }

    /// 해당 곡이 이미 재생목록에 있으면 재생목록 속 해당 곡의 index, 없으면 nil 리턴
    public func uniqueIndex(of item: PlayListItem) -> Int? {
        return list.firstIndex(where: { $0.item == item.item })
    }
}
