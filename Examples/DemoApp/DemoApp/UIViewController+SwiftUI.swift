import SwiftUI
import UIKit

extension UIViewController {
    func toSwiftUI(hideNavigationBar: Bool = false) -> some View {
        ViewControllerContainer(hideNavigationBar: hideNavigationBar) {
            self
        }
        .toolbar(hideNavigationBar ? .hidden : .visible, for: .navigationBar)
    }
}

private struct ViewControllerContainer<Controller: UIViewController>: UIViewControllerRepresentable {
    let makeViewController: () -> Controller
    let hideNavigationBar: Bool

    init(
        hideNavigationBar: Bool = false,
        makeViewController: @escaping () -> Controller
    ) {
        self.hideNavigationBar = hideNavigationBar
        self.makeViewController = makeViewController
    }

    func makeUIViewController(context: Context) -> Controller {
        makeViewController()
    }

    func updateUIViewController(_ uiViewController: Controller, context: Context) {}
}
