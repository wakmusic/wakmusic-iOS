//
//  QnaContentViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/29.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import RxSwift
import RxCocoa
import RxRelay

public struct QnAModel{
    var categoty:String
    var question:String
    var ansewr:String
    var isOpened:Bool
}

class QnaContentViewController: UIViewController, ViewControllerFromStoryBoard {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource:[QnAModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        // Do any additional setup after loading the view.
    }
    
    
    

    public static func viewController(_ datas:[QnAModel]) -> QnaContentViewController {
        let viewController = QnaContentViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        
        viewController.dataSource = datas
        return viewController
    }

}


extension QnaContentViewController{
    
    private func configureUI()
    {
        
        tableView.dataSource = self
        tableView.delegate = self

        tableView.reloadData()
        bindRx()
        
    }
    
    private func bindRx(){
        
    }
    
}


extension QnaContentViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let data = dataSource[section]
    
        
        var count:Int = 0
        
        if data.isOpened {
            count = 2
        }
        else{
            count = 1
        }
        

        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let Qcell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as? QuestionTableViewCell else{
            return UITableViewCell()
        }
        guard let Acell = tableView.dequeueReusableCell(withIdentifier: "AnswerTableViewCell", for: indexPath) as? AnswerTableViewCell else {
            return UITableViewCell()
        }
        Qcell.update(model: dataSource[indexPath.section])
        Qcell.selectionStyle = .none // 선택 시 깜빡임 방지
        Acell.update(model: dataSource[indexPath.section])
        Acell.selectionStyle = .none
        
        
        // 왜 Row는  인덱스 개념이다 0 부터 시작??
        
        if indexPath.row == 0 {
            return Qcell
        }
        else {
            return Acell
        }
            
        
    }
    
    
}

extension QnaContentViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        dataSource[indexPath.section].isOpened = !dataSource[indexPath.section].isOpened
        tableView.reloadSections([indexPath.section], with: .none)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
