//
//  Extension+PreferenceManager.swift
//  Utility
//
//  Created by KTH on 2023/01/09.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift

public extension PreferenceManager {
    
    /// 최근 검색어를 저장
    /// - Parameter word: 최근 검색어
    func addRecentRecords(word: String) {
        let maxSize: Int = 10
        var currentRecentRecords = self.recentRecords
        
        if currentRecentRecords.contains(word) {
            if let i = currentRecentRecords.firstIndex(where: { $0 == word }){
                currentRecentRecords.remove(at: i)
                currentRecentRecords.insert(word, at: 0)
            }
            
        }else{
            if currentRecentRecords.count == maxSize {
                currentRecentRecords.removeLast()
            }
            currentRecentRecords.insert(word, at: 0)
        }
        
        // UserDefaults와 Rx Subject에 동기화
        UserDefaults.standard.set(currentRecentRecords, forKey: Constants.recentRecords.rawValue)
        
        
        recentRecordsSubject.onNext(currentRecentRecords)
    }
    
    /// 최근 검색어를 삭제
    /// - Parameter word: 최근 검색어
    func removeRecentRecords(word: String) {
        var currentRecentRecords = self.recentRecords

        if let i = currentRecentRecords.firstIndex(where: { $0 == word }){
            currentRecentRecords.remove(at: i)
        }
        
        UserDefaults.standard.set(currentRecentRecords, forKey: Constants.recentRecords.rawValue)
        recentRecordsSubject.onNext(currentRecentRecords)
    }
    
    /// 모든 최근 검색어를 삭제
    func allRemoveRecentRecords() {
        UserDefaults.standard.set(nil, forKey: Constants.recentRecords.rawValue)
        recentRecordsSubject.onNext([])
    }
}

extension PreferenceManager: ReactiveCompatible {}

public extension Reactive where Base: PreferenceManager {
    var recentRecords: Observable<[String]> {
        return base.recentRecordsSubject
    }
}
