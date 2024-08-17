import Foundation

public protocol UserPropertyRepresentable {
    var key: String { get }
    var value: String? { get }
}

public enum AnalyticsUserProperty {
    case loginPlatform(platform: String)
    case fruitTotal(count: Int)
    case playlistSongTotal(count: Int)
    case latestSearchKeyword(keyword: String)
}

extension AnalyticsUserProperty: UserPropertyRepresentable {
    public var key: String {
        Mirror(reflecting: self)
            .children
            .first?
            .label?
            .toSnakeCase() ?? String(describing: self).toSnakeCase()
    }

    public var value: String? {
        switch self {
        case .loginPlatform(let platform): return platform
        case .fruitTotal(let count): return "\(count)"
        case .playlistSongTotal(let count): return "\(count)"
        case .latestSearchKeyword(let keyword): return keyword
        }
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
