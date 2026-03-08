//
//  UIView+.swift
//  
//
//  Created by 김동현 on 3/8/26.
//

import ObjectiveC
import UIKit

extension UIView {

    private static var tapKey: UInt8 = 0
    
    func onTap(_ action: @escaping () -> Void) {
        isUserInteractionEnabled = true

        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))

        objc_setAssociatedObject(self, &Self.tapKey, action, .OBJC_ASSOCIATION_COPY_NONATOMIC)

        addGestureRecognizer(gesture)
    }

    @objc private func handleTap() {
        if let action = objc_getAssociatedObject(self, &Self.tapKey) as? () -> Void {
            action()
        }
    }
}
