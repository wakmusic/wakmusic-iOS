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
}

private protocol MyInfoActionProtocol {
    var loginButtonDidTap: Observable<Void> { get }
    var moreButtonDidTap: Observable<Void> { get }
    var likeNavigationButtonDidTap: Observable<Void> { get }
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

    let drawButtonView = DrawButtonView()

    let moreButton = UIButton().then {
        $0.setImage(DesignSystemAsset.MyInfo.more.image, for: .normal)
    }

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

    let likeNavigationButton = MyInfoNavigationButton(
        title: "좋아요",
        image: DesignSystemAsset.MyInfo.heartMyInfo.image
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
        image: DesignSystemAsset.MyInfo.noti.image
    )
    let settingNavigationButton = MyInfoNavigationButton(
        title: "설정",
        image: DesignSystemAsset.MyInfo.gear.image
    )

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
            moreButton,
            loginWarningView,
            profileView,
            drawButtonView,
            vStackView
        )
        vStackView.addArrangedSubviews(
            hStackViewTop,
            hStackViewBottom
        )
        hStackViewTop.addArrangedSubviews(
            likeNavigationButton,
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
            $0.top.equalToSuperview().offset(STATUS_BAR_HEGHIT())
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.edges.equalTo(scrollView.contentLayoutGuide)
        }
        
        moreButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-20)
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

        drawButtonView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(52)
            $0.top.equalTo(loginWarningView.snp.bottom).offset(52)
        }

        vStackView.snp.makeConstraints {
            $0.height.equalTo(200)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(drawButtonView.snp.bottom).offset(16)
            $0.bottom.equalToSuperview()
        }

        hStackViewTop.snp.makeConstraints {
            $0.height.equalTo(100)
        }

        hStackViewBottom.snp.makeConstraints {
            $0.height.equalTo(100)
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
}

extension Reactive: MyInfoActionProtocol where Base: MyInfoView {
    var loginButtonDidTap: Observable<Void> { base.loginWarningView.rx.loginButtonDidTap }
    var moreButtonDidTap: Observable<Void> { base.moreButton.rx.tap.asObservable() }
    var drawButtonDidTap: Observable<Void> { base.drawButtonView.rx.drawButtonDidTap }
    var likeNavigationButtonDidTap: Observable<Void> { base.likeNavigationButton.rx.tap.asObservable() }
    var qnaNavigationButtonDidTap: Observable<Void> { base.qnaNavigationButton.rx.tap.asObservable() }
    var notiNavigationButtonDidTap: Observable<Void> { base.notiNavigationButton.rx.tap.asObservable() }
    var mailNavigationButtonDidTap: Observable<Void> { base.mailNavigationButton.rx.tap.asObservable() }
    var teamNavigationButtonDidTap: Observable<Void> { base.teamNavigationButton.rx.tap.asObservable() }
    var settingNavigationButtonDidTap: Observable<Void> { base.settingNavigationButton.rx.tap.asObservable() }
}
