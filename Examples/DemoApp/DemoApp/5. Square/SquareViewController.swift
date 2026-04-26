import UIKit

final class SquareViewController: UIViewController {
    private let listView = SquareListView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Square"
        view.backgroundColor = .systemBackground

        listView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(listView)

        NSLayoutConstraint.activate([
            listView.topAnchor.constraint(equalTo: view.topAnchor),
            listView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
