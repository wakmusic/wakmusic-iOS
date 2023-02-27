import Foundation

public extension Int {
    
    /// Int 값을 받으면 세번쨰 자리마다 ,를 삽입하여 반환합니다.
    /// - Returns: 세 자리마다 ,가 들어간 String
    func addCommaToNumber() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: self))!
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
