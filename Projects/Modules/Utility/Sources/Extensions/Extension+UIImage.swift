import Foundation
import UIKit

public extension UIImage {
    func customizeForPlaylistCover(targetSize: CGSize) -> UIImage? {
        let imageWidth = self.size.width
        let imageHeight = self.size.height

        guard imageWidth != imageHeight else {
            guard imageWidth > targetSize.width else {
                return self
            }
            return performResize(targetSize: targetSize)
        }

        guard let cropImage = performSquareCrop() else {
            return nil
        }

        guard cropImage.size.width > targetSize.width else {
            return cropImage
        }

        return cropImage.performResize(targetSize: targetSize)
    }

    func performSquareCrop() -> UIImage? {
        let imageWidth = self.size.width
        let imageHeight = self.size.height

        guard imageWidth != imageHeight else {
            return self
        }

        let minLength = min(imageWidth, imageHeight)
        let cropSize = CGSize(width: minLength, height: minLength)

        let x = (imageWidth - cropSize.width) / 2
        let y = (imageHeight - cropSize.height) / 2
        let cropRect = CGRect(x: x, y: y, width: cropSize.width, height: cropSize.height)

        guard let cropCgImage = self.cgImage?.cropping(to: cropRect) else {
            return nil
        }

        return UIImage(cgImage: cropCgImage)
    }

    func performResize(targetSize: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: targetSize)

        guard let cgImage = self.cgImage else { return nil }
        let image = UIImage(cgImage: cgImage, scale: 0, orientation: self.imageOrientation)

        let foramt = UIGraphicsImageRendererFormat.default()
        foramt.scale = 1.0

        let render = UIGraphicsImageRenderer(size: targetSize, format: foramt)

        let newImage = render.image { _ in
            image.draw(in: rect)
        }

        return newImage
    }
}
