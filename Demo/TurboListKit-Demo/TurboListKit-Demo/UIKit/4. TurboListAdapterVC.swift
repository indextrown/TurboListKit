//
//  TestViewController.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/6/26.
//

import UIKit
import TurboListKit

final class TurboListAdapterVC: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAdapter()
    }
    
    private func setupUI() {
         view.backgroundColor = .white
         
         view.addSubview(collectionView)
         collectionView.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             collectionView.topAnchor.constraint(equalTo: view.topAnchor),
             collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
         ])
     }
    
    let collectionView = UICollectionView(
        scrollDirection: .vertical,
        lineSpacing: 10,
        interitemSpacing: 10
    )
    
    lazy var adapter = TurboListAdapter(
        collectionView: collectionView,
        animated: true
    )
    
    func setupAdapter() {
        adapter.setSections([
            
            // section1
            TurboSection(
                id: "id1",
                header: HeaderComponent(title: "Header"),
                footer: FooterComponent(title: "Footer"),
                items: [
                    NumberComponent(number: 1),
                    NumberComponent(number: 2),
                    NumberComponent(number: 3)
                        .onTouch { print("Touched") }       // Touchable
                    ,
                ]
            ),
            
            // section2
            TurboSection(
                id: "id2",
                layout: .grid(columns: 3),                  // optional
                header: HeaderComponent(title: "Header"),   // optional
                footer: FooterComponent(title: "Footer"),   // optional
                items: [
                    NumberComponent(number: 1),
                    NumberComponent(number: 2),
                    NumberComponent(number: 3),
                ]
            ),
            
            // section3
            TurboSection(
                id: "id3",
                layout: .grid(columns: 2),
                header: HeaderComponent(title: "Header"),
                footer: FooterComponent(title: "Footer"),
                items: [
                    NumberComponent(number: 1)
                        .padding(left: 50)
                    ,
                    NumberComponent(number: 2)
                        .padding(right: 50)
                    ,
                ]
            ),
            
            TurboSection(
                id: "id4",
                header: HeaderComponent(title: "Header"),
                footer: FooterComponent(title: "Footer"),
                items: [
                    NumberComponent(number: 1),
                    NumberComponent(number: 2),
                    NumberComponent(number: 3)
                        .onTouch { print("Touched") }       // Touchable
                    ,
                ]
            ),
        ])
    }
}

#Preview {
    TurboListAdapterVC()
}







