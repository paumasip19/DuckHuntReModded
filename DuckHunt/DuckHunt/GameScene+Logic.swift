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
