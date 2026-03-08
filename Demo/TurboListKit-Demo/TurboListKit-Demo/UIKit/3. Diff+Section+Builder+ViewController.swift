//
//  TestViewController.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/6/26.
//

import UIKit
import TurboListKit

final class Diff_Section_Builder_ViewController2: UIViewController {
    
    let collectionView = UICollectionView(
        scrollDirection: .vertical,
        lineSpacing: 10,
        interitemSpacing: 10
    )
    
    lazy var adapter = DiffSectionCollectionViewAdapter(
        collectionView: collectionView,
        animated: true
    )

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
        adapter.sections {
            
            // section0
            ComponentSection(
                id: "title0",
                elements: [
                    TitleComponent(title: "기본")
                        .onTouch {
                            print("테스트1")
                        }
                ]
            )
            
            // section1
            ComponentSection(id: "title1") {
                TitleComponent(title: "Hello")
                TitleComponent(title: "World")
            }
            
            // section2
            Section("title2") {
                TitleComponent(title: "A1")
            }
            
            // section3
            Section("title3") {
                For(of: 0..<300) { index in
                    TitleComponent(title: "기본: \(index)")
                        .onTouch {
                            print("테스트1")
                        }
                }
            }
        }
    }
}

#Preview {
    Diff_Section_Builder_ViewController2()
}

// 헤더를 지금 기본으로 만들어버리는데 해더도 컴포넌트로 만들수있게어떄 
