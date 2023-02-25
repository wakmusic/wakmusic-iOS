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





public class PlayListDetailViewController: BaseViewController,ViewControllerFromStoryBoard {
    
    
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
    

    var disposeBag = DisposeBag()
    var viewModel:PlayListDetailViewModel!
    var multiPurposePopComponent:MultiPurposePopComponent!
    
    
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        let isEdit: Bool = viewModel.output.state.value.isEditing
        
        if isEdit {
            
            let vc = TextPopupViewController.viewController(text: "변경된 내용을 저장할까요?", cancelButtonIsHidden: false,completion: {[weak self] in
                
                guard let self =  self else {
                    return
                }
                //TODO: 저장 코드
                self.viewModel.input.runEditing.onNext(())
                
               // self.navigationController?.popViewController(animated: true)
           // self.viewModel.output.state.accept(EditState(isEditing: false, force: true))
            self.navigationController?.popViewController(animated: true)
                
            },cancelCompletion: { [weak self] in
                
                guard let self =  self else {
                    return
                }
                
                self.viewModel.output.state.accept(EditState(isEditing: false, force: true))
                
                self.viewModel.input.cancelEdit.onNext(())
                
                
            })
            self.showPanModal(content: vc)
        }else{
            
            self.navigationController?.popViewController(animated: true)
        }
       
    }
    
    @IBAction func pressEditListAction(_ sender: UIButton) {
        
        viewModel.output.state.accept(EditState(isEditing: true, force: false))
        
        
       
        
    }
    
    
    @IBAction func pressCompleteAction(_ sender: UIButton) {
        
        viewModel.output.state.accept(EditState(isEditing: false, force: false))
        
       
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
    
    deinit {
        DEBUG_LOG("\(Self.self) deinit")
        
    }
    
    public static func viewController(viewModel:PlayListDetailViewModel,multiPurposePopComponent:MultiPurposePopComponent) -> PlayListDetailViewController {
        let viewController = PlayListDetailViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        
        viewController.viewModel = viewModel
        viewController.multiPurposePopComponent = multiPurposePopComponent
        
        return viewController
    }
    
}

extension PlayListDetailViewController{
    
    private func configureUI(){
    
    
       
        
        // Drag & Drop 기능을 위한 부분
        
        self.tableView.dragInteractionEnabled = false //첫 화면 시  드래그 앤 드롭 방지
        self.tableView.dragDelegate = viewModel.type == .wmRecommend ? nil : self
        self.tableView.dropDelegate = viewModel.type == .wmRecommend ? nil : self
        
        if viewModel.type != .wmRecommend {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
            tableView.addGestureRecognizer(longPress)
        }
        
        
        
        
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
        
        
        self.editPlayListNameButton.setImage(DesignSystemAsset.Storage.storageEdit.image, for: .normal)
        
        
        
        self.playListImage.layer.cornerRadius = 12
        
        self.moreButton.isHidden = viewModel.type == .wmRecommend
        
        
        self.editPlayListNameButton.isHidden = viewModel.type == .wmRecommend
        
        bindRx()
        
        
    }
    
    
    private func bindRx()
    {
       
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(UINib(nibName:"SongListCell", bundle: CommonFeatureResources.bundle), forCellReuseIdentifier: "SongListCell")
        
        //xib로 만든 UI를 컬렉션 뷰에서 사용하기 위해서는 등록이 필요
        //다른 모듈 시 번들 변경 Bundle.module 사용 X
        
        viewModel.output.dataSource
            .skip(1)
            .do(onNext: { [weak self] model in
                
                guard let self = self else {
                    return
                }
                
                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: APP_HEIGHT()/3))
                warningView.text = "플레이리스트에 곡이 없습니다."
                
                
                self.tableView.tableFooterView = model.isEmpty ?  warningView : nil
            })
            .bind(to: tableView.rx.items){[weak self] (tableView, index, model) -> UITableViewCell in
       
                
                guard let self = self else { return UITableViewCell() }

                let bgView = UIView()
                bgView.backgroundColor = DesignSystemAsset.GrayColor.gray200.color
                switch self.viewModel.type {
                    
                case .custom:
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayListTableViewCell",for: IndexPath(row: index, section: 0)) as? PlayListTableViewCell else{
                        return UITableViewCell()
                    }
                    
                    cell.selectedBackgroundView = bgView
                    cell.update(model,self.viewModel.output.state.value.isEditing)
                    
                    return cell
                case .wmRecommend:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongListCell",for: IndexPath(row: index, section: 0)) as? SongListCell else{
                        return UITableViewCell()
                    }
                    
                    cell.selectedBackgroundView = bgView
                    cell.update(model)
                    
                    return cell
                case .none:
                    return UITableViewCell()
                }
                
                
            }
            .disposed(by: disposeBag)

        
               
        
        viewModel.output.state
            .skip(1)
            .do(onNext: { [weak self] state in
                guard let self = self else { return }
                
                
                if state.isEditing == false && state.force == false {
                    
                    self.viewModel.input.runEditing.onNext(())
                }
                
                
                let isEdit = state.isEditing
                
                self.navigationController?.interactivePopGestureRecognizer?.delegate = isEdit ? self : nil
                self.tableView.dragInteractionEnabled = isEdit // true/false로 전환해 드래그 드롭을 활성화하고 비활성화 할 것입니다.
                
                self.moreButton.isHidden = isEdit
                self.completeButton.isHidden = !isEdit
                self.editStateLabel.isHidden = !isEdit
                
                
            })
                .withLatestFrom(viewModel.output.dataSource)
                .bind(to: viewModel.output.dataSource)
            .disposed(by: disposeBag)
                //에딧 상태에 따른 cell 변화를 reload 해주기 위해
                
        
                
        viewModel.output.headerInfo.subscribe(onNext: { [weak self] (model) in
            
            guard let self = self else{
                return
            }
            let type = self.viewModel.type
            
            self.playListImage.kf.setImage(with: type == .wmRecommend ? WMImageAPI.fetchRecommendPlayListWithSquare(id: model.image).toURL : WMImageAPI.fetchPlayList(id: model.image).toURL)
            
            self.playListCountLabel.text = model.songCount
            self.playListNameLabel.text = model.title
            
        }).disposed(by: disposeBag)
                
        
            NotificationCenter.default.rx.notification(.playListNameRefresh)
                .flatMap({ noti -> Observable<String> in
                    
                    guard let obj = noti.object as? String else {
                        return Observable.empty()
                    }
                    
                    return Observable<String>.just(obj)
                    
                })
                .bind(to: viewModel.input.playListNameLoad)
            .disposed(by: disposeBag)
        
        
                viewModel.input.showErrorToast.subscribe(onNext: { [weak self] in
                    
                    guard let self = self else {
                        return
                    }
                    
                    
                    self.showToast(text: $0.description, font: DesignSystemFontFamily.Pretendard.light.font(size: 14))
                    
                })
                .disposed(by: disposeBag)
                
      
    }
    
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        
        
        if  !viewModel.output.state.value.isEditing && sender.state == .began  {
            viewModel.output.state.accept(EditState(isEditing: true, force: true))
            UIImpactFeedbackGenerator(style: .light).impactOccurred() //진동 코드
        }
    }
 
}
   
    



extension PlayListDetailViewController:UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
    
        let view = PlayButtonGroupView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 80))
        
        view.delegate = self

        
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 80
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    
    
//    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
//
//        print("from \(sourceIndexPath) to \(proposedDestinationIndexPath)")
//
//        return IndexPath(item: 0, section: 0)
//
//    }
    
    


    
       
}



extension PlayListDetailViewController: PlayButtonGroupViewDelegate{
    public func pressPlay(_ event: PlayEvent) {
        DEBUG_LOG(event)
    }
    
    
}

extension PlayListDetailViewController: UITableViewDragDelegate {
    public func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        
        viewModel.input.sourceIndexPath.accept(indexPath)
        let itemProvider = NSItemProvider(object: "1" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
        
        
        // 애플의 공식 문서에서는 사용자가 특정 행을 드래그하는 것을 원하지 않으면 빈 배열을 리턴하라고 했는데,
        //빈 배열을 리턴했을 때도 드래그가 가능했습니다. 이 부분은 더 자세히 알아봐야 할 것 같습니다.
    }
    
    
    
    
}

extension PlayListDetailViewController: UITableViewDropDelegate {
    
    
    // 손가락을 화면에서 뗐을 때. 드롭한 데이터를 불러와서 data source를 업데이트 하고, 필요하면 새로운 행을 추가한다.
    public func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        let destinationIndexPath: IndexPath

                if let indexPath = coordinator.destinationIndexPath {
                    destinationIndexPath = indexPath
                } else {
                    // Get last index path of table view.
                    let section = tableView.numberOfSections - 1
                    let row = tableView.numberOfRows(inSection: section)
                    destinationIndexPath = IndexPath(row: row, section: section)
                }
        viewModel.input.destIndexPath.accept(destinationIndexPath)
        
        
        
        var curr = viewModel.output.dataSource.value
        var tmp = curr[viewModel.input.sourceIndexPath.value.row]
        curr.remove(at: viewModel.input.sourceIndexPath.value.row)
        curr.insert(tmp, at: viewModel.input.destIndexPath.value.row)

        viewModel.output.dataSource.accept(curr)
        
        
    }
    
    // 드래그할 떄 (손가락을 화면에 대고 있을 때)
    public func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        var dropProposal = UITableViewDropProposal(operation: .cancel)
        
       
        // Accept only one drag item.
        guard session.items.count == 1 else { return dropProposal }
        
        // The .move drag operation is available only for dragging within this app and while in edit mode.
        if tableView.hasActiveDrag {
            //            if tableView.isEditing {
            dropProposal = UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            //            }
        } else {
            // Drag is coming from outside the app.
            dropProposal = UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
        
        
        return dropProposal
    }
    
    
    
}

extension PlayListDetailViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

