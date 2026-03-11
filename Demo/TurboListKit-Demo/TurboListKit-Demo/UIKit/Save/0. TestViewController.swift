//
//  TestViewController.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/6/26.
//

/*
import UIKit
import TurboListKit

final class TestViewController: UIViewController {
    
//    private let collectionView = UICollectionView(
//        frame: .zero,
//        collectionViewLayout: UICollectionViewFlowLayout()
//    )
    
    
    let collectionView = UICollectionView(scrollDirection: .vertical, lineSpacing: 10, interitemSpacing: 10)
    lazy var adapter = CollectionViewAdapter(collectionView: collectionView)

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
             collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
             collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
             collectionView.topAnchor.constraint(equalTo: view.topAnchor),
             collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
         ])
     }
    
    func setupAdapter() {
        adapter.setItems([
            TitleComponent(title: "Hello"),
            TitleComponent(title: "World"),
            TitleComponent(title: "TurboListKit"),
            NumberComponent(number: 1),
            NumberComponent(number: 2)
        ])
        
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.adapter.setItems([
                NumberComponent(number: 1),
                NumberComponent(number: 2),
            ])
        })
         */
    }
    

}



*/
