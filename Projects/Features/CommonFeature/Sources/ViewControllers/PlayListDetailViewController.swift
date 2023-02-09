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



public enum PlayListType{
    case custom
    case wmRecommend
}


public class PlayListDetailViewController: UIViewController,ViewControllerFromStoryBoard {
    
    
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
    

    var pt:PlayListType = .custom
    var disposeBag = DisposeBag()
    lazy var viewModel = PlayListDetailViewModel()
    
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        let isEdit: Bool = viewModel.output.isEditinglist.value
        
        if isEdit {
            let vc = TextPopupViewController.viewController(text: "변경된 내용을 저장할까요?", cancelButtonIsHidden: false,completion: {
                //TODO: 저장 코드
                
               // self.navigationController?.popViewController(animated: true)
                self.viewModel.output.isEditinglist.accept(false)
                
            },cancelCompletion: {
                self.viewModel.output.isEditinglist.accept(false)
            })
            self.showPanModal(content: vc)
        }else{
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func pressEditListAction(_ sender: UIButton) {
        
        viewModel.output.isEditinglist.accept(true)
        
        
       
        
    }
    
    
    @IBAction func pressCompleteAction(_ sender: UIButton) {
        
        viewModel.output.isEditinglist.accept(false)
        
       
    }
    
    @IBAction func pressEditNameAction(_ sender: UIButton) {
        
        let createPlayListPopupViewController = MultiPurposePopupViewController.viewController(type: .edit)
        self.showPanModal(content: createPlayListPopupViewController)
    }
    
    let sourceIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
    let destIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
    
    var dataSource: BehaviorRelay<[SongInfoDTO]> = BehaviorRelay(value: [
        SongInfoDTO(name: "리와인드1 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),
        SongInfoDTO(name: "리와인드2 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드3 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),
        SongInfoDTO(name: "리와인드3 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),
        SongInfoDTO(name: "리와인드4 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),
        SongInfoDTO(name: "리와인드2 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),
        SongInfoDTO(name: "리와인드5 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),
        SongInfoDTO(name: "리와인드26(RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드3 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12")])
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
       
        
        configureUI()
        
        // Drag & Drop 기능을 위한 부분
        
        self.tableView.dragInteractionEnabled = false //첫 화면 시  드래그 앤 드롭 방지
        self.tableView.dragDelegate = self
        self.tableView.dropDelegate = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
        
        
        // Do any additional setup after loading the view.
    }
    
    public static func viewController(_ pt:PlayListType) -> PlayListDetailViewController {
        let viewController = PlayListDetailViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        
        viewController.pt = pt
        
        return viewController
    }
    
}

extension PlayListDetailViewController{
    
    private func configureUI(){
    
        
        
        if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0 //섹션 해더를 쓸 경우 꼭 언급
        }
        self.view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        tableView.backgroundColor = .clear
        
         
        self.completeButton.isHidden = true
        self.editStateLabel.isHidden = true
        
        
        
        
        self.playListImage.image = DesignSystemAsset.PlayListTheme.theme0.image
        
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
        
        
        
        self.playListImage.image = pt == .wmRecommend ? DesignSystemAsset.RecommendPlayList.dummyPlayList.image :  DesignSystemAsset.PlayListTheme.theme0.image
        
        self.moreButton.isHidden = pt == .wmRecommend
        
        
        self.editPlayListNameButton.isHidden = pt == .wmRecommend
        
        bindRx()
        
        
    }
    
    
    private func bindRx()
    {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(UINib(nibName:"SongListCell", bundle: CommonFeatureResources.bundle), forCellReuseIdentifier: "SongListCell")
        
        //xib로 만든 UI를 컬렉션 뷰에서 사용하기 위해서는 등록이 필요
        //다른 모듈 시 번들 변경 Bundle.module 사용 X
        
        dataSource
            .do(onNext: { [weak self] model in
                
                guard let self = self else {
                    return
                }
                
                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: APP_HEIGHT()/3))
                warningView.text = "플레이리스트에 곡이 없습니다."
                
                
                self.tableView.tableHeaderView = model.isEmpty ?  warningView : nil
            })
            .bind(to: tableView.rx.items){[weak self] (tableView, index, model) -> UITableViewCell in
       
                
                guard let self = self else { return UITableViewCell() }

                let bgView = UIView()
                bgView.backgroundColor = DesignSystemAsset.GrayColor.gray200.color
                switch self.pt {
                    
                case .custom:
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayListTableViewCell",for: IndexPath(row: index, section: 0)) as? PlayListTableViewCell else{
                        return UITableViewCell()
                    }
                    
                    cell.selectedBackgroundView = bgView
                    cell.update(model,self.viewModel.output.isEditinglist.value)
                    
                    return cell
                case .wmRecommend:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongListCell",for: IndexPath(row: index, section: 0)) as? SongListCell else{
                        return UITableViewCell()
                    }
                    
                    cell.selectedBackgroundView = bgView
                    cell.update(model)
                    
                    return cell
                }
                
                
            }
            .disposed(by: disposeBag)

        
               
        
        viewModel.output.isEditinglist
            .do(onNext: { [weak self] isEdit in
                guard let self = self else { return }
                
                self.navigationController?.interactivePopGestureRecognizer?.delegate = isEdit ? self : nil
                self.tableView.dragInteractionEnabled = isEdit // true/false로 전환해 드래그 드롭을 활성화하고 비활성화 할 것입니다.
                
                self.moreButton.isHidden = isEdit
                self.completeButton.isHidden = !isEdit
                self.editStateLabel.isHidden = !isEdit
                
                
            })
            .withLatestFrom(dataSource)
            .bind(to: dataSource)
            .disposed(by: disposeBag)
                //에딧 상태에 따른 cell 변화를 reload 해주기 위해
        
                
                
                
      
    }
    
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        
        
        if  !viewModel.output.isEditinglist.value && sender.state == .began {
            viewModel.output.isEditinglist.accept(true)
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
        
        
        sourceIndexPath.accept(indexPath)
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
        destIndexPath.accept(destinationIndexPath)
        
        
        
        var curr = dataSource.value
        var tmp = curr[sourceIndexPath.value.row]
        curr.remove(at: sourceIndexPath.value.row)
        curr.insert(tmp, at: destIndexPath.value.row)
        
        print("\(sourceIndexPath.value.row) \(destIndexPath.value.row)")
        dataSource.accept(curr)
        
        
        DEBUG_LOG(destinationIndexPath)
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

