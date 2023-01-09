//
//  NewPlayerViewController.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/01/09.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import SwiftUI
import Utility
import DesignSystem
import SnapKit
import Then

public class NewPlayerViewController: UIViewController {
    private var titleBarView: UIView = UIView()
    
    private var closeButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Navigation.close.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    private var titleLabel = UILabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 16)
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.26)
        $0.text = "리와인드(RE:WIND)"
    }
    
    private var artistLabel = UILabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 14)
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.alpha = 0.6
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.2)
        $0.text = "이세계아이돌"
    }
    
    private var thumbnailImageView = UIImageView().then {
        $0.image = UIImage(named: DesignSystemAsset.Player.dummyThumbnailLarge.name)
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 12
    }
    
    private var lyricsTableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(LyricsTableViewCell.self, forCellReuseIdentifier: LyricsTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 24
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        bindUI()
    }
}

public extension NewPlayerViewController {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LyricsTableViewCell.identifier, for: indexPath)
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

private extension NewPlayerViewController {
    private func bindViewModel() {
    }
    
    private func bindUI() {
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(thumbnailImageView)
        thumbnailImageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
}

struct NewPlayerViewController_Previews: PreviewProvider {
    static var previews: some View {
        NewPlayerViewController().toPreview()
    }
}

class LyricsTableViewCell: UITableViewCell {
    static let identifier = "LyricsTableViewCell"
    
    private var lyricsLabel = UILabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 14)
        $0.textColor = DesignSystemAsset.GrayColor.gray500.color
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.44)
        $0.text = "기억나 우리 처음 만난 날"
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(self.lyricsLabel)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("")
    }
}

public extension UIViewController {

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
