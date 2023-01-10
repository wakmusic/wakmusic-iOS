//
//  Extension+UIViewController.swift
//  Utility
//
//  Created by KTH on 2023/01/02.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

public extension UIViewController {

    /// 뷰 컨트롤러로부터 네비게이션 컨트롤러를 입혀 반환합니다.
    /// 화면 이동을 위해서 필요합니다.
    /// https://etst.tistory.com/84
    /// - Returns: UINavigationController
    var wrapNavigationController: UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
    #if DEBUG
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    func toPreview() -> some View {
        Preview(viewController: self)
    }
    #endif

}
