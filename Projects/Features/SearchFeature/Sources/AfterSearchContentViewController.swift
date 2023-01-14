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



typealias SearchSectionModel = SectionModel<SearchType,SongInfoDTO>


enum SearchType:Int{
    case all = 0
    case song
    case artist
    case assistant
}



class AfterSearchContentViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var tableView: UITableView!
    
    //섹션 타이이틀
    //갯수
    //배열 
    
    var searchType:SearchType = .all
    
    //var dataSource: BehaviorRelay<[SearchSectionModel]> = BehaviorRelay(value:[])
    var dataSource: BehaviorRelay<[SearchSectionModel]> = BehaviorRelay(value:[SearchSectionModel.init(model: .song, items: [SongInfoDTO(name: "리와인드 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12")]),SearchSectionModel.init(model: .artist, items: [SongInfoDTO(name: "리와인드 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12")]),SearchSectionModel.init(model: .assistant, items: [SongInfoDTO(name: "리와인드 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12")])])
    
   
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        configureUI()
        bindRx()
        

        // Do any additional setup after loading the view.
    }
    
    public static func viewController(_ type:SearchType) -> AfterSearchContentViewController{
        let viewController = AfterSearchContentViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)
        viewController.searchType = type
        
        DEBUG_LOG("After After")
        
 
        return viewController
    }
    

    
    
    

}

extension AfterSearchContentViewController{
    private func configureUI()
    {
        self.tableView.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        //self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56)) // 미니 플레이어 만큼 밑에서 뛰움
        //self.view.backgroundColor = .
    }
    
    private func bindRx()
    {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        //xib로 만든 UI를 컬렉션 뷰에서 사용하기 위해서는 등록이 필요
        //다른 모듈 시 번들 변경 Bundle.module 사용 X
        tableView.register(UINib(nibName:"SongListCell", bundle: DesignSystemResources.bundle), forCellReuseIdentifier: "SongListCell")
        
        dataSource
            .debug("TEXT")
            .do(onNext: { [weak self] model in
                
                guard let self = self else {
                    return
                }
                
                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: APP_HEIGHT()/2))
                warningView.text = "검색결과가 없습니다."
                
                
                self.tableView.tableHeaderView = model.isEmpty ?  warningView : nil
            })
            .bind(to: tableView.rx.items(dataSource: createDatasource()))
        .disposed(by: disposeBag)
        
        
        
    }
    
}

extension AfterSearchContentViewController:UITableViewDelegate{
 
    
    
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let songlistHeader = EntireSectionHeader()
        
       
        
        
        
        if searchType != .all
        {
            return nil
        }
        songlistHeader.update(self.dataSource.value[section].model, self.dataSource.value[section].items.count)
        songlistHeader.delegate = self
        return songlistHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        return  searchType == .all ? 44 : 0
        
        
    }
}


extension AfterSearchContentViewController{

    func createDatasource() -> RxTableViewSectionedReloadDataSource<SearchSectionModel>{

        let datasource = RxTableViewSectionedReloadDataSource<SearchSectionModel>(configureCell: { [weak self] (datasource, tableView, indexPath, model) -> UITableViewCell in

            guard let self = self else { return UITableViewCell() }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongListCell", for: indexPath) as? SongListCell else{
                return UITableViewCell()
            }
            let bgView = UIView()
            bgView.backgroundColor = DesignSystemAsset.GrayColor.gray200.color
            
            cell.update(model)
            cell.selectedBackgroundView = bgView
            //cell.selectedBa = DesignSystemAsset.GrayColor.gray200.color
            
            return cell


        }, titleForHeaderInSection: { (datasource, sectionNumber) -> String? in
            return nil
        })

        return datasource
    }
}

extension AfterSearchContentViewController:EntireSectionHeaderDelegate{
    func switchTapEvent(_ type: SearchType) {
        
        guard let tabMan = parent?.parent as? AfterSearchViewController else {
            return
        }
    
       
        
        tabMan.scrollToPage(.at(index: type.rawValue), animated: true)
        
    }
    
    
}
