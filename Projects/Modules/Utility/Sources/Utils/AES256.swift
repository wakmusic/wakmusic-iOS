//
//  AES256.swift
//  BaseFeature
//
//  Created by KTH on 2023/11/26.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import CryptoSwift
import Foundation

public enum AES256 {
    /// 키값 32바이트: AES256(24bytes: AES192, 16bytes: AES128)
    private static let SECRET_KEY = "01234567890123450123456789012345"
    private static let IV = "0123456789012345"
}

public extension AES256 {
    static func encrypt(string: String) -> String {
        guard !string.isEmpty else { return "" }
        guard let result = try? getAESObject()?.encrypt(string.bytes).toBase64() else {
            return ""
        }
        return result
    }

    static func decrypt(encoded: String) -> String {
        guard !encoded.isEmpty else {
            return ""
        }
        guard let datas = Data(base64Encoded: encoded) else {
            return ""
        }
        let bytes = datas.bytes
        guard let decode = try? getAESObject()?.decrypt(bytes) else {
            return ""
        }
        return String(bytes: decode, encoding: .utf8) ?? ""
    }
}

private extension AES256 {
    static func getAESObject() -> AES? {
        let keyDecodes: [UInt8] = Array(SECRET_KEY.utf8)
        let ivDecodes: [UInt8] = Array(IV.utf8)
        let aesObject = try? AES(key: keyDecodes, blockMode: CBC(iv: ivDecodes), padding: .pkcs5)
        return aesObject
    }
}
