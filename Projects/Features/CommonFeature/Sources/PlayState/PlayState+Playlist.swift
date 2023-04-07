//
//  PlayState+Playlist.swift
//  CommonFeature
//
//  Created by YoungK on 2023/04/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DomainModule

extension PlayState {
    public class PlayList {
        @Published public var list: [SongEntity]
        @Published public var currentPlayIndex: Int // 현재 재생중인 노래 인덱스 번호
        
        init(list: [SongEntity] = []) {
            self.list = list
            currentPlayIndex = 0
        }
        
        public var first: SongEntity? { return list.first }
        public var last: SongEntity? { return list.last }
        public var current: SongEntity? { return list[currentPlayIndex] }
        public var count: Int { return list.count }
        public var lastIndex: Int { return list.count - 1 }
        public var isEmpty: Bool { return list.isEmpty }
        public var isLast: Bool { return currentPlayIndex == lastIndex }
        
        public func append(_ item: SongEntity) {
            list.append(item)
        }
        
        public func insert(_ newElement: SongEntity, at: Int) {
            list.insert(newElement, at: at)
        }
        
        public func remove(at: Int) {
            list.remove(at: at)
        }
        
        public func removeAll() {
            list.removeAll()
        }
        
        public func contains(_ item: SongEntity) -> Bool {
            return list.contains(item)
        }
        
        public func back() {
            // 현재 곡이 첫번째 곡이면 마지막 곡으로
            if currentPlayIndex == 0 { currentPlayIndex = lastIndex; return }
            currentPlayIndex -= 1
        }
        
        public func next() {
            // 현재 곡이 마지막이면 첫번째 곡으로
            if isLast { currentPlayIndex = 0; return }
            currentPlayIndex += 1
        }
        
        public func reorderPlaylist(from: Int, to: Int) {
            let movedData = list[from]
            list.remove(at: from)
            list.insert(movedData, at: to)
            
            if currentPlayIndex == from {
                currentPlayIndex = to
            } else if currentPlayIndex > from && currentPlayIndex <= to {
                currentPlayIndex -= 1
            } else if currentPlayIndex < from && currentPlayIndex >= to {
                currentPlayIndex += 1
            }
        }
        
        public func uniqueIndex(of item: SongEntity) -> Int? {
            // 해당 곡이 이미 재생목록에 있으면 재생목록 속 해당 곡의 index, 없으면 nil 리턴
            for (index, song) in list.enumerated() {
                if song == item { return index }
            }
            return nil
        }
        
    }
    
}
