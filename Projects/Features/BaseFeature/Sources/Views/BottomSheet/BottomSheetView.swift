//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - Public extensions
extension Array {
    /// Returns an Optional that will be nil if index < count
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : .none
    }
}

public extension CGFloat {
    static let bottomSheetAutomatic: CGFloat = -123_456_789
}

public extension Array where Element == CGFloat {
    @MainActor
    static var bottomSheetDefault: [CGFloat] {
        let screenSize = UIScreen.main.bounds.size

        if screenSize.height <= 568 {
            return [510]
        } else if screenSize.height >= 812 {
            return [570, screenSize.height - 64]
        } else {
            return [510, screenSize.height - 64]
        }
    }
}

// MARK: - Delegate

public protocol BottomSheetViewDismissalDelegate: AnyObject {
    func bottomSheetView(_ view: BottomSheetView, willDismissBy action: BottomSheetView.DismissAction)
}

public protocol BottomSheetViewAnimationDelegate: AnyObject {
    func bottomSheetView(_ view: BottomSheetView, didAnimateToPosition position: CGPoint)
    func bottomSheetView(_ view: BottomSheetView, didCompleteAnimation complete: Bool)
}

// MARK: - View

public final class BottomSheetView: UIView {
    @MainActor
    public enum HandleBackground: Sendable {
        case color(UIColor)
        case visualEffect(UIVisualEffect)

        var view: UIView {
            switch self {
            case let .color(value):
                let view = UIView()
                view.backgroundColor = value
                return view
            case let .visualEffect(value):
                return UIVisualEffectView(effect: value)
            }
        }
    }

    public enum DismissAction {
        case drag(velocity: CGPoint)
        case tap
    }

    public weak var dismissalDelegate: BottomSheetViewDismissalDelegate?
    public weak var animationDelegate: BottomSheetViewAnimationDelegate?
    public private(set) var contentHeights: [CGFloat]
    public private(set) var currentTargetOffsetIndex: Int = 0

    // MARK: - Private properties

    private let useSafeAreaInsets: Bool
    private let stretchOnResize: Bool
    private let contentView: UIView
    private var topConstraint: NSLayoutConstraint!
    private var targetOffsets = [CGFloat]()
    private var initialOffset: CGFloat?
    private var translationTargets = [TranslationTarget]()
    private lazy var springAnimator = SpringAnimator(dampingRatio: 0.8, frequencyResponse: 0.4)
    private var bottomInset: CGFloat {
        return useSafeAreaInsets ? .safeAreaBottomInset : 0
    }

    private lazy var contentViewHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)

    // MARK: - Init

    public init(
        contentView: UIView,
        contentHeights: [CGFloat],
        handleBackground: HandleBackground = .color(.clear),
        draggableHeight: CGFloat? = nil,
        useSafeAreaInsets: Bool = false,
        stretchOnResize: Bool = false,
        dismissalDelegate: BottomSheetViewDismissalDelegate? = nil,
        animationDelegate: BottomSheetViewAnimationDelegate? = nil
    ) {
        self.contentView = contentView
        self.contentHeights = contentHeights.isEmpty ? [.bottomSheetAutomatic] : contentHeights
        self.useSafeAreaInsets = useSafeAreaInsets
        self.stretchOnResize = stretchOnResize
        self.dismissalDelegate = dismissalDelegate
        self.animationDelegate = animationDelegate
        super.init(frame: .zero)
        setup()
        accessibilityViewIsModal = true
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    // MARK: - Overrides

    override public func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Public API

    /// Presents bottom sheet view from the bottom of the given container view.
    ///
    /// - Parameters:
    ///   - view: the container for the bottom sheet view
    ///   - completion: a closure to be executed when the animation ends
    public func present(
        in superview: UIView,
        targetIndex: Int = 0,
        animated: Bool = true,
        completion: ((Bool) -> Void)? = nil
    ) {
        guard
            self.superview != superview,
            let height = contentHeights[safe: targetIndex]
        else {
            return
        }

        superview.addSubview(self)

        translatesAutoresizingMaskIntoConstraints = false

        let startOffset = BottomSheetCalculator.offset(
            for: contentView,
            in: superview,
            height: height,
            useSafeAreaInsets: useSafeAreaInsets
        )

        if animated {
            topConstraint = topAnchor.constraint(equalTo: superview.topAnchor, constant: superview.frame.height)
        } else {
            topConstraint = topAnchor.constraint(equalTo: superview.topAnchor, constant: startOffset)
        }

        springAnimator.addAnimation { [weak self] position in
            guard let self = self else { return }
            self.topConstraint.constant = position.y
            self.animationDelegate?.bottomSheetView(self, didAnimateToPosition: position)
        }

        springAnimator.addCompletion { [weak self] didComplete in
            guard let self = self else { return }
            completion?(didComplete)
            self.animationDelegate?.bottomSheetView(self, didCompleteAnimation: didComplete)
        }

        let bottomGreaterThanConstraint = bottomAnchor.constraint(greaterThanOrEqualTo: superview.bottomAnchor)
        let bottomEqualConstraint = bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        bottomEqualConstraint.priority = .required - 1

        NSLayoutConstraint.activate([
            topConstraint,
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomGreaterThanConstraint,
            bottomEqualConstraint,
            contentViewHeightConstraint
        ])

        updateTargetOffsets()
        transition(to: targetIndex)
        createTranslationTargets()
    }

    /// Animates bottom sheet view out of the screen bounds and removes it from the superview on completion.
    ///
    /// - Parameters:
    ///   - completion: a closure to be executed when the animation ends
    public func dismiss(velocity: CGPoint = .zero, completion: ((Bool) -> Void)? = nil) {
        springAnimator.addCompletion { [weak self] didComplete in
            if didComplete {
                self?.contentView.constraints.forEach { constraint in
                    self?.contentView.removeConstraint(constraint)
                }
                self?.contentView.removeFromSuperview()
                self?.removeFromSuperview()
                self?.springAnimator.invalidate()
            }

            completion?(didComplete)
        }

        animate(to: superview?.frame.height ?? 0, with: velocity)
    }

    /// Recalculates target offsets and animates to the minimum one.
    /// Call this method e.g. when orientation change is detected.
    public func reset() {
        updateTargetOffsets()
        createTranslationTargets()

        if let targetOffset = targetOffsets[safe: currentTargetOffsetIndex] {
            animate(to: targetOffset)
        }
    }

    public func reload(with contentHeights: [CGFloat], targetIndex: Int?) {
        self.contentHeights = contentHeights
        if let targetIndex = targetIndex {
            currentTargetOffsetIndex = targetIndex
        }
        reset()
    }

    /// Animates bottom sheet view to the given height.
    ///
    /// - Parameters:
    ///   - index: the index of the target height
    public func transition(to index: Int) {
        guard let height = contentHeights[safe: index] else {
            return
        }

        guard let superview = superview else {
            return
        }

        let offset = BottomSheetCalculator.offset(
            for: contentView,
            in: superview,
            height: height,
            useSafeAreaInsets: useSafeAreaInsets
        )

        animate(to: offset)
    }

    // MARK: - Setup
    private func setup() {
        backgroundColor = UIColor.clear
        addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false

        var constraints = [
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]

        if stretchOnResize {
            constraints.append(contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomInset))
        } else {
            constraints.append(contentView.bottomAnchor.constraint(
                lessThanOrEqualTo: bottomAnchor,
                constant: -bottomInset
            ))
        }

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Animations
    private func animate(to offset: CGFloat, with initialVelocity: CGPoint = .zero) {
        if let index = targetOffsets.firstIndex(of: offset) {
            currentTargetOffsetIndex = index
        }

        springAnimator.fromPosition = CGPoint(x: 0, y: topConstraint.constant)
        springAnimator.toPosition = CGPoint(x: 0, y: offset)
        springAnimator.initialVelocity = initialVelocity
        springAnimator.startAnimation()
    }

    // MARK: - Offset calculation

    private func updateTargetOffsets() {
        guard let superview = superview else { return }

        contentViewHeightConstraint.constant = 0

        targetOffsets = contentHeights.map {
            BottomSheetCalculator.offset(
                for: contentView,
                in: superview,
                height: $0,
                useSafeAreaInsets: useSafeAreaInsets
            )
        }.sorted(by: >)

        if let maxOffset = targetOffsets.max() {
            let contentViewHeight = superview.frame.size.height - maxOffset - bottomInset
            contentViewHeightConstraint.constant = contentViewHeight
        }

        superview.layoutIfNeeded()
    }

    private func createTranslationTargets() {
        guard let superview = superview else { return }

        translationTargets = BottomSheetCalculator.createTranslationTargets(
            for: targetOffsets,
            at: currentTargetOffsetIndex,
            in: superview,
            targetMaxHeight: dismissalDelegate != nil
        )
    }
}
