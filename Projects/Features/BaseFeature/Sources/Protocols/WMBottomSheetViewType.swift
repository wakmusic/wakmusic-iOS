import DesignSystem
import Foundation
import UIKit
import Utility

public protocol WMBottomSheetViewType: AnyObject {
    var bottomSheetView: BottomSheetView! { get set }
}

public extension WMBottomSheetViewType where Self: UIViewController {
    /// 편집하기 팝업을 띄웁니다.
    /// - Parameter view: 팝업을 붙일 대상이 되는 뷰
    /// - Parameter size: 높이 값 (변경할 일 있으면 사용)
    func showWMBottomSheet(
        in view: UIView,
        with items: [UIButton],
        size: CGFloat = 56
    ) {
        if self.bottomSheetView != nil {
            hideWMBottomSheet(postNoti: false)
        }
        let wmBottomSheetView = WMBottomSheetView(items: items)
        bottomSheetView = BottomSheetView(
            contentView: wmBottomSheetView,
            contentHeights: [size]
        )

        guard
            let bottomSheetView = self.bottomSheetView
        else { return }

        // bottomSheetView가 해당 뷰에 붙지 않았을때만 present 합니다.
        guard
            !view.subviews.contains(self.bottomSheetView)
        else { return }

        bottomSheetView.present(in: view)

        // 메인 컨테이너 뷰컨에서 해당 노티를 수신, 팝업이 올라오면 미니 플레이어를 숨깁니다.
        NotificationCenter.default.post(name: .shouldHidePlaylistFloatingButton, object: nil)
    }

    /// 편집하기 팝업을 제거합니다.
    func hideWMBottomSheet(postNoti: Bool = true) {
        guard
            let bottomSheetView = self.bottomSheetView
        else { return }
        bottomSheetView.dismiss()

        // nil 할당으로 메모리에서 제거
        self.bottomSheetView = nil

        // 메인 컨테이너 뷰컨에서 해당 노티를 수신, 팝업이 올라오면 미니 플레이어를 다시 보여줍니다.
        if postNoti {
            NotificationCenter.default.post(name: .shouldShowPlaylistFloatingButton, object: nil)
        }
    }
}
