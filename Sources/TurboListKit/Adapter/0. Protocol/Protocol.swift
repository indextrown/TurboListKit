//
//  File.swift
//  TurboListKit
//
//  Created by 김동현 on 3/8/26.
//

/**
 `CellDataModel`
 - Cell에 바인딩되는 데이터
 - 참고: 토스에서는 명칭을 CellItemModelType
 
 `CellDataModelBindable`
 - CellDataModel를 셀 구현체에 바인딩할 수 있는 프로토콜
 - 참고: 토스에서는 명칭을 CellItemModelBindable
 
 `SampleCellModel`: CellDataModel, FlowSizable
 - 셀 데이터 모델
 - 참고: 토스에서는 ListRowModel: CellItemModelType, FlowSizable
 
 `SampleCell`: BaseCell, CellDataModelBindable
 - 셀 구현체
 - 참고: 토스에서는 ListRow: BaseView, CellDataModelBindable
 
 */

import UIKit

extension UICollectionViewCell {}

/// 터치 가능 여부
public protocol Touchable {}
extension Touchable where Self: UIView {
    @MainActor
    func touchableAreaTap(_ action: @escaping () -> Void) {
        self.onTap(action)
    }
}

/// 버튼 존재 여부
public protocol ContainsButton {
    
}

/// 셀 데이터 타입
/// CollectionViewCell의 프로토콜
/// Model → 어떤 Cell을 사용할지 알고 있음
public protocol CellDataModel: Hashable {
    nonisolated static var cellType: UICollectionViewCell.Type { get }
}

public extension Component {
    // TitleComponent.cellType
    // → ContainerCell<TitleComponent>
    nonisolated static var cellType: UICollectionViewCell.Type {
        ContainerCell<Self>.self
    }
}

/// 셀 사이즈 계산 책임
public protocol FlowSizable {
    @MainActor
    func size(cellSize: CGSize) -> CGSize
}

/// CellModel을 바인딩할 수 있는 프로토콜 셀을 실제 셀 UI에 연결해서 화면에 그려주는 작업
public protocol CellDataModelBindable {
    @MainActor
    func bind(to cellDataModel: any CellDataModel, context: Context)
}

/// 공통 베이스 셀
open class BaseCell: UICollectionViewCell {
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
}

// MARK: - Component
public struct Context {
    public let indexPath: IndexPath
    // public let containerSize: CGSize
}

// MARK: - Data + Render
public protocol Component: CellDataModel, FlowSizable {
    associatedtype CellUIView: UIView
    
    @MainActor
    func createCellUIView() -> CellUIView
    
    @MainActor
    func render(context: Context, content: CellUIView)
}

class ContainerCell<C>: UICollectionViewCell, CellDataModelBindable where C: Component {
    
    private var content: C.CellUIView?
    
    static var reuseIdentifier: String {
        "\(Self.self)_\(C.self)"
    }
    
    func bind(to cellDataModel: any CellDataModel, context: Context) {
        guard let component = cellDataModel as? C else {
            assertionFailure("Component 타입이 아닙니다.")
            return
        }
        
        // view 최초 생성
        content = content ?? component.createCellUIView()
        guard let content else { return }
        
        if content.superview == nil {
            content.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(content)
            
            NSLayoutConstraint.activate([
                content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                content.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                content.topAnchor.constraint(equalTo: contentView.topAnchor),
                content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }
        
        // Component render
        component.render(context: context, content: content)
    }
}

