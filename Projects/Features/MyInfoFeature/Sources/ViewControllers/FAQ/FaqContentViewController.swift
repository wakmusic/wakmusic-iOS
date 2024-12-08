import BaseFeature
import LogManager
import RxCocoa
import RxRelay
import RxSwift
import UIKit
import Utility

public final class FaqContentViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var tableView: UITableView!

  var viewModel: FAQContentViewModel!

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil // 스와이프로 뒤로가기
    }

    public static func viewController(viewModel: FAQContentViewModel) -> FaqContentViewController {
        let viewController = FaqContentViewController.viewController(storyBoardName: "Faq", bundle: Bundle.module)
        viewController.viewModel = viewModel
        return viewController
    }
}

extension FaqContentViewController {
    private func configureUI() {
        tableView.dataSource = self
        tableView.delegate = self
        let space = APP_HEIGHT() - 106 - STATUS_BAR_HEGHIT() - SAFEAREA_BOTTOM_HEIGHT()
        let height = space / 3 * 2
        let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: height))
        warningView.text = "자주 묻는 질문이 없습니다."
        tableView.tableFooterView = viewModel.dataSource.isEmpty ? warningView : UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: APP_WIDTH(),
            height: PLAYER_HEIGHT()
        ))
        tableView.reloadData()
    }

    private func scrollToBottom(indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
}

extension FaqContentViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSource.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = viewModel.dataSource[section]
        var count: Int = 0

        if data.isOpen {
            count = 2
        } else {
            count = 1
        }
        return count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let questionCell = tableView
            .dequeueReusableCell(withIdentifier: "FAQQuestionTableViewCell", for: indexPath) as? FAQQuestionTableViewCell
        else {
            return UITableViewCell()
        }
        guard let answerCell = tableView
            .dequeueReusableCell(withIdentifier: "FAQAnswerTableViewCell", for: indexPath) as? FAQAnswerTableViewCell else {
            return UITableViewCell()
        }

        var data = viewModel.dataSource

        questionCell.update(model: data[indexPath.section])
        questionCell.selectionStyle = .none // 선택 시 깜빡임 방지
        answerCell.update(model: data[indexPath.section])
        answerCell.selectionStyle = .none

        // 왜 Row는  인덱스 개념이다 0 부터 시작??
        if indexPath.row == 0 {
            return questionCell
        } else {
            return answerCell
        }
    }
}

extension FaqContentViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        var data = viewModel.dataSource

        data[indexPath.section].isOpen = !data[indexPath.section].isOpen

        viewModel.dataSource = data

        tableView.reloadSections([indexPath.section], with: .none)

        let next = IndexPath(row: 1, section: indexPath.section) // row 1이 답변 쪽

        if data[indexPath.section].isOpen {
            self.scrollToBottom(indexPath: next)
            let title = data[indexPath.section].question
            LogManager.analytics(FAQAnalyticsLog.clickFaqItem(title: title))
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
