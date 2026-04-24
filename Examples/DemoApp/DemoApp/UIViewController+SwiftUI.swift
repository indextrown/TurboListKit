import SwiftUI
import UIKit

extension UIViewController {
    func toSwiftUI() -> some View {
        ViewControllerContainer {
            self
        }
    }
}

private struct ViewControllerContainer<Controller: UIViewController>: UIViewControllerRepresentable {
    let makeViewController: () -> Controller

    func makeUIViewController(context: Context) -> Controller {
        makeViewController()
    }

    func updateUIViewController(_ uiViewController: Controller, context: Context) {}
}
