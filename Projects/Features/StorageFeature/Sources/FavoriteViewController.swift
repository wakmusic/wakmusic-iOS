//
//  FavoriteViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import RxRelay
import DesignSystem
import RxSwift

class FavoriteViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var tableView: UITableView!
    
    
    var dataSource: BehaviorRelay<[SongInfoDTO]> = BehaviorRelay(value: [SongInfoDTO(name: "리와인드1 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드2 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드3 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드3 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드4 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드2 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드5 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드26(RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드3 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12")])
    
    lazy var viewModel = FavoriteViewModel()
    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

        // Do any additional setup after loading the view.
    }
    

    public static func viewController() -> FavoriteViewController {
        let viewController = FavoriteViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        
      
        
        return viewController
    }

}

extension FavoriteViewController{
    
    private func configureUI()
    {
        tableView.dropDelegate = self
        tableView.dragDelegate = self
        
        if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0 //섹션 해더를 쓸 경우 꼭 언급
        }
        self.view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        tableView.backgroundColor = .clear
        
        bindRx()
        
    }
    
    private func bindRx()
    {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        dataSource
        .do(onNext: { [weak self] model in
            
            guard let self = self else {
                return
            }
            
            let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: APP_HEIGHT()/3))
            warningView.text = "좋아요 한 곡이 없습니다."
            
            
            self.tableView.tableHeaderView = model.isEmpty ?  warningView : nil
        })
            .bind(to: tableView.rx.items){[weak self] (tableView:UITableView,index:Int,model:SongInfoDTO) -> UITableViewCell in
                guard let self = self else{return UITableViewCell()}
                
                let bgView = UIView()
                bgView.backgroundColor = DesignSystemAsset.GrayColor.gray200.color.withAlphaComponent(0.6)
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier:  "FavoriteTableViewCell", for: IndexPath(row: index, section: 0)) as? FavoriteTableViewCell
                else {return UITableViewCell()}
                 
                cell.selectedBackgroundView = bgView
                cell.update(model, self.viewModel.output.isEditinglist.value)
              
                        
             return cell
            }.disposed(by: disposeBag)
        
        
        viewModel.output.isEditinglist
            .do(onNext: { [weak self] (res:Bool) in
                
                guard let self = self else{
                    return
                }
                
                
                self.tableView.dragInteractionEnabled = res
                
                DEBUG_LOG("RES: \(res)")
                
                
            })
            .withLatestFrom(dataSource)
            .bind(to: dataSource)
            .disposed(by: disposeBag)
    
        
      
        
    }
    
}

extension FavoriteViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
        
}


extension  FavoriteViewController: UITableViewDragDelegate {
    public func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        
        self.viewModel.input.sourceIndexPath.accept(indexPath)
        let itemProvider = NSItemProvider(object: "1" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
        
        
        // 애플의 공식 문서에서는 사용자가 특정 행을 드래그하는 것을 원하지 않으면 빈 배열을 리턴하라고 했는데,
        //빈 배열을 리턴했을 때도 드래그가 가능했습니다. 이 부분은 더 자세히 알아봐야 할 것 같습니다.
    }
    
    
    
    
}

extension  FavoriteViewController: UITableViewDropDelegate {
    
    
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
        self.viewModel.input.destIndexPath.accept(destinationIndexPath)
        
        
        
        
        var curr = dataSource.value
        var tmp = curr[self.viewModel.input.sourceIndexPath.value.row]
        curr.remove(at: self.viewModel.input.sourceIndexPath.value.row)
        curr.insert(tmp, at: self.viewModel.input.destIndexPath.value.row)
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
