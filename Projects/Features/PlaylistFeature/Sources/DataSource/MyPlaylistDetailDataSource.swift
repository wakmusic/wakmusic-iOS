import SongsDomainInterface
import UIKit

final class MyPlaylistDetailDataSource: UITableViewDiffableDataSource<Int, PlaylistItemModel> {
    private let reactor: MyPlaylistDetailReactor

    init(
        reactor: MyPlaylistDetailReactor,
        tableView: UITableView,
        cellProvider: @escaping UITableViewDiffableDataSource<Int, PlaylistItemModel>.CellProvider
    ) {
        self.reactor = reactor
        super.init(tableView: tableView, cellProvider: cellProvider)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }

    override func tableView(
        _ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        guard let sourceIdentifier = itemIdentifier(for: sourceIndexPath) else { return }
        guard sourceIndexPath != destinationIndexPath else { return }
        let destinationIdentifier = itemIdentifier(for: destinationIndexPath)

        #warning("updateDataSource에서 apply해주는데 왜 여기서도 해줘야하지 ?? 질문하기")
        var snapshot = self.snapshot()

        // 같은 섹션으로 이동
        if let destinationIdentifier = destinationIdentifier {
            if let sourceIndex = snapshot.indexOfItem(sourceIdentifier),
               let destinationIndex = snapshot.indexOfItem(destinationIdentifier) {
                let isAfter = destinationIndex > sourceIndex &&
                    snapshot.sectionIdentifier(containingItem: sourceIdentifier) ==
                    snapshot.sectionIdentifier(containingItem: destinationIdentifier)
                snapshot.deleteItems([sourceIdentifier])
                if isAfter {
                    snapshot.insertItems([sourceIdentifier], afterItem: destinationIdentifier)
                } else {
                    snapshot.insertItems([sourceIdentifier], beforeItem: destinationIdentifier)
                }
            }
        } else {
            // 다른 섹션으로 이동
            let destinationSectionIdentifier = snapshot.sectionIdentifiers[destinationIndexPath.section]
            snapshot.deleteItems([sourceIdentifier])
            snapshot.appendItems([sourceIdentifier], toSection: destinationSectionIdentifier)
        }
        apply(snapshot, animatingDifferences: false)

        reactor.action.onNext(.itemDidMoved(sourceIndexPath.row, destinationIndexPath.row))
    }
}
