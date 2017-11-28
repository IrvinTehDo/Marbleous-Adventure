//
//  GameScene.swift
//  Marbleous Adventure
//
//  Created by student on 11/15/17.
//  Copyright © 2017 Irvin Do. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GAME_STATE{
    case BEGIN
    case DEFAULT
    case GAME_OVER
    case END
}

enum MENU_STATE{
    case MAIN
    case PLAYING
    case RESULTS
}

struct PhysicsCategory{
    static let None: UInt32 = 0
    static let Player: UInt32 = 0b1
    static let PlayerBottom: UInt32 = 0b10
    static let Block: UInt32 = 0b100
    static let Goal: UInt32 = 0b1000
    static let Edge: UInt32 = 0b10000
}

class GameScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate {
    
    var playerNode: PlayerNode!
    var gameState = GAME_STATE.BEGIN
    var menuState = MENU_STATE.MAIN
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    // MARK: Initializer
    
    override func didMove(to view: SKView) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let maxAspectRatioHeight = size.width/maxAspectRatio
        let playableMargin: CGFloat = (size.height - maxAspectRatioHeight)/2
        
        let playableRect = CGRect(x:0, y: playableMargin, width: size.width, height: size.height-playableMargin*2)
        
        playerNode = childNode(withName:"player") as! PlayerNode
        
        enumerateChildNodes(withName: "block"){
            node, _ in
            node.physicsBody?.contactTestBitMask = PhysicsCategory.Block
        }
        
        //To Implement Later
        //physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        //physicsWorld.contactDelegate = self
        //physicsBody!.categoryBitMask = PhysicsCategory.Edge
        
    }
    
    // MARK: Update
    
    override func update(_ currentTime: TimeInterval) {
        calculateDeltaTime(currentTime: currentTime)
        // Called before each frame is rendered
        movePlayer(dt: CGFloat(dt))
    }
    
    // MARK: Events
    
    func didBegin(_ contact: SKPhysicsContact) {
        //Collision Code
        if !(menuState == MENU_STATE.PLAYING){return}
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        
        else{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        
        if firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.Block{
            playerNode.canJump = true
            print("can jump")
        }
        
        //do collision comparison
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //same
        if playerNode.canJump{
            print("jumped")
            playerNode.physicsBody?.applyForce(CGVector(dx: 0, dy: 10000))
            playerNode.canJump = false
        }
        
        
    }
    
    // MARK: Helper Methods

    func calculateDeltaTime(currentTime: TimeInterval)
    {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        }
            
        else{
            dt = 0
        }
        lastUpdateTime = currentTime
    }
    
    func movePlayer(dt:CGFloat){
        let gravityVector = MotionMonitor.sharedMotionMonitor.gravityVectorNormalized
        //print(gravityVector)         
        var xVelocity = gravityVector.dx
        xVelocity = xVelocity < -0.33 ? -0.33: xVelocity
        xVelocity = xVelocity > 0.33 ? 0.33: xVelocity
        
        //Make it either around -1 to 1
        xVelocity = xVelocity * 3
        
        //Tilting Dead Zone
        if(abs(xVelocity) < 0.1){
            xVelocity = 0
        }
        
        //playerNode.position.x += xVelocity * CGFloat(800.0)
        playerNode.physicsBody?.applyForce(CGVector(dx: xVelocity * 200.0, dy: 0))
        
        /*
        if playerNode.physicsBody!.velocity.dy > CGFloat(10000.0){
            playerNode.physicsBody?.velocity.dy = 10000.0
        }
        */
        
        if let playerCamera = childNode(withName: "playerCamera") as? SKCameraNode{
            //print(playerCamera.position)
            playerCamera.position = playerNode.position
        }
        
        if let playerGround = playerNode.childNode(withName: "playerGround"){
            playerGround.position = CGPoint(x: playerNode.position.x, y: playerNode.position.y - -27.019)
        }
        
        
    }
    

}
