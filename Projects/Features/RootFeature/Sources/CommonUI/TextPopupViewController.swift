//
//  TextPopupViewController.swift
//  RootFeatureTests
//
//  Created by KTH on 2023/01/02.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import PanModal

class TextPopupViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!

    var contentString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    public static func viewController(text: String = "") -> TextPopupViewController {
        let viewController = TextPopupViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        viewController.contentString = text
        return viewController
    }
}

extension TextPopupViewController {

    private func configureUI() {

        cancelButton.layer.cornerRadius = 12
        cancelButton.clipsToBounds = true

        confirmButton.layer.cornerRadius = cancelButton.layer.cornerRadius
        confirmButton.clipsToBounds = true
    }
}

extension TextPopupViewController: PanModalPresentable {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var panModalBackgroundColor: UIColor {
        return colorFromRGB(0x000000, alpha: 0.4)
    }

    var panScrollable: UIScrollView? {
      return nil
    }

     var longFormHeight: PanModalHeight {
         let stringHeight: CGFloat = contentString.heightConstraintAt(width: APP_WIDTH()-40,
                                                                      font: .systemFont(ofSize: 18, weight: .medium))
         return .contentHeight(60 + stringHeight + 52 + 56 + 20)
     }

    var cornerRadius: CGFloat {
        return 24.0
    }

    var allowsExtendedPanScrolling: Bool {
        return true
    }

    var showDragIndicator: Bool {
        return false
    }
}
