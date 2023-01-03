//
//  Extension+UIImage.swift
//  Utility
//
//  Created by KTH on 2023/01/02.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {

    /// 메인 탭바의 상단에 들어갈 라인을 이미지로 그리고 반환합니다.
    /// - Parameter color: 컬러 값
    /// - Returns: 라인 이미지
    static func tabBarTopLine(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: APP_WIDTH(), height: 1.0)

        // 화면에 바로 나타나지 않는 offscreen 이미지를 생성하고 싶을 때는 반드시 bitmap image context를 생성해야 한다.
        // https://soulpark.wordpress.com/tag/uigraphicsbeginimagecontext

        // 그림을 그리기 위한 콘텍스트 생성
        UIGraphicsBeginImageContext(rect.size)

        // context: 코어 이미지의 모든 과정은 CIContext내에서 수행합니다.
        // 렌더링 과정과 렌더링에 필요한 리소스를 더 정밀하게 컨트롤 할수 있게 해주는 객체
        // 생성된 콘텍스트 정보 획득
        guard let context = UIGraphicsGetCurrentContext() else { return Self() }

        // 채우기 색상 설정
        context.setFillColor(color.cgColor)

        // 사각형 채우기
        context.fill(rect)

        // 현재 콘텍스트에 그려진 이미지를 가져옵니다.
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return Self() }

        // 그림 그리기 종료
        UIGraphicsEndImageContext()

        return image
    }
}
