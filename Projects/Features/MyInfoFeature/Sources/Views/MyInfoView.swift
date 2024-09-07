import DesignSystem
import RxCocoa
import RxSwift
import SignInFeatureInterface
import SnapKit
import Then
import UIKit
import UserDomainInterface
import Utility

private protocol MyInfoStateProtocol {
    func updateIsHiddenLoginWarningView(isLoggedIn: Bool)
    func updateFruitCount(count: Int)
}

private protocol MyInfoActionProtocol {
    var scrollViewDidTap: Observable<Void> { get }
    var loginButtonDidTap: Observable<Void> { get }
    var profileImageDidTap: Observable<Void> { get }
    var fruitStorageButtonDidTap: Observable<Void> { get }
    var drawButtonDidTap: Observable<Void> { get }
    var fruitNavigationButtonDidTap: Observable<Void> { get }
    var qnaNavigationButtonDidTap: Observable<Void> { get }
    var notiNavigationButtonDidTap: Observable<Void> { get }
    var mailNavigationButtonDidTap: Observable<Void> { get }
    var teamNavigationButtonDidTap: Observable<Void> { get }
    var settingNavigationButtonDidTap: Observable<Void> { get }
}

final class MyInfoView: UIView {
    let scrollView = UIScrollView()
    let contentView = UIView()

    let loginWarningView = LoginWarningView(text: "로그인을 해주세요.")

    let profileView = ProfileView().then {
        $0.isHidden = true
    }

    let fruitDrawButtonView = FruitDrawButtonView()

    let vStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }

    let hStackViewTop = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }

    let hStackViewBottom = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }

    let fruitNavigationButton = MyInfoNavigationButton(
        title: "열매함",
        image: DesignSystemAsset.MyInfo.fruit.image
    )
    let qnaNavigationButton = MyInfoNavigationButton(
        title: "자주 묻는 질문",
        image: DesignSystemAsset.MyInfo.qna.image
    )
    let notiNavigationButton = MyInfoNavigationButton(
        title: "공지사항",
        image: DesignSystemAsset.MyInfo.noti.image
    )
    let mailNavigationButton = MyInfoNavigationButton(
        title: "문의하기",
        image: DesignSystemAsset.MyInfo.mail.image
    )
    let teamNavigationButton = MyInfoNavigationButton(
        title: "팀 소개",
        image: DesignSystemAsset.MyInfo.team.image
    )
    let settingNavigationButton = MyInfoNavigationButton(
        title: "설정",
        image: DesignSystemAsset.MyInfo.gear.image
    )
    let newNotiIndicator = UIView().then {
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 2.5
        $0.isHidden = true
    }

    init() {
        super.init(frame: .zero)
        addView()
        setLayout()
        self.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MyInfoView {
    func addView() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            loginWarningView,
            profileView,
            fruitDrawButtonView,
            vStackView,
            newNotiIndicator
        )
        vStackView.addArrangedSubviews(
            hStackViewTop,
            hStackViewBottom
        )
        hStackViewTop.addArrangedSubviews(
            fruitNavigationButton,
            qnaNavigationButton,
            notiNavigationButton
        )
        hStackViewBottom.addArrangedSubviews(
            mailNavigationButton,
            teamNavigationButton,
            settingNavigationButton
        )
    }

    func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.edges.equalTo(scrollView.contentLayoutGuide)
        }

        loginWarningView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(164)
            $0.height.equalTo(154)
        }

        profileView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(52)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(162)
        }

        fruitDrawButtonView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(52)
            $0.top.equalTo(loginWarningView.snp.bottom).offset(52)
        }

        vStackView.snp.makeConstraints {
            $0.height.equalTo(200)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(fruitDrawButtonView.snp.bottom).offset(16)
            $0.bottom.equalToSuperview()
        }

        hStackViewTop.snp.makeConstraints {
            $0.height.equalTo(100)
        }

        hStackViewBottom.snp.makeConstraints {
            $0.height.equalTo(100)
        }

        newNotiIndicator.snp.makeConstraints {
            $0.width.height.equalTo(5)
            $0.centerX.equalTo(notiNavigationButton.snp.centerX).offset(27)
            $0.centerY.equalTo(notiNavigationButton.snp.centerY).offset(12)
        }
    }
}

extension MyInfoView: MyInfoStateProtocol {
    func updateIsHiddenLoginWarningView(isLoggedIn: Bool) {
        if isLoggedIn {
            loginWarningView.isHidden = true
            profileView.isHidden = false
        } else {
            profileView.isHidden = true
            loginWarningView.isHidden = false
        }
    }

    func updateFruitCount(count: Int) {
        fruitDrawButtonView.updateFruitCount(count: count)
    }
}

extension Reactive: MyInfoActionProtocol where Base: MyInfoView {
    var scrollViewDidTap: Observable<Void> {
        let tapGestureRecognizer = UITapGestureRecognizer()
        base.scrollView.addGestureRecognizer(tapGestureRecognizer)
        base.scrollView.isUserInteractionEnabled = true
        return tapGestureRecognizer.rx.event.map { _ in }.asObservable()
    }

    var loginButtonDidTap: Observable<Void> { base.loginWarningView.rx.loginButtonDidTap }
    var profileImageDidTap: Observable<Void> { base.profileView.rx.profileImageDidTap }
    var fruitStorageButtonDidTap: Observable<Void> { base.fruitDrawButtonView.rx.fruitStorageButtonDidTap }
    var drawButtonDidTap: Observable<Void> { base.fruitDrawButtonView.rx.drawButtonDidTap }
    var fruitNavigationButtonDidTap: Observable<Void> { base.fruitNavigationButton.rx.tap.asObservable() }
    var qnaNavigationButtonDidTap: Observable<Void> { base.qnaNavigationButton.rx.tap.asObservable() }
    var notiNavigationButtonDidTap: Observable<Void> { base.notiNavigationButton.rx.tap.asObservable() }
    var mailNavigationButtonDidTap: Observable<Void> { base.mailNavigationButton.rx.tap.asObservable() }
    var teamNavigationButtonDidTap: Observable<Void> { base.teamNavigationButton.rx.tap.asObservable() }
    var settingNavigationButtonDidTap: Observable<Void> { base.settingNavigationButton.rx.tap.asObservable() }
}
