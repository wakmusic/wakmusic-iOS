import Foundation
import FirebaseMessaging
import RxSwift

extension Messaging {
    func fetchAsyncPushToken() async throws -> String {
        let token = try await self.token()
        return token
    }
    
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
