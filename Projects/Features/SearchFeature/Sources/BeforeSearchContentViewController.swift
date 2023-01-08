//
//  SearchContentViewController.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/05.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility

class BeforeSearchContentViewController: UIViewController,ViewControllerFromStoryBoard {

    
    @IBOutlet weak var tableView: UITableView!
    

    let keyword:[String] = ["A","우왁굳","왁타버스"]
    override func viewDidLoad() {
        super.viewDidLoad()

        DEBUG_LOG("\(Self.self) viewDidLoad")
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        if(keyword.count != 0 )
        {
            
        }
        else
        {
            
        }
        
    }
    
    public static func viewController() -> BeforeSearchContentViewController {
        let viewController =  BeforeSearchContentViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)
        return viewController
    }
    

}



extension BeforeSearchContentViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return keyword.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentRecordTableViewCell", for: indexPath) as? RecentRecordTableViewCell else {
            return RecentRecordTableViewCell()
        }
        
        
        cell.recentLabel.text = keyword[indexPath.row]
        cell.delegate = self //cell의 delegate를 받기위해
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let parent = self.parent as? SearchViewController else
        {
            return
        }
        
        parent.searchTextFiled.rx.text.onNext(keyword[indexPath.row])
        parent.viewModel.input.textString.accept(keyword[indexPath.row])
        parent.viewModel.output.isFoucused.accept(false)
        parent.view.endEditing(true)
        
       
        
         
    }
    

}

extension BeforeSearchContentViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}


extension BeforeSearchContentViewController:RecentRecordDelegate
{
    func selectedItems(item: String) {
        //키워드 배열 조작
        // reloadRow 이용
        
        //tableView.reloadRows(at: <#T##[IndexPath]#>, with: .none)
        print(item)
    }

    
}
