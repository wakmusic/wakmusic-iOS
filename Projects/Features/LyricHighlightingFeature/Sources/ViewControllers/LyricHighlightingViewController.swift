//
//  LyricHighlightingViewController.swift
//  LyricHighlightingFeature
//
//  Created by KTH on 6/1/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import LogManager
import UIKit

class LyricHighlightingViewController: UIViewController {

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(Self.self) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
