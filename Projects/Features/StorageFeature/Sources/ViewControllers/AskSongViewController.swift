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
import CommonFeature

public final class AskSongViewController: UIViewController,ViewControllerFromStoryBoard {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var dotLabel1: UILabel!
    @IBOutlet weak var explainLabel1: UILabel!
    
    @IBOutlet weak var dotLabel2: UILabel!
    @IBOutlet weak var explainLabel2: UILabel!
    
    @IBOutlet weak var redirectWebButton: UIButton!
    @IBOutlet weak var redirectWebLabel: UILabel!
    @IBOutlet weak var redirectWebImageView: UIImageView!
    
    //  @IBOutlet weak var baseLineView: UIView!
    
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var completionButton: UIButton!
    
    
    let unPointColor:UIColor = DesignSystemAsset.GrayColor.gray200.color
    let pointColor:UIColor = DesignSystemAsset.PrimaryColor.decrease.color
    let textViewPlaceHolder:String = "내 대답"
    
    let disposeBag = DisposeBag()
    
    var viewModel:WakMusicFeedbackViewModel!
    lazy var input = WakMusicFeedbackViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    
    public override func viewDidLoad() {
        super.viewDidLoad()

       
        configureUI()
        
    }
    

    public static func viewController() -> AskSongViewController {
        let viewController = AskSongViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        
       

        
        return viewController
    }

}


extension AskSongViewController {
    
    private func configureUI(){
        
        
        hideKeyboardWhenTappedAround()
        
        dotLabel1.layer.cornerRadius = 2
        dotLabel1.clipsToBounds = true
        dotLabel1.backgroundColor = DesignSystemAsset.GrayColor.gray400.color
        
        dotLabel2.layer.cornerRadius = 2
        dotLabel2.clipsToBounds = true
        dotLabel2.backgroundColor = DesignSystemAsset.GrayColor.gray400.color
        
        explainLabel1.text = "이세돌 분들이 부르신걸 이파리분들이 개인소장용으로 일부공개한 영상을 올리길 원하시면 ‘은수저’님에게 왁물원 채팅으로 부탁드립니다."
        explainLabel1.textColor = DesignSystemAsset.GrayColor.gray500.color
        explainLabel1.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        
        explainLabel2.text = "왁뮤에 들어갈 수 있는 기준을 충족하는지 꼭 확인하시고 추가 요청해 주세요."
        explainLabel2.textColor = DesignSystemAsset.GrayColor.gray500.color
        explainLabel2.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        
        redirectWebLabel.text = "왁뮤 노래 포함 기준"
        redirectWebLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 12)
        redirectWebLabel.textColor = DesignSystemAsset.PrimaryColor.decrease.color
        
        redirectWebImageView.image = DesignSystemAsset.Storage.blueArrowRight.image
        
        
        titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        closeButton.setImage(DesignSystemAsset.Navigation.crossClose.image, for: .normal)
        
//        descriptionLabel1.text = "문의하실 내용을 적어주세요."
//        descriptionLabel1.font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
//        descriptionLabel1.textColor = DesignSystemAsset.GrayColor.gray900.color
//
//
//        textView.delegate = self
//        textView.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
//
//        textView.placeholder = textViewPlaceHolder
//        textView.placeholderColor = DesignSystemAsset.GrayColor.gray400.color
//        textView.textColor = DesignSystemAsset.GrayColor.gray600.color
//        textView.minHeight = 32.0
//        textView.maxHeight = spaceHeight()
       
        
        
    //    baseLineView.backgroundColor = unPointColor
        
         
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
        

        
        previousButton.rx.tap.subscribe(onNext: { [weak self] in
            
            guard let self = self else{
                return
            }
            
            
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
        
        
        completionButton.rx.tap
            .withLatestFrom(input.textString)
            .subscribe(onNext: { [weak self] (text:String) in
                
                
                
                DEBUG_LOG("\(text)")
                
                //TODO: 텍스트 팝업
                
            })
            .disposed(by: disposeBag)
            
    }
    
    
    private func bindRx(){
        
//        textView.rx.text.orEmpty
//      //      .skip(1)  //바인드 할 때 발생하는 첫 이벤트를 무시
//            .distinctUntilChanged() // 연달아 같은 값이 이어질 때 중복된 값을 막아줍니다
//            .bind(to: input.textString)
//            .disposed(by: disposeBag)
    
        input.textString.subscribe(onNext: {
            
            self.completionButton.isEnabled = !$0.isWhiteSpace
            
        })
        
    }
    
    
    private func responseViewbyKeyboard(){
//        RxKeyboard.instance.visibleHeight //드라이브: 무조건 메인쓰레드에서 돌아감
//            .drive(onNext: { [weak self] keyboardVisibleHeight in
//
//                guard let self = self else {
//                    return
//                }
//
//                self.textView.maxHeight = keyboardVisibleHeight == .zero ?  self.spaceHeight() :
//                self.spaceHeight() - keyboardVisibleHeight + SAFEAREA_BOTTOM_HEGHIT() + 56
//               //키보드에서 바텀이 빼지면서 2번 빠짐
//
//                DEBUG_LOG("\(self.spaceHeight()) \(SAFEAREA_BOTTOM_HEGHIT()) \(keyboardVisibleHeight)  \(self.spaceHeight() - keyboardVisibleHeight + SAFEAREA_BOTTOM_HEGHIT())  ")
//
//
//                self.view.layoutIfNeeded() //제약조건 바뀌었으므로 알려줌
//
//
//            }).disposed(by: disposeBag)
        
    }
    
    func spaceHeight() -> CGFloat {
        
        
        return APP_HEIGHT() - ( STATUS_BAR_HEGHIT() + SAFEAREA_BOTTOM_HEGHIT()  + 48 +  20 + 28 + 16 +  66 + 10   ) // 마지막 10은 여유 공간
        
    }
    
}


//extension WakMusicFeedbackViewController : UITextViewDelegate {
//
//
//
//
//
//    public func textViewDidBeginEditing(_ textView: UITextView) {
//
//
//        self.baseLineView.backgroundColor = self.pointColor
//
//
//    }
//
//    public func textViewDidEndEditing(_ textView: UITextView) {
//
//        self.baseLineView.backgroundColor = self.unPointColor
//
//    }
//
//}
