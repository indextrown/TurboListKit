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
        // TestViewController.toSwiftUI()
        // DiffViewController.toSwiftUI()
        // Diff_Section_Builder_ViewController2.toSwiftUI()
        // TurboListAdapterVC.toSwiftUI()
        // TurboListAdapterDSLVC2.toSwiftUI()
        // SampleView()
        // SwiftUIListView2()
        // ShuffleVC.toSwiftUI()
        // ViewController.toSwiftUI()
        
        NavigationStack {
            List {
                Section("UIKit") {
                    NavigationLink("List") {
                        TurboListAdapterDSLVC.toSwiftUI(withNavigation: false)
                    }
                    
                    NavigationLink("Shuffle") {
                        ShuffleVC.toSwiftUI(withNavigation: false)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    NavigationLink("Header Footer Spacer") {
                        TurboListAdapterDSLVC2.toSwiftUI(withNavigation: false)
                    }
                }
                
                Section("SwiftUI") {
                    NavigationLink("SwiftUI") {
                        TurboView()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
