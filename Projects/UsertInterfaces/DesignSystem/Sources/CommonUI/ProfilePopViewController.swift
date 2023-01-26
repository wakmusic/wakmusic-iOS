//
//  ProfilePopViewController.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 2023/01/26.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import PanModal
import RxCocoa
import RxRelay
import RxSwift


public struct Model {
    var type:FanType
    var isSelected:Bool
}


public final class ProfilePopViewController: UIViewController, ViewControllerFromStoryBoard {

    
    @IBOutlet weak var collectionVIewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveAction(_ sender: UIButton) {
        
        //MARK: TODO 네트워크 작업 !!
        
        dismiss(animated: true)
    }
    
    var dataSource:BehaviorRelay<[Model]> = BehaviorRelay.init(value: [Model(type: .panzee, isSelected: true),Model(type: .leaf, isSelected: false),Model(type: .pigeon, isSelected: false),Model(type: .bat, isSelected: false),Model(type: .germ, isSelected: false),Model(type: .gorani, isSelected: false),Model(type: .fox, isSelected: false),Model(type: .poopDog, isSelected: false)])
    
    
    var disposeBag = DisposeBag()
    var rowHeight:CGFloat = (( APP_WIDTH() - 70) / 4) * 2
    
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    public static func viewController() -> ProfilePopViewController {
        let viewController = ProfilePopViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        

        
        return viewController
    }

}


extension ProfilePopViewController{
    
    private func configureUI(){
        
        saveButton.layer.cornerRadius = 12
        saveButton.clipsToBounds = true
        saveButton.setAttributedTitle(NSMutableAttributedString(string:"완료",attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),.foregroundColor: DesignSystemAsset.GrayColor.gray25.color ]), for: .normal)
        
     
        collectionVIewHeight.constant = rowHeight  + 10
        
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        bindRx()
        
    }
    
    
    private func bindRx(){
        
        
        dataSource.bind(to: collectionView.rx.items) { (collectionView: UICollectionView, index: Int, model: Model) -> UICollectionViewCell in
            
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: IndexPath(row: index, section: 0)) as? ProfileCollectionViewCell else {
                
                return UICollectionViewCell()
            }
            
            cell.update(model)
            
            return cell
                     
            
        }.disposed(by:disposeBag)
        
        
        collectionView.rx.itemSelected
            .withLatestFrom(dataSource){($0,$1)}
            .map{(indexPath:IndexPath,dataSource:[Model]) -> [Model] in
                var newModel = dataSource
                guard let index = newModel.firstIndex(where:{$0.isSelected}) else {
                    return dataSource
                }
                
                newModel[index].isSelected = false  //이전 선택 false
                
                newModel[indexPath.row].isSelected = true //현재 선택 true
                
                return newModel
                
            }
            .bind(to: dataSource)
            .disposed(by: disposeBag)
        
    }
    
    
    
}

extension ProfilePopViewController: PanModalPresentable {

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
    
   
        return PanModalHeight.contentHeight( rowHeight + 200 )
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


extension ProfilePopViewController:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size:CGFloat = (APP_WIDTH() - 70) / 4
        
        return CGSize(width: size, height: size)
    }
    
    //행간 간격
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
    
    //아이템 사이 간격(좌,우)
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    
    
    
}
