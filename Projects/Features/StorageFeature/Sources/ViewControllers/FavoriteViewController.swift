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
import BaseFeature
import CommonFeature
import DomainModule
import RxDataSources

public typealias FavoriteSectionModel = SectionModel<Int, FavoriteSongEntity>

public final class FavoriteViewController: BaseViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var tableView: UITableView!
    
    
  
    var viewModel: FavoriteViewModel!
    lazy var input = FavoriteViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    
    
    var disposeBag = DisposeBag()
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()

        // Do any additional setup after loading the view.
    }
    

    public static func viewController(viewModel:FavoriteViewModel) -> FavoriteViewController {
        let viewController = FavoriteViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        
      
        viewController.viewModel = viewModel
        
        return viewController
    }

}

extension FavoriteViewController{
    
    private func createDatasources() -> RxTableViewSectionedReloadDataSource<FavoriteSectionModel> {
        let datasource = RxTableViewSectionedReloadDataSource<FavoriteSectionModel>(configureCell: { [weak self] (datasource, tableView, indexPath, model) -> UITableViewCell in
            guard let self = self else{return UITableViewCell()}
            
            let bgView = UIView()
            bgView.backgroundColor = DesignSystemAsset.GrayColor.gray200.color.withAlphaComponent(0.6)
            
            let index = indexPath.row
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier:  "FavoriteTableViewCell", for: IndexPath(row: index, section: 0)) as? FavoriteTableViewCell
            else {return UITableViewCell()}
             
            cell.selectedBackgroundView = bgView
            cell.update(model, self.output.state.value.isEditing)
          
                    
         return cell
            
        }, canEditRowAtIndexPath: { (_, _) -> Bool in
            return true
        }, canMoveRowAtIndexPath: { (_, _) -> Bool in
            return true
        })
        return datasource
    }
    
    private func configureUI()
    {
        self.view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        tableView.backgroundColor = .clear
        
        bindRx()
        
    }
    
   
    
    private func bindRx()
    {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        output.dataSource
        .do(onNext: { [weak self] model in
            
            guard let self = self else {
                return
            }
            
            let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: APP_HEIGHT()/3))
            warningView.text = "좋아요 한 곡이 없습니다."
        
            
            self.tableView.tableHeaderView = model.isEmpty ?  warningView : nil
        })
            
            .bind(to: tableView.rx.items(dataSource: createDatasources()))
            .disposed(by: disposeBag)
            
            tableView.rx.itemMoved.asObservable()
                .subscribe(onNext: { [weak self] (sourceIndexPath, destinationIndexPath) in
                    guard let `self` = self else { return }



                    self.input.sourceIndexPath.accept(sourceIndexPath)
                    self.input.destIndexPath.accept(destinationIndexPath)
                    
                    var curr = self.output.dataSource.value.first?.items ?? []
                    
                    let tmp = curr[self.input.sourceIndexPath.value.row]
                    curr.remove(at: self.input.sourceIndexPath.value.row)
                    curr.insert(tmp, at: self.input.destIndexPath.value.row)

                    let newModel = [FavoriteSectionModel(model: 0, items: curr)]
                    self.output.dataSource.accept(newModel)
                    
                }).disposed(by: disposeBag)
        
        
        output.state
            .skip(1)
            .subscribe(onNext: { [weak self] (state) in
                guard let self = self else{
                    return
                }
                if state.isEditing == false && state.force == false { // 정상적인 편집 완료 이벤트
                    self.input.runEditing.onNext(())
                }
                guard let parent = self.parent?.parent as? AfterLoginViewController else{
                    return
                }
                // 탭맨 쪽 편집 변경
                let isEdit: Bool = state.isEditing
                parent.output.state.accept(EditState(isEditing: isEdit, force: true))
                self.tableView.setEditing(isEdit, animated: true)
                self.tableView.visibleCells.forEach { $0.isEditing = isEdit }
            })
            .disposed(by: disposeBag)

        input.showConfirmModal.subscribe(onNext: { [weak self] in
                    
            guard let self = self else{
                return
            }
                let vc = TextPopupViewController.viewController(text: "변경된 내용을 저장할까요?", cancelButtonIsHidden: false,completion: {
                    self.input.runEditing.onNext(())
                },cancelCompletion: {
                    self.input.cancelEdit.onNext(())
                })
            
                self.showPanModal(content: vc)
            
            }).disposed(by: disposeBag)
                
                
        input.showErrorToast.subscribe(onNext: { [weak self] (msg:String) in
            guard let self = self else{
                return
            }
            self.showToast(text: msg, font: DesignSystemFontFamily.Pretendard.light.font(size: 14))
            
        }).disposed(by: disposeBag)

    }
}

extension FavoriteViewController:UITableViewDelegate{
    
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



