//
//  PKCEManager.swift
//  Utility
//
//  Created by 김대희 on 2023/03/30.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import CryptoKit
import Foundation

struct PKCE {
    typealias PKCECode = String

    let codeVerifier: PKCECode // 임의로 생성한 ASCII 문자
    let codeChallenge: PKCECode // 임의로 생성한 codeVerifier Base64URL 인코딩된 SHA256 해시

    init() throws {
        codeVerifier = PKCE.generateCodeVerifier()
        codeChallenge = try PKCE.codeChallenge(fromVerifier: codeVerifier)
    }

    static func codeChallenge(fromVerifier verifier: PKCECode) throws -> PKCECode {
        guard let verifierData = verifier.data(using: .ascii) else { throw PKCEError.improperlyFormattedVerifier }

        let challengeHashed = SHA256.hash(data: verifierData)
        let challengeBase64Encoded = Data(challengeHashed).base64URLEncodedString

        return challengeBase64Encoded
    }

    static func generateCodeVerifier() -> PKCECode {
        do {
            let rando = try PKCE.generateCryptographicallySecureRandomOctets(count: 32)
            return Data(bytes: rando, count: rando.count).base64URLEncodedString
        } catch {
            return generateBase64RandomString(ofLength: 43)
        }
    }

    private static func generateCryptographicallySecureRandomOctets(count: Int) throws -> [UInt8] {
        var octets = [UInt8](repeating: 0, count: count)
        let status = SecRandomCopyBytes(kSecRandomDefault, octets.count, &octets)

        if status == errSecSuccess {
            return octets
        } else {
            throw PKCEError.failedToGenerateRandomOctets
        }
    }

    private static func generateBase64RandomString(ofLength length: UInt8) -> PKCECode {
        let base64 = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< length).map { _ in base64.randomElement()! })
    }

    enum PKCEError: Error {
        case failedToGenerateRandomOctets
        case improperlyFormattedVerifier
    }
}

extension Data {
    var base64URLEncodedString: String {
        base64EncodedString()
            .replacingOccurrences(of: "=", with: "") // Remove any trailing '='s
            .replacingOccurrences(of: "+", with: "-") // 62nd char of encoding
            .replacingOccurrences(of: "/", with: "_") // 63rd char of encoding
            .trimmingCharacters(in: .whitespaces)
    }
}
