import AuthDomainInterface
import KeychainModule
import RxSwift
import Utility

public final class LocalAuthDataSourceImpl: LocalAuthDataSource {
    private let keychain: any Keychain

    public init(keychain: any Keychain) {
        self.keychain = keychain
    }

    public func logout() {
        keychain.delete(type: .accessToken)
        keychain.delete(type: .refreshToken)
        keychain.delete(type: .accessExpiresIn)
        PreferenceManager.userInfo = nil
    }
}
