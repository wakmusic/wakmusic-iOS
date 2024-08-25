import DesignSystem
import SnapKit
import Then
import UIKit
import Utility

public final class TogglePopupViewController: UIViewController {
    private let dimmView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.4)
    }

    private let contentView = UIView().then {
        $0.layer.cornerRadius = 24
        $0.backgroundColor = .white
    }

    private let titleLabel = WMLabel(
        text: "",
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

    private let firstItemButton = UIButton()

    private let secondItemButton = UIButton()

    private let dotImageView = UIImageView().then {
        $0.image = DesignSystemAsset.MyInfo.dot.image
    }

    private let descriptionLabel = WMLabel(
        text: "",
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

    private var titleString: String
    private var firstItemString: String
    private var secondItemString: String
    private var cancelButtonText: String
    private var confirmButtonText: String
    private var firstDescriptionText: String
    private var secondDescriptionText: String
    var completion: (() -> Void)?
    var cancelCompletion: (() -> Void)?

    init(
        titleString: String,
        firstItemString: String,
        secondItemString: String,
        cancelButtonText: String = "취소",
        confirmButtonText: String = "확인",
        firstDescriptionText: String = "",
        secondDescriptionText: String = "",
        completion: (() -> Void)? = nil,
        cancelCompletion: (() -> Void)? = nil
    ) {
        self.titleString = titleString
        self.firstItemString = firstItemString
        self.secondItemString = secondItemString
        self.cancelButtonText = cancelButtonText
        self.confirmButtonText = confirmButtonText
        self.firstDescriptionText = firstDescriptionText
        self.secondDescriptionText = secondDescriptionText
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
        firstItemButton.addTarget(nil, action: #selector(firstItemDidTap), for: .touchUpInside)
        secondItemButton.addTarget(nil, action: #selector(secondItemDidTap), for: .touchUpInside)
        cancelButton.addTarget(nil, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        confirmButton.addTarget(nil, action: #selector(confirmButtonDidTap), for: .touchUpInside)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        contentView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.contentView.transform = CGAffineTransform.identity
        }, completion: nil)
    }

    @objc func firstItemDidTap() {
        print("1")
    }

    @objc func secondItemDidTap() {
        print("2")
    }

    @objc func cancelButtonDidTap() {
        dismiss()
    }

    @objc func confirmButtonDidTap() {
        print("confirm")
    }
}

private extension TogglePopupViewController {
    func addViews() {
        self.view.addSubviews(
            dimmView,
            contentView
        )
        contentView.addSubviews(
            titleLabel,
            firstItemButton,
            secondItemButton,
            dotImageView,
            descriptionLabel,
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
            $0.height.equalTo(322)
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

        dotImageView.snp.makeConstraints {
            $0.centerY.equalTo(descriptionLabel.snp.centerY)
            $0.left.equalToSuperview().offset(20)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(secondItemButton.snp.bottom).offset(8)
            $0.left.equalTo(dotImageView.snp.right)
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

        titleLabel.text = self.titleString
        firstItemButton.setTitle(self.firstItemString, for: .normal)
        secondItemButton.setTitle(self.secondItemString, for: .normal)
        descriptionLabel.text = self.firstDescriptionText
        cancelButton.setTitle(self.cancelButtonText, for: .normal)
        confirmButton.setTitle(self.confirmButtonText, for: .normal)

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
