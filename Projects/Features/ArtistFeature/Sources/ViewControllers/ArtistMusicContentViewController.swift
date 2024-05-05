//
//  ArtistMusicContentViewController.swift
//  ArtistFeature
//
//  Created by KTH on 2023/01/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import ArtistDomainInterface
import BaseFeature
import DesignSystem
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import SongsDomainInterface
import UIKit
import Utility

public class ArtistMusicContentViewController: BaseViewController, ViewControllerFromStoryBoard, SongCartViewType {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndidator: NVActivityIndicatorView!

    public var songCartView: SongCartView!
    public var bottomSheetView: BottomSheetView!
    var containSongsComponent: ContainSongsComponent!

    private var viewModel: ArtistMusicContentViewModel!
    lazy var input = ArtistMusicContentViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    var disposeBag = DisposeBag()

    deinit { DEBUG_LOG("\(Self.self) Deinit") }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        inputBind()
        outputBind()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.input.allSongSelected.onNext(false)
    }

    public static func viewController(
        viewModel: ArtistMusicContentViewModel,
        containSongsComponent: ContainSongsComponent
    ) -> ArtistMusicContentViewController {
        let viewController = ArtistMusicContentViewController.viewController(
            storyBoardName: "Artist",
            bundle: Bundle.module
        )
        viewController.viewModel = viewModel
        viewController.containSongsComponent = containSongsComponent
        return viewController
    }
}

extension ArtistMusicContentViewController {
    private func inputBind() {
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        tableView.rx.willDisplayCell
            .map { $1 }
            .withLatestFrom(
                output.dataSource,
                resultSelector: { indexPath, datasource -> (IndexPath, [ArtistSongListEntity]) in
                    return (indexPath, datasource)
                }
            )
            .filter { indexPath, datasources -> Bool in
                return indexPath.item == datasources.count - 1
            }
            .withLatestFrom(output.canLoadMore)
            .filter { $0 }
            .map { _ in return () }
            .bind(to: rx.loadMore)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: input.songTapped)
            .disposed(by: disposeBag)
    }

    private func outputBind() {
        output.dataSource
            .skip(1)
            .withLatestFrom(output.indexOfSelectedSongs) { ($0, $1) }
            .do(onNext: { [weak self] dataSource, songs in
                guard let `self` = self else { return }
                self.activityIndidator.stopAnimating()

                guard let songCart = self.songCartView else { return }
                songCart.updateAllSelect(isAll: songs.count == dataSource.count)
            })
            .map { $0.0 }
            .bind(to: tableView.rx.items) { tableView, index, model -> UITableViewCell in
                let indexPath: IndexPath = IndexPath(row: index, section: 0)
                guard let cell = tableView
                    .dequeueReusableCell(withIdentifier: "ArtistMusicCell", for: indexPath) as? ArtistMusicCell else {
                    return UITableViewCell()
                }
                cell.update(model: model)
                return cell
            }.disposed(by: disposeBag)

        output.indexOfSelectedSongs
            .skip(1)
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .subscribe(onNext: { [weak self] songs, dataSource in
                guard let self = self else { return }
                switch songs.isEmpty {
                case true:
                    self.hideSongCart()
                case false:
                    self.showSongCart(
                        in: self.view,
                        type: .artistSong,
                        selectedSongCount: songs.count,
                        totalSongCount: dataSource.count,
                        useBottomSpace: false
                    )
                    self.songCartView?.delegate = self
                }
            }).disposed(by: disposeBag)
    }

    private func configureUI() {
        self.activityIndidator.color = DesignSystemAsset.PrimaryColor.point.color
        self.activityIndidator.type = .circleStrokeSpin
        self.activityIndidator.startAnimating()
        self.tableView.backgroundColor = .clear
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: PLAYER_HEIGHT()))
        self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: PLAYER_HEIGHT(), right: 0)
    }
}

extension ArtistMusicContentViewController: SongCartViewDelegate {
    public func buttonTapped(type: SongCartSelectType) {
        switch type {
        case let .allSelect(flag):
            input.allSongSelected.onNext(flag)

        case .addSong:
            let songs: [String] = output.songEntityOfSelectedSongs.value.map { $0.id }
            let viewController = containSongsComponent.makeView(songs: songs)
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true) {
                self.input.allSongSelected.onNext(false)
            }
        case .addPlayList:
            let songs: [SongEntity] = output.songEntityOfSelectedSongs.value
            PlayState.shared.appendSongsToPlaylist(songs)
            input.allSongSelected.onNext(false)

        case .play:
            let songs: [SongEntity] = output.songEntityOfSelectedSongs.value
            PlayState.shared.loadAndAppendSongsToPlaylist(songs)
            input.allSongSelected.onNext(false)

        default: return
        }
    }
}

extension ArtistMusicContentViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = ArtistPlayButtonGroupView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 80))
        view.delegate = self
        return view
    }
}

extension ArtistMusicContentViewController: PlayButtonGroupViewDelegate {
    public func play(_ event: PlayEvent) {
        let songs: [SongEntity] = output.dataSource.value.map {
            return SongEntity(
                id: $0.songId,
                title: $0.title,
                artist: $0.artist,
                remix: $0.remix,
                reaction: $0.reaction,
                views: $0.views,
                last: $0.last,
                date: $0.date
            )
        }
        switch event {
        case .allPlay:
            PlayState.shared.loadAndAppendSongsToPlaylist(songs)
            input.allSongSelected.onNext(false)
        case .shufflePlay:
            PlayState.shared.loadAndAppendSongsToPlaylist(songs.shuffled())
            input.allSongSelected.onNext(false)
        }
    }
}

extension Reactive where Base: ArtistMusicContentViewController {
    var refresh: Binder<Void> {
        return Binder(base) { viewController, _ in
            viewController.input.pageID.accept(1)
        }
    }

    var loadMore: Binder<Void> {
        return Binder(base) { viewController, _ in
            let pageID = viewController.input.pageID.value
            viewController.input.pageID.accept(pageID + 1)
        }
    }
}

extension ArtistMusicContentViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.output.dataSource.value.count >= 25 else { return }
        guard let parent = self.parent?.parent?.parent as? ArtistDetailViewController else { return }
        let type = self.viewModel.type
        let i = (type == .new) ? 0 : (type == .popular) ? 1 : 2
        parent.scrollViewDidScrollFromChild(scrollView: scrollView, i: i)
    }
}
