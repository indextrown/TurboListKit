import SwiftUI
import UIKit

extension UIViewController {
    func toSwiftUI(hideNavigationBar: Bool = false) -> some View {
        ViewControllerContainer(hideNavigationBar: hideNavigationBar) {
            self
        }
        .toolbarBackground(hideNavigationBar ? .hidden : .visible, for: .navigationBar)
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
        let viewController = makeViewController()
        applyNavigationBarVisibility(to: viewController)
        return viewController
    }

    func updateUIViewController(_ uiViewController: Controller, context: Context) {
        applyNavigationBarVisibility(to: uiViewController)
    }

    private func applyNavigationBarVisibility(to viewController: UIViewController) {
        guard let navigationController = viewController as? UINavigationController else { return }
        navigationController.setNavigationBarHidden(hideNavigationBar, animated: false)
    }
}
