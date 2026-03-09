// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TurboListKit",
    platforms: [.iOS(.v15)], // iOS 15 이상 지원
    products: [
        // 임포트할 수 있는 모듈을 가진 product
        .library(name: "TurboListKit",
                 targets: ["TurboListKit"]),
        
        // 실행파일(터미널에서 돌아가는 프로그램 구현 시 사용)
        // .executable(name: <#T##String#>, targets: <#T##[String]#>)
    ],
    
    // 의존성
    dependencies: [
        // swift package manager에서 dooc명령어를 터미널에서 쓸수있게 해주는 플러그인
        // - spm 라이브러리와 실행파일들을 위해 문서를 빌드해주는 커맨드를 제공
        // - 터미널에서 swift package 명령어로 문서를 생성할 수 있다
        // - 생성한 문서파일은 dooc 아카이브 파일로 저장된다

        /*
         [실행법 1]
         swift package generate-documentation
         swift package는 macos에서 돌아가기떄문에 platform에 macos추가해야함
         
         [실행법 2]
         xcodebuild docbuild \
           -workspace TurboListKit.xcworkspace \
           -scheme TurboListKit-Demo \
           -destination 'generic/platform=iOS'
         
         //
         xcodebuild docbuild \
           -workspace TurboListKit.xcworkspace \
           -scheme TurboListKit \
           -destination 'generic/platform=iOS'
         
         # 1️⃣ DocC archive 생성
         xcodebuild docbuild \
         -workspace TurboListKit.xcworkspace \
         -scheme TurboListKit \
         -destination 'generic/platform=iOS' \
         -derivedDataPath .build

         # 2️⃣ Static Hosting 변환
         xcrun docc process-archive transform-for-static-hosting \
         .build/Build/Products/Debug-iphoneos/TurboListKit.doccarchive \
         --output-path ./docs \
         --hosting-base-path TurboListKit
         */
        .package(url: "https://github.com/apple/swift-docc-plugin",
                 branch: "main"),
        
        .package(
            url: "https://github.com/ra1028/DifferenceKit",
            from: "1.3.0"
        ),
        
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
    ],
    targets: [
        // 별도로 빌드할 소스 위치를 명시하지 않음
        // 자동으로 Sources/TurboListKit/소스파일들을 빌드한다
        .target(name: "TurboListKit",
                dependencies: ["DifferenceKit",
                               .product(name: "Algorithms", package: "swift-algorithms")
                              ]
        ),
        .testTarget(name: "TurboListKitTests",
                    dependencies: ["TurboListKit"]
        ),
    ]
)

