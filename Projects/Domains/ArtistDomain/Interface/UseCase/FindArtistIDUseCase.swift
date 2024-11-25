import RxSwift

public protocol FindArtistIDUseCase: Sendable {
    func execute(name: String) -> Single<String>
}
