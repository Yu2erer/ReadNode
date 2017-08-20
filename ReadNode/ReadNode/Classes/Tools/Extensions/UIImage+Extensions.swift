//
//  NTUIImage+Extensions.swift
//  图像的优化
//
//  Created by ntian on 2017/3/1.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 创建头像图像
    ///
    /// - Parameters:
    ///   - size: 尺寸
    ///   - backColor: 背景颜色
    ///   - lineColor: 线条颜色
    ///   - lineWidth: 线条宽度
    /// - Returns: 裁切后的图像
    func nt_acatarImage(size: CGSize?, backColor: UIColor = UIColor.white, lineColor: UIColor = UIColor.lightGray, lineWidth: CGFloat = 1) -> UIImage? {
        
        // 判断 size 是否为空 若为空 则以图像大小为准
        var size = size
        if size == nil {
            size = self.size
        }
        
        let rect = CGRect(origin: .zero, size: size!)
        // 1.图像的上下文 - 内存中开辟一个地址 跟屏幕无关
        /**
         1> size: 绘图的尺寸
         2> 不透明: false = 透明/ true = 不透明
         3> scale: 屏幕分辨率 如果不指定，生成的图像使用 1.0 分辨率
         可以指定 0 会根据当前设备的屏幕分辨率
         */
        // 上下文开启
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        // 设置背景填充颜色
        backColor.setFill()
        UIRectFill(rect)
        
        // 实例化一个圆形路径
        let path = UIBezierPath(ovalIn: rect)

        // 路径裁切
        path.addClip()
        // 绘图 drawInRect 在指定区域内拉伸屏幕
        draw(in: rect)
        // 绘制内切的圆形边线
        path.lineWidth = lineWidth
        lineColor.setStroke()
        path.stroke()
        // 获取结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return result
    }
    
    /// 生成指定大小的不透明图像
    ///
    /// - Parameters:
    ///   - size: 尺寸
    ///   - backColor: 背景颜色
    /// - Returns: 图像
    func nt_image(size: CGSize?, backColor: UIColor = UIColor.white) -> UIImage? {
        
        var size = size
        if size == nil {
            size = self.size
        }
        let rect = CGRect(origin: .zero, size: size!)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        backColor.setFill()
        UIRectFill(rect)
        draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    /// 生成相应颜色的图片
    ///
    /// - Parameter color: 颜色
    /// - Returns: 图像
    func imageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage
    }
    
}
