import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

@MainActor
private protocol StorageStateProtocol {
    func updateIsHiddenEditButton(isHidden: Bool)
}

private protocol StorageActionProtocol {
    var editButtonDidTap: Observable<Void> { get }
    var saveButtonDidTap: Observable<Void> { get }
}

private enum ButtonAttributed {
    @MainActor
    static let edit = NSMutableAttributedString(
        string: "편집",
        attributes: [
            .font: DesignSystemFontFamily.Pretendard.bold.font(size: 12),
            .foregroundColor: DesignSystemAsset.BlueGrayColor.blueGray400.color
        ]
    )
    @MainActor
    static let save = NSMutableAttributedString(
        string: "완료",
        attributes: [
            .font: DesignSystemFontFamily.Pretendard.bold.font(size: 12),
            .foregroundColor: DesignSystemAsset.PrimaryColor.point.color
        ]
    )
}

final class StorageView: UIView {
    public let tabBarView = UIView()

    public let lineView = UIView()

    fileprivate let editButton = UIButton().then {
        $0.setTitle("편집", for: .normal)
    }

    fileprivate let saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
    }

    init() {
        super.init(frame: .zero)
        addView()
        setLayout()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addView() {
        self.addSubviews(
            tabBarView,
            editButton,
            saveButton
        )
        tabBarView.addSubview(lineView)
    }

    func setLayout() {
        tabBarView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().priority(999)
            $0.height.equalTo(36)
        }

        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }

        editButton.snp.makeConstraints {
            $0.width.equalTo(45)
            $0.height.equalTo(24)
            $0.bottom.equalTo(lineView.snp.top).offset(-8)
            $0.right.equalToSuperview().inset(20)
        }

        saveButton.snp.makeConstraints {
            $0.width.equalTo(45)
            $0.height.equalTo(24)
            $0.bottom.equalTo(lineView.snp.top).offset(-8)
            $0.right.equalToSuperview().inset(20)
        }
    }

    func configureUI() {
        backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color

        lineView.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray200.color

        editButton.layer.cornerRadius = 4
        editButton.layer.borderWidth = 1
        editButton.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color
        editButton.layer.borderColor = DesignSystemAsset.BlueGrayColor.blueGray300.color.cgColor
        editButton.setAttributedTitle(ButtonAttributed.edit, for: .normal)

        saveButton.isHidden = true
        saveButton.layer.cornerRadius = 4
        saveButton.layer.borderWidth = 1
        saveButton.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color
        saveButton.layer.borderColor = DesignSystemAsset.PrimaryColor.point.color.cgColor
        saveButton.setAttributedTitle(ButtonAttributed.save, for: .normal)
    }
}

extension StorageView: StorageStateProtocol {
    func updateIsHiddenEditButton(isHidden: Bool) {
        self.editButton.isHidden = isHidden
        self.saveButton.isHidden = !isHidden
    }
}

extension Reactive: StorageActionProtocol where Base: StorageView {
    var editButtonDidTap: Observable<Void> {
        base.editButton.rx.tap.asObservable()
    }

    var saveButtonDidTap: Observable<Void> {
        base.saveButton.rx.tap.asObservable()
    }
}
