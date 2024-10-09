//
//  PlaylistView.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/02/28.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import Foundation
import SnapKit
import Then
import UIKit
import Utility

public final class PlaylistView: UIView {
    private lazy var backgroundView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
    }

    private lazy var contentView = UIView()

    internal lazy var titleBarView = UIView()

    internal lazy var closeButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Navigation.close.image, for: .normal)
        $0.tintColor = .systemGray
    }

    internal lazy var titleCountStackView = UIStackView(arrangedSubviews: [titleLabel, countLabel]).then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 4
    }

    lazy var titleLabel = WMLabel(
        text: "재생목록",
        textColor: DesignSystemAsset.BlueGrayColor.gray900.color,
        font: .t5(weight: .medium),
        alignment: .center,
        lineHeight: UIFont.WMFontSystem.t5().lineHeight,
        kernValue: -0.5
    )

    lazy var countLabel = WMLabel(
        text: "재생목록",
        textColor: DesignSystemAsset.PrimaryColor.point.color,
        font: .t4(weight: .bold),
        alignment: .center,
        lineHeight: UIFont.WMFontSystem.t4().lineHeight,
        kernValue: -0.5
    )

    internal lazy var editButton = RectangleButton(type: .custom).then {
        $0.setBackgroundColor(.clear, for: .normal)
        $0.setColor(isHighlight: false)
        $0.setTitle("편집", for: .normal)
        $0.titleLabel?.font = .init(font: DesignSystemFontFamily.Pretendard.bold, size: 12)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
    }

    internal lazy var playlistTableView = UITableView().then {
        $0.register(PlaylistTableViewCell.self, forCellReuseIdentifier: PlaylistTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 60
        $0.estimatedRowHeight = 60
        $0.sectionHeaderTopPadding = 0
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color
        $0.showsVerticalScrollIndicator = true
        $0.allowsSelectionDuringEditing = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension PlaylistView {
    private func configureUI() {
        self.backgroundColor = .clear // 가장 뒷배경
        self.configureSubViews()
        self.configureBackground()
        self.configureContent()
        self.configureTitleBar()
        self.configurePlaylist()
    }

    private func configureSubViews() {
        self.addSubview(backgroundView)
        self.addSubview(contentView)
        contentView.addSubview(titleBarView)
        titleBarView.addSubview(closeButton)
        titleBarView.addSubview(titleCountStackView)
        titleBarView.addSubview(editButton)
        contentView.addSubview(playlistTableView)
    }

    private func configureBackground() {
        backgroundView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-SAFEAREA_BOTTOM_HEIGHT())
        }
    }

    private func configureContent() {
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Utility.STATUS_BAR_HEGHIT())
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }

    private func configureTitleBar() {
        titleBarView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(48)
        }

        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }

        titleCountStackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        editButton.snp.makeConstraints {
            $0.width.equalTo(45)
            $0.height.equalTo(24)
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }

    private func configurePlaylist() {
        playlistTableView.snp.makeConstraints {
            $0.top.equalTo(titleBarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension PlaylistView {
    func willShowSongCart(isShow: Bool) {
        let bottom: CGFloat = isShow ? 56 : 0
        playlistTableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
        playlistTableView.contentInset = .init(top: 0, left: 0, bottom: bottom, right: 0)
    }
}
