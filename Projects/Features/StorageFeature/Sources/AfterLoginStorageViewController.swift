//
//  AfterLoginViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/26.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import Pageboy
import Tabman
import RxSwift
import PanModal

class AfterLoginStorageViewController: TabmanViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var editButton: UIButton!
    
    
    
    @IBAction func pressRequestAction(_ sender: UIButton) {
        
        let viewController = RequestViewController.viewController()
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func pressEditProfileAction(_ sender: UIButton) {
        
        let vc = ProfilePopViewController.viewController()
        self.showPanModal(content: vc)
    }
    
    
    @IBAction func pressLogoutAction(_ sender: UIButton) {
        
        let vc = TextPopupViewController.viewController(text:"로그아웃 하시겠습니까?",cancelButtonIsHidden: false)
        self.showPanModal(content: vc)
    }
    
    
    private var viewControllers: [UIViewController] = [MyPlayListViewController.viewController(),FavoriteViewController.viewController()]
    lazy var viewModel = AfterLoginStroageViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    

        // Do any additional setup after loading the view.
    }
    
    //탭맨 페이지 변경 감지 함수
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: TabmanViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        
        
        guard let vc1 = self.viewControllers[0] as? MyPlayListViewController  else{
            return
        }
        
        guard let vc2 = self.viewControllers[1] as? FavoriteViewController  else{
            return
        }
        vc1.viewModel.output.isEditinglist.accept(false)
        vc2.viewModel.output.isEditinglist.accept(false)
        
        viewModel.output.isEditing.accept(false)
    }
    
    
    public static func viewController() -> AfterLoginStorageViewController {
        let viewController = AfterLoginStorageViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        return viewController
    }

}



extension AfterLoginStorageViewController{
    
    private func configureUI(){
        profileImageButton.setImage(DesignSystemAsset.Profile.profile0.image, for: .normal)
        
        profileLabel.text = "닉네임"
        profileLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        
        logoutButton.setImage(DesignSystemAsset.Storage.logout.image, for: .normal)
        
        requestButton.setImage(DesignSystemAsset.Storage.request.image, for: .normal)
        
        
        
        //탭바 설정
        self.dataSource = self
        let bar = TMBar.ButtonBar()
        
        
        // 배경색
       
        bar.backgroundView.style = .flat(color: .red)
        
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
        
        // indicator
        bar.indicator.weight = .custom(value: 3)
        bar.indicator.tintColor = DesignSystemAsset.PrimaryColor.point.color
        bar.indicator.overscrollBehavior = .compress
        addBar(bar, dataSource: self, at: .custom(view: tabBarView, layout: nil))
        bar.layer.addBorder([.bottom], color:DesignSystemAsset.GrayColor.gray300.color.withAlphaComponent(0.4), height: 1)

    
        bindRx()
        
    
        
        
    }
    
    private func bindRx()
    {
        viewModel.output.isEditing.subscribe { [weak self] (res:Bool) in
            
            guard let self = self else{
                return
            }
            
            let attr = NSMutableAttributedString(string: res ? "완료" : "편집",
                                                 attributes: [.font: DesignSystemFontFamily.Pretendard.bold.font(size: 12),
                                                              .foregroundColor: res ? DesignSystemAsset.PrimaryColor.point.color : DesignSystemAsset.GrayColor.gray400.color ])
            self.editButton.layer.cornerRadius = 4
            self.editButton.layer.borderColor = res ? DesignSystemAsset.PrimaryColor.point.color.cgColor : DesignSystemAsset.GrayColor.gray300.color.cgColor
            self.editButton.layer.borderWidth = 1
            self.editButton.backgroundColor = .clear
            
            self.editButton.setAttributedTitle(attr, for: .normal)
            
            self.isScrollEnabled = !res //  편집 시 , 옆 탭으로 swipe를 막기 위함
            
            
        }.disposed(by: disposeBag)
        
        
        
        editButton.rx.tap
            .withLatestFrom(viewModel.output.isEditing)
            .map({!$0})
            .do(onNext: { [weak self] (res:Bool)  in
                
                
                guard let self = self else{
                    return
                }
                
                if self.currentIndex ?? 0  == 0 {
                    
                    guard let vc = self.viewControllers[0] as? MyPlayListViewController  else{
                        return
                    }
                    vc.viewModel.output.isEditinglist.accept(res)
                }
                
                else{
                    guard let vc =  self.viewControllers[1] as? FavoriteViewController else{
                        return
                    }
                    vc.viewModel.output.isEditinglist.accept(res)
                    
                }
                
                
            })
            .bind(to: viewModel.output.isEditing)
            .disposed(by: disposeBag)
        
        
    }
    
    
}

extension AfterLoginStorageViewController:PageboyViewControllerDataSource, TMBarDataSource {
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
            return TMBarItem(title: "내 리스트")
        case 1:
            return TMBarItem(title: "좋아요")
        default:
            let title = "Page \(index)"
           return TMBarItem(title: title)
        }
        
    }
    
}
