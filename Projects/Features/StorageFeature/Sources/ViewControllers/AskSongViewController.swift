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
import SafariServices

public final class AskSongViewController: UIViewController,ViewControllerFromStoryBoard {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var dotLabel1: UILabel!
    @IBOutlet weak var explainLabel1: UILabel!
    
    @IBOutlet weak var dotLabel2: UILabel!
    @IBOutlet weak var explainLabel2: UILabel!
    
    @IBOutlet weak var redirectWebButton: UIButton!
    
    @IBOutlet weak var descriptionLabel1: UILabel!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var baseLine1: UIView!
    
    
    @IBOutlet weak var descriptionLabel2: UILabel!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var baseLine2: UIView!
    
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var descriptionLabel3: UILabel!
    @IBOutlet weak var baseLine3: UIView!
    
    
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var descriptionLabel4: UILabel!
    @IBOutlet weak var baseLine4: UIView!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var completionButton: UIButton!
    
    
    let unPointColor:UIColor = DesignSystemAsset.GrayColor.gray200.color
    let pointColor:UIColor = DesignSystemAsset.PrimaryColor.decrease.color
    let placeHolder:String = "내 대답"
    
    let placeHolderAttributes = [
        NSAttributedString.Key.foregroundColor:  DesignSystemAsset.GrayColor.gray400.color,
        NSAttributedString.Key.font : DesignSystemFontFamily.Pretendard.medium.font(size: 16)
    ] // 포커싱 플레이스홀더 폰트 및 color 설정
    
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
    
    private func configureHeaderUI() {
        
        dotLabel1.layer.cornerRadius = 2
        dotLabel1.clipsToBounds = true
        dotLabel1.backgroundColor = DesignSystemAsset.GrayColor.gray400.color
        
        dotLabel2.layer.cornerRadius = 2
        dotLabel2.clipsToBounds = true
        dotLabel2.backgroundColor = DesignSystemAsset.GrayColor.gray400.color
    
        
        redirectWebButton.setTitle("왁뮤 노래 포함 기준", for: .normal)
        redirectWebButton.setImage(DesignSystemAsset.Storage.blueArrowRight.image, for: .normal)
        redirectWebButton.titleLabel?.font = DesignSystemFontFamily.Pretendard.medium.font(size: 12)
        redirectWebButton.titleLabel?.textColor = DesignSystemAsset.PrimaryColor.decrease.color
        
        
        titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.35
        
        explainLabel1.attributedText = NSMutableAttributedString(
            string: "이세돌 분들이 부르신걸 이파리분들이 개인소장용으로 일부공개한 영상을 올리길 원하시면 ‘은수저’님에게 왁물원 채팅으로 부탁드립니다.",
            attributes: [.font: DesignSystemFontFamily.Pretendard.light.font(size: 12),
                         .foregroundColor: DesignSystemAsset.GrayColor.gray500.color,
                         .paragraphStyle: style]
        )
        
        explainLabel2.attributedText = NSMutableAttributedString(
            string: "왁뮤에 들어갈 수 있는 기준을 충족하는지 꼭 확인하시고 추가 요청해 주세요.",
            attributes: [.font: DesignSystemFontFamily.Pretendard.light.font(size: 12),
                         .foregroundColor: DesignSystemAsset.GrayColor.gray500.color,
                         .paragraphStyle: style]
        )
    }
    
    private func configureUI(){
        
        
        hideKeyboardWhenTappedAround()
        configureHeaderUI()
       
        
        let descriptionLabels:[UILabel] = [descriptionLabel1,descriptionLabel2,descriptionLabel3,descriptionLabel4]
       
        let textFields:[UITextField] = [textField1,textField2,textField3,textField4]
        
        let baseLines:[UIView] = [baseLine1,baseLine2,baseLine3,baseLine4]
        
        
        for i in 0..<4 {
            
            var title:String = ""
            
            switch i {
                
            case 0 :
                title = "아티스트"
                
            case 1 :
                title = "노래 제목"
                
            case 2 :
                title = "유튜브 링크"
            
            case 3 :
                title = "내용"
                
            default :
                return
                
                
            }
            
            
            
            descriptionLabels[i].text = title
            descriptionLabels[i].font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
            descriptionLabels[i].textColor = DesignSystemAsset.GrayColor.gray900.color
            
            if i < 3 {
                
                textFields[i].attributedPlaceholder = NSAttributedString(string: placeHolder,attributes:placeHolderAttributes) //플레이스 홀더 설정
                
                textFields[i].font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
                
                textFields[i].textColor = DesignSystemAsset.GrayColor.gray600.color
            }
            
            
            baseLines[i].backgroundColor = unPointColor

            
            
        }
        
        
        
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
        
        
        
        closeButton.setImage(DesignSystemAsset.Navigation.crossClose.image, for: .normal)
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
        
        self.scrollView.delegate = self
        
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
        
        redirectWebButton.rx.tap
            .subscribe(onNext: { [weak self] () in
                guard let URL = URL(string: "https://whimsical.com/E3GQxrTaafVVBrhm55BNBS") else { return }
                
                let safari = SFSafariViewController(url: URL)
                self?.present(safari, animated: true)
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

extension AskSongViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        DEBUG_LOG(scrollView.contentOffset.y)
        scrollView.bounces = scrollView.contentOffset.y > 0
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
