//
//  MyPlayListViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import RxSwift
import RxRelay
import RxCocoa
import DesignSystem
import PanModal

class MyPlayListViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var tableView: UITableView!
    
    
    var isEdit:BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    //var dataSource: BehaviorRelay<[PlayListDTO]> = BehaviorRelay(value: [PlayListDTO(playListName: "임시 플레이리스트", numberOfSong: 100)])
    
    var dataSource: BehaviorRelay<[PlayListDTO]> = BehaviorRelay(value: [])
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

        // Do any additional setup after loading the view.
    }
    

    public static func viewController() -> MyPlayListViewController {
        let viewController = MyPlayListViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        
      
        
        return viewController
    }

}

extension MyPlayListViewController{
    
    private func configureUI()
    {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0 //섹션 해더를 쓸 경우 꼭 언급
        }
        
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
            warningView.text = "플레이리스트가 없습니다."
            
            
            self.tableView.tableHeaderView = model.isEmpty ?  warningView : nil
        })
            .bind(to: tableView.rx.items){[weak self] (tableView,index,model) -> UITableViewCell in
                guard let self = self else{return UITableViewCell()}
                
                let bgView = UIView()
                bgView.backgroundColor = DesignSystemAsset.GrayColor.gray200.color.withAlphaComponent(0.6)
                
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPlayListTableViewCell",for: IndexPath(row: index, section: 0)) as? MyPlayListTableViewCell
                else {return UITableViewCell()}
                 
                cell.selectedBackgroundView = bgView
                cell.update(model: model, isEditing: self.isEdit.value)
              
                        
             return cell
            }.disposed(by: disposeBag)
        
        
        isEdit
            .do(onNext: { [weak self] (res:Bool) in
                
                guard let self = self else{
                    return
                }
                
                
                self.tableView.dragInteractionEnabled = res
                
                
            })
            .withLatestFrom(dataSource)
            .bind(to: dataSource)
            .disposed(by: disposeBag)
    
        
      
        
    }
    
}



extension MyPlayListViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let header = MyPlayListHeaderView()
      

        header.delegate = self
        return dataSource.value.isEmpty ? nil :  isEdit.value ? nil : header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        return dataSource.value.isEmpty ? 0 : isEdit.value ? 0 : 140
        
        
    }
    
}

extension MyPlayListViewController:MyPlayListHeaderViewDelegate{
    func action(_ type: PlayListControlPopupType) {
     
            
        let vc =  CreatePlayListPopupViewController.viewController(type: type)
        
        let viewController:PanModalPresentable.LayoutType = vc
        self.presentPanModal(viewController)
            
      
    }
    
    
}



