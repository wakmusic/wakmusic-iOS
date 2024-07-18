import Foundation
import LogManager
import RxSwift
import RxRelay
import BaseFeature
import TeamDomainInterface

public final class TeamInfoViewModel: ViewModelType {
    private let fetchTeamListUseCase: FetchTeamListUseCase
    private let disposeBag = DisposeBag()
    
    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }
    
    public init(
        fetchTeamListUseCase: any FetchTeamListUseCase
    ) {
        self.fetchTeamListUseCase = fetchTeamListUseCase
    }
    
    public struct Input {
        let fetchFruitList: PublishSubject<Void> = PublishSubject()
    }
    
    public struct Output {
    }
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        return output
    }
}
