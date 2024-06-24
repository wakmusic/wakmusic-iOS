import SongsDomainInterface
import UIKit

final class MyplaylistDetailDataSource: UITableViewDiffableDataSource<Int, SongEntity> {
    
    private let reactor: MyPlaylistDetailReactor
    
    init(reactor: MyPlaylistDetailReactor, tableView: UITableView, cellProvider: @escaping UITableViewDiffableDataSource<Int, SongEntity>.CellProvider) {
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
        var snapshot = self.snapshot()
        
        reactor.action.onNext(.itemDidMoved(sourceIndexPath.row, destinationIndexPath.row))

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
        
        print(snapshot.itemIdentifiers.map(\.title))
        apply(snapshot, animatingDifferences: false)
    }
}
