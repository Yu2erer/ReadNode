//
//  NTRefreshControl.swift
//  刷新控件
//
//  Created by ntian on 2016/12/21.
//  Copyright © 2016年 ntian. All rights reserved.
//

import UIKit

/// 刷新状态切换临界点
private let NTRefreshOffset: CGFloat = 60

/// 刷新状态
///
/// - Normal: 普通状态 - 什么都不做
/// - Pulling: 超过临界点 如果放手开始刷新
/// - WillRefresh: 用户超过临界点 并且放手
enum NTRefreshState {
    case Normal
    case Pulling
    case WillRefresh
}

/// 刷新控件 
class NTRefreshControl: UIControl {
    
    // MARK: - 属性
    /// 滚动视图的父视图 - 下拉刷新控件应该适用于 UITableView / UICollectionView
    /// 用弱引用是为了防止循环引用 addSubview 是一个强引用
    private weak var scrollView: UIScrollView?
    
    lazy var refreshView: NTRefreshView = NTRefreshView.refreshView()
    
    /// MARK: - 构造函数
    init() {
        super.init(frame: CGRect())
        setupUI()
    }
    
    /// XIB 开发要用的构造函数
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    // willMove addSubview 方法会调用
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        // 判断父视图的类型
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        // 记录父视图
        scrollView = sv
        
        // KVO 监听父视图 contentOffset 
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
        
    }
    // 本视图从父视图上移除
    // 提示：所有的下拉刷新框架都是监听父视图的 contentOffset
    // 所有的框架的 KVO 监听实现思路都是这个
    override func removeFromSuperview() {
        // superView 还存在
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
        // superView 不存在
    }
    
    // 所有 KVO 会统一调用 此方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // contentOffset 的 y值 跟 contentInset 的 top 有关
        //print(scrollView?.contentOffset)
        guard let sv = scrollView else {
            return
        }
        
        // 初始高度就应该是 0
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        
        if height < 0 {
            return
        }
        
        // 可以根据高度 设置 刷新控件的 frame
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
        if refreshView.refreshState == .Normal {
            UIView.animate(withDuration: 0.25) {
                self.alpha = height
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.alpha = 1
            }
        }
        // 判断临界点 - 只需要判断一次
        if sv.isDragging {
            
            if height > NTRefreshOffset && refreshView.refreshState == .Normal {
                refreshView.refreshState = .Pulling
            } else if height <= NTRefreshOffset && refreshView.refreshState == .Pulling {
                refreshView.refreshState = .Normal
            }
        } else {
            if refreshView.refreshState == .Pulling {
                
                beginRefreshing()
                sendActions(for: .valueChanged)
            }
        }
    }
    
    /// 开始刷新
    func beginRefreshing() {
        
//        print("开始")
        // 判断父视图
        guard let sv = scrollView else {
            return
        }
        
        // 判断是否正在刷新 如果正在刷新 直接返回
        if refreshView.refreshState == .WillRefresh {
            return
        }
        // 设置刷新视图状态
        refreshView.refreshState = .WillRefresh
        
        UIView.animate(withDuration: 0.25) {
            var inset = sv.contentInset
            inset.top += NTRefreshOffset
            sv.contentInset = inset
        }
    }
    
    /// 结束刷新
    func endRefreshing() {
        guard let sv = scrollView else {
            return
        }
        // 判断状态 是否正在刷新 如果不是 直接返回
        if refreshView.refreshState != .WillRefresh {
            return
        }
        // 恢复刷新视图的状态
        refreshView.refreshState = .Normal
        // 恢复表格视图的 contentInset
        UIView.animate(withDuration: 0.25) { 
            var inset = sv.contentInset
            inset.top -= NTRefreshOffset
            sv.contentInset = inset
        }

    }
}

private extension NTRefreshControl {
    
    func setupUI() {
        backgroundColor = superview?.backgroundColor
        alpha = 0

        // 添加刷新视图
        addSubview(refreshView)
        // 自动布局
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.height))
    }
}
