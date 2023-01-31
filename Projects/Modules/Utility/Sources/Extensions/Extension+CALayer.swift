//
//  Extension+CALayer.swift
//  Utility
//
//  Created by yongbeomkwak on 2023/01/30.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit


public extension CALayer {
    ///  해당 layer의 원하는 방향에 borderColor와 width를 부여한다
    /// - Parameter arr_edge: bodrer가 들어갈 방향
    /// - Parameter color: 적용할 색상
    /// - Parameter width: border 두께
    /*
    UIRectEdge.all, //전체
    UIRectEdge.top, //상단
    UIRectEdge.bottom, //하단
    UIRectEdge.left, //왼쪽
    UIRectEdge.right, //오른쪽
    */

    func addBorder(_ edges: [UIRectEdge], color: UIColor, height: CGFloat) {
        for edge in edges {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: height)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - height, width: frame.width, height: height)
            
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: height, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - height, y: 0, width: height, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
