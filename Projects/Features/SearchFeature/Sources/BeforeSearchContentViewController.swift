//
//  SearchContentViewController.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/05.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import RxSwift
import RxCocoa

class BeforeSearchContentViewController: UIViewController,ViewControllerFromStoryBoard {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    let disposeBag = DisposeBag()
    
    var viewModel = BeforeSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DEBUG_LOG("\(Self.self) viewDidLoad")
        //tableView.delegate = self
        //tableView.dataSource = self
        configureUI()
        bindTable()
        

        
    }
    
    public static func viewController() -> BeforeSearchContentViewController {
        let viewController =  BeforeSearchContentViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)
        return viewController
    }
    

}



extension BeforeSearchContentViewController {
    
    
    private func configureUI() {
        self.tableView.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
    }
    
    
    private func bindTable() {
        
       
        // 헤더 적용을 위한 델리게이트
        tableView.rx.setDelegate(self)
        .disposed(by: disposeBag)
        
        guard let parent = self.parent as? SearchViewController else
        {
            return
        }
        
   
        //cell 그리기
        viewModel.output.keywords.bind(to: tableView.rx.items) { (tableView: UITableView, index: Int, element: String) -> RecentRecordTableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentRecordTableViewCell") as? RecentRecordTableViewCell  else
            {
                return RecentRecordTableViewCell()
            }
            
            cell.backgroundColor = .clear
            cell.recentLabel.text = element
            cell.delegate = self
            
            return cell
                
        }.disposed(by: disposeBag)
        
        
        //터치 이벤트
        tableView.rx.modelSelected(String.self)
            .subscribe{ event in
                
                let keyword = event.element!
                
                parent.searchTextFiled.rx.text.onNext(keyword)
                parent.viewModel.input.textString.accept(keyword)
                parent.viewModel.output.isFoucused.accept(false)
                parent.view.endEditing(true)
            }.disposed(by: disposeBag)
        
//        tableView.rx.itemDeleted
//                .subscribe(onNext: { [weak self] indexPath in
//                        self?.keywords.remove(at: indexPath.row)
//                })
//                .disposed(by: disposeBag)
            
      
        
        
        
        
    }
    
    

    
    
}



//extension BeforeSearchContentViewController:UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return keyword.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentRecordTableViewCell", for: indexPath) as? RecentRecordTableViewCell else {
//            return RecentRecordTableViewCell()
//        }
//
//
//        cell.backgroundColor = .clear
//        cell.recentLabel.text = keyword[indexPath.row]
//        cell.delegate = self //cell의 delegate를 받기위해
//
//        return cell
//
//
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        guard let parent = self.parent as? SearchViewController else
//        {
//            return
//        }
//
//        parent.searchTextFiled.rx.text.onNext(keyword[indexPath.row])
//        parent.viewModel.input.textString.accept(keyword[indexPath.row])
//        parent.viewModel.output.isFoucused.accept(false)
//        parent.view.endEditing(true)
//
//
//
//
//    }
//
//
//}
//
//
// 테이블뷰 rx

extension BeforeSearchContentViewController:UITableViewDelegate{
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(viewModel.output.keywords.value.count == 0 )
        {
            return 300
        }
        return 40
        
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 300))
        warningView.text = "최근 검색 기록이 없습니다."

        let recentRecordHeaderView = RecentRecordHeaderView()
        
        if(viewModel.output.keywords.value.count == 0 )
        {
            return warningView
        }
        


        return recentRecordHeaderView
    }




}


extension BeforeSearchContentViewController:RecentRecordDelegate
{
    func selectedItems(_ keyword: String) {

        self.viewModel.output.keywords.accept(viewModel.output.keywords.value.filter( {$0 != keyword }))

    }

    
}
