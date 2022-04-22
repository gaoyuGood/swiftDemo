//
//  DemoTabBar.swift
//  
//
//  Created by *** on 25/1/21.
//  Copyright © 2021 ***. All rights reserved.
//

import UIKit

class DemoTabBar: UIView {

    public var selectedItemSingle:((_ index:Int) -> ())?        //单击
    public var selectedItemDouble:((_ index:Int) -> ())?        //双击
    private var currentIndex:Int = 0                            //当前位置
    
    private let tabBarItemSeparator = kScreenW/5
    private let tabBarItemW = kScreenW/5 - frameMath(4)
    
    private let normalColor = UIColor(hex: "#004E74", alpha: 0.5)
    private let selectedColor = UIColor(hex: "#004E74")
    
    private let titleNormalFont = UIFont.customFontReal(name: CustomFontName.RobotoRegular, size: 10)
    private let titleSelectedFont = UIFont.customFontReal(name: CustomFontName.RobotoBold, size: 10)
    
    // MARK: - 模糊背景
    private lazy var visual: UIVisualEffectView = {

        let visual = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kTabBarH))
        let effect = UIBlurEffect(style: .light)
        visual.effect = effect
        visual.alpha = 0.98

        visual.layer.shadowColor = UIColor(hex: "000000").cgColor
        visual.layer.shadowOffset = CGSize(width: 0, height: -3)
        visual.layer.shadowOpacity = 0.15

        return visual
    }()
    
    // MARK: - First
    private lazy var first: UIView = {
        let first = UIView(frame: CGRect(x: frameMath(2), y: 0, width: tabBarItemW, height: kTabBarH))
        first.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedFirst(_:))))
        first.addSubview(firstIcon)
        first.addSubview(firstTitle)
        return first
    }()
    private lazy var firstIcon: UIImageView = {
        let firstIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        firstIcon.center = CGPoint(x: tabBarItemW/2, y: 18)
        firstIcon.image = UIImage(named: "Tabbar_First_Normal")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        return firstIcon
    }()
    private lazy var firstTitle: UILabel = {
        let firstTitle = UILabel()
        firstTitle.textColor = normalColor
        firstTitle.textAlignment = .center
        firstTitle.font = titleNormalFont
        firstTitle.text = "First"
        return firstTitle
    }()
    
    // MARK: - Second
    private lazy var second: UIView = {
        let second = UIView(frame: CGRect(x: tabBarItemSeparator+frameMath(2), y: 0, width: tabBarItemW, height: kTabBarH))
        second.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedSecond(_:))))
        second.addSubview(secondIcon)
        second.addSubview(secondTitle)
        return second
    }()
    private lazy var secondIcon: UIImageView = {
        let secondIcon = UIImageView(frame: CGRect(x: 0, y: 8, width: 25, height: 20))
        secondIcon.center = CGPoint(x: tabBarItemW/2, y: 18)
        secondIcon.image = UIImage(named: "Tabbar_Second_Normal")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        return secondIcon
    }()
    private lazy var secondTitle: UILabel = {
        let secondTitle = UILabel()
        secondTitle.textColor = normalColor
        secondTitle.textAlignment = .center
        secondTitle.font = titleNormalFont
        secondTitle.text = "Second"
        return secondTitle
    }()
    
    // MARK: - Third
    private lazy var third: UIView = {
        
        let third = UIView(frame: CGRect(x: tabBarItemSeparator*2+frameMath(2), y: 0, width: tabBarItemW, height: kTabBarH))
        third.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedThird(_:))))
        third.addSubview(thirdIcon)
        third.addSubview(thirdTitle)
        
        return third
    }()
    private lazy var thirdIcon: UIImageView = {
        let thirdIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        thirdIcon.center = CGPoint(x: tabBarItemW/2, y: 18)
        thirdIcon.image = UIImage(named: "Tabbar_Third_Normal")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        return thirdIcon
    }()
    private lazy var thirdTitle: UILabel = {
        let thirdTitle = UILabel()
        thirdTitle.textColor = normalColor
        thirdTitle.textAlignment = .center
        thirdTitle.font = titleNormalFont
        thirdTitle.text = "Third"
        return thirdTitle
    }()
    
    // MARK: - Fourth
    private lazy var fourth: UIView = {
        let fourth = UIView(frame: CGRect(x: tabBarItemSeparator*3+frameMath(2), y: 0, width: tabBarItemW, height: kTabBarH))
        fourth.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedFourth(_:))))
        fourth.addSubview(fourthIcon)
        fourth.addSubview(fourthTitle)
        return fourth
    }()
    private lazy var fourthIcon: UIImageView = {
        let fourthIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        fourthIcon.center = CGPoint(x: tabBarItemW/2, y: 18)
        fourthIcon.image = UIImage(named: "Tabbar_Fourth_Normal")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        return fourthIcon
    }()
    private lazy var fourthTitle: UILabel = {
        let fourthTitle = UILabel()
        fourthTitle.textColor = normalColor
        fourthTitle.textAlignment = .center
        fourthTitle.font = titleNormalFont
        fourthTitle.text = "Fourth"
        return fourthTitle
    }()
    
    // MARK: - Fifth
    private lazy var fifth: UIView = {
        
        let fifth = UIView(frame: CGRect(x: tabBarItemSeparator*4+frameMath(2), y: 0, width: tabBarItemW, height: kTabBarH))
        
        fifth.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedFifth(_:))))
        
        let double = UITapGestureRecognizer(target: self, action: #selector(doubleFifth(_:)))
        double.numberOfTapsRequired = 2
        fifth.addGestureRecognizer(double)
        
        fifth.addSubview(fifthIcon)
        fifth.addSubview(fifthTitle)
        
        return fifth
    }()
    private lazy var fifthIcon: UIImageView = {
        let fifthIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        fifthIcon.center = CGPoint(x: tabBarItemW/2, y: 18)
        fifthIcon.image = UIImage(named: "Tabbar_Fifth_Normal")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        return fifthIcon
    }()
    private lazy var fifthTitle: UILabel = {
        let fifthTitle = UILabel()
        fifthTitle.textColor = normalColor
        fifthTitle.textAlignment = .center
        fifthTitle.font = titleNormalFont
        fifthTitle.text = "Fifth"
        return fifthTitle
    }()
    
    
    // MARK: - 生命周期
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(hex: "FFFFFF", alpha: 0.8)
        isUserInteractionEnabled = true
        createRootTabBar()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(changedLanguage), name: LanguageChangedNotification, object: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension DemoTabBar {
    
    // MARK: 初始化视图
    private func createRootTabBar() {
        
        addSubview(visual)
        
        addSubview(first)
        addSubview(second)
        addSubview(third)
        addSubview(fourth)
        addSubview(fifth)
        
        setup_UI()
    }
    
    // MARK: 约束
    private func setup_UI() {
        
        firstTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(first.snp.centerX)
            make.centerY.equalTo(first.snp.top).offset(40)
        }
        secondTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(second.snp.centerX)
            make.centerY.equalTo(firstTitle.snp.centerY)
        }
        thirdTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(third.snp.centerX)
            make.centerY.equalTo(firstTitle.snp.centerY)
        }
        fourthTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(fourth.snp.centerX)
            make.centerY.equalTo(firstTitle.snp.centerY)
        }
        fifthTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(fifth.snp.centerX)
            make.centerY.equalTo(firstTitle.snp.centerY)
        }
    }
    
    // MARK: 选中某个 tabBar
    @objc public func selectedItem(_ index:Int, blockAction:Bool = true) {
        
        if blockAction {
            self.selectedItemSingle?(index)
        }
        
        currentIndex = index
        
        if index != index_first {
            firstIcon.image = UIImage(named: "Tabbar_First_Normal")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            firstTitle.textColor = normalColor
            firstTitle.font = titleNormalFont
        }
        if index != index_second {
            secondIcon.image = UIImage(named: "Tabbar_Second_Normal")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            secondTitle.textColor = normalColor
            secondTitle.font = titleNormalFont
        }
        if index != index_third {
            thirdIcon.image = UIImage(named: "Tabbar_Third_Normal")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            thirdTitle.textColor = normalColor
            thirdTitle.font = titleNormalFont
        }
        if index != index_fourth {
            fourthIcon.image = UIImage(named: "Tabbar_Fourth_Normal")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            fourthTitle.textColor = normalColor
            fourthTitle.font = titleNormalFont
        }
        if index != index_fifth {
            fifthIcon.image = UIImage(named: "Tabbar_Fifth_Normal")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            fifthTitle.textColor = normalColor
            fifthTitle.font = titleNormalFont
        }
        
        switch index {
        case index_first:
            firstIcon.image = UIImage(named: "Tabbar_First_Selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            firstTitle.textColor = selectedColor
            firstTitle.font = titleSelectedFont
        case index_second:
            secondIcon.image = UIImage(named: "Tabbar_Second_Selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            secondTitle.textColor = selectedColor
            secondTitle.font = titleSelectedFont
        case index_third:
            thirdIcon.image = UIImage(named: "Tabbar_Third_Selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            thirdTitle.textColor = selectedColor
            thirdTitle.font = titleSelectedFont
        case index_fourth:
            fourthIcon.image = UIImage(named: "Tabbar_Fourth_Selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            fourthTitle.textColor = selectedColor
            fourthTitle.font = titleSelectedFont
        case index_fifth:
            fifthIcon.image = UIImage(named: "Tabbar_Fifth_Selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            fifthTitle.textColor = selectedColor
            fifthTitle.font = titleSelectedFont
        default:
            break
        }
    }
}

extension DemoTabBar {
    
    @objc private func selectedFirst(_ ges: UITapGestureRecognizer) {
        selectedItem(index_first)
    }
    @objc private func selectedSecond(_ ges: UITapGestureRecognizer) {
        selectedItem(index_second)
    }
    @objc private func selectedThird(_ ges: UITapGestureRecognizer) {
        selectedItem(index_third)
    }
    @objc private func selectedFourth(_ ges: UITapGestureRecognizer) {
        selectedItem(index_fourth)
    }
    @objc private func selectedFifth(_ ges: UITapGestureRecognizer) {
        selectedItem(index_fifth)
    }
}

extension DemoTabBar {
        
    @objc private func doubleFifth(_ ges: UITapGestureRecognizer) {
        print("double click fifth")
    }
}

