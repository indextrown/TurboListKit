//
//  ContentView.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/5/26.
//

import UIKit
import SwiftUI
import TurboListKit

struct ContentView: View {
    var body: some View {
        
        NavigationStack {
            List {
                Section("UIKit") {
                    NavigationLink("List") {
                        TurboListVC.toSwiftUI(withNavigation: false)
                            // .toolbar(.hidden, for: .navigationBar)
                    }
                    
                    NavigationLink("Header Footer Spacer") {
                        TurboListHeaderFooterSpacerVC.toSwiftUI(withNavigation: false)
                            // .toolbar(.hidden, for: .navigationBar)
                    }
                    
                    NavigationLink("Shuffle") {
                        ShuffleVC.toSwiftUI(withNavigation: false)
                            // .toolbar(.hidden, for: .navigationBar)
                            // .preferredColorScheme(.dark)
                    }
                }
                
                Section("SwiftUI") {
                    NavigationLink("TurboCompont Can be used in SwiftUI") {
                        TurboView()
                            // .toolbar(.hidden, for: .navigationBar)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
