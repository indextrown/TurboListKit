//
//  ContentView.swift
//  DemoApp
//
//  Created by 김동현 on 4/25/26.
//

import SwiftUI

struct ContentView: View {
    private enum Destination: String, CaseIterable, Identifiable {
        case autoLayoutSample
        case demo
        case sample

        var id: String { rawValue }

        var title: String {
            switch self {
            case .autoLayoutSample:
                return "AutoLayoutSampleViewController"
            case .demo:
                return "DemoViewController"
            case .sample:
                return "SampleViewController"
            }
        }

        var subtitle: String {
            switch self {
            case .autoLayoutSample:
                return "컴포넌트 내부를 오토레이아웃으로 구성한 예제"
            case .demo:
                return "TurboListKit 데모 화면"
            case .sample:
                return "새 화면 작업용 기본 틀"
            }
        }
    }

    var body: some View {
        NavigationStack {
            List(Destination.allCases) { destination in
                NavigationLink(value: destination) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(destination.title)
                            .font(.headline)
                        Text(destination.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Demo App")
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .autoLayoutSample:
                    AutoLayoutSampleViewController()
                        .toSwiftUI()
                        .ignoresSafeArea()
                case .demo:
                    DemoViewController()
                        .toSwiftUI()
                        .ignoresSafeArea()
                case .sample:
                    SampleViewController()
                        .toSwiftUI(hideNavigationBar: false)
                        .ignoresSafeArea()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
