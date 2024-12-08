import BaseFeature
import Foundation
import Localization
import LogManager
import PlaylistDomainInterface
import PriceDomainInterface
import ReactorKit
import RxCocoa
import RxSwift
@preconcurrency import SongsDomainInterface
import UserDomainInterface
import Utility

final class ListStorageReactor: Reactor {
    enum Action {
        case viewDidLoad
        case refresh
        case itemMoved(ItemMovedEvent)
        case didSelectPlaylist(IndexPath)
        case didLongPressedPlaylist(IndexPath)
        case playDidTap(Int)
        case tapAll(isSelecting: Bool)
        case loginButtonDidTap
        case createListButtonDidTap
        case confirmCreatePriceButtonDidTap
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
        case showLoginAlert(CommonAnalyticsLog.LoginButtonEntry?)
        case showToast(String)
        case showCreatePricePopup(Int)
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
        @Pulse var showLoginAlert: CommonAnalyticsLog.LoginButtonEntry?
        @Pulse var showToast: String?
        @Pulse var hideSongCart: Void?
        @Pulse var showCreatePricePopup: Int?
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
    private let fetchPlaylistCreationPriceUseCase: any FetchPlaylistCreationPriceUseCase

    init(
        storageCommonService: any StorageCommonService,
        createPlaylistUseCase: any CreatePlaylistUseCase,
        fetchPlayListUseCase: any FetchPlaylistUseCase,
        editPlayListOrderUseCase: any EditPlaylistOrderUseCase,
        deletePlayListUseCase: any DeletePlaylistUseCase,
        fetchPlaylistSongsUseCase: any FetchPlaylistSongsUseCase,
        fetchPlaylistCreationPriceUseCase: any FetchPlaylistCreationPriceUseCase
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
        self.fetchPlaylistCreationPriceUseCase = fetchPlaylistCreationPriceUseCase
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

        case let .didSelectPlaylist(indexPath):
            return didSelectPlaylistCell(indexPath: indexPath)

        case let .didLongPressedPlaylist(indexPath):
            return didLongPressedPlaylist(indexPath: indexPath)

        case let .playDidTap(index):
            return playWithAddToCurrentPlaylist(index)

        case let .tapAll(isSelecting):
            return tapAll(isSelecting)

        case .loginButtonDidTap:
            let log = CommonAnalyticsLog.clickLoginButton(entry: .myPlaylist)
            LogManager.analytics(log)
            return .just(.showLoginAlert(.myPlaylist))

        case .addToCurrentPlaylistButtonDidTap:
            return addToCurrentPlaylist()

        case .createListButtonDidTap:
            let log = CommonAnalyticsLog.clickLoginButton(entry: .addMusics)
            LogManager.analytics(log)
            let isLoggedIn = currentState.isLoggedIn
            return isLoggedIn ? mutateFetchPlaylistCreationPrice() : .just(.showLoginAlert(.addMusics))

        case .confirmCreatePriceButtonDidTap:
            return .just(.showCreateListPopup)

        case let .confirmCreateListButtonDidTap(title):
            return createList(title)

        case .deleteButtonDidTap:
            let itemCount = currentState.selectedItemCount
            return .just(.showDeletePopup(itemCount))

        case .confirmDeleteButtonDidTap:
            return deleteList()

        case .drawFruitButtonDidTap:
            let isLoggedIn = currentState.isLoggedIn
            return isLoggedIn ? .just(.showDrawFruitPopup) : .just(.showLoginAlert(.fruitDraw))

        case .completedFruitDraw:
            return completedFruitDraw()
        }
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let switchEditingStateMutation = storageCommonService.isEditingState
            .skip(1)
            .filter { [weak self] in
                $0 != self?.currentState.isEditing
            }
            .withUnretained(self)
            .flatMap { owner, editingState -> Observable<Mutation> in
                let log = if !editingState {
                    CommonAnalyticsLog.clickEditButton(location: .playlist)
                } else {
                    CommonAnalyticsLog.clickEditCompleteButton(location: .playlist)
                }
                LogManager.analytics(log)

                // 편집이 종료될 때 처리
                if editingState == false {
                    let new = owner.currentState.dataSource.flatMap { $0.items }.map { $0.key }
                    let original = owner.currentState.backupDataSource.flatMap { $0.items }.map { $0.key }
                    let isChanged = new != original
                    if isChanged {
                        return .concat(
                            .just(.updateIsShowActivityIndicator(true)),
                            owner.mutateEditPlayListOrder(),
                            .just(.updateIsShowActivityIndicator(false)),
                            .just(.updateSelectedItemCount(0)),
                            owner.setAllSelection(isSelected: false),
                            .just(.hideSongCart),
                            .just(.switchEditingState(false))
                        )
                    } else {
                        return .concat(
                            .just(.updateSelectedItemCount(0)),
                            owner.setAllSelection(isSelected: false),
                            .just(.undoDataSource),
                            .just(.hideSongCart),
                            .just(.switchEditingState(false))
                        )
                    }
                } else {
                    return .concat(
                        .just(.switchEditingState(editingState)),
                        owner.setAllSelection(isSelected: false)
                    )
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
        case let .showLoginAlert(entry):
            newState.showLoginAlert = entry
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
        case let .showCreatePricePopup(price):
            newState.showCreatePricePopup = price
        }

        return newState
    }
}

extension ListStorageReactor {
    func viewDidLoad() -> Observable<Mutation> {
        let isLoggedIn = PreferenceManager.shared.userInfo != nil
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
            mutateCreatePlaylist(title),
            .just(.updateIsShowActivityIndicator(false)),
            .just(.hideSongCart)
        )
    }

    func deleteList() -> Observable<Mutation> {
        let selectedItemIDs = currentState.dataSource.flatMap { $0.items.filter { $0.isSelected == true } }
        storageCommonService.isEditingState.onNext(false)

        return .concat(
            .just(.updateIsShowActivityIndicator(true)),
            mutateDeletePlaylist(selectedItemIDs),
            .just(.updateIsShowActivityIndicator(false)),
            .just(.hideSongCart),
            .just(.switchEditingState(false))
        )
    }

    func didLongPressedPlaylist(indexPath: IndexPath) -> Observable<Mutation> {
        guard !currentState.isEditing else { return .empty() }
        storageCommonService.isEditingState.onNext(true)
        return .concat(
            changeSelectingState(indexPath.row),
            .just(.switchEditingState(true))
        )
    }

    func didSelectPlaylistCell(indexPath: IndexPath) -> Observable<Mutation> {
        if currentState.isEditing {
            return changeSelectingState(indexPath.row)
        } else {
            return showDetail(indexPath)
        }
    }

    func showDetail(_ indexPath: IndexPath) -> Observable<Mutation> {
        let selectedList = currentState.dataSource[indexPath.section].items[indexPath.row]
        let key = selectedList.key

        return .just(.showDetail(key: key))
    }

    func addToCurrentPlaylist() -> Observable<Mutation> {
        _ = 50
        let selectedPlaylists = currentState.dataSource
            .flatMap { $0.items.filter { $0.isSelected == true } }

        let selectedSongCount = selectedPlaylists.map { $0.songCount }.reduce(0, +)

        if selectedSongCount == 0 {
            return .just(.showToast("플레이리스트가 비어있습니다."))
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
                .just(.showToast(error.errorDescription ?? LocalizationStrings.unknownErrorWarning))
            ])
        }
    }

    func playWithAddToCurrentPlaylist(_ index: Int) -> Observable<Mutation> {
        let limit = 50
        guard let selectedPlaylist = currentState.dataSource.first?.items[safe: index] else {
            return .just(.showToast(LocalizationStrings.unknownErrorWarning))
        }

        if selectedPlaylist.songCount == 0 {
            return .just(.showToast("플레이리스트가 비어있습니다."))
        }
        return Observable.concat(
            .just(.updateIsShowActivityIndicator(true)),
            fetchPlaylistSongsUseCase.execute(key: selectedPlaylist.key)
                .asObservable()
                .do(onNext: { [weak self] appendingPlaylistItems in
                    PlayState.shared.appendSongsToPlaylist(appendingPlaylistItems)
                    Task { @MainActor in
                        let ids = appendingPlaylistItems.map { $0.id }
                            .prefix(50)

                        if appendingPlaylistItems.allSatisfy({ $0.title.isContainShortsTagTitle }) {
                            WakmusicYoutubePlayer(ids: Array(ids), title: "왁타버스 뮤직", playPlatform: .youtube).play()
                        } else {
                            WakmusicYoutubePlayer(ids: Array(ids), title: "왁타버스 뮤직").play()
                        }
                    }
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
                .just(.showToast(error.errorDescription ?? LocalizationStrings.unknownErrorWarning))
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
        return setAllSelection(isSelected: flag)
    }

    func setAllSelection(isSelected: Bool) -> Observable<Mutation> {
        guard var tmp = currentState.dataSource.first?.items else {
            LogManager.printError("playlist datasource is empty")
            return .empty()
        }

        let count = isSelected ? tmp.count : 0

        for i in 0 ..< tmp.count {
            tmp[i].isSelected = isSelected
        }

        return .concat(
            .just(.updateDataSource([MyPlayListSectionModel(model: 0, items: tmp)])),
            .just(.updateSelectedItemCount(count))
        )
    }
}

private extension ListStorageReactor {
    func mutateCreatePlaylist(_ title: String) -> Observable<Mutation> {
        return Observable.concat(
            .just(.updateIsShowActivityIndicator(true)),
            createPlaylistUseCase.execute(title: title)
                .asObservable()
                .withUnretained(self)
                .flatMap { owner, _ -> Observable<Mutation> in
                    NotificationCenter.default.post(name: .willRefreshUserInfo, object: nil)
                    return .concat(
                        owner.fetchDataSource(),
                        .just(.showToast("리스트를 만들었습니다."))
                    )
                }
                .catch { error in
                    let error = error.asWMError
                    return .just(.showToast(error.errorDescription ?? LocalizationStrings.unknownErrorWarning))
                },
            .just(.updateIsShowActivityIndicator(false))
        )
    }

    func mutateDeletePlaylist(_ playlists: [PlaylistEntity]) -> Observable<Mutation> {
        let noti = NotificationCenter.default
        let subscribedPlaylistKeys = playlists.filter { $0.userId != PreferenceManager.shared.userInfo?.decryptedID }
            .map { $0.key }
        let ids = playlists.map { $0.key }
        return deletePlayListUseCase.execute(ids: ids)
            .do(onCompleted: {
                noti.post(name: .didRemovedSubscriptionPlaylist, object: subscribedPlaylistKeys, userInfo: nil)
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
                    .just(.showToast(error.errorDescription ?? LocalizationStrings.unknownErrorWarning))
                )
            }
    }

    func mutateEditPlayListOrder() -> Observable<Mutation> {
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
                    .just(.showToast(error.errorDescription ?? LocalizationStrings.unknownErrorWarning))
                ])
            }
    }

    func mutateFetchPlaylistCreationPrice() -> Observable<Mutation> {
        return Observable.concat(
            .just(.updateIsShowActivityIndicator(true)),
            fetchPlaylistCreationPriceUseCase.execute()
                .asObservable()
                .map { $0.price }
                .flatMap { price -> Observable<Mutation> in
                    guard let userItemCount = PreferenceManager.shared.userInfo?.itemCount else {
                        return .just(.showToast(LocalizationStrings.unknownErrorWarning))
                    }
                    if userItemCount < price {
                        return .just(.showToast(LocalizationStrings.lackOfMoney(price - userItemCount)))
                    }
                    return .just(.showCreatePricePopup(price))
                }
                .catch { error in
                    let error = error.asWMError
                    return .just(.showToast(error.errorDescription ?? LocalizationStrings.unknownErrorWarning))
                },
            .just(.updateIsShowActivityIndicator(false))
        )
    }
}
