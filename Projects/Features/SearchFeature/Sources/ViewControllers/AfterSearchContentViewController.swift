//
//  AfterSearchContentViewController.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/11.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import RxCocoa
import RxSwift
import RxDataSources
import DesignSystem
import BaseFeature
import CommonFeature
import DomainModule




public final class AfterSearchContentViewController: BaseViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var tableView: UITableView!
    
    //섹션 타이이틀
    //갯수
    //배열 
    
    var viewModel:AfterSearchContentViewModel!
    lazy var input = AfterSearchContentViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    
   
    
   
    var disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        DEBUG_LOG("VIEW DID LOAD")
        
        configureUI()
        requestFromParent()
        
        

        // Do any additional setup after loading the view.
    }
    
    public static func viewController(viewModel:AfterSearchContentViewModel) -> AfterSearchContentViewController{
        let viewController = AfterSearchContentViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)
        
        viewController.viewModel = viewModel
       
        
        DEBUG_LOG("After After")
        
 
        return viewController
    }
    

    
    
    

}

extension AfterSearchContentViewController{
    private func configureUI()
    {
        self.tableView.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56))
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        self.view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
//        self.indicator.startAnimating()
//        self.indicator.hidesWhenStopped = true
        bindRx()
        bindRxEvent()
    }
    
    private func bindRx()
    {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        //xib로 만든 UI를 컬렉션 뷰에서 사용하기 위해서는 등록이 필요
        //다른 모듈 시 번들 변경 Bundle.module 사용 X
        tableView.register(UINib(nibName:"SongListCell", bundle: CommonFeatureResources.bundle), forCellReuseIdentifier: "SongListCell")
        
        output.dataSource
            .do(onNext: { [weak self] model in
                
         
                guard let self = self else {
                    return
                }
                
                
                self.tableView.isHidden = false // 검색 완료 시 보여줌
                
                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: APP_HEIGHT()/2))
                warningView.text = "검색결과가 없습니다."
                
                
                let isEmpty = model.first?.items.isEmpty ?? false
                
                
                self.tableView.tableHeaderView = isEmpty ?  warningView : nil
            })
            .bind(to: tableView.rx.items(dataSource: createDatasource()))
        .disposed(by: disposeBag)
        
        
        
    }
    
    private func bindRxEvent()
    {
        tableView.rx.itemSelected
            .bind(to: input.indexPath)
            .disposed(by: disposeBag)
            
    }
        
    
    func requestFromParent()
    {
        
        guard let parent = self.parent?.parent as? AfterSearchViewController else {
            return
        }
        
        
        
       let entities = parent.output.songEntityOfSelectedSongs.value
       let models = output.dataSource.value
       let indexPaths = entities.map { entity -> IndexPath? in
                    var indexPath: IndexPath?

                    models.enumerated().forEach { (section, model) in
                        if let row = model.items.firstIndex(where: { $0 == entity }){
                            indexPath = IndexPath(row: row, section: section)
                        }
                    }
                    return indexPath
       }.compactMap({$0})
        
    input.mandatoryLoadIndexPath.accept(indexPaths)
        
        
    
       
       
        
    }
    
}

extension AfterSearchContentViewController:UITableViewDelegate{
 
    
    
        
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let songlistHeader = EntireSectionHeader()
        
       
        
        
        
        if viewModel.sectionType != .all
        {
            return nil
        }
        
        if self.output.dataSource.value[section].items.count == 0
        {
            return nil
        }
        
        songlistHeader.update(self.output.dataSource.value[section].model)
        songlistHeader.delegate = self
        return songlistHeader
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        if viewModel.sectionType != .all
        {
            return 0
        }
        
        if self.output.dataSource.value[section].items.count == 0
        {
            return 0
        }
        
        return 44
        
        
    }
}


extension AfterSearchContentViewController{

    func createDatasource() -> RxTableViewSectionedReloadDataSource<SearchSectionModel>{

        let datasource = RxTableViewSectionedReloadDataSource<SearchSectionModel>(configureCell: { [weak self] (datasource, tableView, indexPath, model) -> UITableViewCell in

            guard let self = self else { return UITableViewCell() }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongListCell", for: indexPath) as? SongListCell else{
                return UITableViewCell()
            }

            
            cell.update(model)
    

            
            return cell


        }, titleForHeaderInSection: { (datasource, sectionNumber) -> String? in
            return nil
        })

        return datasource
    }
}

extension AfterSearchContentViewController:EntireSectionHeaderDelegate{
    func switchTapEvent(_ type: TabPosition) {
        
        guard let tabMan = parent?.parent as? AfterSearchViewController else {
            return
        }
    
       
        
        tabMan.scrollToPage(.at(index: type.rawValue), animated: true)
        
    }
    
    
}
