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

public class NewPlayerViewController: UIViewController {
    private var titleBarView: UIView = UIView()
    
    private var closeButton: UIButton {
        let button = UIButton()
        button.setImage(DesignSystemAsset.Navigation.close.image, for: .normal)
        button.tintColor = .systemGray
        return button
    }
    
    private var titleLabel: UILabel {
        let label = UILabel()
        label.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 16)
        label.textColor = DesignSystemAsset.GrayColor.gray900.color
        label.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.26)
        label.text = "리와인드(RE:WIND)"
        return label
    }
    
    private var artistLabel: UILabel {
        let label = UILabel()
        label.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 14)
        label.textColor = DesignSystemAsset.GrayColor.gray900.color
        label.alpha = 0.6
        label.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.2)
        label.text = "이세계아이돌"
        return label
    }
    
    private var thumbnailImageView: UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: DesignSystemAsset.Player.dummyThumbnailLarge.name)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private var lyricsTableView: UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(LyricsTableViewCell.self, forCellReuseIdentifier: LyricsTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 24
        return tableView
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
    
    private var lyricsLabel: UILabel {
        let label = UILabel()
        label.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 14)
        label.textColor = DesignSystemAsset.GrayColor.gray500.color
        label.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.44)
        label.text = "기억나 우리 처음 만난 날"
        return label
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
