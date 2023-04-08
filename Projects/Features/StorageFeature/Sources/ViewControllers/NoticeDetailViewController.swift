//
//  NoticeDetailViewController.swift
//  StorageFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import RxSwift
import RxCocoa

public class NoticeDetailViewController: UIViewController, ViewControllerFromStoryBoard {

    var viewModel: NoticeDetailViewModel!
    var disposeBag = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    public static func viewController(
        viewModel: NoticeDetailViewModel
    ) -> NoticeDetailViewController {
        let viewController = NoticeDetailViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        viewController.viewModel = viewModel
        return viewController
    }
}
