//
//  TestViewController.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/6/26.
//

import UIKit
import TurboListKit

final class TurboListAdapterDSLVC2: UIViewController {

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
        typealias Section = TurboSection
        adapter.setSections {
            
            // ex1)
            Section("id1") {
                Header(title: "Header")
                
                NumberComponent(number: 1)
                NumberComponent(number: 2)
            }
            .list(spacing: 5)
            .paddingHorizontal(10)
            .spacingAfter(20)
            
            // ex2)
            Section("id2") {
                Header(title: "Header")
                
                for idx in 0..<6 {
                    NumberComponent(number: idx)
                }
                
                Footer(title: "Footer")
            }
            .grid(columns: 2, vSpacing: 10, hSpacing: 10)
            .paddingHorizontal(10)
        }
    }
    
    
    
    
/*
 // ex0)
 TurboSection(
     id: "id2",
     layout: .grid(columns: 3),         // optional
     header: Header(title: "Header"),   // optional
     footer: Footer(title: "Footer"),   // optional
     items: [
         NumberComponent(number: 1),
         NumberComponent(number: 2),
         NumberComponent(number: 3),
     ]
 )
 .paddingHorizontal(10)
 .spacingAfter(20)

 // ex1)
 Section("id1") {
     Header(title: "Header")
     
     NumberComponent(number: 1)
     NumberComponent(number: 2)
     
     Footer(title: "Footer")
 }
 .list(spacing: 5)
 .paddingHorizontal(10)
 .spacingAfter(20)
 
 // ex2)
 Section("id2") {
     Header(title: "Header")
     
     for idx in 0..<6 {
         NumberComponent(number: idx)
     }
     
     Footer(title: "Footer")
 }
 .grid(columns: 2, vSpacing: 10, hSpacing: 10)
 .paddingHorizontal(10)
 */
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

#Preview {
    TurboListAdapterDSLVC2()
}























/*
 TurboSection("id1") {
     NumberComponent(number: 1)
     NumberComponent(number: 2)
 }
 .header { HeaderComponent(title: "Header") }
 .footer { FooterComponent(title: "Footer") }
 .spacingAfter(20)
 
 TurboSection("id2") {
     NumberComponent(number: 1)
     NumberComponent(number: 2)
 }
 .header { HeaderComponent(title: "Header") }
 .footer { FooterComponent(title: "Footer") }
 .grid(columns: 2, spacing: 10)
 .spacingAfter(20)
 
 TurboSection("id3") {
     NumberComponent(number: 1)
     NumberComponent(number: 2)
 }
 .header { HeaderComponent(title: "Header") }
 .footer { FooterComponent(title: "Footer") }
 .grid(columns: 2, spacing: 10)
 .spacingAfter(20)
 */











// DSL 2
//            TurboSection("id1") {
//
//                for idx in 0..<3 {
//                    NumberComponent(number: idx)
//                }
//
//                for idx in 3..<6 {
//                    NumberComponent(number: idx)
//                }
//            }
//            .grid(columns: 2, vSpacing: 10, hSpacing: 10)
//            .header { HeaderComponent(title: "Header") }
//            .footer { FooterComponent(title: "Footer") }
//
//            TurboSection("id2") {
//                NumberComponent(number: 1)
//                NumberComponent(number: 2)
//            }

//            TurboSection("id1") {
//
//                for idx in 0..<3 {
//                    NumberComponent(number: idx)
//                }
//
//                for idx in 3..<6 {
//                    NumberComponent(number: idx)
//                }
//            }
//            .grid(columns: 2, vSpacing: 10, hSpacing: 10)
//            .header { HeaderComponent(title: "Header") }
//            .footer { FooterComponent(title: "Footer") }


