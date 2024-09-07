//
//  Extension+NSAttributedString.swift
//  Utility
//
//  Created by KTH on 2023/02/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit

public extension NSAttributedString {
    func height(containerWidth: CGFloat) -> CGFloat {
        let rect = self.boundingRect(
            with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        return ceil(rect.size.height)
    }

    func width(containerHeight: CGFloat) -> CGFloat {
        let rect = self.boundingRect(
            with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: containerHeight),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        return ceil(rect.size.width)
    }
}
