import Foundation

public enum SettingItemType {
    case navigate(_ identifier: SettingItemIdentifier)
    case description(_ identifier: SettingItemIdentifier)
}
