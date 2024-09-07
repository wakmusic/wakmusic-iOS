import AVFoundation
import Foundation
import Photos
import UIKit
import Utility

public enum RequestPermissionType {
    case photoLibrary
}

public protocol RequestPermissionable: AnyObject {
    func requestPhotoLibraryPermission()
    func showErrorMessage(type: RequestPermissionType)
    func showPhotoLibrary()
}

public extension RequestPermissionable where Self: UIViewController {
    func requestPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            self.showPhotoLibrary()
        case .denied, .restricted:
            self.showErrorMessage(type: .photoLibrary)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self.showPhotoLibrary()
                    }
                case .denied, .restricted:
                    self.showErrorMessage(type: .photoLibrary)
                default: return
                }
            }
        default: return
        }
    }

    func showErrorMessage(type: RequestPermissionType) {
        var message: String = ""
        switch type {
        case .photoLibrary:
            message = "[선택권한] 앨범 사진을 첨부하거나, 저장 하려면 권한 승인이 필요합니다."
        }

        DispatchQueue.main.async {
            let alertViewController = UIAlertController(
                title: "권한이 거부 됨",
                message: message,
                preferredStyle: UIAlertController.Style.alert
            )

            let okAction = UIAlertAction(title: "설정 바로가기", style: .default) { _ in
                guard let openSettingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(openSettingsURL)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            }

            alertViewController.addAction(okAction)
            alertViewController.addAction(cancelAction)
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
}
