//
//  ViewController.swift
//  DynamicRadialGravity
//
//  Created by Joshua Homann on 4/22/17.
//  Copyright © 2017 josh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: IBOutlet

    // MARK: Variables
    var animator: UIDynamicAnimator!
    var gravity: UIFieldBehavior?
    let rows = 16
    let columns = 8
    var views: [UIView] = []
    // MARK: Constants
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: view)
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: #selector(pan(recognizer:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard views.count == 0 else {
            return
        }
        views = stride(from: 0, to: rows * columns, by: 1).map { (index: Int) -> UIView in
            let y = CGFloat(index / columns)
            let x = CGFloat(index % columns)
            let view = UIView(frame: CGRect(x: x * 50, y: y * 50, width: 20, height: 20))
            view.layer.cornerRadius = 10
            view.backgroundColor = UIColor.blue.withAlphaComponent(0.25)
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            let snapBehavior = UISnapBehavior(item: view, snapTo: view.center)
            animator.addBehavior(snapBehavior)
            return view
        }

    }

    deinit {
    }
    // MARK: Instance Methods
    @objc private func pan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            let gravity = UIFieldBehavior.radialGravityField(position: recognizer.location(in: view))
            gravity.region = UIRegion(radius: 200)
            gravity.minimumRadius = 50
            views.forEach{ gravity.addItem($0) }
            gravity.strength = 100
            gravity.falloff = 1.5
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


