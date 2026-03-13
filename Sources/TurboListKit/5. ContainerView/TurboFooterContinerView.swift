//
//  TurboFooterContinerView.swift
//  
//
//  Created by 김동현 on 3/13/26.
//

import UIKit

/*
 FooterUI와 Section Spacing을 분리하는 래퍼 뷰입니다
 footerHeight = 40
 spacingAfter = 20
 UICollectionReusableView height = 60
 
 UI는 40만 사용하므로 wrapper구현
 */
final class TurboFooterContinerView: UICollectionReusableView {
    private let containerView = UIView()    /// 실제 ui영역
    private var contentViewRef: UIView?     /// 사용자가 만든 FooterView
    private var contentHeight: CGFloat = 0  /// footer UI 높이 = UICollectionReusableViewHeight - spacingAfter = 60 - 20 = 40
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setContent(view: UIView, heigt: CGFloat) {
        contentViewRef?.removeFromSuperview()
        contentViewRef = view
        contentHeight = heigt
        containerView.addSubview(view)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /*
         ReusableView height = 60
         contentHeight = 40
         
         ==> containerView height = 40
         */
        containerView.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.width,
            height: contentHeight
        )
        
        // footerview크기 = 40 height
        contentViewRef?.frame = containerView.bounds
    }
}
