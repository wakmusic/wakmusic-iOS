//
//  Extension+UIViewController.swift
//  Utility
//
//  Created by KTH on 2023/01/02.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import FittedSheets
import Foundation
import SwiftEntryKit
import SwiftUI
import UIKit

public extension UIViewController {
    /// 뷰 컨트롤러로부터 네비게이션 컨트롤러를 입혀 반환합니다.
    /// 화면 이동을 위해서 필요합니다.
    /// https://etst.tistory.com/84
    /// - Returns: UINavigationController
    var wrapNavigationController: UINavigationController {
        return UINavigationController(rootViewController: self)
    }

    #if DEBUG || QA
        private struct Preview: UIViewControllerRepresentable {
            let viewController: UIViewController

            func makeUIViewController(context: Context) -> UIViewController {
                return viewController
            }

            func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
        }

        func toPreview() -> some View {
            Preview(viewController: self)
        }
    #endif

    /// showBottomSheet(): PanModal의 대체
    /// - Parameter content: ViewController
    /// - Parameter size: 내부 컨텐츠로 사이즈 결정이 가능하면 .intrinsic, 고정시켜야 하는 경우: .fixed(200), (default: .intrinsic)
    /// - Parameter dismissOnOverlayTapAndPull: 오버레이 영역 터치하거나 당겨서 닫기 허용여부 (default: true)
    /// - 버튼을 눌러서 다음 행동을 해야하는 경우 dismissOnOverlayTapAndPull 옵션을 필수로 false 설정할 것. (ex: 강제업데이트 팝업)
    func showBottomSheet(
        content: UIViewController,
        size: BottomSheetSize = .intrinsic,
        dismissOnOverlayTapAndPull: Bool = true
    ) {
        showFittedSheets(
            content: content,
            size: size,
            dismissOnOverlayTapAndPull: dismissOnOverlayTapAndPull
        )
    }

    func showToast(
        text: String,
        font: UIFont = UIFont(name: "Pretendard-Light", size: 14) ??
            .systemFont(ofSize: 14, weight: .light),
        options: WMToastOptions = [.empty],
        backgroundThema: EKAttributes.DisplayMode = .dark
    ) {
        var attributes = EKAttributes.bottomFloat
        attributes.displayDuration = 2
        attributes.entryBackground = backgroundThema == .dark ?
            .color(color: EKColor(rgb: 0x101828).with(alpha: 0.8)) :
            .color(color: EKColor(rgb: 0xF2F4F7).with(alpha: 0.8))
        attributes.roundCorners = .all(radius: 20)
        attributes.entranceAnimation = EKAttributes.Animation.init(
            translate: .init(duration: 0.3),
            fade: .init(from: 0, to: 1, duration: 0.3)
        )
        attributes.exitAnimation = EKAttributes.Animation.init(
            fade: .init(from: 1, to: 0, duration: 0.3)
        )
        attributes.positionConstraints.verticalOffset = options.offset

        let style = EKProperty.LabelStyle(
            font: font,
            color: backgroundThema == .dark ? EKColor(rgb: 0xFCFCFD) : EKColor(rgb: 0x191A1C),
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

    func goAppStore() {
        let appID: String = WM_APP_ID()
        guard let storeURL = URL(string: "https://itunes.apple.com/kr/app/id/\(appID)"),
              UIApplication.shared.canOpenURL(storeURL) else { return }
        UIApplication.shared.open(storeURL)
    }
}

private extension UIViewController {
    func showFittedSheets(
        content: UIViewController,
        size: BottomSheetSize,
        dismissOnOverlayTapAndPull: Bool
    ) {
        var toSize: SheetSize = .intrinsic
        switch size {
        case .intrinsic:
            toSize = SheetSize.intrinsic
        case let .fixed(value):
            toSize = SheetSize.fixed(value)
        }

        let options = SheetOptions(
            // The full height of the pull bar.
            // The presented view controller will treat this area as a safearea inset on the top
            pullBarHeight: 0,

            // The corner radius of the shrunken presenting view controller
            presentingViewCornerRadius: 24,

            // Extends the background behind the pull bar or not
            shouldExtendBackground: true,

            // Attempts to use intrinsic heights on navigation controllers.
            // This does not work well in combination with keyboards without your code handling it.
            setIntrinsicHeightOnNavigationControllers: true,

            // Pulls the view controller behind the safe area top,
            // especially useful when embedding navigation controllers
            useFullScreenMode: true,

            // Shrinks the presenting view controller, similar to the native modal
            shrinkPresentingViewController: false,

            // Determines if using inline mode or not
            useInlineMode: false,

            // Adds a padding on the left and right of the sheet with this amount. Defaults to zero (no padding)
            horizontalPadding: 0,

            // Sets the maximum width allowed for the sheet. This defaults to nil and doesn't limit the width.
            maxWidth: nil
        )

        let sheetController = SheetViewController(
            controller: content,
            sizes: [toSize],
            options: options
        )

        // The size of the grip in the pull bar
        sheetController.gripSize = .zero

        // The color of the grip on the pull bar
        sheetController.gripColor = UIColor.clear

        // The corner radius of the sheet
        sheetController.cornerRadius = 24

        // minimum distance above the pull bar, prevents bar from coming right up to the edge of the screen
        sheetController.minimumSpaceAbovePullBar = 0

        // Set the pullbar's background explicitly
        sheetController.pullBarBackgroundColor = UIColor.clear

        // Determine if the rounding should happen on the pullbar or the presented controller only
        // (should only be true when the pull bar's background color is .clear)
        sheetController.treatPullBarAsClear = false

        // Disable the dismiss on background tap functionality
        sheetController.dismissOnOverlayTap = dismissOnOverlayTapAndPull

        // Disable the ability to pull down to dismiss the modal
        sheetController.dismissOnPull = dismissOnOverlayTapAndPull

        // Allow pulling past the maximum height and bounce back. Defaults to true.
        sheetController.allowPullingPastMaxHeight = false

        // Automatically grow/move the sheet to accomidate the keyboard. Defaults to true.
        sheetController.autoAdjustToKeyboard = true

        // Color of the sheet anywhere the child view controller may not show (or is transparent),
        // such as behind the keyboard currently
        sheetController.contentBackgroundColor = UIColor.clear

        // Change the overlay color
        sheetController.overlayColor = UIColor.black.withAlphaComponent(0.4)

        self.present(sheetController, animated: true, completion: nil)
    }
}
