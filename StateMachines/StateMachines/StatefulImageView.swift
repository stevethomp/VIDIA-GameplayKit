//
//  StatefulImageView.swift
//  StateMachines
//
//  Created by Steven Thompson on 2016-06-08.
//  Copyright © 2016 stevethomp. All rights reserved.
//

import UIKit
import GameplayKit

class StatefulImageView: UIImageView {
    var stateMachine: GKStateMachine?
    var timer: NSTimer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        stateMachine = GKStateMachine(states: [ReadyState(imageView: self), UploadState(imageView: self), CompletedState(imageView: self), FailureState(imageView: self)])
        stateMachine?.enterState(ReadyState.self)
    }
    
    func startTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(completed), userInfo: nil, repeats: false)
    }
    
    func completed() {
        if GKARC4RandomSource().nextBool() {
            stateMachine?.enterState(CompletedState.self)
        } else {
            stateMachine?.enterState(FailureState.self)
        }
    }
}

class ImageState: GKState {
    var imageView: StatefulImageView!
    
    init(imageView: StatefulImageView) {
        self.imageView = imageView
    }
    
    override func willExitWithNextState(nextState: GKState) {
        print("Entering " + String(nextState))
    }
}

class ReadyState: ImageState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        imageView.backgroundColor = .grayColor()
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is UploadState.Type
    }
}

class UploadState: ImageState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        imageView.backgroundColor = .blueColor()
        imageView.startTimer()
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is CompletedState.Type || stateClass is FailureState.Type || stateClass is ReadyState.Type
    }
}

class CompletedState: ImageState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        imageView.backgroundColor = .greenColor()
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is ReadyState.Type
    }
}

class FailureState: ImageState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        imageView.backgroundColor = .redColor()
    }

    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is UploadState.Type || stateClass is ReadyState.Type
    }
}