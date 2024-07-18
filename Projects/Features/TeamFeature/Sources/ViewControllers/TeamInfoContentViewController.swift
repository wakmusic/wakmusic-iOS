import DesignSystem
import Foundation
import LogManager
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

final class TeamInfoContentViewController: UIViewController {
    private let tableView = UITableView().then {
        $0.register(TeamInfoSectionCell.self, forCellReuseIdentifier: "\(TeamInfoSectionCell.self)")
        $0.register(TeamInfoListCell.self, forCellReuseIdentifier: "\(TeamInfoListCell.self)")
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.sectionHeaderTopPadding = 0
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("\(Self.self) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setLayout()
        configureUI()
    }
}

private extension TeamInfoContentViewController {
    func addSubviews() {
        view.addSubviews(tableView)
    }

    func setLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(104)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }

    func configureUI() {
    }
}
