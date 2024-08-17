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

    var toUnitNumber: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.roundingMode = .floor

        let correctNumber: Int = (self < 0) ? 0 : self

        switch correctNumber {
        case 0 ..< 1000:
            return String(correctNumber)
        case 1000 ..< 10000:
            let thousands = Double(correctNumber) / 1000.0
            return formatter.string(from: NSNumber(value: thousands))! + "천"
        case 10000 ..< 1_000_000:
            let tenThousands = Double(correctNumber) / 10000.0
            return formatter.string(from: NSNumber(value: tenThousands))! + "만"
        case 1_000_000 ..< 100_000_000:
            let tenThousands = Int(correctNumber) / 10000
            return formatter.string(from: NSNumber(value: tenThousands))! + "만"
        default:
            let millions = Double(correctNumber) / 100_000_000.0
            return formatter.string(from: NSNumber(value: millions))! + "억"
        }
    }

    func formattedWithComma() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        guard let result = numberFormatter.string(from: NSNumber(value: self)) else {
            return "0"
        }

        return result
    }
}
