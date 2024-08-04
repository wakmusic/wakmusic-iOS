import BaseFeature
import Foundation
import Localization
import LogManager
import PlaylistDomainInterface
import ReactorKit
import RxCocoa
import RxSwift
import SongsDomainInterface
import UserDomainInterface
import Utility

final class ListStorageReactor: Reactor {
    enum Action {
        case viewDidLoad
        case refresh
        case itemMoved(ItemMovedEvent)
        case cellDidTap(Int)
        case listDidTap(IndexPath)
        case playDidTap(Int)
        case tapAll(isSelecting: Bool)
        case loginButtonDidTap
        case createListButtonDidTap
        case confirmCreateListButtonDidTap(String)
        case addToCurrentPlaylistButtonDidTap
        case deleteButtonDidTap
        case confirmDeleteButtonDidTap
        case drawFruitButtonDidTap
        case completedFruitDraw
    }

    enum Mutation {
        case clearDataSource
        case updateDataSource([MyPlayListSectionModel])
        case updateBackupDataSource([MyPlayListSectionModel])
        case undoDataSource
        case switchEditingState(Bool)
        case updateIsLoggedIn(Bool)
        case updateIsShowActivityIndicator(Bool)
        case showLoginAlert
        case showToast(String)
        case showCreateListPopup
        case showDeletePopup(Int)
        case showDetail(key: String)
        case hideSongCart
        case updateSelectedItemCount(Int)
        case showDrawFruitPopup
    }

    struct State {
        var isLoggedIn: Bool
        var isEditing: Bool
        var dataSource: [MyPlayListSectionModel]
        var backupDataSource: [MyPlayListSectionModel]
        var selectedItemCount: Int
        var isShowActivityIndicator: Bool
        @Pulse var showLoginAlert: Void?
        @Pulse var showToast: String?
        @Pulse var hideSongCart: Void?
        @Pulse var showCreateListPopup: Void?
        @Pulse var showDeletePopup: Int?
        @Pulse var showDetail: String?
        @Pulse var showDrawFruitPopup: Void?
    }

    var initialState: State
    private var disposeBag = DisposeBag()
    private let storageCommonService: any StorageCommonService
    private let createPlaylistUseCase: any CreatePlaylistUseCase
    private let fetchPlayListUseCase: any FetchPlaylistUseCase
    private let editPlayListOrderUseCase: any EditPlaylistOrderUseCase
    private let deletePlayListUseCase: any DeletePlaylistUseCase
    private let fetchPlaylistSongsUseCase: any FetchPlaylistSongsUseCase

    init(
        storageCommonService: any StorageCommonService,
        createPlaylistUseCase: any CreatePlaylistUseCase,
        fetchPlayListUseCase: any FetchPlaylistUseCase,
        editPlayListOrderUseCase: any EditPlaylistOrderUseCase,
        deletePlayListUseCase: any DeletePlaylistUseCase,
        fetchPlaylistSongsUseCase: any FetchPlaylistSongsUseCase
    ) {
        self.initialState = State(
            isLoggedIn: false,
            isEditing: false,
            dataSource: [],
            backupDataSource: [],
            selectedItemCount: 0,
            isShowActivityIndicator: false
        )
        self.storageCommonService = storageCommonService
        self.createPlaylistUseCase = createPlaylistUseCase
        self.fetchPlayListUseCase = fetchPlayListUseCase
        self.editPlayListOrderUseCase = editPlayListOrderUseCase
        self.deletePlayListUseCase = deletePlayListUseCase
        self.fetchPlaylistSongsUseCase = fetchPlaylistSongsUseCase
    }

    deinit {
        LogManager.printDebug("❌ Deinit \(Self.self)")
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return viewDidLoad()
        case .refresh:
            return fetchDataSource()

        case let .itemMoved((sourceIndex, destinationIndex)):
            return updateOrder(src: sourceIndex.row, dest: destinationIndex.row)

        case let .cellDidTap(index):
            return changeSelectingState(index)

        case let .listDidTap(indexPath):
            return showDetail(indexPath)

        case let .playDidTap(index):
            return playWithAddToCurrentPlaylist(index)

        case let .tapAll(isSelecting):
            return tapAll(isSelecting)

        case .loginButtonDidTap:
            return .just(.showLoginAlert)

        case .addToCurrentPlaylistButtonDidTap:
            return addToCurrentPlaylist()

        case .createListButtonDidTap:
            let isLoggedIn = currentState.isLoggedIn
            return isLoggedIn ? .just(.showCreateListPopup) : .just(.showLoginAlert)

        case .deleteButtonDidTap:
            let itemCount = currentState.selectedItemCount
            return .just(.showDeletePopup(itemCount))

        case let .confirmCreateListButtonDidTap(title):
            return createList(title)

        case .confirmDeleteButtonDidTap:
            return deleteList()

        case .drawFruitButtonDidTap:
            let isLoggedIn = currentState.isLoggedIn
            return isLoggedIn ? .just(.showDrawFruitPopup) : .just(.showLoginAlert)

        case .completedFruitDraw:
            return completedFruitDraw()
        }
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let switchEditingStateMutation = storageCommonService.isEditingState
            .skip(1)
            .withUnretained(self)
            .flatMap { owner, editingState -> Observable<Mutation> in
                // 편집이 종료될 때 처리
                if editingState == false {
                    let new = owner.currentState.dataSource.flatMap { $0.items }.map { $0.key }
                    let original = owner.currentState.backupDataSource.flatMap { $0.items }.map { $0.key }
                    let isChanged = new != original
                    if isChanged {
                        return .concat(
                            .just(.updateIsShowActivityIndicator(true)),
                            owner.mutateEditPlayListOrderUseCase(),
                            .just(.updateIsShowActivityIndicator(false)),
                            .just(.updateSelectedItemCount(0)),
                            .just(.hideSongCart),
                            .just(.switchEditingState(false))
                        )
                    } else {
                        return .concat(
                            .just(.updateSelectedItemCount(0)),
                            .just(.undoDataSource),
                            .just(.hideSongCart),
                            .just(.switchEditingState(false))
                        )
                    }
                } else {
                    return .just(.switchEditingState(editingState))
                }
            }

        let updateIsLoggedInMutation = storageCommonService.loginStateDidChangedEvent
            .withUnretained(self)
            .flatMap { owner, userID -> Observable<Mutation> in
                let isLoggedIn = userID != nil
                return .concat(
                    owner.updateIsLoggedIn(isLoggedIn),
                    owner.fetchDataSource()
                )
            }

        let playlistRefreshMutation = storageCommonService.playlistRefreshEvent
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<Mutation> in
                return owner.fetchDataSource()
            }

        return Observable.merge(
            mutation,
            switchEditingStateMutation,
            updateIsLoggedInMutation,
            playlistRefreshMutation
        )
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateDataSource(dataSource):
            newState.dataSource = dataSource
        case .updateBackupDataSource:
            newState.backupDataSource = currentState.dataSource
        case .undoDataSource:
            newState.dataSource = currentState.backupDataSource
        case .clearDataSource:
            newState.dataSource = []
        case let .switchEditingState(flag):
            newState.isEditing = flag
        case let .updateIsLoggedIn(isLoggedIn):
            newState.isLoggedIn = isLoggedIn
        case .showLoginAlert:
            newState.showLoginAlert = ()
        case let .updateIsShowActivityIndicator(isShow):
            newState.isShowActivityIndicator = isShow
        case let .showToast(message):
            newState.showToast = message
        case .hideSongCart:
            newState.hideSongCart = ()
        case .showCreateListPopup:
            newState.showCreateListPopup = ()
        case let .showDeletePopup(itemCount):
            newState.showDeletePopup = itemCount
        case let .updateSelectedItemCount(count):
            newState.selectedItemCount = count
        case let .showDetail(key):
            newState.showDetail = key
        case .showDrawFruitPopup:
            newState.showDrawFruitPopup = ()
        }

        return newState
    }
}

extension ListStorageReactor {
    func viewDidLoad() -> Observable<Mutation> {
        let isLoggedIn = PreferenceManager.userInfo != nil
        if !isLoggedIn { return .empty() }
        return .concat(
            updateIsLoggedIn(isLoggedIn),
            .concat(
                .just(.updateIsShowActivityIndicator(true)),
                fetchDataSource(),
                .just(.updateIsShowActivityIndicator(false))
            )
        )
    }

    func fetchDataSource() -> Observable<Mutation> {
        fetchPlayListUseCase
            .execute()
            .catchAndReturn([])
            .asObservable()
            .map { [MyPlayListSectionModel(model: 0, items: $0)] }
            .flatMap { fetchedDataSource -> Observable<Mutation> in
                .concat(
                    .just(.updateDataSource(fetchedDataSource)),
                    .just(.updateBackupDataSource(fetchedDataSource))
                )
            }
    }

    func clearDataSource() -> Observable<Mutation> {
        return .just(.clearDataSource)
    }

    func completedFruitDraw() -> Observable<Mutation> {
        NotificationCenter.default.post(name: .willRefreshUserInfo, object: nil)
        return .empty()
    }

    func updateIsLoggedIn(_ isLoggedIn: Bool) -> Observable<Mutation> {
        return .just(.updateIsLoggedIn(isLoggedIn))
    }

    func createList(_ title: String) -> Observable<Mutation> {
        return .concat(
            .just(.updateIsShowActivityIndicator(true)),
            mutateCreatePlaylistUseCase(title),
            .just(.updateIsShowActivityIndicator(false)),
            .just(.hideSongCart)
        )
    }

    func deleteList() -> Observable<Mutation> {
        let selectedItemIDs = currentState.dataSource.flatMap { $0.items.filter { $0.isSelected == true } }
        storageCommonService.isEditingState.onNext(false)

        return .concat(
            .just(.updateIsShowActivityIndicator(true)),
            mutateDeletePlaylistUseCase(selectedItemIDs),
            .just(.updateIsShowActivityIndicator(false)),
            .just(.hideSongCart),
            .just(.switchEditingState(false))
        )
    }

    func showDetail(_ indexPath: IndexPath) -> Observable<Mutation> {
        let selectedList = currentState.dataSource[indexPath.section].items[indexPath.row]
        let key = selectedList.key

        return .just(.showDetail(key: key))
    }

    func addToCurrentPlaylist() -> Observable<Mutation> {
        let limit = 50
        let selectedPlaylists = currentState.dataSource
            .flatMap { $0.items.filter { $0.isSelected == true } }

        let selectedSongCount = selectedPlaylists.map { $0.songCount }.reduce(0, +)

        if selectedSongCount == 0 {
            return .just(.showToast("플레이리스트가 비어있습니다."))
        }

        if selectedSongCount > limit {
            let overFlowQuantity = selectedSongCount - limit
            let overFlowMessage = LocalizationStrings.overFlowAddPlaylistWarning(overFlowQuantity)
            return .just(.showToast(overFlowMessage))
        }

        let keys = selectedPlaylists.map { $0.key }

        let observables = keys.map { key in
            fetchPlaylistSongsUseCase.execute(key: key).asObservable()
        }

        return Observable.concat(
            .just(.updateIsShowActivityIndicator(true)),
            Observable.zip(observables)
                .map { songEntities in
                    songEntities.flatMap { $0 }
                }
                .do(onNext: { [weak self] appendingPlaylistItems in
                    PlayState.shared.appendSongsToPlaylist(appendingPlaylistItems)
                    self?.storageCommonService.isEditingState.onNext(false)
                })
                .flatMap { _ -> Observable<Mutation> in
                    return .concat(
                        .just(.hideSongCart),
                        .just(.showToast(LocalizationStrings.addList))
                    )
                },
            .just(.updateIsShowActivityIndicator(false))
        )
        .catch { error in
            let error = error.asWMError
            return Observable.concat([
                .just(.updateIsShowActivityIndicator(false)),
                .just(.showToast(error.errorDescription ?? "알 수 없는 오류가 발생하였습니다."))
            ])
        }
    }

    func playWithAddToCurrentPlaylist(_ index: Int) -> Observable<Mutation> {
        let limit = 50
        guard let selectedPlaylist = currentState.dataSource.first?.items[safe: index] else {
            return .just(.showToast("알 수 없는 오류가 발생하였습니다."))
        }

        if selectedPlaylist.songCount == 0 {
            return .just(.showToast("플레이리스트가 비어있습니다."))
        }

        if selectedPlaylist.songCount > limit {
            let overFlowQuantity = selectedPlaylist.songCount - limit
            let overFlowMessage = LocalizationStrings.overFlowAddPlaylistWarning(overFlowQuantity)
            return .just(.showToast(overFlowMessage))
        }

        return Observable.concat(
            .just(.updateIsShowActivityIndicator(true)),
            fetchPlaylistSongsUseCase.execute(key: selectedPlaylist.key)
                .asObservable()
                .do(onNext: { [weak self] appendingPlaylistItems in
                    PlayState.shared.appendSongsToPlaylist(appendingPlaylistItems)
                    let firstItem = appendingPlaylistItems.first!
                    WakmusicYoutubePlayer(id: firstItem.id).play()
                    self?.storageCommonService.isEditingState.onNext(false)
                })
                .flatMap { songs -> Observable<Mutation> in
                    return .just(.showToast(LocalizationStrings.addList))
                },
            .just(.updateIsShowActivityIndicator(false))
        )
        .catch { error in
            let error = error.asWMError
            return Observable.concat([
                .just(.updateIsShowActivityIndicator(false)),
                .just(.showToast(error.errorDescription ?? "알 수 없는 오류가 발생하였습니다."))
            ])
        }
    }

    /// 순서 변경
    func updateOrder(src: Int, dest: Int) -> Observable<Mutation> {
        guard var tmp = currentState.dataSource.first?.items else {
            LogManager.printError("playlist datasource is empty")
            return .empty()
        }

        let target = tmp[src]
        tmp.remove(at: src)
        tmp.insert(target, at: dest)
        return .just(.updateDataSource([MyPlayListSectionModel(model: 0, items: tmp)]))
    }

    func changeSelectingState(_ index: Int) -> Observable<Mutation> {
        guard var tmp = currentState.dataSource.first?.items else {
            LogManager.printError("playlist datasource is empty")
            return .empty()
        }

        var count = currentState.selectedItemCount
        let target = tmp[index]
        count = target.isSelected ? count - 1 : count + 1
        tmp[index].isSelected = !tmp[index].isSelected

        return .concat(
            .just(.updateDataSource([MyPlayListSectionModel(model: 0, items: tmp)])),
            .just(.updateSelectedItemCount(count))
        )
    }

    /// 전체 곡 선택 / 해제
    func tapAll(_ flag: Bool) -> Observable<Mutation> {
        guard var tmp = currentState.dataSource.first?.items else {
            LogManager.printError("playlist datasource is empty")
            return .empty()
        }

        let count = flag ? tmp.count : 0

        for i in 0 ..< tmp.count {
            tmp[i].isSelected = flag
        }

        return .concat(
            .just(.updateDataSource([MyPlayListSectionModel(model: 0, items: tmp)])),
            .just(.updateSelectedItemCount(count))
        )
    }
}

private extension ListStorageReactor {
    func mutateCreatePlaylistUseCase(_ title: String) -> Observable<Mutation> {
        createPlaylistUseCase.execute(title: title)
            .asObservable()
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<Mutation> in
                return owner.fetchDataSource()
            }
            .catch { error in
                let error = error.asWMError
                return .just(.showToast(error.errorDescription ?? "알 수 없는 오류가 발생하였습니다."))
            }
    }

    func mutateDeletePlaylistUseCase(_ playlists: [PlaylistEntity]) -> Observable<Mutation> {
        let noti = NotificationCenter.default
        let subscribedPlaylistKeys = playlists.filter { $0.userId != PreferenceManager.userInfo?.decryptedID }
            .map { $0.key }
        let ids = playlists.map { $0.key }
        return deletePlayListUseCase.execute(ids: ids)
            .do(onCompleted: {
                noti.post(name: .subscriptionPlaylistDidRemoved, object: subscribedPlaylistKeys, userInfo: nil)
            })
            .andThen(
                .concat(
                    fetchDataSource(),
                    .just(.showToast("\(ids.count)개의 리스트를 삭제했습니다."))
                )
            )
            .catch { error in
                let error = error.asWMError
                return .concat(
                    .just(.undoDataSource),
                    .just(.showToast(error.errorDescription ?? "알 수 없는 오류가 발생하였습니다."))
                )
            }
    }

    func mutateEditPlayListOrderUseCase() -> Observable<Mutation> {
        let currentDataSource = currentState.dataSource
        let playlistOrder = currentDataSource.flatMap { $0.items.map { $0.key } }
        return editPlayListOrderUseCase.execute(ids: playlistOrder)
            .andThen(
                .concat(
                    .just(Mutation.updateBackupDataSource(currentDataSource))
                )
            )
            .catch { error in
                let error = error.asWMError
                return Observable.concat([
                    .just(.undoDataSource),
                    .just(.showToast(error.errorDescription ?? "알 수 없는 오류가 발생하였습니다."))
                ])
            }
    }
}
