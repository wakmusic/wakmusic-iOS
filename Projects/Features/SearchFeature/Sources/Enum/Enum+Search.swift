
import Foundation
import RxDataSources
import SongsDomainInterface

public typealias SearchSectionModel = SectionModel<(TabPosition, Int), SongEntity>

public enum TabPosition: Int {
    case all = 0
    case song
    case artist
    case remix
}

public enum TypingStatus {
    case before
    case typing
    case search
}
