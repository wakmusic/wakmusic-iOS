//
//  SongCartViewType.swift
//  Utility
//
//  Created by KTH on 2023/03/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import Foundation
import UIKit
import Utility

// SongCartViewType 어떻게든 해결해야함..
public protocol SongCartViewType: AnyObject {
    var songCartView: SongCartView! { get set }
    var bottomSheetView: BottomSheetView! { get set }
}

/// 각 (담당자)는 넣어서 호출 하세요.
public enum SongCartType {
    case playlist // 플레이어 > 재생목록 (케이)
    case chartSong // 차트 (대희)
    case searchSong // 검색 (함프)
    case artistSong // 아티스트 (구구)
    case likeSong // 보관함 > 좋아요 (함프)
    case playlistStorage // 보관함 > 내 리스트 (함프)
    case myPlaylist // 보관함 > 플레이 리스트 상세 (함프)
    case WMPlaylist // 추천 플레이 리스트 상세 (함프)
    case creditSong // 크레딧 작업자 노래 리스트 (백튼)
}

@MainActor
public extension SongCartViewType where Self: UIViewController {
    /// 노래 담기 팝업을 띄웁니다.
    /// - Parameter view: 팝업을 붙일 대상이 되는 뷰 (ex: 아티스트 노래 리스트, viewController.view)
    /// - Parameter type: 위에 SongCartType 참조
    /// - Parameter contentHeight: (변경할 일 있으면 사용)
    /// - Parameter backgroundColor: 백그라운드 컬러 (변경할 일 있으면 사용)
    /// - Parameter selectedSongCount: 현재 선택된 노래 갯수
    /// - Parameter totalSongCount: 전체 노래 갯수
    /// - Parameter useBottomSpace: 하단의 간격 사용 여부
    func showSongCart(
        in view: UIView,
        type: SongCartType,
        contentHeight: CGFloat = 56,
        backgroundColor: UIColor = UIColor.clear,
        selectedSongCount: Int,
        totalSongCount: Int,
        useBottomSpace: Bool
    ) {
        if self.songCartView == nil || self.bottomSheetView == nil {
            self.songCartView = SongCartView(type: type)
            self.bottomSheetView = BottomSheetView(
                contentView: self.songCartView,
                contentHeights: [contentHeight + (useBottomSpace ? SAFEAREA_BOTTOM_HEIGHT() : 0)]
            )
        }

        guard
            let songCartView = self.songCartView,
            let bottomSheetView = self.bottomSheetView
        else { return }

        // 하단 마진 사용 여부 업데이트
        songCartView.updateBottomSpace(isUse: useBottomSpace)

        // 선택된 노래 갯수 업데이트
        songCartView.updateCount(value: selectedSongCount)

        // 선택된 노래 갯수와 전체 노래 갯수를 비교하여 전체선택이 되었는지 비교하여 덥데이트
        songCartView.updateAllSelect(isAll: selectedSongCount == totalSongCount)

        // bottomSheetView가 해당 뷰에 붙지 않았을때만 present 합니다.
        guard
            !view.subviews.contains(self.bottomSheetView)
        else { return }

        bottomSheetView.present(in: view)

        // 메인 컨테이너 뷰컨에서 해당 노티를 수신, 팝업이 올라오면 미니 플레이어를 숨깁니다.
        NotificationCenter.default.post(name: .shouldHidePlaylistFloatingButton, object: nil)
    }

    /// 노래 담기 팝업을 제거합니다.
    func hideSongCart() {
        guard
            let bottomSheetView = self.bottomSheetView
        else { return }
        bottomSheetView.dismiss()

        // nil 할당으로 메모리에서 제거
        self.songCartView = nil
        self.bottomSheetView = nil

        // 메인 컨테이너 뷰컨에서 해당 노티를 수신, 팝업이 올라오면 미니 플레이어를 다시 보여줍니다.
        NotificationCenter.default.post(name: .shouldShowPlaylistFloatingButton, object: nil)
    }
}
