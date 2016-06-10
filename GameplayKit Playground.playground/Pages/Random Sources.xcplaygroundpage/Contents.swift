//: [Previous](@previous)

import Foundation
import GameplayKit

//Random from 0 to N - 1
let r1 = rand() % 100
//let r2 = random() % 100
let r3 = arc4random() % 100
let r4 = arc4random_uniform(100) //N

GKARC4RandomSource().nextUniform()
GKARC4RandomSource().nextInt()
GKARC4RandomSource().nextIntWithUpperBound(100)

let random = GKRandomDistribution(lowestValue: 0, highestValue: 100).nextInt()

let ints = [1,2,3,4,5,6,7,8,9,10]
let shuffledArray = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(ints)

let normal = GKGaussianDistribution(randomSource: GKARC4RandomSource(), lowestValue: 0, highestValue: 100).nextInt()

func generateUniqueSequence(lowestValue: Int, highestValue: Int) -> [Int] {
    var ints: [Int] = []
    ints += lowestValue...highestValue
    return GKARC4RandomSource.sharedRandom().arrayByShufflingObjectsInArray(ints) as! [Int]
}

generateUniqueSequence(2, highestValue: 15)


//: [Next](@next)
