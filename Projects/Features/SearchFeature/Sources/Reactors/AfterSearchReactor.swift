import Foundation
import ReactorKit
import RxSwift
import SongsDomainInterface
import LogManager

public final class AfterSearchReactor: Reactor {
    
    var disposeBag: DisposeBag = DisposeBag()
    var fetchSearchSongUseCase: FetchSearchSongUseCase
    
    public enum Action {
        case fetchData(String)
    }
    
    public enum Mutation {
        case fetchData([[SearchSectionModel]])
    }
    
    public struct State {
        var dataSource: [[SearchSectionModel]]
        var text: String
    }
    
    public var initialState: State
    
    init(fetchSearchSongUseCase: FetchSearchSongUseCase) {
        self.fetchSearchSongUseCase = fetchSearchSongUseCase
        self.initialState = State(
            dataSource: [],
            text: ""
        )
    }
    
    deinit {
        LogManager.printDebug("\(Self.self)")
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        
        var newState = state
        
        switch mutation {
            
        case let .fetchData(data):
            newState.dataSource = data
        }
        
        return newState
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
            
        case let .fetchData(text):
            return fetchData(text)
        }
        
    }
}

extension AfterSearchReactor {
    func fetchData(_ text: String) -> Observable<Mutation> {
        
        return fetchSearchSongUseCase
            .execute(keyword: text)
            .asObservable()
            .map { res in

                let r1 = res.song
                let r2 = res.artist
                let r3 = res.remix

                let limitCount: Int = 3

                let all: [SearchSectionModel] = [
                    SearchSectionModel(
                        model: (.song, r1.count),
                        items: r1.count > limitCount ? Array(r1[0 ... limitCount - 1]) : r1
                    ),
                    SearchSectionModel(
                        model: (.artist, r2.count),
                        items: r2.count > limitCount ? Array(r2[0 ... limitCount - 1]) : r2
                    ),
                    SearchSectionModel(
                        model: (.remix, r3.count),
                        items: r3.count > limitCount ? Array(r3[0 ... limitCount - 1]) : r3
                    )
                ]

                var results: [[SearchSectionModel]] = []
                results.append(all)
                results.append([SearchSectionModel(model: (.song, r1.count), items: r1)])
                results.append([SearchSectionModel(model: (.artist, r2.count), items: r2)])
                results.append([SearchSectionModel(model: (.remix, r3.count), items: r3)])

                return results
            }
            .map{ Mutation.fetchData($0) }
        
    }
}
