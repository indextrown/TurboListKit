// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TurboListKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "TurboListKit",
                 targets: ["TurboListKit"]),
        
        // 여기추가
    ],
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
         */
        .package(url: "https://github.com/apple/swift-docc-plugin",
                 branch: "main")
    ],
    targets: [
        .target(name: "TurboListKit"),
        .testTarget(name: "TurboListKitTests",
                    dependencies: ["TurboListKit"]
        ),
    ]
)

