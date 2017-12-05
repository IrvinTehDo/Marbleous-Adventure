//
//  PlayerNode.swift
//  Marbleous Adventure
//
//  Created by student on 11/15/17.
//  Copyright © 2017 Irvin Do. All rights reserved.
//

import SpriteKit

class PlayerNode: SKSpriteNode{
    
    var canJump = true
    var groundNode: SKNode?
    
    func didMoveToScene() {
        //Draw and setup physicsbodies
        physicsBody?.categoryBitMask = PhysicsCategory.Player
        physicsBody?.contactTestBitMask = PhysicsCategory.None
        physicsBody?.collisionBitMask = PhysicsCategory.Block | PhysicsCategory.MovingBlock
        
        //groundNode = childNode(withName:"playerBottom")
        //groundNode!.physicsBody?.categoryBitMask = PhysicsCategory.PlayerBottom
    }
    
    
}
