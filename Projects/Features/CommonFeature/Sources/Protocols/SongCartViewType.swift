//
//  SongCartViewType.swift
//  Utility
//
//  Created by KTH on 2023/03/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit
import Utility
import DesignSystem

public protocol SongCartViewType: AnyObject {
    var songCartView: SongCartView! { get set }
    var bottomSheetView: BottomSheetView! { get set }
}

public extension SongCartViewType where Self: UIViewController {
    func showSongCart(
        in view: UIView,
        contentHeight: CGFloat = 52,
        backgroundColor: UIColor = UIColor.clear,
        selectedSongCount: Int,
        dataSourceCount: Int
    ) {
        if self.songCartView == nil, self.bottomSheetView == nil {
            self.songCartView = SongCartView()
            self.bottomSheetView = BottomSheetView(
                contentView: self.songCartView,
                contentHeights: [contentHeight]
            )
        }
        self.songCartView?.updateCount(value: selectedSongCount)
        self.songCartView?.updateAllSelect(isAll: selectedSongCount == dataSourceCount)

        guard !view.subviews.contains(self.bottomSheetView) else { return }
        self.bottomSheetView?.present(in: view)
        NotificationCenter.default.post(name: .showSongCart, object: nil)
    }

    func hideSongCart() {
        self.bottomSheetView?.dismiss()
        self.songCartView = nil
        self.bottomSheetView = nil 
        NotificationCenter.default.post(name: .hideSongCart, object: nil)
    }
}
