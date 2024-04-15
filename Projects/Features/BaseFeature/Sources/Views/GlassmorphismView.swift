//
//  GlassmorphismView.swift
//  HomeFeature
//
//  Created by KTH on 2023/06/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit

@IBDesignable
public class GlassmorphismView: UIView {
    // MARK: - Properties
    private var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let backgroundView = UIView()
    override public var backgroundColor: UIColor? {
        get {
            return .clear
        }
        set {}
    }

    // MARK: - init/deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Public Method
    /// Customizes theme by changing base view's background color.
    /// .light and .dark is available.
    public func setTheme(theme: CHTheme) {
        switch theme {
        case .light:
            self.blurView.effect = nil
            self.blurView.effect = UIBlurEffect(style: .light)
            self.blurView.backgroundColor = UIColor.clear
        case .dark:
            self.blurView.effect = nil
            self.blurView.effect = UIBlurEffect(style: .dark)
            self.blurView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        }
    }

    /// Changes cornerRadius of the view.
    /// Default value is 20
    public func setCornerRadius(_ value: CGFloat) {
        self.backgroundView.layer.cornerRadius = value
        self.blurView.layer.cornerRadius = value
    }

    /// Change distance of the view.
    /// Value can be set between 0 ~ 100 (default: 20)
    /// - parameters:
    ///     - density:  value between 0 ~ 100 (default: 20)
    public func setDistance(_ value: CGFloat) {
        var distance = value
        if value < 0 {
            distance = 0
        } else if value > 100 {
            distance = 100
        }
        self.backgroundView.layer.shadowRadius = distance
    }

    // MARK: - Private Method
    private func initialize() {
        // backgoundView(baseView) setting
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(backgroundView, at: 0)
        backgroundView.layer.cornerRadius = 20
        backgroundView.clipsToBounds = true
        backgroundView.layer.masksToBounds = false
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundView.layer.shadowOpacity = 0.2
        backgroundView.layer.shadowRadius = 20.0

        // blurEffectView setting
        blurView.layer.masksToBounds = true
        blurView.layer.cornerRadius = 20
        blurView.backgroundColor = UIColor.clear
        blurView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.heightAnchor.constraint(equalTo: self.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: self.widthAnchor),
            blurView.topAnchor.constraint(equalTo: self.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurView.heightAnchor.constraint(equalTo: self.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }

    // MARK: - Theme
    public enum CHTheme {
        case light
        case dark
    }
}
