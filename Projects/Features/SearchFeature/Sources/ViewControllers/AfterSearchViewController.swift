//
//  AfterSearchContentViewController.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/11.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import Pageboy
import Tabman
import RxSwift



public final class AfterSearchViewController: TabmanViewController, ViewControllerFromStoryBoard  {

    @IBOutlet weak var tabBarView: UIView!
    
    @IBOutlet weak var fakeView: UIView!
    
    
    
    

    
    var viewModel:AfterSearchViewModel!
    var afterSearchContentComponent:AfterSearchContentComponent!
    let disposeBag = DisposeBag()
    
    
    private var viewControllers: [UIViewController] = [UIViewController(),UIViewController(),UIViewController(),UIViewController()]
    private lazy var input = AfterSearchViewModel.Input()
    private lazy var output = viewModel.transform(from: input)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollToPage(.at(index: 0), animated: false)
    }
    

    public static func viewController(afterSearchContentComponent:AfterSearchContentComponent,viewModel:AfterSearchViewModel) -> AfterSearchViewController {
        let viewController = AfterSearchViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)
        
        viewController.viewModel = viewModel
        viewController.afterSearchContentComponent = afterSearchContentComponent
        
     
        
        
        
        return viewController
    }

}

extension AfterSearchViewController {
    
    private func configureUI() {
        self.fakeView.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        self.dataSource = self //dateSource
        let bar = TMBar.ButtonBar()
        
        // 배경색
        bar.backgroundView.style = .flat(color:.clear)
        
        // 간격 설정
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bar.layout.contentMode = .fit
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
    
    private func bindRx(){
        
        output.result
            .skip(1)
            .subscribe(onNext: { [weak self] result in
            
            guard let self = self else{
                return
            }
            

            
            guard let comp = self.afterSearchContentComponent else {
                return
            }
            
            self.viewControllers = [comp.makeView(type: .all, dataSource: result),comp.makeView(type: .song, dataSource: result),
                                    comp.makeView(type: .artist, dataSource: result),comp.makeView(type: .remix, dataSource: result)
            ]
            self.reloadData()
            
            
        })
        .disposed(by: disposeBag)
        
        
    }
}


extension AfterSearchViewController: PageboyViewControllerDataSource, TMBarDataSource {
    public func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        viewControllers.count
    }
    
    public func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
    }
    
    public func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        nil
    }
    
    public func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "전체")
        case 1:
            return TMBarItem(title: "노래")
        case 2:
           return TMBarItem(title: "가수")
        case 3:
           return TMBarItem(title: "조교")
        default:
            let title = "Page \(index)"
           return TMBarItem(title: title)
        }
    }
    
    
}
