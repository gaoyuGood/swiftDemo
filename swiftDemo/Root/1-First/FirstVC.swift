//
//  FirstVC.swift
//  swiftDemo
//
//  Created by *** on 2022/4/22.
//

import UIKit

class FirstVC: BaseViewController, HadTabBarProtocol, NoneNavigationBarProtocol, NoneInteractivePopGestureProtocol {
    
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
        naviTitle.text = "FirstC"
        return naviTitle
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("hello world")
        
        view.backgroundColor = UIColor(hex: "#554433",alpha: 0.5)
        
        view.addSubview(visual)
        view.addSubview(naviBar)
        
        // Codable
        FirstNetService.getCurrentWeatherCodable { (result: Result<CurrentCityWeatherResult, RequestError>) in
            
            switch result {
            case .success(let value):
                print(value.city)
            case .failure(let error):
                print(error.title)
            }
        }
         
        // NSObject
        FirstNetService.getCurrentWeatherNSObject { model in
            
            print(model.city)
        }
        
        //模拟代码
        let alertButton = UIButton(type: .custom)
        alertButton.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        alertButton.backgroundColor = UIColor.gray
        self.view.addSubview(alertButton)
        alertButton.addTarget(self, action: #selector(click), for: UIControl.Event.touchUpInside)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func click(){
        let model : [AlertShowModel] = [
            AlertShowModel(iconImage: "Tabbar_Fourth_Normal", title: "Tabbar_Fourth_Normal"),
            AlertShowModel(iconImage: "Tabbar_Second_Normal", title: "Tabbar_Second_Normal"),
        ]
        AlertShowView.setAlertView(superView: self.view, model: model, ensureClick: {item in
            
        }, cancelClick: {
            
        })
    }
}
