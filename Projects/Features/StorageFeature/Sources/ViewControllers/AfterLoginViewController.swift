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
import CommonFeature
import KeychainModule
import DataMappingModule



public final class AfterLoginViewController: TabmanViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var headerFakeView: UIView!
    
    @IBOutlet weak var myPlayListFakeView: UIView!
    @IBOutlet weak var favoriteFakeView: UIView!
    
    @IBAction func pressRequestAction(_ sender: UIButton) {
        
        let viewController = requestComponent.makeView()
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
   

    
    @IBAction func pressLogoutAction(_ sender: UIButton) {
        
        let vc = TextPopupViewController.viewController(text:"로그아웃 하시겠습니까?",cancelButtonIsHidden: false, completion: { [weak self] in
            
            guard let self = self else{
                return
            }
            
            self.input.pressLogOut.accept(())

        })
        self.showPanModal(content: vc)
    }
    
    private var viewControllers: [UIViewController] = [UIViewController(),UIViewController()]
    var viewModel:AfterLoginViewModel!
    
    var requestComponent:RequestComponent!
    var profilePopComponent: ProfilePopComponent!
    var myPlayListComponent: MyPlayListComponent!
    var multiPurposePopComponent : MultiPurposePopComponent!
    var favoriteComponent:  FavoriteComponent!
    
    lazy var input = AfterLoginViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    
    let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    

        // Do any additional setup after loading the view.
    }
    
    //탭맨 페이지 변경 감지 함수
    public override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: TabmanViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        
        
        guard let vc1 = self.viewControllers[0] as? MyPlayListViewController  else{
            return
        }
        
        guard let vc2 = self.viewControllers[1] as? FavoriteViewController  else{
            return
        }
        
        
        let state = EditState(isEditing: false, force: true)
        
        
        if index == 0 {
           
            vc1.output.state.accept(state) // 이제 돌아오는 곳을 편집 전 으로 , 이게 밑에 bindEditButtonVisable() 에 연관 됨
            
        }
        else {
        
            vc2.output.state.accept(state)
        }

        output.state.accept(state)
    }
    
    
    public static func viewController(
        viewModel:AfterLoginViewModel,
        requestComponent:RequestComponent,
        profilePopComponent: ProfilePopComponent,
        myPlayListComponent: MyPlayListComponent,
        multiPurposePopComponent : MultiPurposePopComponent,
        favoriteComponent : FavoriteComponent
    ) -> AfterLoginViewController {
        let viewController = AfterLoginViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        
        viewController.viewModel = viewModel
        viewController.requestComponent = requestComponent
        viewController.profilePopComponent = profilePopComponent
        viewController.myPlayListComponent = myPlayListComponent
        viewController.multiPurposePopComponent = multiPurposePopComponent
        viewController.favoriteComponent = favoriteComponent
        
        viewController.viewControllers = [myPlayListComponent.makeView(),favoriteComponent.makeView()]
        
        return viewController
    }
}

extension AfterLoginViewController{
    
    private func configureUI(){

        profileImageView.layer.cornerRadius = 20
        
        profileLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        
        logoutButton.setImage(DesignSystemAsset.Storage.logout.image, for: .normal)
        
        requestButton.setImage(DesignSystemAsset.Storage.request.image, for: .normal)
        
        editButton.layer.cornerRadius = 4
        editButton.layer.borderWidth = 1
        editButton.backgroundColor = .clear
        editButton.isHidden = true
        
        myPlayListFakeView.isHidden = true
        favoriteFakeView.isHidden = true
        
        //탭바 설정
        self.dataSource = self
        let bar = TMBar.ButtonBar()
        
        
        // 배경색
       
        bar.backgroundView.style = .flat(color: .clear)
        
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
        bindEditButtonVisable()
        
    
        
        
    }
    
    private func bindRx()
    {
        
    
        
        output.state.subscribe { [weak self]  state in
            guard let self = self else{
                return
            }
            
            let attr = NSMutableAttributedString(string: state.isEditing ? "완료" : "편집",
                                                 attributes: [.font: DesignSystemFontFamily.Pretendard.bold.font(size: 12),
                                                              .foregroundColor: state.isEditing ? DesignSystemAsset.PrimaryColor.point.color : DesignSystemAsset.GrayColor.gray400.color ])
            
            self.editButton.layer.borderColor = state.isEditing ? DesignSystemAsset.PrimaryColor.point.color.cgColor : DesignSystemAsset.GrayColor.gray300.color.cgColor
         
            
            self.editButton.setAttributedTitle(attr, for: .normal)
            
            self.isScrollEnabled = !state.isEditing //  편집 시 , 옆 탭으로 swipe를 막기 위함
            self.headerFakeView.isHidden = !state.isEditing
            
      
            
            if state.isEditing {
                self.myPlayListFakeView.isHidden = self.currentIndex == 0
                self.favoriteFakeView.isHidden =  self.currentIndex == 1
            } else {
                self.myPlayListFakeView.isHidden = true
                self.favoriteFakeView.isHidden = true
            }
            
            
           
            
            
        }.disposed(by: disposeBag)
                
        editButton.rx.tap
            .withLatestFrom(output.state)
            .map({EditState(isEditing: !$0.isEditing, force: $0.force)})
            .do(onNext: { [weak self] (state:EditState)  in
                
                guard let self = self else{
                    return
                }
                
                
                let nextState = EditState(isEditing: state.isEditing, force: false)
                
                if self.currentIndex ?? 0  == 0 {
                    
                    guard let vc = self.viewControllers[0] as? MyPlayListViewController  else{
                        return
                    }
    
                    vc.output.state.accept(nextState)
                }
                
                else{
                    guard let vc =  self.viewControllers[1] as? FavoriteViewController else{
                        return
                    }
                    vc.output.state.accept(nextState)
                }
            })
            .bind(to: output.state)
            .disposed(by: disposeBag)

        profileButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else{
                return
            }
//            let vc = self.multiPurposePopComponent.makeView(type: .nickname)
            let vc = self.profilePopComponent.makeView()
            self.showPanModal(content: vc)
            
        }).disposed(by: disposeBag)
        
        Utility.PreferenceManager.$userInfo
            .debug("$userInfo")
            .filter { $0 != nil }
            .subscribe(onNext: { [weak self] (model) in
                guard let self = self, let model = model else {
                    return
                }
                self.profileLabel.text = AES256.decrypt(encoded: model.displayName).correctionNickName
                self.profileImageView.kf.setImage(
                    with: URL(string: WMImageAPI.fetchProfile(name: model.profile,version: model.version).toString),
                    placeholder: nil,
                    options: [.transition(.fade(0.2))]
                )
                
            }).disposed(by: disposeBag)
        
       
        
    }
    
    
    func bindEditButtonVisable(){
        guard let vc1 = self.viewControllers[0] as? MyPlayListViewController  else{
            return
        }

        guard let vc2 = self.viewControllers[1] as? FavoriteViewController  else{
            return
        }

        vc1.output.dataSource
            .skip(1)
            .filter{ [weak self] _  in
                guard let self = self else { return false }
                return (self.currentIndex ?? 0) == 0
            }
            .map { ($0.first?.items ?? []).isEmpty }
            .bind(to: editButton.rx.isHidden)
            .disposed(by: disposeBag)

        vc2.output.dataSource
            .skip(1)
            .filter{ [weak self] _  in
                guard let self = self else { return false }
                return (self.currentIndex ?? 0) == 1
            }
            .map { ($0.first?.items ?? []).isEmpty }
            .bind(to: editButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
}

extension AfterLoginViewController:PageboyViewControllerDataSource, TMBarDataSource {
    public func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        self.viewControllers.count
    }
    
    public func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
    }
    
    public func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        nil
    }
    
    public func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        
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
