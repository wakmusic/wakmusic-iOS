import Foundation

public extension Int {
    func toWMDateString() -> String {
        // TODO: API 협의 후 변경할 예정입니다.
        return String(self)
    }
    
    /// DateFormat의 형태를 변경합니다.
    /// - Parameter origin: 원본 포맷 (ex: yyyy-MM-dd HH:mm:ss)
    /// - Parameter result: 바꾸기 원하는 포맷 (ex: HH:mm)
    /// - Returns: 변환 된 값
    func changeDateFormat(origin: String, result: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = origin
        formatter.locale = .current
        
        guard let dateFromString = formatter.date(from: String(self)) else { return "" }
        
        formatter.dateFormat = result
        let stringFromDate = formatter.string(from: dateFromString)
        return stringFromDate
    }
}
