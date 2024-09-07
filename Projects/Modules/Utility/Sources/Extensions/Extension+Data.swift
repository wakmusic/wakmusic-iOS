//
//  Extension+Data.swift
//  Utility
//
//  Created by KTH on 2023/05/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

public extension Data {
    func extractThumbnail() -> UIImage? {
        let tempFile = TemporaryMediaFile(withData: self)
        guard let asset = tempFile.avAsset else {
            tempFile.deleteFile()
            return nil
        }

        // AVAssetImageGenerator 생성
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        // 썸네일 생성을 위한 시간 설정 (ex. 1초)
        let time = CMTimeMake(value: 1, timescale: 1)

        // 썸네일 이미지 생성
        guard let cgImage = try? imageGenerator.copyCGImage(at: time, actualTime: nil) else {
            tempFile.deleteFile()
            return nil
        }
        let thumbnail = UIImage(cgImage: cgImage)
        tempFile.deleteFile()
        return thumbnail
    }
}
