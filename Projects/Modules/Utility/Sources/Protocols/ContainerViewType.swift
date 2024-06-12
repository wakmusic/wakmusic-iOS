//
//  ContainerViewType.swift
//  Utility
//
//  Created by yongbeomkwak on 2023/01/13.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

public protocol ContainerViewType {
    var contentView: UIView! { get set }
}

public extension ContainerViewType where Self: UIViewController {
    func add(asChildViewController viewController: UIViewController?) {
        guard let viewController = viewController else {
            return
        }

        addChild(viewController)
        contentView.addSubview(viewController.view)
        viewController.didMove(toParent: self)

        viewController.view.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }

    func remove(asChildViewController viewController: UIViewController?) {
        guard let viewController = viewController else {
            return
        }

        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}
