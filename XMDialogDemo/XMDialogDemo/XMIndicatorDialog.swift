//
//  XMIndicatorDialog.swift
//  XMDialogDemo
//
//  Created by Jejay on 17/3/27.
//  Copyright © 2017年 jejay. All rights reserved.
//

import UIKit

// 等待对话框。上面一个等待动画，下面一个文本提示
class XMIndicatorDialog: UIView {
    
    private static let _animDuration: NSTimeInterval = 0.3
    private static let _rootViewBg: UIColor = UIColor(white: 0, alpha: 0.5)
    private var _window: UIWindow?
    private lazy var msgLable: UILabel = {
        let msgLable = UILabel()
        msgLable.font = UIFont.systemFontOfSize(15)
        msgLable.textColor = UIColor.whiteColor()
        msgLable.numberOfLines = 1
        msgLable.textAlignment = .Center
        return msgLable
    }()
    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        return indicatorView
    }()
    var message: String? {
        didSet{
            self.msgLable.text = self.message
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        layer.cornerRadius = 10
        addSubview(indicatorView)
        addSubview(msgLable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let uiScreenSize = UIScreen.mainScreen().bounds.size
        let screenWidth = uiScreenSize.width
        let screenHeight = uiScreenSize.height
        
        let indicatorSize = indicatorView.intrinsicContentSize()
        let labelSize = msgLable.intrinsicContentSize()
        
        let indicatorY: CGFloat = 20
        let indicatorAndLabelSplit: CGFloat = 10
        let height = indicatorY + indicatorSize.height + indicatorAndLabelSplit + labelSize.height + 15
        let width = max(height * 1.1, indicatorSize.width + indicatorY*2)
        
        self.frame = CGRectMake((screenWidth - width) / 2, (screenHeight - height) / 2, width, height)
        indicatorView.frame = CGRectMake((width - indicatorSize.width) / 2, indicatorY, indicatorSize.width, indicatorSize.height)
        msgLable.frame = CGRectMake(10, indicatorY + indicatorSize.height + indicatorAndLabelSplit, width - 10*2, labelSize.height)
    }
    
    /** 显示方法，调用该方法，这个界面将显示 **/
    func show(){
        let window = UIWindow()
        self._window = window
        window.frame = UIScreen.mainScreen().bounds
        window.backgroundColor = UIColor.clearColor()
        window.windowLevel = UIWindowLevelAlert
        window.alpha = 1
        window.hidden = false
        window.addSubview(self)
        
        statusShowBefore()
        UIView.animateWithDuration(XMIndicatorDialog._animDuration,
                                   animations:{ _ in self.statusShowing() } )
    }
    
    /** 消失方法，调用该方法，这个界面将消失 **/
    func dismiss(){
        UIView.animateWithDuration(XMIndicatorDialog._animDuration,
                                   animations: {  _ in self.statusDismiss() },
                                   completion: { _ in self.removeWindowAction() } )
    }
    
    private func removeWindowAction(){
        removeFromSuperview()
        if let window = _window {
            window.hidden = true
            window.resignKeyWindow()
        }
        _window = nil
    }
    
    private func statusShowBefore(){
        indicatorView.startAnimating()
        alpha = 0
        transform = CGAffineTransformMakeScale(0.7, 0.7)
    }
    
    private func statusShowing() {
        _window?.backgroundColor = XMIndicatorDialog._rootViewBg
        alpha = 1
        transform = CGAffineTransformMakeScale(1, 1)
    }
    
    private func statusDismiss(){
        _window?.backgroundColor = UIColor.clearColor()
        alpha = 0
        transform = CGAffineTransformMakeScale(0.7, 0.7)
        indicatorView.stopAnimating()
    }
    
    deinit {
        print("XMIndicatorDialog:\(hash) is deinit ")
    }
}

// 考虑到可能同时存在多个HUD，引入控制工具提供控制，一个控制工具管理一个HUD对象
class XMIndicatorDialogUtils: NSObject{

    private weak var _dialog: XMIndicatorDialog?
    private var _disposable: XMDisposable? {
        didSet{
            oldValue?.dispose()
        }
    }
    
    // 延迟显示对话框，延迟时间为单位为：秒，message 为 nil 时显示 "请稍后..."
    func showDialog(message: String? = nil, delay: NSTimeInterval? = nil) {
        if let delay = delay where delay > 0 {
            _disposable = delayerOnMain(delay){ [weak self] in self?.showDialogInner(message) }
        } else {
            showDialogInner(message)
        }
    }
    
    private func showDialogInner(message: String?) {
        let message = message ?? "请稍后..."
        if let view = _dialog {
            if message == view.message{
                return
            }
            view.dismiss()
        }
        let view = XMIndicatorDialog()
        self._dialog = view
        view.message = message
        view.show()
    }
    
    // 取消对话框
    func hideDialog() {
        _disposable = nil
        _dialog?.dismiss()
    }
    
}






