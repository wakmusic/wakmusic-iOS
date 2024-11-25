//
//  ViewControllerFromStoryBoard.swift
//  Utility
//
//  Created by KTH on 2023/01/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewControllerFromStoryBoard {}
public protocol ViewControllerFromStoryBoardAndNeedle {}

@MainActor
public extension ViewControllerFromStoryBoard where Self: UIViewController {
    /// 스토리 보드에 정의된 화면을 객체화 하여 반환합니다.
    /// where Self: UIViewController: UIViewController에 한정하여 사용
    /// - Parameter storyBoardName: 스토리보드 이름
    /// - Parameter bundle: 해당 번들, 각 피쳐별 모듈이 다르기 때문에 번들까지 넘겨줘야합니다.
    /// - Returns: UIViewController
    static func viewController(storyBoardName: String, bundle: Bundle) -> Self {
        guard let viewController = UIStoryboard(name: storyBoardName, bundle: bundle)
            .instantiateViewController(withIdentifier: String(describing: Self.self)) as? Self
        else { return Self() }
        return viewController
    }
}
