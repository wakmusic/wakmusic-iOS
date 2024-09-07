//
//  Extension+String.swift
//  Utility
//
//  Created by KTH on 2023/01/02.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    ///   문자열이 스페이스바 또는 공백으로만 이뤄졌는지 체크
    /// - Returns: 완전환 공백 체크 = true
    var isWhiteSpace: Bool {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }

    /// String(text) 높이 값을 계산하여 반환합니다.
    /// - Parameter width: 스트링이 들어갈 최대 너비
    /// - Parameter font: 사용 된 폰트 값
    /// - Returns: String 높이 값
    func heightConstraintAt(width: CGFloat, font: UIFont) -> CGFloat {
        // greatestFiniteMagnitude: CGFloat 타입이 가질 수 있는 최대 유한 값
        // boundingRect 함수의 파람으로 넘겨줄 CGSize 생성 시에 일단 최대로 잡아둡니다.
        // 여기서는 '높이'를 구할 것이기 때문에 String이 들어갈 최대 너비 값이 몇이냐가 중요합니다.
        // 반대로 '너비'를 구할때는 width에 greatestFiniteMagnitude를 넣어두시면 됩니다.
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)

        // boundingRect: 사각형 내부에서 옵션들과 표시 특성등을 활용하여 사각형을 계산하고 반환합니다.
        // https://onemoonstudio.tistory.com/2
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )

        return boundingBox.height
    }

    /// String(text)의 첫 글자만 대문자로 변환합니다.
    var capitalizingFirstLetter: String {
        // 첫 글자는 대문자로 + 대문자로 변환한 첫 글자는 잘라낸 후 더한다.
        return prefix(1).uppercased() + self.dropFirst()
    }

    var correctionNickName: String {
        let limit: Int = 8
        return self.count > limit ? String(self.prefix(limit)) + "..." : self
    }

    func createRandomStr(length: Int) -> String {
        let str = (0 ..< length).map { _ in self.randomElement()! }
        return String(str)
    }

    func toDateCustomFormat(format: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self) ?? .init()
    }

    var isContainShortsTagTitle: Bool {
        return self.lowercased().contains("#Shorts".lowercased())
    }
}
