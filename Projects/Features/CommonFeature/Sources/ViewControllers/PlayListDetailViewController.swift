//
//  PlayListDetailViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//
import UIKit
import Utility
import RxRelay
import RxSwift
import RxCocoa
import RxDataSources
import PanModal
import DesignSystem
import BaseFeature
import Kingfisher
import DomainModule
import NVActivityIndicatorView

public class PlayListDetailViewController: BaseViewController,ViewControllerFromStoryBoard, SongCartViewType, EditSheetViewType, LoadingAlertControllerType {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var playListImage: UIImageView!
    @IBOutlet weak var playListNameLabel: UILabel!
    @IBOutlet weak var playListCountLabel: UILabel!
    @IBOutlet weak var editPlayListNameButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editStateLabel: UILabel!
    @IBOutlet weak var playListInfoView: UIView!
    @IBOutlet weak var playListInfoSuperView: UIView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!

    var disposeBag = DisposeBag()
    var viewModel:PlayListDetailViewModel!
    lazy var input = PlayListDetailViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    var multiPurposePopComponent:MultiPurposePopComponent!
    var containSongsComponent:ContainSongsComponent!
    
    public var editSheetView: EditSheetView!
    public var songCartView: SongCartView!
    public var bottomSheetView: BottomSheetView!
    public var alertController: UIAlertController!

    let playState = PlayState.shared
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        let isEdit: Bool = input.state.value.isEditing
        
        if isEdit {
            let vc = TextPopupViewController.viewController(text: "변경된 내용을 저장할까요?", cancelButtonIsHidden: false,completion: {[weak self] in
                guard let self =  self else {
                    return
                }
                self.input.runEditing.onNext(())
                self.navigationController?.popViewController(animated: true)
                
            },cancelCompletion: { [weak self] in
                guard let self =  self else {
                    return
                }
                self.input.state.accept(EditState(isEditing: false, force: true))
                self.input.cancelEdit.onNext(())
                self.input.runEditing.onNext(())
            })
            self.showPanModal(content: vc)
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func pressEditListAction(_ sender: UIButton) {
        self.moreButton.isSelected = !self.moreButton.isSelected

        if self.moreButton.isSelected {
            self.showEditSheet(in: self.view, type: .playList)
            self.editSheetView.delegate = self
        }else{
            self.hideEditSheet()
        }
    }
    
    @IBAction func pressCompleteAction(_ sender: UIButton) {
        input.state.accept(EditState(isEditing: false, force: false))
    }
    
    @IBAction func pressEditNameAction(_ sender: UIButton) {
        let multiPurposePopVc = multiPurposePopComponent.makeView(type: .edit,key: viewModel.key!)
        self.showPanModal(content: multiPurposePopVc)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindRx()
        bindSelectedEvent()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideEditSheet()
        self.moreButton.isSelected = false
    }

    deinit {
        DEBUG_LOG("\(Self.self) deinit")
    }
    
    public static func viewController(
        viewModel: PlayListDetailViewModel,
        multiPurposePopComponent: MultiPurposePopComponent,
        containSongsComponent: ContainSongsComponent
    ) -> PlayListDetailViewController {
        let viewController = PlayListDetailViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.multiPurposePopComponent = multiPurposePopComponent
        viewController.containSongsComponent = containSongsComponent
        return viewController
    }
}

public typealias PlayListDetailSectionModel = SectionModel<Int, SongEntity>

extension PlayListDetailViewController{
        
    private func configureUI(){
        self.view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        self.tableView.backgroundColor = .clear
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56))
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        
        self.activityIndicator.color = DesignSystemAsset.PrimaryColor.point.color
        self.activityIndicator.type = .circleStrokeSpin
        self.activityIndicator.startAnimating()

        self.completeButton.isHidden = true
        self.editStateLabel.isHidden = true
        
        self.backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        self.moreButton.setImage(DesignSystemAsset.Storage.more.image, for: .normal)
        
        self.completeButton.titleLabel?.text = "완료"
        self.completeButton.titleLabel?.font = DesignSystemFontFamily.Pretendard.bold.font(size: 12)
        self.completeButton.layer.cornerRadius = 4
        self.completeButton.layer.borderColor =  DesignSystemAsset.PrimaryColor.point.color.cgColor
        self.completeButton.layer.borderWidth = 1
        self.completeButton.backgroundColor = .clear
    
        self.editStateLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        self.editStateLabel.setLineSpacing(kernValue: -0.5)

        self.playListCountLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 14)
        self.playListCountLabel.textColor =  DesignSystemAsset.GrayColor.gray900.color.withAlphaComponent(0.6) // opacity 60%
        self.playListCountLabel.setLineSpacing(kernValue: -0.5)

        self.playListNameLabel.font  = DesignSystemFontFamily.Pretendard.bold.font(size: 20)
        self.playListNameLabel.setLineSpacing(kernValue: -0.5)
        
        playListInfoView.layer.borderWidth = 1
        playListInfoView.layer.borderColor = colorFromRGB(0xFCFCFD).cgColor
        playListInfoView.layer.cornerRadius = 8
 
        self.playListImage.layer.cornerRadius = 12
        self.moreButton.isHidden = viewModel.type == .wmRecommend
        self.editPlayListNameButton.isHidden = viewModel.type == .wmRecommend
    }
    
    private func createDatasources() -> RxTableViewSectionedReloadDataSource<PlayListDetailSectionModel> {
        let datasource = RxTableViewSectionedReloadDataSource<PlayListDetailSectionModel>(configureCell: { [weak self] (_, tableView, indexPath, model) -> UITableViewCell in
            guard let self = self else { return UITableViewCell() }

            switch self.viewModel.type {
                
            case .custom:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayListTableViewCell", for: IndexPath(row: indexPath.row, section: 0)) as? PlayListTableViewCell else{
                    return UITableViewCell()
                }
                cell.update(model,self.input.state.value.isEditing, index: indexPath.row)
                cell.delegate = self
                return cell
                
            case .wmRecommend:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongListCell", for: IndexPath(row: indexPath.row, section: 0)) as? SongListCell else{
                    return UITableViewCell()
                }
                cell.update(model)
                return cell
                
            case .none:
                return UITableViewCell()
            }

        }, canEditRowAtIndexPath: { (_, _) -> Bool in
            return true
        }, canMoveRowAtIndexPath: { (_, _) -> Bool in
            return true
        })
        return datasource
    }

    private func bindRx() {
       
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(UINib(nibName:"SongListCell", bundle: CommonFeatureResources.bundle), forCellReuseIdentifier: "SongListCell")
        
        //xib로 만든 UI를 컬렉션 뷰에서 사용하기 위해서는 등록이 필요
        //다른 모듈 시 번들 변경 Bundle.module 사용 X
        
        output.dataSource
            .skip(1)
            .do(onNext: { [weak self] model in
                guard let self = self else {
                    return
                }
                self.activityIndicator.stopAnimating()
                
                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: APP_HEIGHT()/3))
                warningView.text = "리스트에 곡이 없습니다."
                
                let items = model.first?.items ?? []
                self.tableView.tableFooterView = items.isEmpty ?  warningView : UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56))
            })
            .bind(to: tableView.rx.items(dataSource: createDatasources()))
            .disposed(by: disposeBag)
                
        tableView.rx.itemMoved
            .bind(to: input.itemMoved)
            .disposed(by: disposeBag)
        
        input.state
            .skip(1)
            .subscribe(onNext: { [weak self] (state) in
                guard let self = self else { return }
                let type = self.viewModel.type ?? .wmRecommend
                
                switch type {
                case .custom:
                    if state.isEditing == false && state.force == false {
                        self.input.runEditing.onNext(())
                    }
                    
                    let isEdit = state.isEditing
                    self.navigationController?.interactivePopGestureRecognizer?.delegate = isEdit ? self : nil
                    
                    self.moreButton.isHidden = isEdit
                    self.completeButton.isHidden = !isEdit
                    self.editStateLabel.isHidden = !isEdit
                    
                    self.tableView.setEditing(isEdit, animated: true)
                    self.tableView.reloadData()
                    
                case .wmRecommend:
                    self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
                    self.moreButton.isHidden = true
                    self.completeButton.isHidden = true
                    self.editStateLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
                
        output.headerInfo
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                let imageHeight: CGFloat = (140.0*APP_WIDTH())/375.0
                let newFrame: CGRect = CGRect(x: 0, y: 0, width: APP_WIDTH(), height: imageHeight + 20)
                self.tableView.tableHeaderView?.frame = newFrame
            })
            .subscribe(onNext: { [weak self] (model) in
                guard let self = self else{
                    return
                }
                let type = self.viewModel.type
                
                self.playListImage.kf.setImage(
                    with: type == .wmRecommend ? WMImageAPI.fetchRecommendPlayListWithSquare(id: model.image,version: model.version).toURL : WMImageAPI.fetchPlayList(id: model.image,version: model.version).toURL,
                    placeholder: nil,
                    options: [.transition(.fade(0.2))]
                )
                self.playListCountLabel.text = model.songCount
                self.playListNameLabel.text = model.title
                self.editPlayListNameButton.setImage(DesignSystemAsset.Storage.storageEdit.image, for: .normal)
            }).disposed(by: disposeBag)
                
        NotificationCenter.default.rx.notification(.playListNameRefresh)
            .map{ (notification) -> String in
                guard let obj = notification.object as? String else {
                    return ""
                }
                return obj
            }
            .bind(to: input.playListNameLoad)
            .disposed(by: disposeBag)
        
        output.showErrorToast
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.stopLoading()
                self.showToast(text: $0.description, font: DesignSystemFontFamily.Pretendard.light.font(size: 14))
                self.input.state.accept(EditState(isEditing: false, force: true))
            })
            .disposed(by: disposeBag)
                
        tableView.rx.itemSelected
           .withLatestFrom(output.dataSource) { ($0, $1) }
           .withLatestFrom(input.state) { ($0.0, $0.1, $1) }
           .filter { $0.2.isEditing == false }
           .subscribe(onNext: { [weak self] (indexPath, dataSource, _) in
               guard let self else {return}
               
               guard let type = self.viewModel.type  else {
                   return
               }
               
               switch type {
                   
               case .custom:
                   let song:SongEntity = dataSource[indexPath.section].items[indexPath.row]
                   playState.loadAndAppendSongsToPlaylist([song])
               case .wmRecommend:
                   input.songTapped.onNext(indexPath.row)
               }
               
           })
           .disposed(by: disposeBag)

        output.groupPlaySongs
            .subscribe(onNext: { [weak self] songs in
                guard let self = self else {return}
                self.playState.loadAndAppendSongsToPlaylist(songs)
            })
            .disposed(by: disposeBag)
        
        Utility.PreferenceManager.$startPage
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.input.allSongSelected.onNext(false)
                self.input.state.accept(EditState(isEditing: false, force: true))
            }).disposed(by: disposeBag)
    }
    
    private func bindSelectedEvent() {
        
        output.indexOfSelectedSongs
            .skip(1)
            .withLatestFrom(output.dataSource) {($0,$1)}
            .withLatestFrom(input.state) { ($0,$1)}
            .subscribe(onNext: { [weak self] (arg0, _)   in
                let (songs, dataSource) = arg0
                guard let self = self else {return}
                guard let type = self.viewModel.type else {
                    return
                }
                
                switch type {
                    
                case .custom:
                    switch songs.isEmpty {
                    case true:
                        self.hideSongCart()
                        
                    case false:
                        self.showSongCart(
                            in: self.view,
                            type: .myList,
                            selectedSongCount: songs.count,
                            totalSongCount: (dataSource.first?.items.count ?? 0),
                            useBottomSpace: false
                        )
                        self.songCartView?.delegate = self
                    }
                case .wmRecommend:
                    switch songs.isEmpty {
                    case true:
                        self.hideSongCart()
                        
                    case false:
                        self.showSongCart(
                            in: self.view,
                            type: .WMPlayList,
                            selectedSongCount: songs.count,
                            totalSongCount: (dataSource.first?.items.count ?? 0),
                            useBottomSpace: false
                        )
                        self.songCartView?.delegate = self
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

extension PlayListDetailViewController:UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PlayButtonGroupView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 80))
        view.delegate = self
        let items = output.dataSource.value.first?.items ?? []
        return items.isEmpty ? nil : view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let items = output.dataSource.value.first?.items ?? []
        return items.isEmpty ? 0 : 80
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none // 편집모드 시 왼쪽 버튼을 숨기려면 .none을 리턴합니다.
    }
    
    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false // 편집모드 시 셀의 들여쓰기를 없애려면 false를 리턴합니다.
    }
}

extension PlayListDetailViewController: PlayButtonGroupViewDelegate{
    public func pressPlay(_ event: PlayEvent) {
        input.groupPlayTapped.onNext(event)
    }
}

extension PlayListDetailViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

extension PlayListDetailViewController:SongCartViewDelegate {
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
                self.input.state.accept(EditState(isEditing: false, force: true))
            }
        case .addPlayList:
            let songs: [SongEntity] = output.songEntityOfSelectedSongs.value
            playState.appendSongsToPlaylist(songs)
            self.input.allSongSelected.onNext(false)
            self.input.state.accept(EditState(isEditing: false, force: true))
            
        case .play:
            let songs: [SongEntity] = output.songEntityOfSelectedSongs.value
            playState.loadAndAppendSongsToPlaylist(songs)
            self.input.allSongSelected.onNext(false)
            self.input.state.accept(EditState(isEditing: false, force: true))
            
        case .remove:
            let count: Int = output.songEntityOfSelectedSongs.value.count
            let popup = TextPopupViewController.viewController(
                text: "선택한 내 리스트 \(count)곡이 삭제됩니다.",
                cancelButtonIsHidden: false,
                completion: { [weak self] () in
                guard let `self` = self else { return }
                    self.startLoading(message: "처리 중입니다.")
                    self.input.tapRemoveSongs.onNext(())
            })
            self.showPanModal(content: popup)
        }
    }
}

extension PlayListDetailViewController:EditSheetViewDelegate {
    public func buttonTapped(type: EditSheetSelectType) {
        switch type {
        case .edit:
            input.state.accept(EditState(isEditing: true, force: false))
            
        case .share:
            let vc = multiPurposePopComponent.makeView(type: .share,key: viewModel?.key ?? "")
            self.showPanModal(content: vc)
            
        case .profile:
            return
            
        case .nickname:
            return
        }
        self.hideEditSheet()
        self.moreButton.isSelected = false
    }
}

extension PlayListDetailViewController:PlayListCellDelegate {
    public func buttonTapped(type: PlayListCellDelegateConstant) {
        switch type {
        case let .listTapped(index):
            input.songTapped.onNext(index)
        case let .playTapped(song):
            playState.loadAndAppendSongsToPlaylist([song])
        }
    }
}
