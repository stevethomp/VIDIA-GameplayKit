//: [Previous](@previous)

import GameplayKit

typealias AnimatingComponent = GKComponent

let entity = GKEntity()
let aComponent = AnimatingComponent()
entity.addComponent(aComponent)

let deltaTime = 0.05
entity.updateWithDeltaTime(deltaTime)

//: [Next](@next)
