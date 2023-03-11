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
    @IBOutlet weak var collectionContentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var attachContentView: UIView!
    @IBOutlet weak var attachLabel: UILabel!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var descriptionLabel3: UILabel!
    
    @IBOutlet weak var noticeCheckButton: UIButton!
    @IBOutlet weak var noticeSuperView: UIView!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var noticeImageView: UIImageView!
    
    @IBOutlet weak var nickNameContentView: UIView!
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
    
    
    var viewModel:BugReportViewModel!
    lazy var input = BugReportViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    var keyboardHeight:CGFloat = 267
    
    public override func viewDidLoad() {
        super.viewDidLoad()

       
        configureUI()
        
    }
    
    
    override public func viewDidDisappear(_ animated: Bool) {
        
    }

    public static func viewController(viewModel:BugReportViewModel) -> BugReportViewController {
        let viewController = BugReportViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        
        viewController.viewModel = viewModel
       

        
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
        attachLabel.attributedText = cameraAttributedString
        cameraImageView.image = DesignSystemAsset.Storage.camera.image
        
        attachContentView.layer.cornerRadius = 12
        attachContentView.layer.borderColor = pointColor.cgColor
        attachContentView.layer.borderWidth = 1
        
        //        cameraButton.setImage(DesignSystemAsset.Storage.camera.image.withRenderingMode(.alwaysOriginal), for: .normal)
//        cameraButton.setAttributedTitle(cameraAttributedString, for: .normal)
    }
    
    private func configureUI(){
        
        
        hideKeyboardWhenTappedAround()
        
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
        
        
        
        
        scrollView.delegate = self
        textView.delegate = self
        textView.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        textView.placeholder = placeHolder
        textView.placeholderColor = DesignSystemAsset.GrayColor.gray400.color
        textView.textColor = DesignSystemAsset.GrayColor.gray600.color
        textView.minHeight = 32.0
        textView.maxHeight = spaceHeight()
       
        
        closeButton.setImage(DesignSystemAsset.Navigation.crossClose.image, for: .normal)
        
        
        noticeSuperView.layer.borderWidth = 1
        noticeSuperView.layer.cornerRadius = 12
        noticeSuperView.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.cgColor
        
        noticeLabel.text = "알려주기"
        noticeLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        noticeLabel.textColor = DesignSystemAsset.GrayColor.gray400.color
        
        noticeImageView.image = DesignSystemAsset.Navigation.close.image
        
        
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
        
        noticeCheckButton.rx.tap
            .withLatestFrom(input.wakNickNameOption)
            .subscribe(onNext: { [weak self] (current) in
                guard let self = self else { return }

                let vc = NickNamePopupViewController.viewController(current: current == "선택" ? "알려주기" : current , completion: { (description) in
                    self.input.wakNickNameOption.accept(description)
                    self.nickNameContentView.isHidden = description != "알려주기"
                    
                    if description != "알려주기" {
                        self.input.nickNameString.accept("")
                        self.textField.rx.text.onNext("")
                    }
                })
                self.showPanModal(content: vc)
            })
            .disposed(by: disposeBag)
        
        completionButton.rx.tap
            .bind(to: input.completionButtonTapped)
            .disposed(by: disposeBag)
        
            
    }
    
    private func bindRx(){
        
        textView.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: input.bugContentString)
            .disposed(by: disposeBag)

        
        let tfEditingDidBegin = textField.rx.controlEvent(.editingDidBegin)
        let tfEditingDidEnd = textField.rx.controlEvent(.editingDidEnd)

        let mergeObservable = Observable.merge(tfEditingDidBegin.map { UIControl.Event.editingDidBegin },
                                               tfEditingDidEnd.map { UIControl.Event.editingDidEnd })


        textField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: input.nickNameString)
            .disposed(by: disposeBag)
        
        
        
        mergeObservable
            .asObservable()
            .subscribe(onNext: { [weak self] (event) in

                guard let self = self else{
                    return
                }


                if event ==  .editingDidBegin {
                    self.baseLine2.backgroundColor = self.pointColor
                  //  self.scrollView.scroll(to: .bottom)

                }

                else {
                    self.baseLine2.backgroundColor = self.unPointColor
                }

            })
            .disposed(by: disposeBag)
        
        
        output.showCollectionView
            .bind(to: collectionContentView.rx.isHidden)
            .disposed(by: disposeBag)
        
        input.wakNickNameOption
            .do(onNext: { [weak self] (str:String) in
                DEBUG_LOG(str)
                
                guard let self = self else {
                    return
                }
                
                self.noticeLabel.textColor = str == "선택" ? DesignSystemAsset.GrayColor.gray400.color  : DesignSystemAsset.GrayColor.gray900.color
                
            })
            .bind(to: noticeLabel.rx.text)
            .disposed(by: disposeBag)



        output.enableCompleteButton
            .bind(to: completionButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    
    private func responseViewbyKeyboard(){
        RxKeyboard.instance.visibleHeight
                    .drive(onNext: { [weak self] keyboardVisibleHeight in
                        guard let self = self else {return}
                        let safeAreaInsetsBottom: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
                        let actualKeyboardHeight = max(0, keyboardVisibleHeight - safeAreaInsetsBottom)


                        self.keyboardHeight = actualKeyboardHeight == .zero ? self.keyboardHeight : 300

                        self.view.setNeedsLayout()
                        UIView.animate(withDuration: 0, animations: {
                            self.scrollView.contentInset.bottom = actualKeyboardHeight
                            self.scrollView.verticalScrollIndicatorInsets.bottom = actualKeyboardHeight
                            self.view.layoutIfNeeded()
                        })

                    }).disposed(by: disposeBag)

    }
    
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
