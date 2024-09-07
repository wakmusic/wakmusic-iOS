import Foundation
import UIKit

public extension Date {
    /// Date 값을 받으면 Chart의 Data 형식으로 바꿔줍니다.
    /// - Returns: MM월 dd일 a hh시 형식의 String
    func changeDateFormatForChart() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일 a hh시"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }

    func dateToString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
}
