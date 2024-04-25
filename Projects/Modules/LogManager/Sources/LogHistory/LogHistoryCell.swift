#if DEBUG
    import UIKit

    final class LogHistoryCell: UITableViewCell {
        static let reuseIdentifier = String(describing: LogHistoryCell.self)

        private let logStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 8
            stackView.alignment = .leading
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()

        private let logTitleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 20)
            label.numberOfLines = 0
            return label
        }()

        private let logParametersLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 16)
            label.textColor = .gray
            label.numberOfLines = 0
            return label
        }()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            addView()
            setLayout()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func configure(log: any AnalyticsLogType) {
            logTitleLabel.text = log.name
            logParametersLabel.text = log.params
                .filter { !($0.key == "date" || $0.key == "timestamp") }
                .map { "- \($0) : \($1)" }
                .joined(separator: "\n")
        }
    }

    private extension LogHistoryCell {
        func addView() {
            contentView.addSubview(logStackView)
            logStackView.addArrangedSubview(logTitleLabel)
            logStackView.addArrangedSubview(logParametersLabel)
        }

        func setLayout() {
            NSLayoutConstraint.activate([
                logStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                logStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                logStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                logStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ])
        }
    }

#endif
