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

class RequestViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var reportBugButton: UIButton!
    @IBOutlet weak var songRequestButton: UIButton!
    @IBOutlet weak var qnaButton: UIButton!
    @IBOutlet weak var dotLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var fakeViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var serviceButton: UIButton!
    
    @IBOutlet weak var privacyButton: UIButton!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    

    @IBAction func pressBackAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    @IBAction func moveQnaAction(_ sender: UIButton) {
        
        let viewController = QnAViewController.viewController()
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureUI()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil //스와이프로 뒤로가기
    }
    

    public static func viewController() -> RequestViewController {
        let viewController = RequestViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        return viewController
    }

}

extension RequestViewController{
    
    private func configureUI(){
        
        
        self.backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        
        self.titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        
        let buttons:[UIButton] = [self.reportBugButton,self.songRequestButton,self.qnaButton]
        
        for i in 0...2 {
            
            var title = ""
            switch i {
            case 0:
                title = "버그 제보"
            case 1:
                title = "노래 추가, 수정 요청"
            case 2:
                title = "자주 묻는 질문"
            default:
                return
            }
            
            var attr:NSAttributedString = NSAttributedString(string: title, attributes: [
                NSAttributedString.Key.font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color])
            
            buttons[i].setAttributedTitle(attr, for: .normal)
            
            buttons[i].layer.borderWidth = 1
            buttons[i].layer.cornerRadius = 12
            buttons[i].layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.withAlphaComponent(0.4).cgColor
            

        }
        
        dotLabel.layer.cornerRadius = 2
        dotLabel.clipsToBounds = true
        descriptionLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        
        
        let serviceAttributedString = NSMutableAttributedString.init(string: "서비스 이용약관")
        
        serviceAttributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                                               .foregroundColor: DesignSystemAsset.GrayColor.gray600.color], range: NSRange(location: 0, length: serviceAttributedString.string.count))
        
        
        let privacyAttributedString = NSMutableAttributedString.init(string: "개인정보처리방침")
        
        privacyAttributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                                               .foregroundColor: DesignSystemAsset.GrayColor.gray600.color], range: NSRange(location: 0, length: privacyAttributedString.string.count))
        
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
        
        
       
        fakeViewHeight.constant = calculateFakeViewHeight()
        self.view.layoutIfNeeded()
        
        
    }
    
    
    private func calculateFakeViewHeight() -> CGFloat{
        let window: UIWindow? = UIApplication.shared.windows.first
        let statusBarHeight:CGFloat = window?.safeAreaInsets.top ?? 0
        let safeAreaBottomHeight = window?.safeAreaInsets.bottom ?? 0
        let navigationBarHeight:CGFloat =  48
        let gapBtwNaviAndStack:CGFloat = 20
        let threeButtonHeight:CGFloat = 60 * 3
        let gapButtons:CGFloat = 8 * 2
        let gapBtwLabelAndLastButton:CGFloat = 20
        let textHeight = "왁타버스 뮤직 팀에 속한 모든 팀원들은 부아내비 (부려먹는 게 아니라 내가 비빈거다)라는 모토를 가슴에 새기고 일하고 있습니다.".heightConstraintAt(width: APP_WIDTH() - 56, font:DesignSystemFontFamily.Pretendard.light.font(size: 12))
        let bottomButtonHeight:CGFloat = 44
        let gapBtwBattomButtonsAndVersionLabel:CGFloat = 20
        let versionLabelHeight:CGFloat = 18
        let mainTabBarHeight:CGFloat = 56
        let playerHeight:CGFloat =  56 //TODO: 유무에 따라 변경 56 or 0

    
        let res = (APP_HEIGHT() - (safeAreaBottomHeight + statusBarHeight + navigationBarHeight + gapBtwNaviAndStack + threeButtonHeight + gapButtons + gapBtwLabelAndLastButton + textHeight + bottomButtonHeight + gapBtwBattomButtonsAndVersionLabel + versionLabelHeight + mainTabBarHeight + playerHeight +  20))
        

        
        DEBUG_LOG(res)
        return res
         
        
        
        
        
    }
    
    
}
