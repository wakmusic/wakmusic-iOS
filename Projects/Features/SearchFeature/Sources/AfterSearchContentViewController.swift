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


class AfterSearchContentViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var tableView: UITableView!
    
    //섹션 타이이틀
    //갯수
    //배열 
  
    var dataSource: BehaviorRelay<[SongInfoDTO]> =  BehaviorRelay(value:  [SongInfoDTO(name: "리와인드 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12"),SongInfoDTO(name: "리와인드 (RE:WIND)", artist: "이세계아이돌", releaseDay: "2022.12.12")])
    
   
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindRx()
        

        // Do any additional setup after loading the view.
    }
    
    public static func viewController() -> AfterSearchContentViewController{
        let viewController = AfterSearchContentViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)
        
        DEBUG_LOG("After After")
        
 
        return viewController
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AfterSearchContentViewController{
    private func configureUI()
    {
        self.tableView.backgroundColor = .clear
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56))
        //self.view.backgroundColor = .
    }
    
    private func bindRx()
    {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        //xib로 만든 UI를 컬렉션 뷰에서 사용하기 위해서는 등록이 필요
        //다른 모듈 시 번들 변경 Bundle.module 사용 X
        tableView.register(UINib(nibName:"SongListCell", bundle: DesignSystemResources.bundle), forCellReuseIdentifier: "SongListCell")
        
        dataSource.bind(to: tableView.rx.items) { (tableView, index, model) -> UITableViewCell in
            let indexPath: IndexPath = IndexPath(row: index, section: 0)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongListCell", for: indexPath) as? SongListCell else{
                return UITableViewCell()
            }
            cell.update(model)
            return cell
        }.disposed(by: disposeBag)
        
        
        
    }
    
}

extension AfterSearchContentViewController:UITableViewDelegate{
 
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let songlistHeader = EntireSectionHeader()
        songlistHeader.update("노래", self.dataSource.value.count)
        
        
        return songlistHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
