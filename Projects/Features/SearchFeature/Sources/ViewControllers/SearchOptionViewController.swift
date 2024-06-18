import BaseFeature
import SearchDomainInterface
import SnapKit
import Then
import UIKit
import Utility

protocol SearchOptionViewControllerDelegate: AnyObject {
    func tap(_ option: SortType)
}

final class SearchOptionViewController: BaseViewController {
    weak var delegate: SearchOptionViewControllerDelegate?

    private let options: [SortType] = [.latest, .oldest, .alphabetical]

    private var selectedModel: SortType

    private lazy var dataSource: UITableViewDiffableDataSource<Int, SortType> =
        createDataSource()

    private lazy var tableView: UITableView = UITableView().then {
        $0.register(SearchOptionCell.self, forCellReuseIdentifier: SearchOptionCell.identifer)
        $0.separatorStyle = .none
    }

    init(selectedModel: SortType) {
        self.selectedModel = selectedModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setLayout()
        configureUI()
        initSnapShot()
    }
}

extension SearchOptionViewController {
    private func addSubviews() {
        self.view.addSubviews(tableView)
    }

    private func setLayout() {
        self.tableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    private func configureUI() {
        self.view.backgroundColor = .white
        self.tableView.backgroundColor = .white
        self.tableView.delegate = self
    }

    private func createDataSource() -> UITableViewDiffableDataSource<Int, SortType> {
        return UITableViewDiffableDataSource(tableView: tableView) { [
            weak self
        ] tableView, indexPath, _ -> UITableViewCell in
            guard let self, let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchOptionCell.identifer,
                for: indexPath
            ) as? SearchOptionCell else {
                return UITableViewCell()
            }
            cell.update(self.options[indexPath.row], self.selectedModel)
            cell.selectionStyle = .none
            return cell
        }
    }

    private func initSnapShot() {
        tableView.dataSource = dataSource

        var snapShot = NSDiffableDataSourceSnapshot<Int, SortType>()

        snapShot.appendSections([0])

        snapShot.appendItems(options, toSection: 0)

        dataSource.apply(snapShot)
    }
}

extension SearchOptionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = options[indexPath.row]

        delegate?.tap(option)
        #warning("dismiss")
    }
}
