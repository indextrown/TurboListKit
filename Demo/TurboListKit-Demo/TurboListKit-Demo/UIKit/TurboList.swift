//
//  TurboList.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/14/26.
//

import SwiftUI
import TurboListKit

struct TurboCell: View {
    var number: Int
    
    var body: some View {
        VStack {
            Text("\(number)")
                .font(.system(size: 20, weight: .bold))
            Text("Hello, World!")
        }
        .frame(maxWidth: .infinity)
        .border(.red)
    }
}

struct TurboListView: View {
    
    var body: some View {
        TurboList(spacing: 20) {
            ForEach(0...2, id: \.self) { idx in
                TurboCell(number: idx)
            }
        }
    }
}

#Preview {
    TurboListView()
}
