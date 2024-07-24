import Foundation
import ReactorKit

final class CheckThumbnailReactor: Reactor {
    #warning("가이드라인 UseCase 주입하기")
    enum Action {
        case viewDidLoad
    }

    enum Mutation {
        case updateGuideLine([String])
        case updateLoadingState(Bool)
    }

    struct State {
        var imageData: Data
        var guideLines: [String]
        var isLoading: Bool
    }

    var initialState: State

    init(imageData: Data) {
        initialState = State(imageData: imageData, guideLines: [], isLoading: true)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return updateGuideLine()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateGuideLine(text):
            newState.guideLines = text
        case let .updateLoadingState(isLoading):
            newState.isLoading = isLoading
        }

        return newState
    }
}

extension CheckThumbnailReactor {
    func updateGuideLine() -> Observable<Mutation> {
        #warning("유즈케이스로 교체하기")

        return .concat([
            .just(.updateLoadingState(true)),
            .just(.updateGuideLine([
                "이미지를 변경하면 음표 열매 3개를 소모합니다.",
                "너무 큰 이미지는 서버에 과부화가 올 수있으니 어쩌고 샴퓨님샴퓨님샴퓨님샴퓨님샴퓨님샴퓨님샴퓨님샴퓨님샴퓨님샴퓨님샴퓨님샴퓨님샴퓨님샴퓨님샴퓨님샴퓨님샴퓨님샴퓨님샴퓨님"
            ])),
            .just(.updateLoadingState(false)),
        ])
    }
}
