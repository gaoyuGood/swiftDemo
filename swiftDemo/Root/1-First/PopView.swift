//
//  PopAlert.swift
//  swiftDemo
//
//  Created by gaoyu on 2022/4/25.
//

import Foundation
import UIKit
import SwiftUI

struct AlertShowModel {
    var iconImage: String
    var title: String
}

class AlertShowView: UIView {
    // Btn包起来的view
    var btnCoverView: UIView!
    // 传入model
    var model: [AlertShowModel] = []
    // 点击事件
    var ensureClick: ((AlertShowModel) -> Void)?
    // 取消点击事件
    var cancelClick: (() -> Void)?
    // 单层的高度
    let itemHeight = 40
    
    
    
    // 设置弹窗的函数
    static func setAlertView(superView:UIView?, model:[AlertShowModel], ensureClick:@escaping (AlertShowModel)->Void, cancelClick:@escaping () -> Void){
        let actionSheetView = AlertShowView()
        actionSheetView.backgroundColor = UIColor(hex: "#000000",alpha: 0.7)
        
        if let superView = superView {
            superView.addSubview(actionSheetView)
            actionSheetView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else{
            let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).last
            window?.addSubview(actionSheetView)
            actionSheetView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        actionSheetView.model = model
        actionSheetView.ensureClick = ensureClick
        actionSheetView.cancelClick = cancelClick
        actionSheetView.addItem()
    }
    
    // 循环渲染item
    func addItem() {
        let totalCount = model.count
        
        btnCoverView = UIView(frame: .zero)
        self.addSubview(btnCoverView)
        
        btnCoverView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(totalCount*itemHeight)
            make.height.equalTo(totalCount*itemHeight)
        }
        
        for (index,item) in model.enumerated() {
            // 初始化button
            let listBtn = UIButton(type: UIButton.ButtonType.custom)
            listBtn.backgroundColor = UIColor.red
            listBtn.setImage(.init(named: item.iconImage), for: .normal)
            listBtn.setTitle(item.title, for: .normal)
            listBtn.tag = index
            listBtn.addTarget(self, action: #selector(click), for: UIControl.Event.touchUpInside)
            
            
            btnCoverView.addSubview(listBtn)
            listBtn.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(-index*itemHeight)
                make.height.equalTo(itemHeight)
            }
        }
        
        popupView()
    }
    
    func popupView(){
        let totalCount = model.count
        btnCoverView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-totalCount*itemHeight)
        }
        UIView.animate(withDuration: 0.3) { [self] in
            btnCoverView.layoutIfNeeded()
        }
    }
    
    @objc func click() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let view = touches.first?.view, view == self.btnCoverView {
            return
        }
        dismissRecognizer()
    }
    
    // 消失事件
    func dismissRecognizer() {
        removeFromSuperview()
    }
}
