//
//  SuggestFunctionViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/03/05.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import RxSwift
import RxKeyboard

public final class SuggestFunctionViewController: UIViewController,ViewControllerFromStoryBoard {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var descriptionLabel1: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var baseLineView: UIView!
    @IBOutlet weak var descriptionLabel2: UILabel!
    @IBOutlet weak var mobileAppSuperView: UIView!
    @IBOutlet weak var mobileAppButton: UIButton!
    @IBOutlet weak var mobileAppCheckImageView: UIImageView!
    @IBOutlet weak var webSiteSuperView: UIView!
    @IBOutlet weak var webSiteButton: UIButton!
    @IBOutlet weak var webSiteCheckImageView: UIImageView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let unPointColor:UIColor = DesignSystemAsset.GrayColor.gray200.color
    let pointColor:UIColor = DesignSystemAsset.PrimaryColor.decrease.color
    let unSelectedTextColor:UIColor = DesignSystemAsset.GrayColor.gray900.color
    
    let disposBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

       
        configureUI()
        
    }
    

    public static func viewController() -> SuggestFunctionViewController {
        let viewController = SuggestFunctionViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        
       

        
        return viewController
    }

}


extension SuggestFunctionViewController {
    
    private func configureUI(){
        
        titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        closeButton.setImage(DesignSystemAsset.Navigation.crossClose.image, for: .normal)
        
        descriptionLabel1.text = "제안해 주고 싶은 기능에 대해 설명해 주세요."
        descriptionLabel1.font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        descriptionLabel1.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        
        let placeHolderAttributes = [
            NSAttributedString.Key.foregroundColor: DesignSystemAsset.GrayColor.gray400.color,
            NSAttributedString.Key.font : DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        ] //
        
        textField.attributedPlaceholder =  NSAttributedString(string: "내 답변",
                                                              attributes:placeHolderAttributes)
        textField.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        textField.textColor = DesignSystemAsset.GrayColor.gray600.color
        
        
        baseLineView.backgroundColor = unPointColor
        
        descriptionLabel2.text = "어떤 플랫폼과 관련된 기능인가요?"
        descriptionLabel2.font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        descriptionLabel2.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        let superViews:[UIView] = [self.mobileAppSuperView,self.webSiteSuperView]
        
        let buttons:[UIButton] = [self.mobileAppButton,self.webSiteButton]
        
        let imageViews:[UIImageView] = [self.mobileAppCheckImageView,self.webSiteCheckImageView]
        
        
        for i in 0...1 {
            
            superViews[i].layer.cornerRadius = 12
            superViews[i].layer.borderColor = unPointColor.cgColor
            superViews[i].layer.borderWidth = 1
            imageViews[i].image = DesignSystemAsset.Storage.checkBox.image
            imageViews[i].isHidden = true
            
            var title:String = ""
            
            switch i {
            case 0:
                title = "모바일 앱"
                
            case 1:
                title = "PC 웹"
            default:
                return
                
            }
            
            buttons[i].setAttributedTitle(NSMutableAttributedString(string:title,
                    attributes: [.font: DesignSystemFontFamily.Pretendard.light.font(size: 16),
                                 .foregroundColor: unSelectedTextColor,
                                 
                    ]), for: .normal)
            
            
            
            
            
            
        }
        
        
        
        self.completionButton.layer.cornerRadius = 12
        self.completionButton.clipsToBounds = true
        self.completionButton.isEnabled = false
        self.completionButton.setBackgroundColor(DesignSystemAsset.PrimaryColor.point.color, for: .normal)
        self.completionButton.setBackgroundColor(DesignSystemAsset.GrayColor.gray300.color, for: .disabled)
        self.completionButton.setAttributedTitle(NSMutableAttributedString(string:"완료",
                                                                     attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                                                                                  .foregroundColor: DesignSystemAsset.GrayColor.gray25.color ]), for: .normal)
        
        self.previousButton.layer.cornerRadius = 12
        self.previousButton.clipsToBounds = true
        self.previousButton.setBackgroundColor(DesignSystemAsset.GrayColor.gray400.color, for: .normal)
        self.previousButton.setAttributedTitle(NSMutableAttributedString(string:"이전",
                                                                     attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                                                                                  .foregroundColor: DesignSystemAsset.GrayColor.gray25.color ]), for: .normal)
        
        bindRx()
    }
    
    
    private func bindRx(){
        
        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            
            guard let self = self else{
                return
            }
            
            self.dismiss(animated: true)
           
            
            
     
        })
        .disposed(by: disposBag)
        
        previousButton.rx.tap.subscribe(onNext: { [weak self] in
            
            guard let self = self else{
                return
            }
            
            self.navigationController?.popViewController(animated: true)
            
        })
        .disposed(by: disposBag)
        
        
    }
    
}
