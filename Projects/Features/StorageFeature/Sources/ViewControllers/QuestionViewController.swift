//
//  QuestionViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/03/04.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem
import RxSwift
import Utility
import BaseFeature

public final class QuestionViewController: BaseViewController,ViewControllerFromStoryBoard {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bugReportSuperView: UIView!
    @IBOutlet weak var bugReportButton: UIButton!
    @IBOutlet weak var bugReportCheckImageView: UIImageView!
    
    @IBOutlet weak var suggestFunctionSuperView: UIView!
    @IBOutlet weak var suggestFunctionButton: UIButton!
    @IBOutlet weak var suggestFunctionCheckImageView: UIImageView!
    
    @IBOutlet weak var addSongSuperView: UIView!
    @IBOutlet weak var addSongButton: UIButton!
    @IBOutlet weak var addSongCheckImageView: UIImageView!
    
    @IBOutlet weak var editSongSuperView: UIView!
    @IBOutlet weak var editSongButton: UIButton!
    @IBOutlet weak var editSongCheckImageView: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    let selectedColor:UIColor = DesignSystemAsset.PrimaryColor.decrease.color
    let unSelectedTextColor:UIColor = DesignSystemAsset.GrayColor.gray900.color
    let unSelectedColor:UIColor = DesignSystemAsset.GrayColor.gray200.color
    let disposeBag = DisposeBag()
    var viewModel:QuestionViewModel!
    lazy var input = QuestionViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    
    var suggestFunctionComponent:SuggestFunctionComponent!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    public static func viewController(viewModel:QuestionViewModel,suggestFunctionComponent:SuggestFunctionComponent) -> QuestionViewController {
        let viewController = QuestionViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        
        viewController.viewModel = viewModel
        viewController.suggestFunctionComponent = suggestFunctionComponent

        
        return viewController
    }


}


extension QuestionViewController {
    
    private func configureUI(){
        
        self.titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        self.titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        self.closeButton.setImage(DesignSystemAsset.Navigation.crossClose.image, for: .normal)
        
        self.descriptionLabel.text = "어떤 것 관련해서 문의주셨나요?"
        self.descriptionLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 20)
        self.descriptionLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        self.nextButton.layer.cornerRadius = 12
        self.nextButton.clipsToBounds = true
        self.nextButton.isEnabled = false
        self.nextButton.setBackgroundColor(DesignSystemAsset.PrimaryColor.point.color, for: .normal)
        self.nextButton.setBackgroundColor(DesignSystemAsset.GrayColor.gray300.color, for: .disabled)
        self.nextButton.setAttributedTitle(NSMutableAttributedString(string:"다음",
                                                                     attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                                                                                  .foregroundColor: DesignSystemAsset.GrayColor.gray25.color ]), for: .normal)
        
        
        
            
        let superViews:[UIView] = [self.bugReportSuperView,self.suggestFunctionSuperView,self.addSongSuperView,self.editSongSuperView]
        
        let buttons:[UIButton] = [self.bugReportButton,self.suggestFunctionButton,self.addSongButton,self.editSongButton]
        
        let imageViews:[UIImageView] = [self.bugReportCheckImageView,self.suggestFunctionCheckImageView,self.addSongCheckImageView,self.editSongCheckImageView]
        
        
        for i in 0...3 {
            
            superViews[i].layer.cornerRadius = 12
            superViews[i].layer.borderColor = unSelectedColor.cgColor
            superViews[i].layer.borderWidth = 1
            imageViews[i].image = DesignSystemAsset.Storage.checkBox.image
            imageViews[i].isHidden = true
            
            var title:String = ""
            
            switch i {
            case 0:
                title = "버그 제보"
            
            case 1:
                title = "기능 제안"
            
            case 2:
                title = "노래 추가"
                
            case 3:
                title = "노래 수정"
                
            default:
                return

            }
            
            buttons[i].setAttributedTitle(NSMutableAttributedString(string:title,
                                                                    attributes: [.font: DesignSystemFontFamily.Pretendard.light.font(size: 16),
                                                                                 .foregroundColor: unSelectedTextColor ]), for: .normal)
            

            
        }
        
        bindRx()
        
        
    }
    
    
    private func bindRx(){
        
        self.closeButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else{
                return
            }
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        
        self.bugReportButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else{
                return
            }

           self.output.selectedIndex.accept(0)
        }).disposed(by: disposeBag)
        
        self.suggestFunctionButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else{
                return
            }

            
            self.output.selectedIndex.accept(1)
        }).disposed(by: disposeBag)
        
        self.addSongButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else{
                return
            }

            self.output.selectedIndex.accept(2)
        }).disposed(by: disposeBag)
        
        self.editSongButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else{
                return
            }

            self.output.selectedIndex.accept(3)
        }).disposed(by: disposeBag)
        
        
        self.output.selectedIndex.subscribe(onNext: { [weak self]  (index:Int) in
    
            guard let self = self else{
                return
            }
            
            if !self.nextButton.isEnabled {
                self.nextButton.isEnabled = true
            }
            
            let superViews:[UIView] = [self.bugReportSuperView,self.suggestFunctionSuperView,self.addSongSuperView,self.editSongSuperView]
            
            let buttons:[UIButton] = [self.bugReportButton,self.suggestFunctionButton,self.addSongButton,self.editSongButton]
            
            let imageViews:[UIImageView] = [self.bugReportCheckImageView,self.suggestFunctionCheckImageView,self.addSongCheckImageView,self.editSongCheckImageView]
            
            for i in 0...3 {
                
                
                var title:String = ""
                
                switch i {
                case 0:
                    title = "버그 제보"
                
                case 1:
                    title = "기능 제안"
                
                case 2:
                    title = "노래 추가"
                    
                case 3:
                    title = "노래 수정"
                    
                default:
                    return

                }
                
                
                buttons[i].setAttributedTitle(
                    NSMutableAttributedString(string:title,
                                              attributes: [.font:
                                                            i == index ? DesignSystemFontFamily.Pretendard.medium.font(size: 16)  : DesignSystemFontFamily.Pretendard.light.font(size: 16),
                                 .foregroundColor:
                                                            i == index ? self.selectedColor : self.unSelectedTextColor   ]), for: .normal)
                
               
                
                imageViews[i].isHidden = i == index ? false : true
                
                superViews[i].layer.borderColor = i == index ? self.selectedColor.cgColor : self.unSelectedColor.cgColor
                
            }
            
            
            
        }).disposed(by: disposeBag)
        
        
        
        self.nextButton.rx.tap
            .withLatestFrom(output.selectedIndex)
            .subscribe(onNext: { [weak self] in
                
                guard let self = self else{
                    return
                }
                
                DEBUG_LOG($0)
                
                switch $0 {
                    
                case 1:
                    let vc = self.suggestFunctionComponent.makeView()
                    
                    
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                default:
                    return
                }
                
                
            })
            .disposed(by: disposeBag)
        
        
    }
    
}
