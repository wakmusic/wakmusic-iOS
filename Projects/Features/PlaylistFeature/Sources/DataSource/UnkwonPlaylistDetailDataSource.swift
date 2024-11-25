@preconcurrency import SongsDomainInterface
import UIKit

final class UnknownPlaylistDetailDataSource: UITableViewDiffableDataSource<Int, SongEntity> {
    override init(
        tableView: UITableView,
        cellProvider: @escaping UITableViewDiffableDataSource<Int, SongEntity>.CellProvider
    ) {
        super.init(tableView: tableView, cellProvider: cellProvider)
    }
}
