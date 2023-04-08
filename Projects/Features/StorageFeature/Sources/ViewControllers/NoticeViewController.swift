//
//  NoticeViewController.swift
//  StorageFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import RxSwift
import RxCocoa

public class NoticeViewController: UIViewController, ViewControllerFromStoryBoard {
    
    var viewModel: NoticeViewModel!
    var noticeDetailComponent: NoticeDetailComponent!
    var disposeBag = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    public static func viewController(
        viewModel: NoticeViewModel,
        noticeDetailComponent: NoticeDetailComponent
    ) -> NoticeViewController {
        let viewController = NoticeViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.noticeDetailComponent = noticeDetailComponent
        return viewController
    }
}
