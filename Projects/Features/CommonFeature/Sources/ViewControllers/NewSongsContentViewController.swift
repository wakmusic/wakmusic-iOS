//
//  NewSongsContentViewController.swift
//  CommonFeature
//
//  Created by KTH on 2023/11/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import RxSwift
import RxCocoa
import NVActivityIndicatorView
import DomainModule

public class NewSongsContentViewController: UIViewController, ViewControllerFromStoryBoard, SongCartViewType {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIncidator: NVActivityIndicatorView!
    
    var viewModel: NewSongsContentViewModel!
    fileprivate lazy var input = NewSongsContentViewModel.Input()
    fileprivate lazy var output = viewModel.transform(from: input)
    var disposeBag = DisposeBag()
    
    private var containSongsComponent: ContainSongsComponent!
    public var songCartView: SongCartView!
    public var bottomSheetView: BottomSheetView!
    private var refreshControl = UIRefreshControl()

    deinit { DEBUG_LOG("❌ \(Self.self) Deinit") }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        outputBind()
        inputBind()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.input.allSongSelected.onNext(false)
    }

    public static func viewController(
        viewModel: NewSongsContentViewModel,
        containSongsComponent: ContainSongsComponent
    ) -> NewSongsContentViewController {
        let viewController = NewSongsContentViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.containSongsComponent = containSongsComponent
        return viewController
    }
}

extension NewSongsContentViewController {
    private func inputBind() {
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .map { $1 }
            .withLatestFrom(output.dataSource, resultSelector: { (indexPath, datasource) -> (IndexPath, [NewSongsEntity]) in
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
            .map{ $0.row }
            .bind(to: input.songTapped)
            .disposed(by: disposeBag)

        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: input.refreshPulled)
            .disposed(by: disposeBag)
    }
    
    private func outputBind() {
        output.dataSource
            .skip(1)
            .do(onNext: { [weak self] (model) in
                guard let `self` = self else { return }
                self.activityIncidator.stopAnimating()
                self.refreshControl.endRefreshing()
                let space: CGFloat = APP_HEIGHT() - 48 - 40 - 56 - 56 - STATUS_BAR_HEGHIT() - SAFEAREA_BOTTOM_HEIGHT()
                let height: CGFloat = space / 3 * 2
                let warningView: WarningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: height))
                warningView.text = "데이터가 없습니다."
                self.tableView.tableFooterView = model.isEmpty ? warningView : UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: PLAYER_HEIGHT()))
            })
            .bind(to: tableView.rx.items) { (tableView, index, model) -> UITableViewCell in
                let indexPath: IndexPath = IndexPath(row: index, section: 0)
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "NewSongsCell",
                    for: indexPath
                ) as? NewSongsCell else {
                    return UITableViewCell()
                }
                cell.update(model: model)
                return cell
            }
            .disposed(by: disposeBag)

        output.indexOfSelectedSongs
            .skip(1)
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .subscribe(onNext: { [weak self] (songs, dataSource) in
                guard let self = self else { return }
                switch songs.isEmpty {
                case true :
                    self.hideSongCart()
                case false:
                    self.showSongCart(
                        in: self.view,
                        type: .chartSong,
                        selectedSongCount: songs.count,
                        totalSongCount: dataSource.count,
                        useBottomSpace: false
                    )
                    self.songCartView?.delegate = self
                }
            }).disposed(by: disposeBag)
        
        output.songEntityOfSelectedSongs
            .filter{ !$0.isEmpty }
            .subscribe()
            .disposed(by: disposeBag)
        
        output.updateTime
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        self.view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        self.activityIncidator.type = .circleStrokeSpin
        self.activityIncidator.color = DesignSystemAsset.PrimaryColor.point.color
        self.activityIncidator.startAnimating()
        self.tableView.backgroundColor = .clear
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: PLAYER_HEIGHT()))
        self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: PLAYER_HEIGHT(), right: 0)
        self.tableView.refreshControl = refreshControl
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
}

extension NewSongsContentViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80 + 22
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let base = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 88+22))
        
        let view = PlayButtonGroupView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 80))
        view.delegate = self
        base.addSubview(view)
        
        let time = ChartUpdateTimeView(frame: CGRect(x: 0, y: view.frame.height, width: APP_WIDTH(), height: 22))
        time.setUpdateTime(updateTime: self.output.updateTime.value)
        base.addSubview(time)
        
        return base
    }
}

extension NewSongsContentViewController: PlayButtonGroupViewDelegate{
    public func pressPlay(_ event: PlayEvent) {
        input.groupPlayTapped.onNext(event)
    }
}

extension NewSongsContentViewController: SongCartViewDelegate {
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
            let songs = output.songEntityOfSelectedSongs.value
            PlayState.shared.appendSongsToPlaylist(songs)
            self.input.allSongSelected.onNext(false)
            
        case .play:
            let songs = output.songEntityOfSelectedSongs.value
            PlayState.shared.loadAndAppendSongsToPlaylist(songs)
            self.input.allSongSelected.onNext(false)
            
        case .remove:
            return
        }
    }
}

extension Reactive where Base: NewSongsContentViewController{
    var loadMore: Binder<Void> {
        return Binder(base) { viewController, _ in
            let pageID = viewController.input.pageID.value
            viewController.input.pageID.accept(pageID + 1)
        }
    }
}
