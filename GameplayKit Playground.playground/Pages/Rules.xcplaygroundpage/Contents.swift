import UIKit
import GameplayKit

let predicate = NSPredicate(format: "$userAge > 18")
let basicRule = GKRule(predicate: predicate, assertingFact: "welcome", grade: 1.0)

let complicatedRule = GKRule(blockPredicate: { (system) -> Bool in
    return true
    }) { (system) in
        
}

let ruleSystem = GKRuleSystem()
ruleSystem.addRule(basicRule)

ruleSystem.state["userAge"] = 36

ruleSystem.state

ruleSystem.reset()
ruleSystem.evaluate()

ruleSystem.gradeForFact("welcome")
