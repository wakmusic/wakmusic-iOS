import Foundation
import LogManager
import ReactorKit
import RxSwift
import SongsDomainInterface

public final class AfterSearchReactor: Reactor {
    var disposeBag: DisposeBag = DisposeBag()

    public enum Action {
        case updateData(String)
    }

    public enum Mutation {
        case updateData([[SearchSectionModel]])
    }

    public struct State {
        var dataSource: [[SearchSectionModel]]
        var text: String
    }

    public var initialState: State

    init() {
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
        case let .updateData(data):
            newState.dataSource = data
        }

        return newState
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateData(text):
            return fetchData(text)
        }
    }
}

private extension AfterSearchReactor {
    func fetchData(_ text: String) -> Observable<Mutation> {
        return Observable.just(SearchResultEntity(song: [], artist: [], remix: []))
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
            .map { Mutation.updateData($0) }
    }
}
