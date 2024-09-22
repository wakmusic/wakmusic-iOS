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

final class Playlist {
    @Published private(set) var list: [PlaylistItem] = []

    init(list: [PlaylistItem] = []) {
        self.list = list
    }

    var count: Int { return list.count }
    var isEmpty: Bool { return list.isEmpty }

    internal func subscribeListChanges() -> AnyPublisher<[PlaylistItem], Never> {
        $list.eraseToAnyPublisher()
    }

    func append(_ item: PlaylistItem) {
        list.append(item)
    }

    func append(_ items: [PlaylistItem]) {
        list.append(contentsOf: items)
    }

    func insert(_ newElement: PlaylistItem, at: Int) {
        list.insert(newElement, at: at)
    }

    func update(contentsOf items: [PlaylistItem]) {
        list = items
    }

    func remove(at index: Int) {
        guard list[safe: index] != nil else { return }
        list.remove(at: index)
    }

    func remove(indexs: [Int]) {
        let sortedIndexs = indexs.sorted(by: >) // 앞에서부터 삭제하면 인덱스 순서가 바뀜
        sortedIndexs.forEach { index in
            remove(at: index)
        }
    }

    func remove(id: String) {
        if let index = list.firstIndex(where: { $0.id == id }) {
            remove(at: index)
        }
    }

    func removeAll() {
        list.removeAll()
    }

    func removeAll(where shouldBeRemoved: (PlaylistItem) -> Bool) {
        list.removeAll(where: shouldBeRemoved)
    }

    func contains(_ item: PlaylistItem) -> Bool {
        return list.contains(item)
    }

    func contains(id: String) -> Bool {
        return list.contains { $0.id == id }
    }

    func reorderPlaylist(from: Int, to: Int) {
        let movedData = list[from]
        list.remove(at: from)
        list.insert(movedData, at: to)
    }

    /// 해당 곡이 이미 재생목록에 있으면 재생목록 속 해당 곡의 index, 없으면 nil 리턴
    func uniqueIndex(of item: PlaylistItem) -> Int? {
        return list.firstIndex(of: item)
    }
}
