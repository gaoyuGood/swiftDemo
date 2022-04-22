//
//  GradientView.swift
//
//
//  Created by *** on 19/2/21.
//  Copyright © 2021 ***. All rights reserved.
//

import UIKit

enum EnumDirection {
    case upDown
    case downUp
    case leftRight
    case rightLeft
}

class GradientView: UIView {

    var gradientView:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GradientView {
    
    public func setupWhiteGradientView(_ direction: EnumDirection = .upDown) {
        
        let color1:CGColor = UIColor(white: 1, alpha: 0).cgColor
        let color101:CGColor = UIColor(white: 1, alpha: 0.05).cgColor
        let color102:CGColor = UIColor(white: 1, alpha: 0.1).cgColor
        let color103:CGColor = UIColor(white: 1, alpha: 0.15).cgColor
        let color104:CGColor = UIColor(white: 1, alpha: 0.2).cgColor
        let color105:CGColor = UIColor(white: 1, alpha: 0.3).cgColor
        let color106:CGColor = UIColor(white: 1, alpha: 0.4).cgColor
        let color107:CGColor = UIColor(white: 1, alpha: 0.5).cgColor
        let color108:CGColor = UIColor(white: 1, alpha: 0.65).cgColor
        let color109:CGColor = UIColor(white: 1, alpha: 0.8).cgColor
        let color2:CGColor = UIColor(white: 1, alpha: 0.3).cgColor
        let color3:CGColor = UIColor(white: 1, alpha: 0.83).cgColor
        let color4:CGColor = UIColor(white: 1, alpha: 0.86).cgColor
        let color5:CGColor = UIColor(white: 1, alpha: 0.89).cgColor
        let color6:CGColor = UIColor(white: 1, alpha: 0.93).cgColor
        let color7:CGColor = UIColor(white: 1, alpha: 0.95).cgColor
        let color8:CGColor = UIColor(white: 1, alpha: 0.96).cgColor
        let color9:CGColor = UIColor(white: 1, alpha: 0.97).cgColor
        let color10:CGColor = UIColor(white: 1, alpha: 0.98).cgColor
        let color11:CGColor = UIColor(white: 1, alpha: 1).cgColor
        
        gradientView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        gradientView?.backgroundColor = UIColor.clear
        gradientView?.isUserInteractionEnabled = false
        layer.masksToBounds = true
        
        var colorsArr: [CGColor] = []
        
        switch direction {
        case .upDown, .downUp:
            colorsArr = [color1,color2,color3,color4,color5,color6,color7,color8,color9,color10,color11]
        case .leftRight, .rightLeft:
            colorsArr = [color1,color101,color102,color103,color104,color105,color106,color107,color108,color109,color11]
        }
        
        let gradientLayer: CAGradientLayer = setupGradientLayerWithColors(colorsArr, direction)

        gradientView?.layer.addSublayer(gradientLayer)
        
        addSubview(gradientView ?? UIView())
    }
    
    func setupGradientLayerWithColors(_ colors:[CGColor], _ direction: EnumDirection = .upDown) -> CAGradientLayer {
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
//        var locationsArr: [NSNumber] = []
//        for (i, _) in colors.enumerated() {
//            locationsArr.append(NSNumber(value: Double(i) / Double(colors.count-1)))
//        }
//        gradientLayer.locations = locationsArr
        
        switch direction {
        case .upDown:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        case .downUp:
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        case .leftRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        case .rightLeft:
            gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        }
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
        return gradientLayer
    }
}
