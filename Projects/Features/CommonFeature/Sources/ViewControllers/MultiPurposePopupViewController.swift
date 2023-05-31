//
//  CreatePlayListPopupViewController.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 2023/01/21.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import RxCocoa
import RxSwift
import RxKeyboard
import DesignSystem
import NVActivityIndicatorView
import SwiftEntryKit

public enum PurposeType{
    case creation
    case edit
    case load
    case share
    case nickname
}

extension PurposeType{
    var title:String{
        switch self{
        case .creation:
            return "리스트 만들기"
        case .edit:
            return "리스트 수정하기"
        case .load:
            return "리스트 가져오기"
        case .share:
            return "리스트 공유하기"
        case .nickname:
            return "닉네임 수정"
        }
    }
    
    var subTitle:String{
        switch self{
        case .creation:
            return "리스트 제목"
        case .edit:
            return "리스트 제목"
        case .load:
            return "리스트 코드"
        case .share:
            return "리스트 코드"
        case .nickname:
            return "닉네임"
        }
    }
    
    var btnText:String{
        switch self{
        case .creation:
            return "리스트 생성"
        case .edit:
            return "리스트 수정"
        case .load:
           return "가져오기"
        case .share:
            return "확인"
        case .nickname:
            return "완료"
        }
    }
}

public final class  MultiPurposePopupViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var confirmLabel: UILabel!
    
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    
    @IBOutlet weak var confireLabelGap: NSLayoutConstraint!
    
    @IBOutlet weak var cancelButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cancelButtonWidth: NSLayoutConstraint!
    
    @IBAction func cancelAction(_ sender: UIButton) {
        if viewModel.type == .share{
            UIPasteboard.general.string = input.textString.value //클립보드 복사
            self.showToast(text: "복사가 완료되었습니다.", font: DesignSystemFontFamily.Pretendard.light.font(size: 14))
            
        }else{
            textField.rx.text.onNext("")
            input.textString.accept("")
        }
    }
    
    var viewModel:MultiPurposePopupViewModel!
    lazy var input = MultiPurposePopupViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    
    var limitCount: Int = 12
    var creationCompletion: ((String) -> Void)?
    
    public var disposeBag = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    public static func viewController(
        viewModel: MultiPurposePopupViewModel,
        completion: ((String) -> Void)? = nil
    ) -> MultiPurposePopupViewController {
        let viewController = MultiPurposePopupViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.creationCompletion = completion
        return viewController
    }
}

extension MultiPurposePopupViewController{
    private func configureUI() {
        self.view.layer.cornerRadius = 24
        self.view.clipsToBounds = true
        
        titleLabel.text = viewModel.type.title
        titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        subTitleLabel.text = viewModel.type.subTitle
        subTitleLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 16)
        subTitleLabel.textColor = DesignSystemAsset.GrayColor.gray400.color
        
        let headerFontSize:CGFloat = 20
        let focusedplaceHolderAttributes = [
            NSAttributedString.Key.foregroundColor: DesignSystemAsset.GrayColor.gray400.color,
            NSAttributedString.Key.font : DesignSystemFontFamily.Pretendard.medium.font(size: headerFontSize)
        ] // 포커싱 플레이스홀더 폰트 및 color 설정
        
//        textField.becomeFirstResponder()
        self.textField.attributedPlaceholder = NSAttributedString(
            string: viewModel.type == .creation || viewModel.type == .edit ?
                    "리스트 제목을 입력하세요." : viewModel.type == .nickname ? "닉네임을 입력하세요." : "코드를 입력해주세요.",
            attributes: focusedplaceHolderAttributes
        ) //플레이스 홀더 설정
        self.textField.font = DesignSystemFontFamily.Pretendard.medium.font(size: headerFontSize)
        
        if viewModel.type == .share { //공유는 오직 읽기 전용
            self.textField.isEnabled = false
            self.input.textString.accept(viewModel.key)
            self.textField.text = viewModel.key
        }
        
        self.dividerView.backgroundColor = DesignSystemAsset.GrayColor.gray200.color
        
        if viewModel.type == .share{
            self.cancelButtonWidth.constant = 32
            self.cancelButtonHeight.constant = 32
            self.cancelButton.setImage(DesignSystemAsset.Storage.copy.image, for: .normal)
            
        }else{
            self.cancelButton.layer.cornerRadius = 12
            self.cancelButton.titleLabel?.text = "취소"
            self.cancelButton.titleLabel?.font = DesignSystemFontFamily.Pretendard.bold.font(size: 12)
            self.cancelButton.layer.cornerRadius = 4
            self.cancelButton.layer.borderColor =  DesignSystemAsset.GrayColor.gray200.color.cgColor
            self.cancelButton.layer.borderWidth = 1
            self.cancelButton.backgroundColor = .white
            self.cancelButton.isHidden = true
        }
        
        switch viewModel.type {
            
        case .creation, .edit, .nickname:
            self.confirmLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
            self.confirmLabel.isHidden = true
            
            self.limitLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
            self.limitLabel.textColor = DesignSystemAsset.GrayColor.gray500.color
            
            self.countLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
            self.countLabel.textColor = DesignSystemAsset.PrimaryColor.point.color
            bindRxCreationOrEditOrNickName()

        case .load, .share:
            self.confirmLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
            self.confirmLabel.textColor = DesignSystemAsset.GrayColor.gray500.color
            self.confirmLabel.isHidden = false
            self.confirmLabel.text =  viewModel.type == .load ?  "· 리스트 코드로 리스트를 가져올 수 있습니다." : "· 리스트 코드로 리스트를 공유할 수 있습니다."
            self.confireLabelGap.constant = 12
            
            self.limitLabel.isHidden = true
            self.countLabel.isHidden = true
            bindRxLoadOrShare()
        }
        
        bindRxEvent()
        
        saveButton.layer.cornerRadius = 12
        saveButton.clipsToBounds = true
        saveButton.setAttributedTitle(NSMutableAttributedString(
            string: viewModel.type.btnText,
            attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                         .foregroundColor: DesignSystemAsset.GrayColor.gray25.color ]
        ), for: .normal)

        saveButton.setBackgroundColor(DesignSystemAsset.PrimaryColor.point.color, for: .normal)
        saveButton.setBackgroundColor(DesignSystemAsset.GrayColor.gray300.color, for: .disabled)
        
        self.indicator.type = .circleStrokeSpin
        self.indicator.color = .white
    }
    
    private func bindRxCreationOrEditOrNickName(){
        limitCount = viewModel.type == .nickname ? 8 : 12
        limitLabel.text = "/\(limitCount)"
                
        input.textString
            .subscribe { [weak self] (str: String) in
                guard let self = self else{
                    return
                }
                
                let errorColor = DesignSystemAsset.PrimaryColor.increase.color
                let passColor = DesignSystemAsset.PrimaryColor.decrease.color
                
                self.countLabel.text = "\(str.count)자"
                
                if str.count == 0{
                    self.cancelButton.isHidden = true
                    self.confirmLabel.isHidden = true
                    self.saveButton.isEnabled = false
                    self.dividerView.backgroundColor = DesignSystemAsset.GrayColor.gray200.color
                    self.countLabel.textColor = DesignSystemAsset.PrimaryColor.point.color
                    return
                    
                }else{
                    self.cancelButton.isHidden = false
                    self.confirmLabel.isHidden = false
                    self.countLabel.isHidden = false
                }
                
                if str.isWhiteSpace {
                    self.dividerView.backgroundColor = errorColor
                    self.confirmLabel.text = "제목이 비어있습니다."
                    self.confirmLabel.textColor = errorColor
                    self.countLabel.textColor = errorColor
                    self.saveButton.isEnabled = false
                    
                }else if str.count > self.limitCount {
                    self.dividerView.backgroundColor = errorColor
                    self.confirmLabel.text = "글자 수를 초과하였습니다."
                    self.confirmLabel.textColor = errorColor
                    self.countLabel.textColor = errorColor
                    self.saveButton.isEnabled = false
                    
                }else {
                    self.dividerView.backgroundColor = passColor
                    self.confirmLabel.text =  self.viewModel.type == .nickname ? "사용할 수 있는 닉네임입니다." : "사용할 수 있는 제목입니다."
                    self.confirmLabel.textColor = passColor
                    self.countLabel.textColor = DesignSystemAsset.PrimaryColor.point.color
                    self.saveButton.isEnabled = true
                }
                
            }.disposed(by: disposeBag)
        
        output.newPlayListKey
            .subscribe(onNext: { [weak self] (str: String) in
                guard let self = self else{return}
                self.creationCompletion?(str)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindRxLoadOrShare() {
        input.textString
            .subscribe { [weak self] (str: String) in
                guard let self = self else{
                    return
                }
                
                if str.count == 0 {
                    self.cancelButton.isHidden = true
                    self.saveButton.isEnabled = false
                }else {
                    self.cancelButton.isHidden =  false
                    if str.isWhiteSpace {
                        self.saveButton.isEnabled = false
                    }else{
                        self.saveButton.isEnabled = true
                    }
                }
            }.disposed(by: disposeBag)
    }
    
    private func bindRxEvent(){
        textField.rx.text.orEmpty
            .skip(1)  //바인드 할 때 발생하는 첫 이벤트를 무시
            .bind(to: input.textString)
            .disposed(by: self.disposeBag)
        
        output.result.subscribe(onNext: { [weak self] res in
            guard let self = self else{
                return
            }
            
            self.indicator.stopAnimating()
            self.saveButton.setAttributedTitle(
                NSMutableAttributedString(
                    string: "완료",
                    attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                                 .foregroundColor: DesignSystemAsset.GrayColor.gray25.color]
                ), for: .normal
            )
            self.view.endEditing(true)
            
            if res.status == 200 {
                SwiftEntryKit.dismiss()
                
            }
            
            else if res.status == 401 {
                //SwiftEntryKit.dismiss()
                self.showToast(text: res.description, font: DesignSystemFontFamily.Pretendard.light.font(size: 14))
                
                if viewModel.type == .edit {
                    // 플레이리스트 디테일 dismiss 코드 
                }
                
                LOGOUT()
                NotificationCenter.default.post(name: .movedTab, object: 4) // 보관함 탭으로 이동
            }
            
            else {
                self.showToast(text: res.description, font: DesignSystemFontFamily.Pretendard.light.font(size: 14))
            }
        })
        .disposed(by: disposeBag)
        
        saveButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            if self.viewModel.type != .share {
                self.indicator.startAnimating()
                self.saveButton.setAttributedTitle(
                    NSMutableAttributedString(
                        string: "",
                        attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                                     .foregroundColor: DesignSystemAsset.GrayColor.gray25.color]
                    ), for: .normal
                )
            }
            self.input.pressConfirm.onNext(())
        })
        .disposed(by: disposeBag)
    }
    
}
