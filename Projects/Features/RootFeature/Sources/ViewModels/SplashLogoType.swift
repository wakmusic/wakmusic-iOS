import UIKit

enum SplashLogoType: String {
    case usual = "Splash_Logo_Main"
    case halloween = "Splash_Logo_Halloween"
    case xmas = "Splash_Logo_Xmas"

    var icon: String? {
        switch self {
        case .usual:
            return nil
        case .halloween:
            return "HalloweenAppIcon"
        case .xmas:
            return "XmasAppIcon"
        }
    }
}

func changeAppIcon(_ type: SplashLogoType) {
    guard UIApplication.shared.alternateIconName != type.icon else {
        return
    }

    UIApplication.shared.setAlternateIconName(type.icon)
}
