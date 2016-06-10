//
//  ViewController.swift
//  FlockingTouches
//
//  Created by Steven Thompson on 2016-06-06.
//  Copyright © 2016 stevethomp. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {
    @IBOutlet var ships: [FlockingView]!
    @IBOutlet weak var imageView: UIImageView!

    let agentSystem: GKComponentSystem = GKComponentSystem(componentClass: GKAgent2D.self)
    let tapAgent: GKAgent2D = GKAgent2D() //Agent for finger tap
    var seekTapGoal: GKGoal!
    var pathGoal: GKGoal!

    var updateTimer: NSTimer!
    let timeInterval = NSTimeInterval(0.05)
    
    let separationRadius: Float =  0.553 * 50;
    let separationAngle: Float  = 3 * Float(M_PI) / 4.0;
    let separationWeight: Float =  10.0;
    
    let alignmentRadius: Float = 0.83333 * 50;
    let alignmentAngle: Float  = Float(M_PI) / 4.0;
    let alignmentWeight: Float = 12.66;
    
    let cohesionRadius: Float = 1.0 * 100;
    let cohesionAngle: Float  = Float(M_PI) / 2.0;
    let cohesionWeight: Float = 8.66;
    
    var seeking: Bool = false {
        didSet {
            for agent in agentSystem.components {
                let ag = agent as! GKAgent2D
                if seeking {
                    ag.behavior?.setWeight(1.0, forGoal: seekTapGoal)
                    ag.behavior?.setWeight(0.0, forGoal: pathGoal)
                } else {
                    ag.behavior?.setWeight(0.0, forGoal: seekTapGoal)
                    ag.behavior?.setWeight(0.8, forGoal: pathGoal)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = NSBundle.mainBundle().URLForResource("fez", withExtension: "gif")
        imageView.image = UIImage.animatedImageWithAnimatedGIFURL(url!)
        
        ships.forEach { (ship) in
            ship.configureAgent(ship.frame.origin)
            agentSystem.addComponent(ship.agent)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let center: vector_float2 = vector_float2(Float(view.frame.size.width/2), Float(view.frame.size.height/2))
        let points = [
            vector_float2(center.x-100, center.y-200),
            vector_float2(center.x-100, center.y-100),
            vector_float2(center.x-100, center.y),
            vector_float2(center.x-100, center.y+100),
            vector_float2(center.x-100, center.y+200),
            vector_float2(center.x-50, center.y+200),
            vector_float2(center.x, center.y+200),
            vector_float2(center.x+50, center.y+200),
            vector_float2(center.x+100, center.y+200),
            vector_float2(center.x+100, center.y+100),
            vector_float2(center.x+100, center.y),
            vector_float2(center.x+100, center.y-100),
            vector_float2(center.x+100, center.y-200),
            vector_float2(center.x+50, center.y-200),
            vector_float2(center.x, center.y-200),
            vector_float2(center.x-50, center.y-200)]
        
        let path = GKPath(points: UnsafeMutablePointer(points), count: 16, radius: 20, cyclical: true)
        
//        let bPath = UIBezierPath()
//        bPath.moveToPoint(CGPoint(x: CGFloat(points[0].x), y: CGFloat(points[0].y)))
//        for point in points {
//            bPath.addLineToPoint(CGPoint(x: CGFloat(point.x), y: CGFloat(point.y)))
//        }
//        bPath.closePath()
//        
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = bPath.CGPath
//        shapeLayer.strokeColor = UIColor.grayColor().CGColor
//        shapeLayer.lineWidth = 3.0
//        shapeLayer.fillColor = UIColor.clearColor().CGColor
//        view.layer.addSublayer(shapeLayer)
        
        let behaviour = GKBehavior()
        let agents = agentSystem.components as! [GKAgent2D]
        behaviour.setWeight(separationWeight, forGoal: GKGoal(toSeparateFromAgents: agents, maxDistance: separationRadius, maxAngle: separationAngle))
        behaviour.setWeight(alignmentWeight, forGoal: GKGoal(toAlignWithAgents: agents, maxDistance: alignmentRadius, maxAngle: alignmentAngle))
        behaviour.setWeight(cohesionWeight, forGoal: GKGoal(toCohereWithAgents: agents, maxDistance: cohesionRadius, maxAngle: cohesionAngle))
        pathGoal = GKGoal(toFollowPath: path, maxPredictionTime: 1.4, forward: GKRandomSource.sharedRandom().nextBool())
        behaviour.setWeight(0.8, forGoal: pathGoal)
        
        for agent in agents {
            agent.behavior = behaviour
        }
        
        seekTapGoal = GKGoal(toSeekAgent: tapAgent)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    func update() {
        agentSystem.updateWithDeltaTime(timeInterval)
    }
    
    // Touch handling
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let position = touch?.locationInView(self.view)
        tapAgent.position = vector_float2(Float(position!.x), Float(position!.y))

        seeking = true
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        seeking = false
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        seeking = false
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let position = touch?.locationInView(self.view)
        tapAgent.position = vector_float2(Float(position!.x), Float(position!.y))
        
        seeking = true
    }
}