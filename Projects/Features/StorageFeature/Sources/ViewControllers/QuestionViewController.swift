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
import DataMappingModule
import MessageUI
import CommonFeature

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
    
    
    @IBOutlet weak var wakMusicFeedbackSuperView: UIView!
    @IBOutlet weak var wakMusicFeedbackButton: UIButton!
    @IBOutlet weak var wakMusicFeedbackCheckImageView: UIImageView!
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    let selectedColor:UIColor = DesignSystemAsset.PrimaryColor.decrease.color
    let unSelectedTextColor:UIColor = DesignSystemAsset.GrayColor.gray900.color
    let unSelectedColor:UIColor = DesignSystemAsset.GrayColor.gray200.color
    let disposeBag = DisposeBag()
    var viewModel:QuestionViewModel!
    lazy var input = QuestionViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    
    var suggestFunctionComponent:SuggestFunctionComponent!
    var wakMusicFeedbackComponent: WakMusicFeedbackComponent!
    var askSongComponent: AskSongComponent!
    var bugReportComponent: BugReportComponent!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindRx()
    }
    
    public static func viewController(
        viewModel:QuestionViewModel,
        suggestFunctionComponent: SuggestFunctionComponent,
        wakMusicFeedbackComponent: WakMusicFeedbackComponent,
        askSongComponent: AskSongComponent,
        bugReportComponent: BugReportComponent
    ) -> QuestionViewController {
        let viewController = QuestionViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.suggestFunctionComponent = suggestFunctionComponent
        viewController.wakMusicFeedbackComponent = wakMusicFeedbackComponent
        viewController.askSongComponent = askSongComponent
        viewController.bugReportComponent = bugReportComponent
        return viewController
    }
}

extension QuestionViewController {
    
    private func configureUI(){
        self.titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        self.titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.titleLabel.text = "문의하기"
        self.titleLabel.setLineSpacing(kernValue: -0.5)

        self.closeButton.setImage(DesignSystemAsset.Navigation.crossClose.image, for: .normal)
        
        self.descriptionLabel.text = "어떤 것 관련해서 문의주셨나요?"
        self.descriptionLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 20)
        self.descriptionLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.descriptionLabel.setLineSpacing(kernValue: -0.5)

        self.nextButton.layer.cornerRadius = 12
        self.nextButton.clipsToBounds = true
        self.nextButton.isEnabled = false
        self.nextButton.setBackgroundColor(DesignSystemAsset.PrimaryColor.point.color, for: .normal)
        self.nextButton.setBackgroundColor(DesignSystemAsset.GrayColor.gray300.color, for: .disabled)
        self.nextButton.setAttributedTitle(
            NSMutableAttributedString(
                string: "다음",
                attributes: [
                    .font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                    .foregroundColor: DesignSystemAsset.GrayColor.gray25.color,
                    .kern: -0.5
                ]
            ), for: .normal
        )
            
        let superViews:[UIView] = [self.bugReportSuperView,
                                   self.suggestFunctionSuperView,
                                   self.addSongSuperView,
                                   self.editSongSuperView,
                                   self.wakMusicFeedbackSuperView]
        
        let buttons:[UIButton] = [self.bugReportButton,
                                  self.suggestFunctionButton,
                                  self.addSongButton,
                                  self.editSongButton,
                                  self.wakMusicFeedbackButton]
        
        let imageViews:[UIImageView] = [self.bugReportCheckImageView,
                                        self.suggestFunctionCheckImageView,
                                        self.addSongCheckImageView,
                                        self.editSongCheckImageView,
                                        self.wakMusicFeedbackCheckImageView]
        
        for i in 0..<superViews.count {
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
            case 4:
                title = "주간차트 영상"
            default:
                return
            }
            
            buttons[i].setAttributedTitle(
                NSMutableAttributedString(
                    string:title,
                    attributes: [
                        .font: DesignSystemFontFamily.Pretendard.light.font(size: 16),
                        .foregroundColor: unSelectedTextColor,
                        .kern: -0.5
                    ]
                ), for: .normal
            )
        }
    }
    
    private func bindRx(){
        
        self.closeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)

        Observable.merge(
            bugReportButton.rx.tap.map { _ in 0 },
            suggestFunctionButton.rx.tap.map { _ in 1 },
            addSongButton.rx.tap.map { _ in 2 },
            editSongButton.rx.tap.map { _ in 3 },
            wakMusicFeedbackButton.rx.tap.map{_ in 4}
        )
        .bind(to: output.selectedIndex)
        .disposed(by: disposeBag)
        
        self.output.selectedIndex.subscribe(onNext: { [weak self]  (index:Int) in
            guard let self = self else{
                return
            }
            
            if !self.nextButton.isEnabled {
                self.nextButton.isEnabled = true
            }
            let superViews:[UIView] = [self.bugReportSuperView,
                                       self.suggestFunctionSuperView,
                                       self.addSongSuperView,
                                       self.editSongSuperView,
                                       self.wakMusicFeedbackSuperView]
            
            let buttons:[UIButton] = [self.bugReportButton,
                                      self.suggestFunctionButton,
                                      self.addSongButton,
                                      self.editSongButton,
                                      self.wakMusicFeedbackButton]
            
            let imageViews:[UIImageView] = [self.bugReportCheckImageView,
                                            self.suggestFunctionCheckImageView,
                                            self.addSongCheckImageView,
                                            self.editSongCheckImageView,
                                            self.wakMusicFeedbackCheckImageView]
            
            let mailContentSuffix:String = "* 자동으로 작성된 시스템 정보입니다.\n* 원활한 문의를 위해서 삭제하지 말아주세요\n\n하드웨어 / \(OS_VERSION())\n\n userID:\(AES256.decrypt(encoded: Utility.PreferenceManager.userInfo?.displayName ?? "") )"
            
            let emailContent:[MailContent] = [MailContent(title: "버그 제보", body: "겪으신 버그에 대해 설명해 주세요.\n\n버그와 관련된 사진이나 영상을 첨부해 주세요.\n\n왁물원 닉네임을 알려주세요.\n\n\(mailContentSuffix)"),
                                              MailContent(title: "기능 제안", body: "제안해 주고 싶은 기능에 대해 설명해 주세요.\n\n어떤 플랫폼과 관련된 기능인가요\n\n a. 모바일 앱\n b. 데스크 앱\n c. 웹 사이트\n\n\(mailContentSuffix)"),
                                              MailContent(title: "노래 추가", body: "- 이세돌 분들이 부르신걸 이파리분들이 개인소장용으로 일부공개한 영상을 올리길 원하시면 ‘은수저’님에게 왁물원 채팅으로 부탁드립니다.\n- 왁뮤에 들어갈 수 있는 기준을 충족하는지 꼭 확인하시고 추가 요청해 주세요.\n\n아티스트:\n\n노래 제목:\n\n유튜브 링크:\n\n내용:\n\n\(mailContentSuffix)"),
                                              MailContent(title: "노래 수정", body:"- 이세돌 분들이 부르신걸 이파리분들이 개인소장용으로 일부공개한 영상을 올리길 원하시면 ‘은수저’님에게 왁물원 채팅으로 부탁드립니다.\n- 왁뮤에 들어갈 수 있는 기준을 충족하는지 꼭 확인하시고 추가 요청해 주세요.\n\n아티스트:\n\n노래 제목:\n\n유튜브 링크:\n\n내용:\n\n\(mailContentSuffix)"),
                                              MailContent(title: "주간 왁뮤", body: "문의하실 내용을 적어주세요.\n\n\(mailContentSuffix)")]
            
            self.output.mailContent.accept(emailContent[index]) //해당 이메일 넘겨 주
            
            for i in 0..<superViews.count {
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
                case 4:
                    title = "주간차트 영상"
                default:
                    return
                }
                buttons[i].setAttributedTitle(
                    NSMutableAttributedString(
                        string:title,
                        attributes: [
                            .font: i == index ? DesignSystemFontFamily.Pretendard.medium.font(size: 16) :
                                DesignSystemFontFamily.Pretendard.light.font(size: 16),
                            .foregroundColor: i == index ? self.selectedColor : self.unSelectedTextColor,
                            .kern: -0.5
                        ]
                    ), for: .normal
                )
                imageViews[i].isHidden = i == index ? false : true
                superViews[i].layer.borderColor = i == index ? self.selectedColor.cgColor : self.unSelectedColor.cgColor
                superViews[i].addShadow(offset: CGSize(width: 0, height: 2),color: colorFromRGB("080F34"),opacity: i == index ? 0.08 : 0)
                
            }
        }).disposed(by: disposeBag)
        
        self.nextButton.rx.tap
            .withLatestFrom(output.mailContent)
            .subscribe(onNext: { [weak self] in
                guard let self = self else{
                    return
                }
                
                if MFMailComposeViewController.canSendMail() {
                        
                        let compseVC = MFMailComposeViewController()
                        compseVC.mailComposeDelegate = self
                        
                        compseVC.setToRecipients([$0.receiver])
                        compseVC.setSubject($0.title)
                        compseVC.setMessageBody($0.body, isHTML: false)
                        self.present(compseVC, animated: true, completion: nil)
                        
                }
                else {
                    self.output.state.accept(.notReady)
                    self.output.showPopUp.accept(true)
                }
                
                
            })
            .disposed(by: disposeBag)
        
        
        output.showPopUp
            .filter({$0})
            .withLatestFrom(output.state){($1)}
            .subscribe {[weak self]  state in
                
                guard let self else {return}
                
                
                switch state {
                    
                case .sent:
                    
                    self.showToast(text: state.message, font: DesignSystemFontFamily.Pretendard.light.font(size: 14))
                    self.output.showPopUp.accept(false)
                    
                case .notReady:
                    
                    let vc = TextPopupViewController.viewController(text: state.message,cancelButtonIsHidden: true,confirmButtonText:state.buttonText ,completion: {
                        
                        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                        
                        self.output.showPopUp.accept(false)
                    })
                                                                    
                                                                
                    self.showPanModal(content: vc)
                }
                
                
               
                                                                
            }
            .disposed(by: disposeBag)
    }
    
 
}


extension QuestionViewController : MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if result == .sent {
            output.state.accept(.sent)
        }
        
        
        controller.dismiss(animated: true, completion: { [weak self]  in
            
            guard let self else {return}
            
            self.output.showPopUp.accept(true)
        })
    }
}
