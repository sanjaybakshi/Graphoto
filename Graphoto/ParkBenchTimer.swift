//
//  ParkBenchTimer.swift
//  Photo-Graphs2
//
//  Created by Sanjay Bakshi on 9/2/17.
//  Copyright © 2017 Theo and Milo Bakshi. All rights reserved.
//

import Foundation

public class ParkBenchTimer {
    
    let startTime:CFAbsoluteTime
    var endTime:CFAbsoluteTime?
    
    public init() {
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    public func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()
        
        return duration!
    }
    
    public var duration:CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
}

