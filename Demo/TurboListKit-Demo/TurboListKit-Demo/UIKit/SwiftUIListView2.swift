//
//  SwiftUIListView2.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/14/26.
//

import SwiftUI

struct SwiftUIListView2: View {

    var body: some View {

        List {

            Section {

                Text("Header")

                ForEach(0..<1000, id: \.self) { idx in
                    Text("Number \(idx)")
                }

                Text("Footer")

            }

        }
        .listStyle(.plain)
    }
}

#Preview {
    SwiftUIListView2()
}
