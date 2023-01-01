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
    var cancelButtonIsHidden: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    public static func viewController(text: String = "", cancelButtonIsHidden: Bool) -> TextPopupViewController {
        let viewController = TextPopupViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        viewController.contentString = text
        viewController.cancelButtonIsHidden = cancelButtonIsHidden
        return viewController
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func confirmButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension TextPopupViewController {

    private func configureUI() {

        cancelButton.layer.cornerRadius = 12
        cancelButton.clipsToBounds = true

        confirmButton.layer.cornerRadius = cancelButton.layer.cornerRadius
        confirmButton.clipsToBounds = true

        cancelButton.isHidden = cancelButtonIsHidden
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
         let spacingHeight: CGFloat = 60 + 52 + 56 + 20
         return .contentHeight(spacingHeight + stringHeight)
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
