//
//  Utils.swift
//  XMDialogDemo
//
//  Created by Jejay on 17/3/27.
//  Copyright © 2017年 jejay. All rights reserved.
//

import UIKit

protocol XMDisposable: class {
    
    var disposed: Bool { get }
    
    func dispose()
}

private class XMInnerDisposable: XMDisposable {
    
    var disposed: Bool = false
    
    func dispose() {
        disposed = true
    }
}

func delayerOnMain(delay: NSTimeInterval, action: Void -> Void) -> XMDisposable {
    return delayer(delay, queue: dispatch_get_main_queue(), action: action)
}

func delayer(delay: NSTimeInterval, queue: dispatch_queue_t, action: Void -> Void) -> XMDisposable {
    precondition(delay >= 0)
    
    let disposable = XMInnerDisposable()
    dispatch_after(wallTimeWithDate(NSDate().dateByAddingTimeInterval(delay)), queue) {
        if !disposable.disposed {
            action()
        }
    }
    return disposable
}

private func wallTimeWithDate(date: NSDate) -> dispatch_time_t {
    
    let (seconds, frac) = modf(date.timeIntervalSince1970)
    
    let nsec: Double = frac * Double(NSEC_PER_SEC)
    var walltime = timespec(tv_sec: Int(seconds), tv_nsec: Int(nsec))
    
    return dispatch_walltime(&walltime, 0)
}
    