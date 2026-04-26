import UIKit

final class SampleViewController: UIViewController {
    private let listView = VerticalLayoutListView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sample"
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
