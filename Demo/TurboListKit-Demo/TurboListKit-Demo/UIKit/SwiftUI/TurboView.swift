//
//  TurboView.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/14/26.
//

import SwiftUI
import TurboListKit

struct TurboView: View {
    var body: some View {
        VStack {
            Text("Hello Turbo!")
            
            TitleComponent(title: "123")
                .onTouch {
                    print("Touched")
                }
                
            NumberComponent(number: 1)
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    TurboView()
}


