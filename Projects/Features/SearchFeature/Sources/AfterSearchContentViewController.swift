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



typealias SearchSectionModel = SectionModel<String,SongInfoDTO>


enum SearchType{
    case all
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
    var dataSource: BehaviorRelay<[SearchSectionModel]> = BehaviorRelay(value:[SearchSectionModel.init(model: "노래", items: [SongInfoDTO(name: "리와인드 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12")]),SearchSectionModel.init(model: "가수", items: [SongInfoDTO(name: "리와인드 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12")])])
    
   
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
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56)) // 미니 플레이어 만큼 밑에서 뛰움
        //self.view.backgroundColor = .
    }
    
    private func bindRx()
    {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        //xib로 만든 UI를 컬렉션 뷰에서 사용하기 위해서는 등록이 필요
        //다른 모듈 시 번들 변경 Bundle.module 사용 X
        tableView.register(UINib(nibName:"SongListCell", bundle: DesignSystemResources.bundle), forCellReuseIdentifier: "SongListCell")
        
        dataSource.bind(to: tableView.rx.items(dataSource: createDatasource()))
        .disposed(by: disposeBag)
        
        
        
    }
    
}

extension AfterSearchContentViewController:UITableViewDelegate{
 
    
    
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let songlistHeader = EntireSectionHeader()
        songlistHeader.update(self.dataSource.value[section].model, self.dataSource.value[section].items.count)
        
        
        return songlistHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}


extension AfterSearchContentViewController{

    func createDatasource() -> RxTableViewSectionedReloadDataSource<SearchSectionModel>{

        let datasource = RxTableViewSectionedReloadDataSource<SearchSectionModel>(configureCell: { [weak self] (datasource, tableView, indexPath, model) -> UITableViewCell in

            guard let self = self else { return UITableViewCell() }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongListCell", for: indexPath) as? SongListCell else{
                return UITableViewCell()
            }
            return cell


        }, titleForHeaderInSection: { (datasource, sectionNumber) -> String? in
            return nil
        })

        return datasource
    }
}
