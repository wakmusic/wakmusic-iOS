import FirebaseMessaging
import Foundation
import RxSwift

public extension Messaging {
    func fetchRxPushToken() -> Single<String> {
        return Single.create { single in
            self.token { token, error in
                if let error = error {
                    single(.failure(error))
                } else if let token = token {
                    single(.success(token))
                }
            }
            return Disposables.create()
        }
    }
}
