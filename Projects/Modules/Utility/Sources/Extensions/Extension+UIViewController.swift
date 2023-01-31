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
import PanModal
import SwiftEntryKit

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
    
    func showPanModal(content: UIViewController & PanModalPresentable) {
        let viewController: PanModalPresentable.LayoutType = content
        self.presentPanModal(viewController)
    }
    
    func showToast(text: String, font: UIFont) {
        var attributes = EKAttributes.bottomFloat
        attributes.displayDuration = 2
        attributes.entryBackground = .color(color: EKColor(rgb: 0x101828).with(alpha: 0.8))
        attributes.roundCorners = .all(radius: 20)

        let style = EKProperty.LabelStyle(
            font: font,
            color: EKColor(rgb: 0xFCFCFD),
            alignment: .center
        )
        let labelContent = EKProperty.LabelContent(
            text: text,
            style: style
        )

        let contentView = EKNoteMessageView(with: labelContent)
        contentView.verticalOffset = 10
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}
