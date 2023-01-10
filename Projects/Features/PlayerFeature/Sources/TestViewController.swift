//
//  TestViewController.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/01/09.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import SwiftUI
import Utility
import DesignSystem

public class TestViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let myFirstView = UIView()
        myFirstView.translatesAutoresizingMaskIntoConstraints = false
        myFirstView.backgroundColor = .systemPink
        self.view.addSubview(myFirstView)

        // x축, y축 위치
        myFirstView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        myFirstView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true

        // 뷰의 가로세로, 크기 제공
        myFirstView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        myFirstView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        myFirstView.layer.cornerRadius = 30
    }
}

struct TestViewController_Previews: PreviewProvider {
    static var previews: some View {
        TestViewController().toPreview()
    }
}
