import DesignSystem
import Foundation
import UIKit
import Utility

public protocol PlaylistEditSheetViewType: AnyObject {
    var playlisteditSheetView: PlaylistEditSheetView! { get set }
    var bottomSheetView: BottomSheetView! { get set }
}

public enum PlaylistEditType {
    case edit
    case share
}

public extension PlaylistEditSheetViewType where Self: UIViewController {
    /// 편집하기 팝업을 띄웁니다.
    /// - Parameter view: 팝업을 붙일 대상이 되는 뷰 (ex: 아티스트 노래 리스트, viewController.view)
    /// - Parameter type: 위에 EditSheetType 참조
    /// - Parameter contentHeight: (변경할 일 있으면 사용)
    func showplaylistEditSheet(
        in view: UIView,
        contentHeight: CGFloat = 56
    ) {
        if self.playlisteditSheetView == nil || self.bottomSheetView == nil {
            self.playlisteditSheetView = PlaylistEditSheetView()
            self.bottomSheetView = BottomSheetView(
                contentView: self.playlisteditSheetView,
                contentHeights: [contentHeight]
            )
        }

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
    func hideplaylistEditSheet() {
        guard
            let bottomSheetView = self.bottomSheetView
        else { return }
        bottomSheetView.dismiss()

        // nil 할당으로 메모리에서 제거
        self.playlisteditSheetView = nil
        self.bottomSheetView = nil

        // 메인 컨테이너 뷰컨에서 해당 노티를 수신, 팝업이 올라오면 미니 플레이어를 다시 보여줍니다.
        NotificationCenter.default.post(name: .shouldShowPlaylistFloatingButton, object: nil)
    }
}
