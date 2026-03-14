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
        adapter.apply {
            
            // example 1
            Section("id2") {
                Header(title: "Header")
                
                for idx in 0..<3 {
                    NumberComponent(number: idx)
                        .onTouch { print("Hello Turbo!") }
                }
                
                Footer(title: "Footer")
            }
            .list(spacing: 10)
            .padding(.horizontal, 20)
            .spacingAfter(20)
            
            // example 2
            Section("id3") {
                Header(title: "Header")
                For(of: 0..<4) { idx in
                    CellComponent(number: idx)
                        .onTouch { print("\(idx) touched") }
                }
                Footer(title: "Footer")
            }
            .grid(columns: 2, vSpacing: 20, hSpacing: 20)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    TurboListAdapterDSLVC2()
}
