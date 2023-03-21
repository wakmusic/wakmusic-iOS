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
import SkeletonView
import DomainModule




public class PlayListDetailViewController: BaseViewController,ViewControllerFromStoryBoard, SongCartViewType, EditSheetViewType {
    
    
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
    
    var disposeBag = DisposeBag()
    var viewModel:PlayListDetailViewModel!
    lazy var input = PlayListDetailViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    var multiPurposePopComponent:MultiPurposePopComponent!
    var containSongsComponent:ContainSongsComponent!
    
    public var editSheetView: EditSheetView!
    public var songCartView: SongCartView!
    public var bottomSheetView: BottomSheetView!
    
    
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        let isEdit: Bool = output.state.value.isEditing
        
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
                
                self.output.state.accept(EditState(isEditing: false, force: true))
                
                self.input.cancelEdit.onNext(())
                
                
            })
            self.showPanModal(content: vc)
        }else{
            
            self.navigationController?.popViewController(animated: true)
        }
       
    }
    
    @IBAction func pressEditListAction(_ sender: UIButton) {
        
       //  TODO : 바깥 클릭 시 hide... 
        
        
        self.showEditSheet(in: self.view, type: .playList)
        self.editSheetView.delegate = self
        
       
        
    }
    
    
    @IBAction func pressCompleteAction(_ sender: UIButton) {
        
        output.state.accept(EditState(isEditing: false, force: false))
        
       
    }
    
    @IBAction func pressEditNameAction(_ sender: UIButton) {
        
        let multiPurposePopVc = multiPurposePopComponent.makeView(type: .edit,key: viewModel.key!)
        self.showPanModal(content: multiPurposePopVc)
    }
    
    
    
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
       
        
        configureUI()
        
      
        
        
        // Do any additional setup after loading the view.
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    deinit {
        DEBUG_LOG("\(Self.self) deinit")
        
    }
    
    public static func viewController(viewModel:PlayListDetailViewModel,multiPurposePopComponent:MultiPurposePopComponent,containSongsComponent:ContainSongsComponent) -> PlayListDetailViewController {
        let viewController = PlayListDetailViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        
        viewController.viewModel = viewModel
        viewController.multiPurposePopComponent = multiPurposePopComponent
        
        viewController.containSongsComponent = containSongsComponent
        
        return viewController
    }
    
}

public typealias PlayListDetailSectionModel = SectionModel<Int, SongEntity>

extension PlayListDetailViewController{
    
    private func configureSkeleton(){
        
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        
        let baseColor = DesignSystemAsset.PrimaryColor.baseskeleton.color
        
        let secondaryColor = DesignSystemAsset.PrimaryColor.secondaryskeleton.color
        
        
        playListInfoSuperView.isSkeletonable = true
        playListInfoView.isSkeletonable = true
        
        // 디졸브 상황에서 두 장면이 서로 교차할 때, 앞 화면이 사라지고 뒤 화면이 뚜렷하게 나타나는 화면 전환 기법
        playListImage.isSkeletonable = true
        playListImage.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: baseColor ,secondaryColor: secondaryColor), animation: animation, transition: .crossDissolve(0.25))
        
        playListNameLabel.isSkeletonable = true
        playListNameLabel.skeletonCornerRadius = 2
        playListNameLabel.skeletonTextLineHeight = .relativeToFont
        playListNameLabel.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: baseColor ,secondaryColor: secondaryColor), animation: animation, transition: .crossDissolve(0.25))
        
        
        
        playListCountLabel.isSkeletonable = true
        playListCountLabel.skeletonCornerRadius = 2
        playListCountLabel.skeletonTextLineHeight = .relativeToFont
        playListCountLabel.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: baseColor ,secondaryColor: secondaryColor), animation: animation, transition: .crossDissolve(0.25))
        
        
       
    }
    
    
    private func configureUI(){
        self.view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        tableView.backgroundColor = .clear
         
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
        
        
        self.playListCountLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 14)
        self.playListCountLabel.textColor =  DesignSystemAsset.GrayColor.gray900.color.withAlphaComponent(0.6) // opacity 60%
        
        self.playListNameLabel.font  = DesignSystemFontFamily.Pretendard.bold.font(size: 20)
        
        
        playListInfoView.layer.borderWidth = 1
        playListInfoView.layer.borderColor = colorFromRGB(0xFCFCFD).cgColor
        playListInfoView.layer.cornerRadius = 8
        
        
        
        
        
        
        self.playListImage.layer.cornerRadius = 12
        
        self.moreButton.isHidden = viewModel.type == .wmRecommend
        
        
        self.editPlayListNameButton.isHidden = viewModel.type == .wmRecommend
        
        bindRx()
        configureSkeleton()
        bindSelectedEvent()
    }
    
    private func createDatasources() -> RxTableViewSectionedReloadDataSource<PlayListDetailSectionModel> {
        let datasource = RxTableViewSectionedReloadDataSource<PlayListDetailSectionModel>(configureCell: { [weak self] (datasource, tableView, indexPath, model) -> UITableViewCell in
            guard let self = self else { return UITableViewCell() }


            switch self.viewModel.type {
                
            case .custom:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayListTableViewCell", for: IndexPath(row: indexPath.row, section: 0)) as? PlayListTableViewCell else{
                    return UITableViewCell()
                }
                
                cell.update(model,self.output.state.value.isEditing,index: indexPath.row)
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
                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: APP_HEIGHT()/3))
                warningView.text = "플레이리스트에 곡이 없습니다."
                
                let items = model.first?.items ?? []
                self.tableView.tableFooterView = items.isEmpty ?  warningView : nil
            })
            .bind(to: tableView.rx.items(dataSource: createDatasources()))
            .disposed(by: disposeBag)
                
        tableView.rx.itemMoved.asObservable()
            .subscribe(onNext: { [weak self] (sourceIndexPath, destinationIndexPath) in
                guard let `self` = self else { return }

                DEBUG_LOG("sourceIndexPath: \(sourceIndexPath)")
                DEBUG_LOG("destIndexPath: \(destinationIndexPath)")

                self.input.sourceIndexPath.accept(sourceIndexPath)
                self.input.destIndexPath.accept(destinationIndexPath)
                
                
                let source = self.input.sourceIndexPath.value.row
                let dest =  self.input.destIndexPath.value.row
                
                var curr = self.output.dataSource.value.first?.items ?? []
                let tmp = curr[source]
                
                curr.remove(at:  source)
                curr.insert(tmp, at: dest)
                
                var indexs = self.output.indexOfSelectedSongs.value // 현재 선택된 인덱스 모음
                let limit = curr.count - 1 // 마지막 인덱스
                
                var isSelctedIndexMoved:Bool = false // 선택된 것을 움직 였는지 ?
                

                let newModel = [PlayListDetailSectionModel(model: 0, items: curr)]
                
               
                if indexs.contains(where: {$0 == source}) {
                    //선택된 인덱스 배열 안에 source(시작점)이 있다는 뜻은 선택된 것을 옮긴다는 뜻

                    let pos = indexs.firstIndex(where: {$0 == source})!
                    indexs.remove(at: pos)
                    
                    //그러므로 일단 지워준다.
                    isSelctedIndexMoved = true // 이후 선택된 것을 움직였으므로 true
                   
                }
                
                
                
                indexs = indexs
                    .map({ i -> Int in
                        
                        //i: 현재 저장된 인덱스들을 순회함
                        
                        if  source < i && i > dest {
                            // 옮기기 시작한 위치와 도착한 위치가 i를 기준으로 앞일 때 아무 영향 없음
                            
                            return i
                        }
                        
                        if source < i && i <= dest {
                            
                            /* 옮기기 시작한 위치는 i 앞
                               도착한 위치가 i또는 i 뒤일 경우
                                i는 앞으로 한 칸 가야함
                             */
                            
                            return i - 1
                        }
                        
                        if   i < source  &&   dest <= i {
                            
                            /* 옮기기 시작한 위치는 i 뒤
                               도착한 위치가 i또는 i 앞일 경우
                                i는 뒤로 한칸 가야함
                             
                                ** 단 옮겨질 위치가  배열의 끝일 경우는 그대로 있음
                             */
                            
                            return i + 1 >= limit ? i : i + 1
                        }
                        
                        if source > i && i < dest {
                            
                            /* 옮기기 시작한 위치는 i 뒤
                               도착한 위치가 i 뒤 일경우
                             
                                아무 영향 없음
                             */
                            
                            
                            return i
                        }
                        
                        return i
                       
   
                    })
                   
                
                if isSelctedIndexMoved { // 선택된 것을 건드렸으므로 dest 인덱스로 갱신하여 넣어준다
                    indexs.append(dest)
                }
                
                indexs.sort()
                
                
                    
                self.output.indexOfSelectedSongs.accept(indexs)
                
                self.output.dataSource.accept(newModel)
                
            }).disposed(by: disposeBag)
        
        output.state
            .skip(1)
            .subscribe(onNext: { [weak self] (state) in
                guard let self = self else { return }
                
                if state.isEditing == false && state.force == false {
                    self.input.runEditing.onNext(())
                }
                
                let isEdit = state.isEditing
                self.navigationController?.interactivePopGestureRecognizer?.delegate = isEdit ? self : nil
                
                self.moreButton.isHidden = isEdit
                self.completeButton.isHidden = !isEdit
                self.editStateLabel.isHidden = !isEdit
                
                self.tableView.setEditing(isEdit, animated: true)
                self.tableView.visibleCells.forEach { $0.isEditing = isEdit }
            })
            .disposed(by: disposeBag)
                
        output.headerInfo.subscribe(onNext: { [weak self] (model) in
            guard let self = self else{
                return
            }
            let type = self.viewModel.type
            
            self.playListImage.kf.setImage(with: type == .wmRecommend ? WMImageAPI.fetchRecommendPlayListWithSquare(id: model.image,version: model.version).toURL : WMImageAPI.fetchPlayList(id: model.image,version: model.version).toURL,placeholder: nil,completionHandler: {[weak self]  _ in
                
                guard let self = self else{
                    return
                }
                
                self.playListImage.stopSkeletonAnimation()
                self.playListImage.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
            })
                
            DEBUG_LOG(model)
            
            self.playListCountLabel.text = model.songCount
            self.playListNameLabel.text = model.title
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                self.playListCountLabel.stopSkeletonAnimation()
                self.playListCountLabel.hideSkeleton(reloadDataAfter: true,transition: .crossDissolve(0.5))


                self.playListNameLabel.stopSkeletonAnimation()
                self.playListNameLabel.hideSkeleton(reloadDataAfter: true,transition: .crossDissolve(0.5))

                self.playListCountLabel.text = model.songCount
                self.playListNameLabel.text = model.title
            }

            self.editPlayListNameButton.setImage(DesignSystemAsset.Storage.storageEdit.image, for: .normal)
            
        }).disposed(by: disposeBag)
                
        NotificationCenter.default.rx.notification(.playListNameRefresh)
            .map({noti -> String in
                guard let obj = noti.object as? String else {
                    return ""
                }
                return obj
                
            })
            .bind(to: input.playListNameLoad)
            .disposed(by: disposeBag)
        
        input.showErrorToast.subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.showToast(text: $0.description, font: DesignSystemFontFamily.Pretendard.light.font(size: 14))
        })
        .disposed(by: disposeBag)
                
        tableView.rx.itemSelected
            .withLatestFrom(output.state){($0,$1)}
            .filter({ [weak self] in
                

                
                $0.1.isEditing || self?.viewModel.type == .wmRecommend})
            .map { $0.0.row }
            .bind(to: input.songTapped)
            .disposed(by: disposeBag)
    }
    
    private func bindSelectedEvent() {
        
        output.indexOfSelectedSongs
            .skip(1)
            .withLatestFrom(output.dataSource) {($0,$1)}
            .withLatestFrom(output.state) { ($0,$1)}
            .subscribe(onNext: { [weak self] (arg0,state)   in
                
                
                let (songs, dataSource) = arg0
                guard let self = self else {return}
                
               
                DEBUG_LOG("SONGs \(songs)")
                    switch songs.isEmpty {
                    case true:
                        self.hideSongCart()
                        
                    case false:
                        self.showSongCart(
                            in: self.view,
                            type: .myList,
                            selectedSongCount: songs.count,
                            totalSongCount: (dataSource.first?.items.count ?? 0),
                            useBottomSpace: true
                        )
                        self.songCartView?.delegate = self
                    }
                
        
                    
                    
         
                
            })
            .disposed(by: disposeBag)
        
        output.songEntityOfSelectedSongs
            .filter{ !$0.isEmpty }
            .debug("songEntityOfSelectedSongs")
            .subscribe()
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
        DEBUG_LOG(event)
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
                self.output.state.accept(EditState(isEditing: false, force: true))
            }
        case .addPlayList:
            return
        case .play:
            return
        case .remove:
            return
        }
    }
    
    
}

extension PlayListDetailViewController:EditSheetViewDelegate {
    public func buttonTapped(type: EditSheetSelectType) {
        
       
        
        switch type {
            
        case .edit:
            output.state.accept(EditState(isEditing: true, force: false))
        case .share:
            let vc = multiPurposePopComponent.makeView(type: .share,key: viewModel?.key ?? "")
            
            self.showPanModal(content: vc)
            
        case .profile:
            return
        case .nickname:
            return
        }
        
        self.hideEditSheet()
        
    }
    
    
}

extension PlayListDetailViewController:PlayListCellDelegate {
    public func pressCell(index: Int) {
        
        input.songTapped.onNext(index)
        
    }
    
    
}
