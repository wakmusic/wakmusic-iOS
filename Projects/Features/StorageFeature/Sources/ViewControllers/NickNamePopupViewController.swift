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
import PanModal

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
        
        configureEvent()
        
    }
    
    private func configureEvent() {
        
        tableView.rx.itemSelected
            .withLatestFrom(viewModel.output.dataSource){($0,$1)}
            .subscribe (onNext:{ [weak self]  (index,models) in
                
                guard let self = self else{
                    return
                }
                
                var row:Int = index.row
                
                var nextModels:[NickNameInfo] = []
                
                for i in (0..<3) {
                    nextModels.append(NickNameInfo(description: models[i].description, check: i == row))
                    
                }
                
                self.viewModel.output.dataSource.accept(nextModels)
                
                
                
            })
            .disposed(by: disposeBag)
    }
}

extension NickNamePopupViewController :UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    

}

extension NickNamePopupViewController: PanModalPresentable {

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    public var panModalBackgroundColor: UIColor {
        return colorFromRGB(0x000000, alpha: 0.4)
    }

    public var panScrollable: UIScrollView? {
      return nil
    }

    public var longFormHeight: PanModalHeight {
    
   
        return PanModalHeight.contentHeight(228)
     }

    public var cornerRadius: CGFloat {
        return 24.0
    }

    public var allowsExtendedPanScrolling: Bool {
        return true
    }

    public var showDragIndicator: Bool {
        return false
    }
}
