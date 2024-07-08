import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

private protocol StorageStateProtocol {
    func updateIsHiddenEditButton(isHidden: Bool)
    func updateIsHiddenLoginWarningView(isHidden: Bool)
}

private protocol StorageActionProtocol {
    var createListButtonDidTap: Observable<Void> { get }
    var editButtonDidTap: Observable<Void> { get }
    var saveButtonDidTap: Observable<Void> { get }
    var drawFruitButtonDidTap: Observable<Void> { get }
    var loginButtonDidTap: Observable<Void> { get }
}

private enum ButtonAttributed {
    static let edit = NSMutableAttributedString(
        string: "편집",
        attributes: [
            .font: DesignSystemFontFamily.Pretendard.bold.font(size: 12),
            .foregroundColor: DesignSystemAsset.BlueGrayColor.blueGray400.color
        ]
    )
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

    private let lineView = UIView()

//    private let myPlaylistTableView = UITableView().then {
//        let nib = UINib(nibName: "MyPlaylistTableViewCell", bundle: nil)
//        $0.register(nib, forCellReuseIdentifier: "MyPlaylistTableViewCell")
//    }

    fileprivate let createListButton = UIButton().then {
        $0.setTitle("리스트 만들기", for: .normal)
    }

    fileprivate let editButton = UIButton().then {
        $0.setTitle("편집", for: .normal)
    }

    fileprivate let saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
    }

    fileprivate let drawFruitButton = UIButton().then {
        $0.setTitle("음표 열매 뽑으러 가기", for: .normal)
    }

    private var gradientLayer = CAGradientLayer()

    fileprivate let loginWarningView = LoginWarningView(text: "로그인 하고\n리스트를 확인해보세요.") { return }

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
            lineView,
            createListButton,
            editButton,
            saveButton,
            loginWarningView
        )
    }

    func setLayout() {
        tabBarView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().priority(999)
            $0.height.equalTo(36)
        }

        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(tabBarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }

        createListButton.snp.makeConstraints {
            $0.top.equalTo(tabBarView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20).priority(999)
            $0.height.equalTo(52)
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

        loginWarningView.snp.makeConstraints {
            $0.width.equalTo(164)
            $0.height.equalTo(176)
            $0.top.equalTo(createListButton.snp.bottom).offset(80)
            $0.centerX.equalToSuperview()
        }
    }

    func configureUI() {
        backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color

        lineView.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray200.color

        createListButton.setTitleColor(DesignSystemAsset.BlueGrayColor.blueGray900.color, for: .normal)
        createListButton.layer.cornerRadius = 8
        createListButton.layer.borderWidth = 1
        createListButton.backgroundColor = .white
        createListButton.layer.borderColor = DesignSystemAsset.BlueGrayColor.blueGray200.color.cgColor.copy(alpha: 0.7)

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

        drawFruitButton.setAttributedTitle(
            NSAttributedString(
                string: "음표 열매 뽑으러 가기",
                attributes: [
                    .kern: -0.5,
                    .font: UIFont.WMFontSystem.t4(weight: .bold).font,
                    .foregroundColor: UIColor.white
                ]
            ),
            for: .normal
        )
        drawFruitButton.backgroundColor = .cyan
        gradientLayer.frame = drawFruitButton.bounds
        gradientLayer.colors = [UIColor(hex: "#0098E5"), UIColor(hex: "#968FE8")]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0.7, 1.0]
        drawFruitButton.layer.addSublayer(gradientLayer)
    }
}

extension StorageView: StorageStateProtocol {
    func updateIsHiddenEditButton(isHidden: Bool) {
        self.editButton.isHidden = isHidden
        self.saveButton.isHidden = !isHidden
    }

    func updateIsHiddenLoginWarningView(isHidden: Bool) {
        self.loginWarningView.isHidden = isHidden
    }
}

extension Reactive: StorageActionProtocol where Base: StorageView {
    var createListButtonDidTap: Observable<Void> {
        base.createListButton.rx.tap.asObservable()
    }

    var editButtonDidTap: Observable<Void> {
        base.editButton.rx.tap.asObservable()
    }

    var saveButtonDidTap: Observable<Void> {
        base.saveButton.rx.tap.asObservable()
    }

    var drawFruitButtonDidTap: Observable<Void> {
        base.drawFruitButton.rx.tap.asObservable()
    }

    var loginButtonDidTap: Observable<Void> {
        base.loginWarningView.loginButtonDidTapSubject.asObserver()
    }
}
