//
//  BaseViewController.swift
//  BaseFeature
//
//  Created by KTH on 2023/01/29.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit

open class BaseViewController: UIViewController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        configureCommonUI()
    }
}

extension BaseViewController {
    /// 1. 네비게이션 바 숨김, 2. 테이블 뷰를 사용한다면 섹션헤더 간격 0으로 설정
    private func configureCommonUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let tableViews = self.view.subviews.map { $0 as? UITableView }.compactMap { $0 }
        tableViews.forEach {
            $0.sectionHeaderTopPadding = 0
        }
    }
}
