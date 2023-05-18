//
//  PlayerViewModel+Util.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/03/31.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

// MARK: - 뷰모델 내 유틸리티 함수들을 모아놓은 곳입니다.
extension PlayerViewModel {
    
    func formatTime(_ second: Double) -> String {
        let second = Int(floor(second))
        let min = second / 60
        let sec = String(format: "%02d", second % 60)
        return "\(min):\(sec)"
    }
    
    func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        
        let correctNumber: Int = max(0, number)
        
        switch correctNumber {
        case 0..<1000:
            return String(correctNumber)
        case 1000..<10_000:
            let thousands = Double(correctNumber) / 1000.0
            return formatter.string(from: NSNumber(value: thousands))! + "천"
        case 10_000..<100_000_0:
            let tenThousands = Double(correctNumber) / 10000.0
            return formatter.string(from: NSNumber(value: tenThousands))! + "만"
        case 100_000_0..<100_000_000:
            let tenThousands = Int(correctNumber) / 10000
            return formatter.string(from: NSNumber(value: tenThousands))! + "만"
        default:
            let millions = Double(correctNumber) / 100000000.0
            return formatter.string(from: NSNumber(value: millions))! + "억"
        }
    }
    
    func getCurrentLyricsIndex(_ currentTime: Float) -> Int {
        let times = lyricsDict.keys.sorted()
        let index = closestIndex(to: currentTime, in: times)
        return index
    }
    
    /// target보다 작거나 같은 값 중에서 가장 가까운 값을 찾습니다. O(log n)
    func closestIndex(to target: Float, in arr: [Float]) -> Int {
        var left = 0
        var right = arr.count - 1
        var closestIndex = 0
        var closestDistance = Float.greatestFiniteMagnitude
        
        while left <= right {
            let mid = (left + right) / 2
            let midValue = arr[mid]
            
            if midValue <= target {
                let distance = target - midValue
                if distance < closestDistance {
                    closestDistance = distance
                    closestIndex = mid
                }
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
        
        return closestIndex
    }
}
