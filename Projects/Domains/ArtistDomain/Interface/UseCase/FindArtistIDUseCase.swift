import RxSwift

public protocol FindArtistIDUseCase {
    func execute(name: String) -> Single<String>
}
