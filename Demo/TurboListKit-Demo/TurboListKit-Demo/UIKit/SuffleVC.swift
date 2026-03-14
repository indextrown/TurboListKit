//
//  SuffleVC.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/14/26.
//

import UIKit
import TurboListKit

final class ShuffleVC: UIViewController {
    private var numbers = Array(0..<16)
    let collectionView = UICollectionView(scrollDirection: .vertical)
    lazy var adapter = TurboListAdapter(
        collectionView: collectionView,
        animated: true
    )
    
    private lazy var shuffleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Shuffle", for: .normal)
        button.addTarget(self, action: #selector(shuffleTapped), for: .touchUpInside)
        return button
    }()
    
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
        
        view.addSubview(shuffleButton)
        view.addSubview(collectionView)
        
        shuffleButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            shuffleButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            shuffleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shuffleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -250)
        ])
    }
    
    private func setupAdapter() {
        typealias Section = TurboSection
        
        adapter.apply {
            
            Section("id1") {
                Header(title: "Header")
                for number in numbers {
                    CellComponent(number: number)
                        .onTouch {
                            print("\(number) tapped!")
                        }
                }
                Footer(title: "Footer")
            }
            .grid(columns: 4, spacing: 10)
        }
    }
    
    @objc
    private func shuffleTapped() {
        numbers.shuffle()
        setupAdapter()
    }
    
    @objc
    private func deleteRandom() {

        guard !numbers.isEmpty else { return }

        let index = Int.random(in: 0..<numbers.count)
        let removed = numbers.remove(at: index)

        print("삭제:", removed)
        print(numbers)

        setupAdapter()
    }
    
    @objc
    private func insertFront() {

        let newValue = (numbers.max() ?? 0) + 1

        numbers.insert(newValue, at: 0)

        print("추가:", newValue)
        print(numbers)

        setupAdapter()
    }
}

#Preview {
    ShuffleVC()
}


//
//DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//    self.adapter.apply {
//        
//        Section("id1") {
//            Header(title: "Header")
//            for number in self.numbers.reversed() {
//                CellComponent(number: number)
//                    .onTouch { print("Hello Turbo!") }
//            }
//            Footer(title: "Footer")
//        }
//        .grid(columns: 4, spacing: 10)
//    }
//}
