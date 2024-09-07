#if DEBUG || QA
    import UIKit

    public final class LogHistoryViewController: UIViewController {
        private let logHistoryTableView: UITableView = {
            let tableView = UITableView()
            tableView.separatorInset = .init(top: 8, left: 0, bottom: 8, right: 0)
            tableView.register(LogHistoryCell.self, forCellReuseIdentifier: LogHistoryCell.reuseIdentifier)
            return tableView
        }()

        private lazy var logHistoryTableViewDiffableDataSource = UITableViewDiffableDataSource<
            Int,
            LogHistorySectionItem
        >(
            tableView: logHistoryTableView
        ) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: LogHistoryCell.reuseIdentifier,
                for: indexPath
            ) as? LogHistoryCell
            else {
                return UITableViewCell()
            }
            cell.configure(log: itemIdentifier.log)
            return cell
        }

        public init() {
            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override public func viewDidLoad() {
            super.viewDidLoad()
            addView()
            setLayout()
            view.backgroundColor = .white

            let logs = LogHistoryStorage.shared.logHistory
                .enumerated()
                .map { LogHistorySectionItem(index: $0.offset, log: $0.element) }

            var snapshot = logHistoryTableViewDiffableDataSource.snapshot()
            snapshot.appendSections([0])
            snapshot.appendItems(logs, toSection: 0)

            logHistoryTableViewDiffableDataSource.apply(snapshot, animatingDifferences: true)

            navigationItem.title = "애널리틱스 히스토리"
        }
    }

    private extension LogHistoryViewController {
        func addView() {
            view.addSubview(logHistoryTableView)
            logHistoryTableView.translatesAutoresizingMaskIntoConstraints = false
        }

        func setLayout() {
            NSLayoutConstraint.activate([
                logHistoryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                logHistoryTableView.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: 16
                ),
                logHistoryTableView.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -16
                ),
                logHistoryTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
            ])
        }
    }

#endif
