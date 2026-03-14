//
//  BeforeVC.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/13/26.
//

import UIKit

final class UIKitCollectionVC: UIViewController,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {

    struct Section {
        let header: String
        let items: [Int]
        let footer: String
        let isGrid: Bool
        let spacingAfter: CGFloat
    }

    let sections: [Section] = [
        Section(
            header: "Header",
            items: [0,1,2],
            footer: "Footer",
            isGrid: false,
            spacingAfter: 20
        ),
        Section(
            header: "Header",
            items: [0,1,2],
            footer: "Footer",
            isGrid: true,
            spacingAfter: 0
        )
    ]

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 0,
            right: 20
        )
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        collectionView.frame = view.bounds

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(
            UIKitCell.self,
            forCellWithReuseIdentifier: "cell"
        )

        collectionView.register(
            UIKitHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )

        collectionView.register(
            UIKitFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "footer"
        )
    }

    // MARK: Sections

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        sections[section].items.count
    }

    // MARK: Cell

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as! UIKitCell

        let number = sections[indexPath.section].items[indexPath.item]
        cell.configure(number: number)

        return cell
    }

    // MARK: Tap (onTouch equivalent)

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        print("Hello Turbo!")
    }

    // MARK: Item Size

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let section = sections[indexPath.section]

        let width = collectionView.bounds.width - 40

        if section.isGrid {
            return CGSize(
                width: (width - 10) / 2,
                height: 100
            )
        } else {
            return CGSize(
                width: width,
                height: 44
            )
        }
    }

    // MARK: Header / Footer View

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {

            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "header",
                for: indexPath
            ) as! UIKitHeaderView

            view.setTitle(sections[indexPath.section].header)

            return view
        }

        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "footer",
            for: indexPath
        ) as! UIKitFooterView

        view.setTitle(sections[indexPath.section].footer)

        return view
    }

    // MARK: Header Size

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {

        CGSize(
            width: collectionView.bounds.width,
            height: 40
        )
    }

    // MARK: Footer Size

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {

        let spacing = sections[section].spacingAfter

        return CGSize(
            width: collectionView.bounds.width,
            height: 40 + spacing
        )
    }
}

// MARK: Cell

final class UIKitCell: UICollectionViewCell {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        contentView.backgroundColor = .systemGray5
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(number: Int) {
        label.text = "\(number)"
    }
}

// MARK: Header

final class UIKitHeaderView: UICollectionReusableView {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        label.font = .systemFont(ofSize: 16, weight: .medium)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func setTitle(_ text: String) {
        label.text = text
    }
}

// MARK: Footer

final class UIKitFooterView: UICollectionReusableView {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        label.font = .systemFont(ofSize: 16, weight: .medium)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func setTitle(_ text: String) {
        label.text = text
    }
}

#Preview {
    UIKitCollectionVC()
}







//final class UIKitCollectionVC: UIViewController,
//UICollectionViewDataSource,
//UICollectionViewDelegateFlowLayout {
//
//    struct Section {
//        let header: String
//        let items: [Int]
//        let footer: String
//        let isGrid: Bool
//    }
//
//    let sections: [Section] = [
//        Section(header: "Header",
//                items: [0,1,2],
//                footer: "Footer",
//                isGrid: false),
//
//        Section(header: "Header",
//                items: [0,1,2],
//                footer: "Footer",
//                isGrid: true)
//    ]
//
//    let collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 10
//        layout.minimumInteritemSpacing = 10
//        layout.sectionInset = UIEdgeInsets(
//            top: 0,
//            left: 20,
//            bottom: 20,
//            right: 20
//        )
//        return UICollectionView(frame: .zero, collectionViewLayout: layout)
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.addSubview(collectionView)
//        collectionView.frame = view.bounds
//
//        collectionView.dataSource = self
//        collectionView.delegate = self
//
//        collectionView.register(UICollectionViewCell.self,
//                                forCellWithReuseIdentifier: "cell")
//
//        collectionView.register(HeaderView.self,
//                                forSupplementaryViewOfKind:
//                                UICollectionView.elementKindSectionHeader,
//                                withReuseIdentifier: "header")
//
//        collectionView.register(FooterView.self,
//                                forSupplementaryViewOfKind:
//                                UICollectionView.elementKindSectionFooter,
//                                withReuseIdentifier: "footer")
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        sections.count
//    }
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        numberOfItemsInSection section: Int
//    ) -> Int {
//        sections[section].items.count
//    }
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        cellForItemAt indexPath: IndexPath
//    ) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: "cell",
//            for: indexPath
//        )
//
//        cell.backgroundColor = .systemGray5
//        return cell
//    }
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAt indexPath: IndexPath
//    ) -> CGSize {
//
//        let section = sections[indexPath.section]
//
//        let width = collectionView.bounds.width - 40
//
//        if section.isGrid {
//            return CGSize(width: (width - 10)/2, height: 120)
//        } else {
//            return CGSize(width: width, height: 44)
//        }
//    }
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        viewForSupplementaryElementOfKind kind: String,
//        at indexPath: IndexPath
//    ) -> UICollectionReusableView {
//
//        if kind == UICollectionView.elementKindSectionHeader {
//
//            let view = collectionView.dequeueReusableSupplementaryView(
//                ofKind: kind,
//                withReuseIdentifier: "header",
//                for: indexPath
//            )
//
//            return view
//        }
//
//        let view = collectionView.dequeueReusableSupplementaryView(
//            ofKind: kind,
//            withReuseIdentifier: "footer",
//            for: indexPath
//        )
//
//        return view
//    }
//}
//
//#Preview {
//    UIKitCollectionVC()
//}
