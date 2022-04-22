//
//  TimerTool.swift
//
//
//  Created by *** on 30/8/21.
//  Copyright © 2021 ***. All rights reserved.
//

import UIKit

protocol TimerDelegate: AnyObject {
    func refreshTime(_ time: Int)
}

class TimerTool: NSObject {
    
    public weak var delegate: TimerDelegate?
        
    private lazy var date_formatter: DateFormatter = {
        
        let date_formatter = DateFormatter()
        date_formatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        date_formatter.isLenient = true
        date_formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return date_formatter
    }()
    
    var current:TimeInterval = 0
    var to_time:TimeInterval = 0
    var count_down:TimeInterval = 0
    
    var neeCount:Bool = true
    var time_over:(() -> ())?
    
    func time_run(countDown:TimeInterval = 0) {
        
        current = NSDate().timeIntervalSince1970
        to_time = NSDate().timeIntervalSince1970 + countDown
        count_down = to_time - current
        
        neeCount = true
        
        DispatchQueue.global().async {
            
            while self.neeCount {
                /** 误差0.01秒以内 */
                usleep(5*1000)
                
                if self.count_down > 0 {
                    self.judg_date()
                } else {
                    self.neeCount = false
                    self.time_over?()
                }
            }
        }
    }
    
    fileprivate func judg_date() {
        
        let temp_time: TimeInterval = NSDate().timeIntervalSince1970
        
        if date_formatter.string(from: Date(timeIntervalSinceReferenceDate: to_time - temp_time)) != date_formatter.string(from: Date(timeIntervalSinceReferenceDate: count_down)) {
            
            count_down = to_time - temp_time
            
            if self.count_down < 0 {
                
                self.neeCount = false
                self.time_over?()
                
            } else {
                delegate?.refreshTime(Int(count_down))
            }
        }
    }
}
