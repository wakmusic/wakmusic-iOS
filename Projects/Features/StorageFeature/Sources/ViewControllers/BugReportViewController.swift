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

public final class BugReportViewController: UIViewController,ViewControllerFromStoryBoard {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!

    
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var descriptionLabel1: UILabel!
    @IBOutlet weak var baseLine1: UIView!
    
    @IBOutlet weak var descriptionLabel2: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var descriptionLabel3: UILabel!
    @IBOutlet weak var noticeCheckButton: UIButton!



    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var baseLine2: UIView!

    @IBOutlet weak var dotLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!

    
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var completionButton: UIButton!
    
    
    let unPointColor:UIColor = DesignSystemAsset.GrayColor.gray200.color
    let pointColor:UIColor = DesignSystemAsset.PrimaryColor.decrease.color
    let placeHolder:String = "내 답변"
    
    let placeHolderAttributes = [
        NSAttributedString.Key.foregroundColor:  DesignSystemAsset.GrayColor.gray400.color,
        NSAttributedString.Key.font : DesignSystemFontFamily.Pretendard.medium.font(size: 16)
    ] // 포커싱 플레이스홀더 폰트 및 color 설정
    
    let disposeBag = DisposeBag()
    
    
    var keyboardHeight:CGFloat = 267
    
    public override func viewDidLoad() {
        super.viewDidLoad()

       
        configureUI()
        
    }
    

    public static func viewController() -> BugReportViewController {
        let viewController = BugReportViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        
       

        
        return viewController
    }

}


extension BugReportViewController {
    
    
    private func configureCameraButtonUI(){
        
        let pointColor = DesignSystemAsset.PrimaryColor.decrease.color
        
        let cameraAttributedString = NSMutableAttributedString.init(string: "첨부하기")
        
        cameraAttributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
                                               .foregroundColor: pointColor],
                                              range: NSRange(location: 0, length: cameraAttributedString.string.count))
        
        cameraButton.setImage(DesignSystemAsset.Storage.camera.image.withRenderingMode(.alwaysOriginal), for: .normal)
        cameraButton.layer.cornerRadius = 12
        cameraButton.layer.borderColor = pointColor.cgColor
        cameraButton.layer.borderWidth = 1
        
        cameraButton.setAttributedTitle(cameraAttributedString, for: .normal)
        
        
    }
    
    private func configureUI(){
        
        dotLabel.layer.cornerRadius = 2
        dotLabel.clipsToBounds = true
        dotLabel.backgroundColor = DesignSystemAsset.GrayColor.gray400.color
        titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        descriptionLabel1.text = "겪으신 버그에 대해 설명해 주세요."
        descriptionLabel1.font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        descriptionLabel1.textColor =  DesignSystemAsset.GrayColor.gray900.color
        
        baseLine1.backgroundColor = unPointColor
        baseLine2.backgroundColor = unPointColor
        
        descriptionLabel2.text = "버그와 관련된 사진이나 영상을 첨부 해주세요."
        descriptionLabel2.font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        descriptionLabel2.textColor =  DesignSystemAsset.GrayColor.gray900.color
        
        descriptionLabel3.text = "왁물원 닉네임을 알려주세요."
        descriptionLabel3.font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        descriptionLabel3.textColor =  DesignSystemAsset.GrayColor.gray900.color
        
        
        
        hideKeyboardWhenTappedAround()
   
        scrollView.delegate = self
        textView.delegate = self
        textView.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        textView.placeholder = placeHolder
        textView.placeholderColor = DesignSystemAsset.GrayColor.gray400.color
        textView.textColor = DesignSystemAsset.GrayColor.gray600.color
        textView.minHeight = 32.0
        textView.maxHeight = spaceHeight()
       
        
        closeButton.setImage(DesignSystemAsset.Navigation.crossClose.image, for: .normal)
        
        
        noticeCheckButton.layer.borderWidth = 1
        noticeCheckButton.layer.cornerRadius = 12
        noticeCheckButton.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.cgColor
        
        textField.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        
        textField.attributedPlaceholder = NSAttributedString(string: placeHolder,attributes:placeHolderAttributes)
        textField.textColor = DesignSystemAsset.GrayColor.gray600.color
        
        infoLabel.text = "닉네임을 알려주시면 피드백을 받으시는 데 도움이 됩니다."
        infoLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        infoLabel.textColor = DesignSystemAsset.GrayColor.gray500.color
        
        
        
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
        configureCameraButtonUI()
        //responseViewbyKeyboard()
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
        
//        completionButton.rx.tap
//            .bind(to: input.completionButtonTapped)
//            .disposed(by: disposeBag)
        
            
    }
    
    private func bindRx(){
        
//        textField1.rx.text.orEmpty
//            .distinctUntilChanged()
//            .bind(to: input.artistString)
//            .disposed(by: disposeBag)
//
//        textView.rx.text.orEmpty
//            .distinctUntilChanged() // 연달아 같은 값이 이어질 때 중복된 값을 막아줍니다
//            .bind(to: input.contentString)
//            .disposed(by: disposeBag)
//
//        let tfEditingDidBegin1 = textField1.rx.controlEvent(.editingDidBegin)
//        let tfEditingDidEnd1 = textField1.rx.controlEvent(.editingDidEnd)
//
//        let mergeObservable1 = Observable.merge(tfEditingDidBegin1.map { UIControl.Event.editingDidBegin },
//                                               tfEditingDidEnd1.map { UIControl.Event.editingDidEnd })
//
//
//        mergeObservable1
//            .asObservable()
//            .subscribe(onNext: { [weak self] (event) in
//
//                guard let self = self else{
//                    return
//                }
//
//
//                if event ==  .editingDidBegin {
//                    self.baseLine1.backgroundColor = self.pointColor
//                    self.scrollView.scrollToView(view: UIView(frame: .zero))
//
//                }
//
//                else {
//                    self.baseLine1.backgroundColor = self.unPointColor
//                }
//
//            })
//            .disposed(by: disposeBag)
//
//
//        output.enableCompleteButton
//            .bind(to: completionButton.rx.isEnabled)
//            .disposed(by: disposeBag)
    }
    
    
//    private func responseViewbyKeyboard(){
//        RxKeyboard.instance.visibleHeight
//                    .drive(onNext: { [weak self] keyboardVisibleHeight in
//                        guard let self = self else {return}
//                        let safeAreaInsetsBottom: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
//                        let actualKeyboardHeight = max(0, keyboardVisibleHeight - safeAreaInsetsBottom)
//
//
//                        self.keyboardHeight = actualKeyboardHeight == .zero ? self.keyboardHeight : 300
//
//                        self.view.setNeedsLayout()
//                        UIView.animate(withDuration: 0, animations: {
//                            self.scrollView.contentInset.bottom = actualKeyboardHeight
//                            self.scrollView.verticalScrollIndicatorInsets.bottom = actualKeyboardHeight
//                            self.view.layoutIfNeeded()
//                        })
//
//                    }).disposed(by: disposeBag)
//
//    }
    
    func spaceHeight() -> CGFloat {
        
        
        return 16 * 10
        
    }
    
}



extension BugReportViewController : UITextViewDelegate {



    public func textViewDidBeginEditing(_ textView: UITextView) {
    
    

        self.baseLine1.backgroundColor = self.pointColor
        
        
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
   
        self.baseLine1.backgroundColor = self.unPointColor
        
    }

}


