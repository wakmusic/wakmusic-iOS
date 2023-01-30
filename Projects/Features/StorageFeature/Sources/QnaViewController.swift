//
//  QnAViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/29.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import Tabman
import Pageboy
import DesignSystem

class QnaViewController: TabmanViewController, ViewControllerFromStoryBoard {
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tabBarView: UIView!
    
    @IBAction func pressBackAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        // Do any additional setup after loading the view.
    }
    
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil //스와이프로 뒤로가기
    }
    
    
    
    
    let viewControllers:[UIViewController] = [QnaContentViewController.viewController([QnAModel.init(categoty: "플레이리스트", question: "플레이리스트는 어떻게 만드나요?", ansewr: "아 그거는 알잘딱 모시깽이하시면 됩니다.", isOpened: false),QnAModel.init(categoty: "카테고리2", question: "자주 묻는 질문 제목", ansewr: "자주 묻는 질문 답변이 나옵니다.\n위아래 여백에 맞춰 답변 길이가 유동적으로 바뀝니다.\n자주 묻는 질문 답변이 나옵니다.\n위아래 여백에 맞춰 답변 길이가 유동적으로 바뀝니다.", isOpened: false),QnAModel.init(categoty: "플레이리시트", question: "자주 묻는 질문 제목 두줄인 경우 자주 묻는 질문 제목 두줄인 경우 자주 묻는 질문 제목 두줄", ansewr: "아 그거는 알잘딱 모시깽이하시면 됩니다.", isOpened: false),QnAModel.init(categoty: "카테고리2", question: "자주 묻는 질문 제목", ansewr: "자주 묻는 질문 답변이 나옵니다.\n위아래 여백에 맞춰 답변 길이가 유동적으로 바뀝니다.\n자주 묻는 질문 답변이 나옵니다.\n위아래 여백에 맞춰 답변 길이가 유동적으로 바뀝니다.", isOpened: false),QnAModel.init(categoty: "플레이리시트", question: "자주 묻는 질문 제목 두줄인 경우 자주 묻는 질문 제목 두줄인 경우 자주 묻는 질문 제목 두줄", ansewr: "아 그거는 알잘딱 모시깽이하시면 됩니다.", isOpened: false),QnAModel.init(categoty: "카테고리2", question: "자주 묻는 질문 제목", ansewr: "자주 묻는 질문 답변이 나옵니다.\n위아래 여백에 맞춰 답변 길이가 유동적으로 바뀝니다.\n자주 묻는 질문 답변이 나옵니다.\n위아래 여백에 맞춰 답변 길이가 유동적으로 바뀝니다.", isOpened: false),QnAModel.init(categoty: "플레이리시트", question: "자주 묻는 질문 제목 두줄인 경우 자주 묻는 질문 제목 두줄인 경우 자주 묻는 질문 제목 두줄", ansewr: "아 그거는 알잘딱 모시깽이하시면 됩니다.", isOpened: false),QnAModel.init(categoty: "카테고리2", question: "자주 묻는 질문 제목", ansewr: "자주 묻는 질문 답변이 나옵니다.\n위아래 여백에 맞춰 답변 길이가 유동적으로 바뀝니다.\n자주 묻는 질문 답변이 나옵니다.\n위아래 여백에 맞춰 답변 길이가 유동적으로 바뀝니다.", isOpened: false),QnAModel.init(categoty: "플레이리시트", question: "자주 묻는 질문 제목 두줄인 경우 자주 묻는 질문 제목 두줄인 경우 자주 묻는 질문 제목 두줄", ansewr: "아 그거는 알잘딱 모시깽이하시면 됩니다.", isOpened: false)]),UIViewController(),UIViewController(),UIViewController()]
    
    

    public static func viewController() -> QnaViewController {
        let viewController = QnaViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        return viewController
    }
    

}

extension QnaViewController {
    
    private func configureUI(){
        
        self.backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        
        self.titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        
        
        
        
        //탭바 설정
        self.dataSource = self
        let bar = TMBar.ButtonBar()


        
        // 배경색
       
        bar.backgroundView.style = .flat(color: colorFromRGB(0xF0F3F6))
        
        
        // 간격 설정
        
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bar.layout.contentMode = .intrinsic
        bar.layout.transitionStyle = .progressive
        
        
        // 버튼 글씨 커스텀
        bar.buttons.customize { (button) in
            button.tintColor = DesignSystemAsset.GrayColor.gray400.color
            button.selectedTintColor = DesignSystemAsset.GrayColor.gray900.color
            button.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
            button.selectedFont = DesignSystemFontFamily.Pretendard.bold.font(size: 16)
        }
        
        var tmp =  UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 1))
        tmp.backgroundColor = .red
        
        bar.insertSubview(tmp, at: 0)
        // indicator
        bar.indicator.weight = .custom(value: 3)
        bar.indicator.tintColor = DesignSystemAsset.PrimaryColor.point.color
        bar.indicator.overscrollBehavior = .compress
        addBar(bar, dataSource: self, at: .custom(view: tabBarView, layout: nil))
        
       
        
    }
    
}


extension  QnaViewController:PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        self.viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        nil
    }
    
    func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        
        switch index{
        case 0:
 
            return TMBarItem(title: "전체    ")
        default:
            let title = "카테고리\(index)  "
           return TMBarItem(title: title)
        }
        
    }
 
}

