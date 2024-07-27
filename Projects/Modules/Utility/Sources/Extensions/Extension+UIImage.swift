import Foundation
import UIKit

public extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage? {
        let imageWidth = self.size.width
        let imageHeight = self.size.height

        guard imageWidth != imageHeight else {
            guard imageWidth > targetSize.width else {
                return self
            }
            return self.performResize(targetSize: targetSize)
        }

        let minLength = min(imageWidth, imageHeight)
        let cropSize = CGSize(width: minLength, height: minLength)

        let x = (imageWidth - cropSize.width) / 2
        let y = (imageHeight - cropSize.height) / 2
        let cropRect = CGRect(x: x, y: y, width: cropSize.width, height: cropSize.height)

        guard let cropCgImage = self.cgImage?.cropping(to: cropRect) else {
            return nil
        }

        guard cropRect.width > targetSize.width else {
            return UIImage(cgImage: cropCgImage)
        }

        return UIImage(cgImage: cropCgImage).performResize(targetSize: targetSize)
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
