//
//  ArtistMusicContentViewController.swift
//  ArtistFeature
//
//  Created by KTH on 2023/01/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import RxSwift
import RxCocoa
import BaseFeature
import CommonFeature
import DataMappingModule
import DomainModule

public class ArtistMusicContentViewController: BaseViewController, ViewControllerFromStoryBoard, SongCartViewType {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIncidator: UIActivityIndicatorView!
    
    public var songCartView: SongCartView!
    public var bottomSheetView: BottomSheetView!

    private var viewModel: ArtistMusicContentViewModel!
    lazy var input = ArtistMusicContentViewModel.Input(pageID: BehaviorRelay(value: 1))
    lazy var output = viewModel.transform(from: input)
    var disposeBag = DisposeBag()

    deinit {
        DEBUG_LOG("\(Self.self) Deinit")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        inputBind()
        outputBind()
    }
    
    public static func viewController(
        viewModel: ArtistMusicContentViewModel
    ) -> ArtistMusicContentViewController {
        let viewController = ArtistMusicContentViewController.viewController(storyBoardName: "Artist", bundle: Bundle.module)
        viewController.viewModel = viewModel
        return viewController
    }
}

extension ArtistMusicContentViewController {
    
    private func inputBind() {
                
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .map { $1 }
            .withLatestFrom(output.dataSource, resultSelector: { (indexPath, datasource) -> (IndexPath, [ArtistSongListEntity]) in
                return (indexPath, datasource)
            })
            .filter{ (indexPath, datasources) -> Bool in
                return indexPath.item == datasources.count-1
            }
            .withLatestFrom(output.canLoadMore)
            .filter{ $0 }
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
            .do(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    self.activityIncidator.stopAnimating()
                }
            })
            .bind(to: tableView.rx.items) { (tableView, index, model) -> UITableViewCell in
                let indexPath: IndexPath = IndexPath(row: index, section: 0)
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistMusicCell", for: indexPath) as? ArtistMusicCell else{
                    return UITableViewCell()
                }
                cell.update(model: model)
                return cell
            }.disposed(by: disposeBag)
        
        output.selectedSongs
            .skip(1)
            .debug("selectedSongs")
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .subscribe(onNext: { [weak self] (songs, dataSource) in
                guard let self = self else { return }
                switch songs.isEmpty {
                case true :
                    self.hideSongCart()
                case false:
                    self.showSongCart(
                        in: self.view,
                        type: .artistSong,
                        contentHeight: 56,
                        selectedSongCount: songs.count,
                        totalSongCount: dataSource.count
                    )
                    self.songCartView?.delegate = self
                }
            }).disposed(by: disposeBag)
    }
    
    private func configureUI() {
        self.activityIncidator.startAnimating()
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56))
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
    }
}

extension ArtistMusicContentViewController: SongCartViewDelegate {
    public func buttonTapped(type: SongCartSelectType) {
        switch type {
        case let .allSelect(flag):
            input.allSongSelected.onNext(flag)
        case .addSong:
            return
        case .addPlayList:
            return
        case .play:
            return
        case .remove:
            return
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
        let view = PlayButtonGroupView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 80))
        view.delegate = self
        return view
    }
}

extension ArtistMusicContentViewController: PlayButtonGroupViewDelegate{
    public func pressPlay(_ event: PlayEvent) {
        DEBUG_LOG(event)
    }
}

extension Reactive where Base: ArtistMusicContentViewController{
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
