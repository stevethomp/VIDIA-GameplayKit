//: [Previous](@previous)

import GameplayKit

typealias PreparingState = GKState

class UploadState: GKState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        if stateClass is PreparingState.Type {
            return false
        }
        return true
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
    
    override func willExitWithNextState(nextState: GKState) {
        
    }
}

//: [Next](@next)
