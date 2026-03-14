//
//  SwiftUIListView.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/14/26.
//

import SwiftUI

struct SwiftUIListView: View {

    var body: some View {

        ScrollView {

            LazyVStack(spacing: 10) {

                Text("Header")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))

                ForEach(0..<1000, id: \.self) { idx in

                    Text("Number \(idx)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)

                }

                Text("Footer")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))

            }
            .padding(10)

        }
    }
}

#Preview {
    SwiftUIListView()
}

