import RxSwift

public protocol LocalAuthDataSource: Sendable {
    func logout()
    func checkIsExistAccessToken() -> Bool
}
