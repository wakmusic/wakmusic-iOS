import Foundation

public protocol AnalyticsLogType: Sendable {
    var name: String { get }
    var params: [String: Any] { get }
}

public extension AnalyticsLogType {
    var name: String {
        Mirror(reflecting: self)
            .children
            .first?
            .label?
            .toSnakeCase() ?? String(describing: self).toSnakeCase()
    }

    var params: [String: Any] {
        var dict: [String: Any] = [:]

        let enumMirror = Mirror(reflecting: self)

        guard let associated = enumMirror.children.first else { return dict }

        for enumParams in Mirror(reflecting: associated.value).children {
            guard let label = enumParams.label?.toSnakeCase() else { continue }
            dict[label] = enumParams.value
        }

        return dict
    }
}

private extension String {
    func toSnakeCase() -> String {
        var result = ""
        var previousStringWasCapitalized = false
        var previousStringWasNumber = false

        for (index, string) in self.enumerated() {
            var mutableString = String(string)

            if !mutableString.isAlphabet {
                if index != 0,
                   !previousStringWasNumber {
                    mutableString = "_" + mutableString
                }
                previousStringWasNumber = true
            } else if mutableString == mutableString.uppercased() {
                mutableString = mutableString.lowercased()

                // e.g. JSON으로 오면 j_s_o_n 이런식이 아닌 json 이렇게 바뀌도록
                if index != 0,
                   !previousStringWasCapitalized {
                    mutableString = "_" + mutableString
                }
                previousStringWasCapitalized = true
            } else {
                previousStringWasCapitalized = false
                previousStringWasNumber = false
            }
            result += mutableString
        }
        return result
    }

    var isAlphabet: Bool {
        let alphabetSet = CharacterSet.uppercaseLetters.union(.lowercaseLetters).union(.whitespacesAndNewlines)
        return self.rangeOfCharacter(from: alphabetSet.inverted) == nil
    }
}
