import UIKit
import MyInfoFeatureInterface

class SettingItemDataSource: NSObject, UITableViewDataSource {
    private let nonLoginSettingItems: [SettingItemType] = [
        .navigate(.appPush),
        .navigate(.serviceTerms),
        .navigate(.privacy),
        .navigate(.openSource),
        .navigate(.removeCache),
        .description(.versionInfo)
    ]
    
    private let loginSettingItems: [SettingItemType] = [
        .navigate(.appPush),
        .navigate(.serviceTerms),
        .navigate(.privacy),
        .navigate(.openSource),
        .navigate(.removeCache),
        .navigate(.logout),
        .description(.versionInfo)
    ]
    
    private(set) var currentSettingItems: [SettingItemType]
    
    override init() {
        currentSettingItems = nonLoginSettingItems
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSettingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = currentSettingItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingItemTableViewCell.reuseIdentifier, for: indexPath) as! SettingItemTableViewCell
        cell.configure(type: item)
        return cell
    }
}

extension SettingItemDataSource {
    func updateCurrentSettingItems(isHidden: Bool) {
        currentSettingItems = isHidden ? nonLoginSettingItems : loginSettingItems
    }
}
