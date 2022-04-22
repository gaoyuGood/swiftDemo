//
//  Extension+UIImage.swift
//
//
//  Created by *** on 12/3/21.
//  Copyright © 2021 ***. All rights reserved.
//

import UIKit

//MARK: - 带圆角渐变的矩形图片
extension UIImage {
    enum gradient_direction : Int {
        case left_right = 0
        case up_down = 1
    }
    
    /// 圆角矩形渐变image
    ///
    /// - Parameters:
    ///   - startColor: 开始颜色
    ///   - endColor: 结束颜色
    ///   - rect: 图片rect
    ///   - radius: 图片圆角
    ///   - direction: 变色方向（上下、左右）
    /// - Returns: 渐变image
    class func gradientColor(startColor:UIColor,endColor:UIColor,rect:CGRect,radius:CGFloat,direction:gradient_direction = .left_right) -> UIImage {
        
        //创建CGContextRef
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale);
        let gc:CGContext = UIGraphicsGetCurrentContext()!
        
        //创建CGMutablePathRef
        let path:CGMutablePath = CGMutablePath()
        
        //圆角矩形
        path.move(to: CGPoint(x: rect.minX, y: rect.minY+radius))
        path.addArc(center: CGPoint(x: rect.minX+radius, y: rect.minY+radius), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi)/2*3, clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX-radius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX-radius, y: rect.minY+radius), radius: radius, startAngle: CGFloat(Double.pi)/2*3, endAngle: CGFloat(Double.pi)*2, clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY-radius))
        path.addArc(center: CGPoint(x: rect.maxX-radius, y: rect.maxY-radius), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi)/2, clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX+radius, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX+radius, y: rect.maxY-radius), radius: radius, startAngle: CGFloat(Double.pi)/2, endAngle: CGFloat(Double.pi), clockwise: false)
        path.closeSubpath()
        
        //绘制渐变
        self.drawLinearGradient(context: gc, path: path, startColor: startColor.cgColor, endColor: endColor.cgColor, direction: direction)
        
        //从Context中获取图像，并显示在界面上
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// 矩形渐变image
    ///
    /// - Parameters:
    ///   - startColor: 开始颜色
    ///   - endColor: 结束颜色
    ///   - rect: 图片rect
    ///   - direction: 变色方向（上下、左右）
    /// - Returns: 渐变image
    class func gradientColor(startColor:UIColor,endColor:UIColor,rect:CGRect,direction:gradient_direction = .left_right) -> UIImage {
        
        //创建CGContextRef
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale);
        let gc:CGContext = UIGraphicsGetCurrentContext()!
        
        //创建CGMutablePathRef
        let path:CGMutablePath = CGMutablePath()
        
        //矩形Path
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        
        //绘制渐变
        self.drawLinearGradient(context: gc, path: path, startColor: startColor.cgColor, endColor: endColor.cgColor, direction:direction)
        
        //从Context中获取图像，并显示在界面上
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /** 绘制渐变 */
    private class func drawLinearGradient(context:CGContext,path:CGPath,startColor:CGColor,endColor:CGColor,direction:gradient_direction = .left_right) {
        
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0,1.0]
        let colors:[CGColor] = [startColor,endColor]
        
        let gradiend:CGGradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)!
        let pathRect:CGRect = path.boundingBoxOfPath
        
        //具体方向可根据需求修改
        let point_arr:[CGPoint] = UIImage.GradientDirection(direction: direction, pathRect: pathRect)
        
        context.saveGState()
        context.addPath(path)
        context.clip()
        context.drawLinearGradient(gradiend, start: point_arr[0], end: point_arr[1], options: CGGradientDrawingOptions(rawValue: 0))
        context.restoreGState()
    }
    
    private class func GradientDirection(direction:gradient_direction = .left_right, pathRect:CGRect) -> [CGPoint] {
        
        if direction == .left_right {
            return [CGPoint(x: pathRect.minX, y: pathRect.midY),CGPoint(x: pathRect.maxX, y: pathRect.midY)]
        } else {
            //            direction == .up_down
            return [CGPoint(x: pathRect.midX, y: pathRect.minY),CGPoint(x: pathRect.midX, y: pathRect.maxY)]
        }
    }
    
    public func createRadiusBackgroundImage(rect:CGRect, radius:CGFloat) -> UIImage {
        
        //创建CGContextRef
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale);
        let context:CGContext = UIGraphicsGetCurrentContext()!
        
        //创建CGMutablePathRef
        let path:CGMutablePath = CGMutablePath()
        
        //圆角矩形
        path.move(to: CGPoint(x: rect.minX, y: rect.minY+radius))
        path.addArc(center: CGPoint(x: rect.minX+radius, y: rect.minY+radius), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi)/2*3, clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX-radius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX-radius, y: rect.minY+radius), radius: radius, startAngle: CGFloat(Double.pi)/2*3, endAngle: CGFloat(Double.pi)*2, clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY-radius))
        path.addArc(center: CGPoint(x: rect.maxX-radius, y: rect.maxY-radius), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi)/2, clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX+radius, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX+radius, y: rect.maxY-radius), radius: radius, startAngle: CGFloat(Double.pi)/2, endAngle: CGFloat(Double.pi), clockwise: false)
        path.closeSubpath()
        
        context.saveGState()
        context.addPath(path)
        context.clip()
        self.draw(in: rect)
        context.restoreGState()
        
        //从Context中获取图像，并显示在界面上
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
}

