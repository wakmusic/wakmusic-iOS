import DesignSystem
import SnapKit
import Then
import UIKit
import Utility

public final class PlayTypeTogglePopupViewController: UIViewController {
    private let dimmView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.4)
    }

    private let contentView = UIView().then {
        $0.layer.cornerRadius = 24
        $0.backgroundColor = .white
    }

    private let titleLabel = WMLabel(
        text: "어떻게 재생할까요?",
        textColor: DesignSystemAsset.BlueGrayColor.gray900.color,
        font: .t2(weight: .bold),
        alignment: .center,
        lineHeight: UIFont.WMFontSystem.t2().lineHeight,
        kernValue: -0.5
    )

    private let vStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.distribution = .fillEqually
    }

    private let firstItemButton = PlayTypeTogglePopupItemButtonView()

    private let secondItemButton = PlayTypeTogglePopupItemButtonView()

    private let firstDotImageView = UIImageView().then {
        $0.image = DesignSystemAsset.MyInfo.dot.image
    }

    private let secondDotImageView = UIImageView().then {
        $0.image = DesignSystemAsset.MyInfo.dot.image
    }

    private let firstDescriptionLabel = WMLabel(
        text: "해당 기능을 사용하려면 앱이 설치되어 있어야 합니다.",
        textColor: DesignSystemAsset.BlueGrayColor.gray500.color,
        font: .t7(weight: .light),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t7().lineHeight,
        kernValue: -0.5
    )

    private let secondDescriptionLabel = WMLabel(
        text: "일부 노래나 쇼츠는 YouTube Music에서 지원되지 않습니다.",
        textColor: DesignSystemAsset.BlueGrayColor.gray500.color,
        font: .t7(weight: .light),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t7().lineHeight,
        kernValue: -0.5
    )

    private let hStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.distribution = .fillEqually
    }

    private let cancelButton = UIButton().then {
        let cancleButtonBackgroundColor = DesignSystemAsset.BlueGrayColor.blueGray400.color
        $0.setBackgroundColor(cancleButtonBackgroundColor, for: .normal)
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(DesignSystemAsset.BlueGrayColor.blueGray25.color, for: .normal)
        $0.titleLabel?.font = .setFont(.t4(weight: .medium))
        $0.titleLabel?.setTextWithAttributes(alignment: .center)
    }

    private let confirmButton = UIButton().then {
        let confirmButtonBackgroundColor = DesignSystemAsset.PrimaryColorV2.point.color
        $0.setBackgroundColor(confirmButtonBackgroundColor, for: .normal)
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(DesignSystemAsset.BlueGrayColor.blueGray25.color, for: .normal)
        $0.titleLabel?.font = .setFont(.t4(weight: .medium))
        $0.titleLabel?.setTextWithAttributes(alignment: .center)
    }

    private var selectedItemString: String = ""

    var completion: ((_ selectedItemString: String) -> Void)?
    var cancelCompletion: (() -> Void)?

    init(
        completion: ((_ selectedItemString: String) -> Void)? = nil,
        cancelCompletion: (() -> Void)? = nil
    ) {
        self.completion = completion
        self.cancelCompletion = cancelCompletion
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setLayout()
        configureUI()
        setActions()
        firstItemButton.setDelegate(self)
        secondItemButton.setDelegate(self)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        contentView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.contentView.transform = CGAffineTransform.identity
        }, completion: nil)
    }

    func setActions() {
        let cancelAction = UIAction { [weak self] _ in
            self?.dismiss()
        }

        let confirmAction = UIAction { [weak self] _ in
            guard let self else { return }
            self.completion?(self.selectedItemString)
            self.dismiss()
        }
        cancelButton.addAction(cancelAction, for: .touchUpInside)
        confirmButton.addAction(confirmAction, for: .touchUpInside)
    }
}

private extension PlayTypeTogglePopupViewController {
    func addViews() {
        self.view.addSubviews(
            dimmView,
            contentView
        )
        contentView.addSubviews(
            titleLabel,
            firstItemButton,
            secondItemButton,
            firstDotImageView,
            firstDescriptionLabel,
            secondDotImageView,
            secondDescriptionLabel,
            hStackView
        )
        hStackView.addArrangedSubviews(cancelButton, confirmButton)
    }

    func setLayout() {
        dimmView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.width.equalTo(335)
            $0.height.equalTo(344)
            $0.center.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(30)
        }

        firstItemButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        secondItemButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalTo(firstItemButton.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        firstDotImageView.snp.makeConstraints {
            $0.centerY.equalTo(firstDescriptionLabel.snp.centerY)
            $0.left.equalToSuperview().offset(20)
        }

        firstDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(secondItemButton.snp.bottom).offset(8)
            $0.left.equalTo(firstDotImageView.snp.right)
            $0.right.equalToSuperview().inset(20)
        }

        secondDotImageView.snp.makeConstraints {
            $0.centerY.equalTo(secondDescriptionLabel.snp.centerY)
            $0.left.equalToSuperview().offset(20)
        }

        secondDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(firstDescriptionLabel.snp.bottom).offset(4)
            $0.left.equalTo(secondDotImageView.snp.right)
            $0.right.equalToSuperview().inset(20)
        }

        hStackView.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    func configureUI() {
        self.view.backgroundColor = .clear
        contentView.clipsToBounds = true

        let alreadySelectedYoutubeMusic = PreferenceManager.playWithYoutubeMusic ?? false
        self.selectedItemString = alreadySelectedYoutubeMusic ? "YouTube Music" : "YouTube"

        firstItemButton.setTitleWithOption(title: "YouTube")
        secondItemButton.setTitleWithOption(title: "YouTube Music", shouldCheckAppIsInstalled: true)

        firstItemButton.isSelected = !alreadySelectedYoutubeMusic
        secondItemButton.isSelected = alreadySelectedYoutubeMusic

        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedAround(_:)))
        dimmView.addGestureRecognizer(gesture)
        dimmView.isUserInteractionEnabled = true
    }

    @objc func tappedAround(_ sender: UITapGestureRecognizer) {
        dismiss()
    }

    func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }, completion: nil)
        // 내려가는 애니메이션이 끝난 다음 dismiss 하기 위해 0.3초 딜레이
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.dismiss(animated: false)
        }
    }
}

extension PlayTypeTogglePopupViewController: PlayTypeTogglePopupItemButtonViewDelegate {
    func tappedButtonAction(title: String) {
        switch title {
        case "YouTube":
            self.selectedItemString = title
            firstItemButton.isSelected = true
            secondItemButton.isSelected = false
        case "YouTube Music":
            self.selectedItemString = title
            firstItemButton.isSelected = false
            secondItemButton.isSelected = true
        default:
            break
        }
    }
}
