//
//  TestViewController.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/6/26.
//

import UIKit
import TurboListKit

final class TurboListAdapterDSLVC: UIViewController {

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
    
    let collectionView = UICollectionView(scrollDirection: .vertical)
    
    lazy var adapter = TurboListAdapter(
        collectionView: collectionView,
        animated: true
    )
    
    // Component는 사용자 정의 UI
    func setupAdapter() {
        adapter.setSections {
            /*
            // example 1
            TurboSection("id2") {
                for idx in 0..<3 {
                    NumberComponent(number: idx)
                        .padding(h: 20)
                        .padding(b: 10)
                }
            }
            .header { HeaderComponent(title: "Header").padding(h: 20) }
            
            
  
            // example 2
            TurboSection("id3") {
                For(of: 0..<3) { idx in
                    NumberComponent(number: idx)
                }
            }
            .padding(h: 20)
            .header { HeaderComponent(title: "Header").padding(h: 20) }
            .footer { FooterComponent(title: "Footer").padding(h: 20) }
            .sectionLayout(.grid(columns: 2,        // 가로 셀 개수
                                 itemSpacing: 10,   // 열 간격
                                 lineSpacing: 10))  // 행 간격
             */
            
//            TurboSection("id4") {
//                For(of: 0..<3) { idx in
//                    NumberComponent(number: idx)
//                }
//            }
//            .header { HeaderComponent(title: "Header") }
//            
//            TurboSection("id5") {
//                For(of: 0..<3) { idx in
//                    NumberComponent(number: idx)
//                }
//            }
//            .header { HeaderComponent(title: "Header") }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

#Preview {
    TurboListAdapterDSLVC()
}














//// example 2
//TurboSection("id3") {
//    For(of: 0..<3) { idx in
//        NumberComponent(number: idx)
//    }
//}
//.padding(h: 20)
//.header { HeaderComponent(title: "Header").padding(h: 20) }
//.footer { FooterComponent(title: "Footer").padding(h: 20) }
//.sectionLayout(.grid(columns: 2,        // 가로 셀 개수
//                     itemSpacing: 10,   // 열 간격
//                     lineSpacing: 10))  // 행 간격







//// section1
//TurboSection(
//    id: "id1",
//    header: HeaderComponent(title: "Header"),
//    footer: FooterComponent(title: "Footer"),
//    items: [
//        NumberComponent(number: 1),
//        NumberComponent(number: 2),
//        NumberComponent(number: 3)
//            .onTouch { print("Touched") }
//        ,
//        
//    ]
//),

//            TurboSection("id2") {
//                For(of: 0..<300) { index in {
//                    NumberComponent(number: index)
//                }
//            }
//            .sectionLayout(.grid(columns: 2))
//            .header { HeaderComponent(title: "") }
//            .footer { FooterComponent(title: "") }
