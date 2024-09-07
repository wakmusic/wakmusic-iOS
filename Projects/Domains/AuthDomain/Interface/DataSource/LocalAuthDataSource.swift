import RxSwift

public protocol LocalAuthDataSource {
    func logout()
    func checkIsExistAccessToken() -> Bool
}
