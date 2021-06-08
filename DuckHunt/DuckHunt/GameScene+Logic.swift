//
//  GameScene+Logic.swift
//  DuckHunt
//
//  Created by Mireia on 5/5/21.
//

import GameplayKit
import SpriteKit

func isInBounds(limitsX: CGPoint, limitsY: CGPoint, pos: CGPoint) -> Bool
{
    if(pos.x < limitsX.y && pos.x > limitsX.x && pos.y < limitsY.y && pos.y > limitsY.x)
    {
        return true
    }
    else
    {
        return false
    }
}

func arrayToScore(array: [Int]) -> Int
{
    var finalResult = 0
    
    var multiplier = 1
    
    var index = array.count - 1
    for _ in 1...array.count
    {
        finalResult += (array[index] * multiplier)
        multiplier *= 10
        index -= 1
    }
    
    return finalResult
}

func getScore() -> [Int]
{
    var score = [Int]()
    var index = 0
    
    let defaults = UserDefaults.standard

    for _ in 1...6
    {
        score.append(defaults.integer(forKey: "BestScore_" + String(index)))
        index += 1
    }
    
    return score
}

func saveNewScore(points: Points)
{
    if(arrayToScore(array: points.internalScore) > arrayToScore(array: getScore()))
    {
        var index = 0
        let defaults = UserDefaults.standard
        for _ in 1...6
        {
            defaults.set(points.internalScore[index], forKey: "BestScore_" + String(index))
            index += 1
        }
    }
}

