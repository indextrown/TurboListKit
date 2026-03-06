//
//  UIViewController+.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/6/26.
//

import SwiftUI
import UIKit

extension UIViewController {

    struct VCWrapper: UIViewControllerRepresentable {

        typealias UIViewControllerType = UIViewController
        
        let vcType: UIViewController.Type
        let withNavigation: Bool

        func makeUIViewController(
            context: UIViewControllerRepresentableContext<Self>
        ) -> UIViewController {

            let rootVC = vcType.init()

            return withNavigation
                ? UINavigationController(rootViewController: rootVC)
                : rootVC
        }

        func updateUIViewController(
            _ uiViewController: UIViewController,
            context: UIViewControllerRepresentableContext<Self>
        ) { }
    }

    static func toSwiftUI(withNavigation: Bool = true) -> some View {
        VCWrapper(
            vcType: Self.self,
            withNavigation: withNavigation
        )
    }
}
