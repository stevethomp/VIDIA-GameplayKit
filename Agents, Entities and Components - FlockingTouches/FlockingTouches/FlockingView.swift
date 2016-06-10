//
//  FlockingView.swift
//  FlockingTouches
//
//  Created by Steven Thompson on 2016-06-06.
//  Copyright © 2016 stevethomp. All rights reserved.
//

import UIKit
import GameplayKit

class FlockingView: UIImageView, GKAgentDelegate {
    var agent: GKAgent2D!
    
    func configureAgent(position: CGPoint) {
        agent = GKAgent2D()
        agent.radius = 20
        agent.position = vector_float2(Float(position.x), Float(position.y))
        agent.delegate = self
        agent.maxSpeed = 110
        agent.maxAcceleration = 60
        agent.mass = 0.9
    }
    
    func agentDidUpdate(agent: GKAgent) {
        let ag = agent as! GKAgent2D
        self.frame = CGRect(x: CGFloat(ag.position.x), y: CGFloat(ag.position.y), width: 20.0, height: 20.0)
    }
    
    func agentWillUpdate(agent: GKAgent) {
        // Nothing for us here
    }
}
