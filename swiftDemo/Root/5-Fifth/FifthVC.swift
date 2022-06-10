//
//  FifthVC.swift
//  swiftDemo
//
//  Created by *** on 2022/4/22.
//

import UIKit
import SwiftUI

class FifthVC: BaseViewController, HadTabBarProtocol, NoneNavigationBarProtocol, NoneInteractivePopGestureProtocol {
    
    private lazy var visual: UIVisualEffectView = {

        let visual = UIVisualEffectView(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: getNaviHeight()))
        let effect = UIBlurEffect(style: .light)
        visual.effect = effect
        visual.alpha = 0.98
        visual.layer.shadowColor = UIColor(hex: "000000").cgColor
        visual.layer.shadowOffset = CGSize(width: 0, height: frameMath(2.5))
        visual.layer.shadowOpacity = 0.08

        return visual
    }()
    private lazy var naviBar: UIView = {
        
        let naviBar = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: getNaviHeight()))
        
        naviBar.addSubview(naviTitle)
        
        naviTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(naviBar.snp.centerX)
            make.centerY.equalTo(naviBar.snp.bottom).offset(-22)
        }
        
        return naviBar
    }()
    lazy var naviTitle: UILabel = {
        let naviTitle = UILabel()
        naviTitle.textColor = UIColor.black
        naviTitle.font = UIFont.customFont(name: .RobotoMedium, size: 20)
        naviTitle.text = "Fifth"
        return naviTitle
    }()
    
    private lazy var fifthViewVC: UIViewController = {
        let fifthViewVC = UIHostingController(rootView: FifthView())
        fifthViewVC.view.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH-getTabBarHeight())
        fifthViewVC.view.backgroundColor = UIColor(hex: "#F8F8F8")
        return fifthViewVC
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(fifthViewVC.view)
        
        view.addSubview(visual)
        view.addSubview(naviBar)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}




