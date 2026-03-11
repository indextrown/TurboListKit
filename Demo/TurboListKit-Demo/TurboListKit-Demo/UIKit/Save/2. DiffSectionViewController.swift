//
//  TestViewController.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/6/26.
//

/*
import UIKit
import TurboListKit
import SwiftUICore

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
             collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             collectionView.topAnchor.constraint(equalTo: view.topAnchor),
             collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
         ])
     }
    
    func setupAdapter() {
 
        adapter.setSections([
            // section1
            ComponentSection(id: "title1") {
                TitleComponent(title: "Hello")
                TitleComponent(title: "World")
            },
            
            // section2
            Section("title2") {
                TitleComponent(title: "A1")
            },
            
            // section3
            Section("title3") {
                For(of: 1...5) { index in
                    TitleComponent(title: "기본")
                        .onTouch {
                            print("테스트1")
                        }
                }
            },
            
            // section4
            ComponentSection(
                id: "title4",
                elements: [
                    TitleComponent(title: "기본")
                        .onTouch {
                            print("테스트1")
                        },
                    
                    TitleComponent(title: ".padding(left: 50)")
                        .padding(left: 50)
                        .onTouch {
                            print("테스트2")
                        },
                        
                    TitleComponent(title: ".padding(right: 50)")
                        .padding(right: 50)
                        .onTouch {
                            print("테스트3")
                        },
                    
                    TitleComponent(title: ".padding(vertical: 0)")
                        .padding(vertical: 0)
                        .onTouch {
                            print("테스트4")
                        },
                    
                    TitleComponent(title: ".padding(horizontal: 50)")
                        .padding(left: 50)
                        .padding(right: 50)
                        .padding(horizontal: 50)
                        .onTouch {
                            print("테스트5")
                        }
                ]
            ),
        ])

        
        // MARK: - SectionBuilder
        /*
        adapter.setSections(
            sections {
                Section("A") {
                    TitleComponent(title: "A1")
                }

                Section("B") {
                    TitleComponent(title: "B1")
                }
            }
        )
         */
    }
}

#Preview {
    DiffSectionViewController()
}

/*
 ComponentSection(
     id: "numbers",
     elements: [
         TitleComponent(title: "기본")
             .onTouch {
                 print("테스트1")
             },
         
         TitleComponent(title: ".padding(left: 50)")
             .padding(left: 50)
             .onTouch {
                 print("테스트2")
             },
             
         TitleComponent(title: ".padding(right: 50)")
             .padding(right: 50)
             .onTouch {
                 print("테스트3")
             },
         
         TitleComponent(title: ".padding(vertical: 0)")
             .padding(vertical: 0)
             .onTouch {
                 print("테스트4")
             },
         
         TitleComponent(title: ".padding(horizontal: 50)")
             .padding(horizontal: 50)
             .onTouch {
                 print("테스트5")
             }
     ]
 )
 */


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


/*
ComponentSection(
    id: "numbers",
    elements: [
        NumberComponent(number: 1)
            .onTouch {
                print("테스트1")
            },
        
        NumberComponent(number: 2)
            .padding(left: 50)
            .onTouch {
                print("테스트2")
            },
            
        NumberComponent(number: 3)
            .padding(right: 50)
            .onTouch {
                print("테스트3")
            },
        
        NumberComponent(number: 4)
            .padding(vertical: 0)
            .onTouch {
                print("테스트4")
            },
        
        NumberComponent(number: 5)
            .padding(left: 50)
            .padding(right: 50)
            .padding(horizontal: 50)
            .onTouch {
                print("테스트5")
            }
    ]
)
 */
*/
