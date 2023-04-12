//
//  PlayState+Playlist.swift
//  CommonFeature
//
//  Created by YoungK on 2023/04/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DomainModule
import Combine

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

extension PlayState {
    public class PlayList {
        public var list: [PlayListItem] {
            didSet(oldValue) {
                listChanged.send(list)
                if oldValue.isEmpty { changeCurrentPlayIndex(to: 0) }
            }
        }
        public var listChanged: CurrentValueSubject<[PlayListItem], Never>
        
        init(list: [PlayListItem] = []) {
            self.list = list
            self.listChanged = .init([])
        }
        public var currentPlayIndex: Int? { return list.firstIndex(where: { $0.isPlaying == true }) }
        public var first: SongEntity? { return list.first?.item }
        public var last: SongEntity? { return list.last?.item }
        public var count: Int { return list.count }
        public var lastIndex: Int { return list.count - 1 }
        public var isEmpty: Bool { return list.isEmpty }
        public var isFirst: Bool { return currentPlayIndex == 0 }
        public var isLast: Bool { return currentPlayIndex == lastIndex }
        
        public func append(_ item: PlayListItem) {
            list.append(item)
        }
        
        public func insert(_ newElement: PlayListItem, at: Int) {
            list.insert(newElement, at: at)
        }
        
        public func remove(at index: Int) {
            if let currentPlayIndex = currentPlayIndex, index == currentPlayIndex {
                changeCurrentPlayIndexToNext()
            }
            
            list.remove(at: index)
            
            if let currentPlayIndex = currentPlayIndex, index == currentPlayIndex {
                PlayState.shared.currentSong = list[currentPlayIndex].item
                PlayState.shared.loadInPlaylist(at: currentPlayIndex)
            }
        }
        
        public func remove(indexs: [Int]) {
            let sortedIndexs = indexs.sorted(by: >) // 앞에서부터 삭제하면 인덱스 순서가 바뀜
            sortedIndexs.forEach { index in
                remove(at: index)
            }
        }
        
        public func removeAll() {
            list.removeAll()
        }
        
        public func contains(_ item: PlayListItem) -> Bool {
            return list.contains(item)
        }
        
        public func changeCurrentPlayIndex(to index: Int) {
            let currentPlayIndex = currentPlayIndex ?? 0
            list[currentPlayIndex].isPlaying = false
            list[index].isPlaying = true
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
        }
        
        public func uniqueIndex(of item: PlayListItem) -> Int? {
            // 해당 곡이 이미 재생목록에 있으면 재생목록 속 해당 곡의 index, 없으면 nil 리턴
            return list.firstIndex(where: { $0.item == item.item })
        }
        
    }
    
}
