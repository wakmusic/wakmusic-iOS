//
//  RequestViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/28.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import CommonFeature
import RxSwift

public final class RequestViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var questionImageview: UIImageView!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var questionSuperView: UIView!
    
    @IBOutlet weak var qnaSuperView: UIView!
    @IBOutlet weak var qnaSuperImageview: UIImageView!
    @IBOutlet weak var qnaButton: UIButton!
    
    @IBOutlet weak var noticeSuperView: UIView!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var noticeImageView: UIImageView!
    
    @IBOutlet weak var dotLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var fakeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var serviceButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var withdrawButton: UIButton!
    
    @IBAction func pressBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moveQnaAction(_ sender: UIButton) {
        let vc = qnaComponent.makeView()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func moveQuestionAction(_ sender: Any) {
        let vc =  questionComponent.makeView().wrapNavigationController
        vc.modalPresentationStyle = .overFullScreen //꽉찬 모달
        self.present(vc, animated: true)
    }
    
    @IBAction func movenoticeAction(_ sender: Any) {
    }
    
    @IBAction func presswithDrawAction(_ sender: UIButton) {
        let secondConfirmVc = TextPopupViewController.viewController(text: "정말 탈퇴하시겠습니까?", cancelButtonIsHidden: false,completion: {
            // 회원탈퇴 작업
            self.input.pressWithdraw.onNext(())
        })
        let firstConfirmVc = TextPopupViewController.viewController(text: "회원탈퇴 신청을 하시겠습니까?", cancelButtonIsHidden: false,completion: {
            self.showPanModal(content: secondConfirmVc)
        })
        self.showPanModal(content: firstConfirmVc)
    }
    
    @IBAction func pressServiceAction(_ sender: UIButton) {
        let vc = ContractViewController.viewController(type: .service)
        vc.modalPresentationStyle = .overFullScreen //꽉찬 모달
        self.present(vc, animated: true)
    }
    
    @IBAction func pressPrivacyAction(_ sender: UIButton) {
        let vc = ContractViewController.viewController(type: .privacy)
        vc.modalPresentationStyle = .overFullScreen //꽉찬 모달
        self.present(vc, animated: true)
    }
    
    var viewModel:RequestViewModel!
    lazy var input = RequestViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    
    var qnaComponent:QnaComponent!
    var questionComponent:QuestionComponent!
    var containSongsComponent: ContainSongsComponent!
    
    var disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindRx()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil //스와이프로 뒤로가기
    }
    
    public static func viewController(
        viewModel:RequestViewModel,
        qnaComponent: QnaComponent,
        questionComponent: QuestionComponent,
        containSongsComponent: ContainSongsComponent
    ) -> RequestViewController {
        let viewController = RequestViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.qnaComponent = qnaComponent
        viewController.questionComponent = questionComponent
        viewController.containSongsComponent = containSongsComponent
        return viewController
    }
}

extension RequestViewController{
    
    private func configureUI(){
        self.backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        self.titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        
        let buttons: [UIButton] = [self.questionButton, self.qnaButton, self.noticeButton]
        let superViews: [UIView] = [self.questionSuperView, self.qnaSuperView, self.noticeSuperView]
        let imageViews: [UIImageView] = [self.questionImageview, self.qnaSuperImageview, self.noticeImageView]
        
        for i in 0..<buttons.count {
            var title = ""
            switch i {
            case 0:
                title = "문의하기"
                imageViews[i].image = DesignSystemAsset.Storage.question.image
            case 1:
                title = "자주 묻는 질문"
                imageViews[i].image = DesignSystemAsset.Storage.qna.image
            case 2:
                title = "공지사항"
                imageViews[i].image = DesignSystemAsset.Storage.notice.image
            default:
                return
            }
            
            var attr:NSAttributedString = NSAttributedString(
                string: title,
                attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
                             .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                             .kern: -0.5]
            )
            buttons[i].setAttributedTitle(attr, for: .normal)
            superViews[i].backgroundColor = .white.withAlphaComponent(0.4)
            superViews[i].layer.borderWidth = 1
            superViews[i].layer.cornerRadius = 12
            superViews[i].layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.cgColor
        }
        
        dotLabel.layer.cornerRadius = 2
        dotLabel.clipsToBounds = true
        descriptionLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        
        let serviceAttributedString = NSMutableAttributedString.init(string: "서비스 이용약관")
        serviceAttributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                                               .foregroundColor: DesignSystemAsset.GrayColor.gray600.color,
                                               .kern: -0.5], range: NSRange(location: 0, length: serviceAttributedString.string.count))
        
        let privacyAttributedString = NSMutableAttributedString.init(string: "개인정보처리방침")
        privacyAttributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                                               .foregroundColor: DesignSystemAsset.GrayColor.gray600.color,
                                               .kern: -0.5], range: NSRange(location: 0, length: privacyAttributedString.string.count))
        
        privacyButton.layer.cornerRadius = 8
        privacyButton.layer.borderColor = DesignSystemAsset.GrayColor.gray400.color.withAlphaComponent(0.4).cgColor
        privacyButton.layer.borderWidth = 1
        privacyButton.setAttributedTitle(privacyAttributedString, for: .normal)
        
        serviceButton.layer.cornerRadius = 8
        serviceButton.layer.borderColor = DesignSystemAsset.GrayColor.gray400.color.withAlphaComponent(0.4).cgColor
        serviceButton.layer.borderWidth = 1
        serviceButton.setAttributedTitle(serviceAttributedString, for: .normal)
        
        versionLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        versionLabel.text = "버전정보 \(APP_VERSION())"
        
        let withDrawAttributedString = NSMutableAttributedString.init(string: "회원탈퇴")
        withDrawAttributedString.addAttributes(
            [.font: DesignSystemFontFamily.Pretendard.bold.font(size: 12),
             .foregroundColor: DesignSystemAsset.GrayColor.gray400.color,
             .kern: -0.5],
            range: NSRange(location: 0, length: withDrawAttributedString.string.count)
        )
        withdrawButton.layer.borderWidth = 1
        withdrawButton.layer.cornerRadius = 4
        withdrawButton.layer.borderColor = DesignSystemAsset.GrayColor.gray300.color.cgColor
        withdrawButton.setAttributedTitle(withDrawAttributedString, for: .normal)
    }
    
    private func bindRx(){
        
        output.withDrawResult.subscribe(onNext: { [weak self] in
            guard let self = self else{
                return
            }
            
            let status: Int = $0.status
            let withdrawVc = TextPopupViewController.viewController(
                text: (status == 200) ? "회원탈퇴가 완료되었습니다.\n이용해주셔서 감사합니다." : $0.description,
                cancelButtonIsHidden: true,
                completion: {
                    if status == 200 {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            self.showPanModal(content: withdrawVc)
        })
        .disposed(by: disposeBag)
    }
}
