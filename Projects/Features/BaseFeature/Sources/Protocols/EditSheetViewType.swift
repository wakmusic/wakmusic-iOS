//
//  EditSheetViewType.swift
//  CommonFeature
//
//  Created by KTH on 2023/03/17.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import Foundation
import UIKit
import Utility

// 강제 mutable 타입 해결해야함... @preconcurrency
public protocol EditSheetViewType: AnyObject {
    var editSheetView: EditSheetView! { get set }
    var bottomSheetView: BottomSheetView! { get set }
}

public enum EditSheetType {
    case playList // 보관함 > 플레이리스트 편집
    case profile // 보관함 > 프로필 편집
}

@MainActor
public extension EditSheetViewType where Self: UIViewController {
    /// 편집하기 팝업을 띄웁니다.
    /// - Parameter view: 팝업을 붙일 대상이 되는 뷰 (ex: 아티스트 노래 리스트, viewController.view)
    /// - Parameter type: 위에 EditSheetType 참조
    /// - Parameter contentHeight: (변경할 일 있으면 사용)
    func showEditSheet(
        in view: UIView,
        type: EditSheetType,
        contentHeight: CGFloat = 56
    ) {
        if self.editSheetView == nil || self.bottomSheetView == nil {
            self.editSheetView = EditSheetView(type: type)
            self.bottomSheetView = BottomSheetView(
                contentView: self.editSheetView,
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
    func hideEditSheet() {
        guard
            let bottomSheetView = self.bottomSheetView
        else { return }
        bottomSheetView.dismiss()

        // nil 할당으로 메모리에서 제거
        self.editSheetView = nil
        self.bottomSheetView = nil

        // 메인 컨테이너 뷰컨에서 해당 노티를 수신, 팝업이 올라오면 미니 플레이어를 다시 보여줍니다.
        NotificationCenter.default.post(name: .shouldShowPlaylistFloatingButton, object: nil)
    }
}
