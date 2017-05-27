//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

class ViewController: UIViewController {
    // MARK: IBOutlet

    // MARK: Variables
    var animator: UIDynamicAnimator!
    var gravity: UIFieldBehavior?
    var views: [UIView] = []
    // MARK: Constants
    let columns = 16
    let rows = 24
    let diameter: CGFloat = 16
    let minimumRadius: CGFloat = 60
    let radius: CGFloat = 600
    let strength: CGFloat = 600
    let fallOff: CGFloat = 0.25
    let damping: CGFloat = 50
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: view)
        var gestureRecognizer = UILongPressGestureRecognizer()
        gestureRecognizer.minimumPressDuration = .ulpOfOne
        gestureRecognizer.addTarget(self, action: #selector(pan(recognizer:)))
        view.addGestureRecognizer(gestureRecognizer)

        gestureRecognizer = UILongPressGestureRecognizer()
        gestureRecognizer.numberOfTouchesRequired = 2
        gestureRecognizer.minimumPressDuration = .ulpOfOne
        gestureRecognizer.addTarget(self, action: #selector(pan(recognizer:)))
        view.addGestureRecognizer(gestureRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard views.count == 0 else {
            return
        }
        let horizontalSpacing = (self.view.bounds.size.width - CGFloat(columns) * diameter) / (CGFloat(columns) + 1)
        let verticalSpacing = (self.view.bounds.size.height - CGFloat(rows) * diameter) / (CGFloat(rows) + 1)
        views = stride(from: 0, to: rows * columns, by: 1).map { (index: Int) -> UIView in
            let y = CGFloat(index / columns)
            let x = CGFloat(index % columns)
            let xCenter = horizontalSpacing + (x * (horizontalSpacing + diameter))
            let yCenter = verticalSpacing + (y * (verticalSpacing + diameter))
            let view = UIView(frame: CGRect(x: xCenter , y: yCenter, width: diameter, height: diameter))
            view.layer.cornerRadius = diameter / 2

            let color = UIColor(red: x.truncatingRemainder(dividingBy: 3) / 2.5, green:  (x + y + 1).truncatingRemainder(dividingBy:2.5), blue: ( y.truncatingRemainder(dividingBy: 3) + x).truncatingRemainder(dividingBy: 3)/2.5, alpha: 1)
            view.backgroundColor = color.withAlphaComponent(0.5)
            view.layer.borderColor = color.cgColor
            view.layer.borderWidth = 1
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            let snapBehavior = UISnapBehavior(item: view, snapTo: view.center)
            snapBehavior.damping = damping
            animator.addBehavior(snapBehavior)
            return view
        }

    }

    deinit {
    }
    // MARK: Instance Methods
    @objc private func pan(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            let gravity = UIFieldBehavior.radialGravityField(position: recognizer.location(in: view))
            gravity.region = UIRegion(radius: radius)
            gravity.minimumRadius = minimumRadius
            views.forEach{ gravity.addItem($0) }
            gravity.strength = recognizer.numberOfTouches % 2 == 0 ? -strength : strength
            gravity.falloff = fallOff
            animator.addBehavior(gravity)
            self.gravity = gravity
        case .changed:
            gravity?.position = recognizer.location(in: view)
        case .ended, .cancelled:
            if let gravity = gravity {
                animator.removeBehavior(gravity)
            }
        default:
            break
        }
        
    }
    // MARK: IBAction
}

let viewController = ViewController()
PlaygroundPage.current.liveView = viewController
PlaygroundPage.current.needsIndefiniteExecution = true



