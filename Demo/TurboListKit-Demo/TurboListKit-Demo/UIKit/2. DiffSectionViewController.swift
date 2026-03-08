//
//  TestViewController.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/6/26.
//

import UIKit
import TurboListKit

final class DiffSectionViewController: UIViewController {
    
    let collectionView = UICollectionView(scrollDirection: .vertical,
                                          lineSpacing: 10,
                                          interitemSpacing: 10)

    lazy var adapter = DiffSectionCollectionViewAdapter(collectionView: collectionView,
                                                 animated: true)

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
        adapter.setSections([

            ComponentSection(
                id: "title",
                elements: [
                    TitleComponent(title: "Hello"),
                    TitleComponent(title: "World")
                ]
            ),

            ComponentSection(
                id: "numbers",
                elements: [
                    NumberComponent(number: 1)
                        .onTouch {
                            print("테스트1")
                        },
                    
                    NumberComponent(number: 2)
                        .onTouch {
                            print("테스트2")
                        },
                    NumberComponent(number: 3)
                        .onTouch {
                            print("테스트3")
                        }
                ]
            )

        ])
        
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.adapter.setSections([
                
                ComponentSection(
                    id: "title",
                    elements: [
                        TitleComponent(title: "World"),
                        TitleComponent(title: "Hello"),
                    ]
                ),

                ComponentSection(
                    id: "numbers",
                    elements: [
                        NumberComponent(number: 1),
                        NumberComponent(number: 3),
                        NumberComponent(number: 2),
                        
                    ]
                )

            ])
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.adapter.setSections([
                
                ComponentSection(
                    id: "title",
                    elements: [
                        TitleComponent(title: "World"),
                       
                        NumberComponent(number: 1),
                    ]
                ),

                ComponentSection(
                    id: "numbers",
                    elements: [
                        TitleComponent(title: "Hello"),
                        NumberComponent(number: 3),
                        NumberComponent(number: 2),
                    ]
                )

            ])
        }
         */
    }
}

#Preview {
    DiffSectionViewController()
}
