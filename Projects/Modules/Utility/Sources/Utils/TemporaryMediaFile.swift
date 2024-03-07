//
//  TemporaryMediaFile.swift
//  Utility
//
//  Created by KTH on 2023/05/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AVFoundation
import Foundation

public class TemporaryMediaFile {
    public var url: URL?

    public init(withData: Data) {
        let directory = FileManager.default.temporaryDirectory
        let fileName = "\(UUID().uuidString)_\(Date().dateToString(format: "yyMMddHHmmss")).mov"
        let url = directory.appendingPathComponent(fileName)
        do {
            try withData.write(to: url)
            self.url = url
        } catch {
            DEBUG_LOG("Error creating temporary file: \(error)")
        }
    }

    public var avAsset: AVAsset? {
        if let url = self.url {
            return AVAsset(url: url)
        }
        return nil
    }

    public func deleteFile() {
        if let url = self.url {
            do {
                try FileManager.default.removeItem(at: url)
                self.url = nil
            } catch {
                DEBUG_LOG("Error deleting temporary file: \(error)")
            }
        }
    }

    deinit {
        self.deleteFile()
    }
}
