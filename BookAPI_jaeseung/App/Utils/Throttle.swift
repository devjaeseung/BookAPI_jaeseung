//
//  Throttle.swift
//  BookAPI_jaeseung
//
//  Created by jaeseung lim on 2022/08/12.
//

import Foundation

class Throttle {
    
    let TAG = "Throttle"
    
    private var workItem: DispatchWorkItem = DispatchWorkItem(block: {})
    private var previousRun: Date = Date.distantPast
    private let queue: DispatchQueue
    private let delay: TimeInterval
    
    init(minimumDelay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        print(TAG," init 함수 시작 minimumDelay : \(minimumDelay) , queue : \(queue)")
        self.delay = minimumDelay
        self.queue = queue
    }
    
    func throttle(_ block: @escaping () -> Void) {
        print(TAG," throttle 함수 시작 block : \(block)")
        workItem.cancel()
        
        workItem = DispatchWorkItem() {
            [weak self] in
            self?.previousRun = Date()
            block()
        }
        
        let deltaDelay = previousRun.timeIntervalSinceNow > delay ? 0 : delay
        queue.asyncAfter(deadline: .now() + Double(deltaDelay), execute: workItem)
    }
    
}
