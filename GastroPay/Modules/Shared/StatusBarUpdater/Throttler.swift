***REMOVED***
***REMOVED***  Throttler.swift
***REMOVED***  Shared
***REMOVED***
***REMOVED***  Created by  on 18.06.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import Foundation

public class Throttler {
    private let queue = DispatchQueue.global(qos: .background)

    private var job: DispatchWorkItem? {
        didSet {
            oldValue?.cancel()
        }
    }

    private var previousRun: Date?

    var maxInterval: TimeInterval

    init(interval: TimeInterval = 0.3) {
        self.maxInterval = interval
    }

    func throttle(_ actions: @escaping () -> Void) {
        let job = DispatchWorkItem { [weak self] in
            self?.previousRun = Date()
            actions()
        }
        self.job = job
        let delay: TimeInterval
        if let previousRun = previousRun {
            let interval = Date().timeIntervalSince(previousRun)
            delay = interval > maxInterval ? 0 : maxInterval
        } else {
            delay = 0
        }
        queue.asyncAfter(deadline: .now() + delay, execute: job)
    }
}
