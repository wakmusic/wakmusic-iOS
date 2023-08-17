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
    
    func showEntryKitModal(content: UIViewController, height: CGFloat) {
        var attributes: EKAttributes
        attributes = .bottomFloat
        attributes.displayDuration = .infinity
        attributes.screenBackground = .color(color: EKColor(rgb: 0x000000).with(alpha: 0.4))
        attributes.entryBackground = .color(color: EKColor(rgb: 0xffffff))
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.positionConstraints.verticalOffset = 0
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: true)
        attributes.roundCorners = .top(radius: 24)
        attributes.positionConstraints.keyboardRelation = .bind(offset: .none)
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.4,
                spring: .init(damping: 0.8, initialVelocity: 0)
            )
        )
        attributes.exitAnimation = .init(
            translate: .init(
                duration: 0.4,
                spring: .init(damping: 0.8, initialVelocity: 0)
            )
        )
        attributes.positionConstraints.size = .init(
            width: .offset(value: 0),
            height: .constant(value: height)
        )
        attributes.positionConstraints.maxSize = .init(
            width: .offset(value: 0),
            height: .constant(value: height)
        )
        
        HapticManager.shared.impact(style: .light)
        SwiftEntryKit.display(entry: content, using: attributes)
    }
    
    func showToast(text: String, font: UIFont, verticalOffset: CGFloat? = nil) {
        var attributes = EKAttributes.bottomFloat
        attributes.displayDuration = 2
        attributes.entryBackground = .color(color: EKColor(rgb: 0x101828).with(alpha: 0.8))
        attributes.roundCorners = .all(radius: 20)
        
        if let verticalOffset = verticalOffset {
            attributes.positionConstraints.verticalOffset = verticalOffset
        }

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
    
    func hideKeyboardWhenTappedAround() {

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
   static func rootViewController() -> UIViewController? {
        var root: UIViewController?
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            if rootViewController is UINavigationController {
                root = (rootViewController as! UINavigationController).visibleViewController!
            }else{
                if let presentedViewController = rootViewController.presentedViewController {
                    root  = presentedViewController
                }
            }
        }
        return root
    }
    
    func goAppStore() {
        let appID: String = WM_APP_ID()
        guard let storeURL = URL(string: "https://itunes.apple.com/kr/app/id/\(appID)"),
            UIApplication.shared.canOpenURL(storeURL) else { return }
        UIApplication.shared.open(storeURL)
    }
}
