//
//  ClickCounterViewModel.swift
//  swift-mvvm-examples
//
//  Created by Kyle LeNeau on 1/16/15.
//  Copyright (c) 2015 Kyle LeNeau. All rights reserved.
//

import Foundation
import ReactiveCocoa

public class ClickCounterViewModel {

    public let numberOfClicks = MutableProperty(0)
    
    public lazy var clickEnabled: PropertyOf<Bool> = {
        let property = MutableProperty(false)
        
        property <~ self.numberOfClicks.producer
            |> map { $0 <= 3 }
        
        return PropertyOf(property)
    }()
    
    public lazy var resetEnabled: PropertyOf<Bool> = {
        let property = MutableProperty(false)
        
        property <~ self.numberOfClicks.producer
            |> map { $0 > 0 }
        
        return PropertyOf(property)
    }()
    
    public lazy var clickCountDisplay: SignalProducer<String, NoError> = {
        return self.numberOfClicks.producer
            |> map { return "You've clicked \($0) times" }
    }()
    
    public lazy var registerClickAction: Action<AnyObject?, AnyObject, NSError> = {
        return Action<AnyObject?, AnyObject, NSError>(enabledIf: self.clickEnabled, { _ in
            self.numberOfClicks.value += 1
            return SignalProducer.empty
        })
    }()
    
    public lazy var resetClicksAction: Action<AnyObject?, AnyObject, NSError> = {
        return Action<AnyObject?, AnyObject, NSError>(enabledIf: self.resetEnabled, { _ in
            self.numberOfClicks.value = 0
            return SignalProducer.empty
        })
    }()
}
