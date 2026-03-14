//
//  TurboList.swift
//  
//
//  Created by 김동현 on 3/14/26.
//

import SwiftUI
import UIKit

// MARK: - TurboList
public struct TurboList<Content: View>: View {

    private let views: [AnyView]
    private let spacing: CGFloat

    public init(
        spacing: CGFloat = 0,
        @ViewBuilder content: () -> Content
    ) {
        self.spacing = spacing
        self.views = TurboList.flatten(content())
    }

    public var body: some View {
        TurboListRepresentable(
            views: views,
            spacing: spacing
        )
    }
}

// MARK: - flatten
extension TurboList {

    static func flatten<V: View>(_ view: V) -> [AnyView] {

        let mirror = Mirror(reflecting: view)

        if mirror.displayStyle == .tuple {
            return mirror.children.compactMap {
                AnyView(_fromValue: $0.value)
            }
        }

        return [AnyView(view)]
    }
}


struct TurboListRepresentable: UIViewRepresentable {

    let views: [AnyView]
    let spacing: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(views: views)
    }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UICollectionView {

        HostingCell.spacing = spacing

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = .zero

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        collectionView.dataSource = context.coordinator
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true

        collectionView.register(
            HostingCell.self,
            forCellWithReuseIdentifier: "cell"
        )

        return collectionView
    }

    func updateUIView(
        _ uiView: UICollectionView,
        context: UIViewRepresentableContext<Self>
    ) {
        context.coordinator.views = views
        uiView.reloadData()
    }
}



extension TurboListRepresentable {

    final class Coordinator: NSObject, UICollectionViewDataSource {

        var views: [AnyView]

        init(views: [AnyView]) {
            self.views = views
        }

        func collectionView(
            _ collectionView: UICollectionView,
            numberOfItemsInSection section: Int
        ) -> Int {
            views.count
        }

        func collectionView(
            _ collectionView: UICollectionView,
            cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cell",
                for: indexPath
            ) as! HostingCell

            cell.setView(views[indexPath.item])

            return cell
        }
    }
}


final class HostingCell: UICollectionViewCell {

    static var spacing: CGFloat = 0

    private var hostingController: UIHostingController<AnyView>?

    func setView(_ view: AnyView) {

        if hostingController == nil {

            let host = UIHostingController(rootView: view)
            host.view.backgroundColor = .clear
            host.view.translatesAutoresizingMaskIntoConstraints = false

            hostingController = host

            contentView.addSubview(host.view)

            NSLayoutConstraint.activate([
                host.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                host.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                host.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                host.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])

        } else {
            hostingController?.rootView = view
        }
    }

    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {

        guard let collectionView = superview as? UICollectionView else {
            return layoutAttributes
        }

        setNeedsLayout()
        layoutIfNeeded()

        let targetSize = CGSize(
            width: collectionView.bounds.width,
            height: UIView.layoutFittingCompressedSize.height
        )

        let size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        layoutAttributes.size.width = collectionView.bounds.width
        layoutAttributes.size.height = ceil(size.height)

        return layoutAttributes
    }
}

//struct ContentView: View {
//
//    var body: some View {
//        VStack {
//            TurboList {
//                
//                Text("Hello")
//
//                VStack {
//                    Text("SwiftUI Cell")
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
