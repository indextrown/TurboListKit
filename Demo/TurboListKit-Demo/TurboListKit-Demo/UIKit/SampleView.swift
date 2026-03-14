//
//  SampleView.swift
//  TurboListKit-Demo
//

import SwiftUI
import TurboListKit

struct SampleView: View {
    typealias Section = TurboSection
    var body: some View {

        TurboList {
            Section("id1") {

                Header(title: "Header")
                for idx in 0..<1000 {
                    NumberComponent(number: idx)
                        .onTouch {
                            print("\(idx) tapepd!!")
                        }
                }
                Footer(title: "Footer")
            }
            .grid(columns: 1, spacing: 10)
            .spacingAfter(10)

        }
        .padding(10)
    }
}

#Preview {
    SampleView()
}

