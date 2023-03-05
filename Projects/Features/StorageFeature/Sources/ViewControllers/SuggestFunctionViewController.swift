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
    
    
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    let unPointColor:UIColor = DesignSystemAsset.GrayColor.gray200.color
    let pointColor:UIColor = DesignSystemAsset.PrimaryColor.decrease.color
    let unSelectedTextColor:UIColor = DesignSystemAsset.GrayColor.gray900.color
    
    let disposeBag = DisposeBag()
    
    var viewModel:SuggestFunctionViewModel!
    lazy var input = SuggestFunctionViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    
    public override func viewDidLoad() {
        super.viewDidLoad()

       
        configureUI()
        
    }
    

    public static func viewController(viewModel:SuggestFunctionViewModel) -> SuggestFunctionViewController {
        let viewController = SuggestFunctionViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        
        viewController.viewModel = viewModel
       

        
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
        bindbuttonEvent()
        responseViewbyKeyboard()
    }
    
    private func bindbuttonEvent(){
        mobileAppButton.rx.tap.subscribe(onNext: { [weak self] in
            
            guard let self = self else{
                return
            }
            
           
            self.view.endEditing(true)
            self.output.selectedIndex.accept(0)
        }).disposed(by: disposeBag)
        
        
        webSiteButton.rx.tap.subscribe(onNext: { [weak self] in
            
            guard let self = self else{
                return
            }
            
            self.view.endEditing(true)
            self.output.selectedIndex.accept(1)
        }).disposed(by: disposeBag)
        
        previousButton.rx.tap.subscribe(onNext: { [weak self] in
            
            guard let self = self else{
                return
            }
            
            self.view.endEditing(true)
            self.navigationController?.popViewController(animated: true)
            
        })
        .disposed(by: disposeBag)
        
        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            
            guard let self = self else{
                return
            }
            
            self.dismiss(animated: true)
           
        })
        .disposed(by: disposeBag)
        
        let resultObservable = Observable.combineLatest(input.textString, output.selectedIndex)
        
        completionButton.rx.tap
            .withLatestFrom(resultObservable)
            .subscribe(onNext: { [weak self] (text,index) in
                
                DEBUG_LOG("\(text) \(index)")
            })
            .disposed(by: disposeBag)
            
    }
    
    
    private func bindRx(){
        
        textField.rx.text.orEmpty
      //      .skip(1)  //바인드 할 때 발생하는 첫 이벤트를 무시
            .distinctUntilChanged() // 연달아 같은 값이 이어질 때 중복된 값을 막아줍니다
            .bind(to: input.textString)
            .disposed(by: disposeBag)
        
        
     
        
    
        
        let editingDidBegin = textField.rx.controlEvent(.editingDidBegin)
        let editingDidEnd = textField.rx.controlEvent(.editingDidEnd)
        

        let mergeObservable = Observable.merge(editingDidBegin.map { UIControl.Event.editingDidBegin },
                                               editingDidEnd.map { UIControl.Event.editingDidEnd })
        
        
        mergeObservable.subscribe(onNext: { [weak self]  event in
            
            guard let self = self else{
                return
            }
            
            if event == .editingDidBegin {
                self.baseLineView.backgroundColor = self.pointColor
            }
            
            else {
                self.baseLineView.backgroundColor = self.unPointColor
                
                
            }
            
            
        })
        .disposed(by: disposeBag)
        
        
        
        
        output.selectedIndex
            .skip(1)
            .subscribe(onNext: { [weak self] (index:Int) in
            
            guard let self = self else{
                return
            }
            let superViews:[UIView] = [self.mobileAppSuperView,self.webSiteSuperView]
            
            let buttons:[UIButton] = [self.mobileAppButton,self.webSiteButton]
            
            let imageViews:[UIImageView] = [self.mobileAppCheckImageView,self.webSiteCheckImageView]
            
            
            for i in 0...1 {
                
                var title:String = ""
                
                switch i {
                case 0:
                    title = "모바일 앱"
                
                case 1:
                    title = "PC 웹"
                
                    
                default:
                    return

                }
                
                buttons[i].setAttributedTitle(
                    NSMutableAttributedString(string:title,
                                              attributes: [.font:
                                                            i == index ? DesignSystemFontFamily.Pretendard.medium.font(size: 16)  : DesignSystemFontFamily.Pretendard.light.font(size: 16),
                                 .foregroundColor:
                                                            i == index ? self.pointColor : self.unSelectedTextColor   ]), for: .normal)
                
               
                
                imageViews[i].isHidden = i == index ? false : true
                
                superViews[i].layer.borderColor = i == index ? self.pointColor.cgColor : self.unPointColor.cgColor
                
                
                
                
            }
            
        })
        .disposed(by: disposeBag)
        

        
        Observable.combineLatest(input.textString, output.selectedIndex)
            .subscribe(onNext: { [weak self] (text,index) in
                
                guard let self = self else{
                    return
                }
                
 
                if !text.isWhiteSpace && index != -2 {
                    self.completionButton.isEnabled = true
                }
                else {
                    self.completionButton.isEnabled = false
                }
                
                
                
                
            })
            .disposed(by: disposeBag)
        
     
        
    }
    
    
    private func responseViewbyKeyboard(){
        RxKeyboard.instance.visibleHeight //드라이브: 무조건 메인쓰레드에서 돌아감
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                
                guard let self = self else {
                    return
                }
                
             
                //키보드는 바텀 SafeArea부터 계산되므로 빼야함
                let window: UIWindow? = UIApplication.shared.windows.first
                let safeAreaInsetsBottom: CGFloat = window?.safeAreaInsets.bottom ?? 0
                
                let tmp = keyboardVisibleHeight  - safeAreaInsetsBottom + 10
                
                self.contentViewBottomConstraint.constant = tmp > 0 ? tmp  : 0
                self.view.layoutIfNeeded() //제약조건 바뀌었으므로 알려줌
                
                
            }).disposed(by: disposeBag)
        
    }
}
