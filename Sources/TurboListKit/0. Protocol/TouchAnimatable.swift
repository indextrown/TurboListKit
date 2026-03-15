//
//  TouchAnimatable.swift
//  TurboListKit
//
//  Created by 김동현 on 3/15/26.
//
//
//import UIKit
//
//public protocol TouchAnimatable {}
//
//@MainActor
//public extension TouchAnimatable where Self: UIView {
//
//    func enableTouchAnimation() {
//
//        if gestureRecognizers?.contains(where: { $0 is UILongPressGestureRecognizer }) == true {
//            return
//        }
//
//        let gesture = UILongPressGestureRecognizer(
//            target: self,
//            action: #selector(UIView._handleTouchInteractionAnimation(_:))
//        )
//
//        gesture.minimumPressDuration = 0
//        addGestureRecognizer(gesture)
//    }
//}
//
//private extension UIView {
//
//    private var highlightLayer: CALayer {
//        if let layer = self.layer.sublayers?.first(where: { $0.name == "touchHighlightLayer" }) {
//            return layer
//        }
//
//        let layer = CALayer()
//        layer.name = "touchHighlightLayer"
//        layer.backgroundColor = UIColor.gray.withAlphaComponent(0.15).cgColor
//        layer.opacity = 0
//
//        self.layer.addSublayer(layer)
//
//        return layer
//    }
//
//    @objc func _handleTouchInteractionAnimation(_ gesture: UILongPressGestureRecognizer) {
//
//        highlightLayer.frame = bounds
//
//        switch gesture.state {
//
//        case .began:
//            UIView.animate(withDuration: 0.12) {
//                self.highlightLayer.opacity = 1
//                self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
//            }
//
//        case .ended, .cancelled, .failed:
//            UIView.animate(withDuration: 0.12) {
//                self.highlightLayer.opacity = 0
//                self.transform = .identity
//            }
//
//        default:
//            break
//        }
//    }
//}


import UIKit

public protocol TouchAnimatable {}

@MainActor
public extension TouchAnimatable where Self: UIView {

    func enableTouchAnimation() {

        if gestureRecognizers?.contains(where: { $0 is UILongPressGestureRecognizer }) == true {
            return
        }

        let gesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(UIView._handleTouchInteractionAnimation(_:))
        )

        gesture.minimumPressDuration = 0
        addGestureRecognizer(gesture)
    }
}

private extension UIView {

    private var highlightView: UIView {
        if let view = viewWithTag(999_999) {
            return view
        }

        let view = UIView()
        view.tag = 999_999
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.15)
        view.alpha = 0
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false

        addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        return view
    }

    @objc func _handleTouchInteractionAnimation(_ gesture: UILongPressGestureRecognizer) {

        switch gesture.state {

        case .began:
            UIView.animate(withDuration: 0.12) {
                self.highlightView.alpha = 1
                self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            }

        case .ended, .cancelled, .failed:
            UIView.animate(withDuration: 0.12) {
                self.highlightView.alpha = 0
                self.transform = .identity
            }

        default:
            break
        }
    }
}
