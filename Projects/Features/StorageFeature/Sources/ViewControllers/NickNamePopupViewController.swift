//
//  NickNamePopupViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/03/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit
import Utility
import RxSwift

public final class NickNamePopupViewController: UIViewController,ViewControllerFromStoryBoard {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel = NickNamePopupViewModel()
    var disposeBag = DisposeBag()
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()

       configureUI()
        
    }
    

    public static func viewController() -> NickNamePopupViewController {
        let viewController = NickNamePopupViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        

       
        
        return viewController
    }
    
    
}

extension NickNamePopupViewController {
    
    private func configureUI() {
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        
        
        viewModel.output.dataSource
            .bind(to: tableView.rx.items) { (tableView, index, model) -> UITableViewCell in
                let indexPath: IndexPath = IndexPath(row: index, section: 0)
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NickNameInfoTableViewCell", for: indexPath) as? NickNameInfoTableViewCell else{
                    return UITableViewCell()
                }
                
                cell.update(model: model)
                return cell
                
            }
            .disposed(by: disposeBag)
        
        
    }
    
}

extension NickNamePopupViewController :UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    

}
