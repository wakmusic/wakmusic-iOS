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
                
                let allItemsNotPlaying = list.allSatisfy { $0.isPlaying == false }
                if oldValue.isEmpty && !list.isEmpty && allItemsNotPlaying {
                    changeCurrentPlayIndex(to: 0)
                }
            }
        }
        public var listChanged = CurrentValueSubject<[PlayListItem], Never>([])
        public var listAppended = CurrentValueSubject<[PlayListItem], Never>([])
        public var listRemoved = CurrentValueSubject<[PlayListItem], Never>([])
        public var listReordered = CurrentValueSubject<[PlayListItem], Never>([])
        public var currentSongChanged = CurrentValueSubject<[PlayListItem], Never>([])
        
        init(list: [PlayListItem] = []) {
            self.list = list
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
            if let currentPlayIndex = currentPlayIndex, index == currentPlayIndex {
                changeCurrentPlayIndexToNext()
            }
            
            list.remove(at: index)
            
            if let currentPlayIndex = currentPlayIndex, index == currentPlayIndex {
                PlayState.shared.currentSong = list[safe: currentPlayIndex]?.item
                PlayState.shared.loadInPlaylist(at: currentPlayIndex)
            }
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
            currentSongChanged.send(list)
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
            listReordered.send(list)
        }
        
        /// 해당 곡이 이미 재생목록에 있으면 재생목록 속 해당 곡의 index, 없으면 nil 리턴
        public func uniqueIndex(of item: PlayListItem) -> Int? {
            return list.firstIndex(where: { $0.item == item.item })
        }
        
    }
    
}
