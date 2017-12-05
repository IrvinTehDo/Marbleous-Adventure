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
    static let MovingBlock: UInt32 = 0b1000
    static let Goal: UInt32 = 0b1000
    static let Edge: UInt32 = 0b10000
}

class GameScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate {
    var playerNode: PlayerNode!
    var blocks: [BlockNode] = []
    var movingBlocks: [MovingBlockNode] = []
    
    var gameState = GAME_STATE.BEGIN
    var menuState = MENU_STATE.PLAYING
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    // MARK: Initializer
    
    override func didMove(to view: SKView) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let maxAspectRatioHeight = size.width/maxAspectRatio
        let playableMargin: CGFloat = (size.height - maxAspectRatioHeight)/2
        
        let playableRect = CGRect(x:0, y: playableMargin, width: size.width, height: size.height-playableMargin*2)

        //physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        
        playerNode = childNode(withName:"player") as! PlayerNode
        playerNode.didMoveToScene()

        
        enumerateChildNodes(withName: "block"){
            node, _ in
//            node.physicsBody?.categoryBitMask = PhysicsCategory.Block
//            node.physicsBody?.contactTestBitMask = PhysicsCategory.PlayerBottom
//            node.physicsBody?.collisionBitMask = PhysicsCategory.Player
            self.blocks.append(node as! BlockNode)
        }
        
        for i in blocks {
            i.didMoveToScene()
        }
        
        enumerateChildNodes(withName: "movingBlock"){
            node, _ in
            self.movingBlocks.append(node as! MovingBlockNode)
        }
        
        for i in movingBlocks{
            i.didMoveToScene()
            let moveTo: CGFloat = (i.userData?.value(forKey: "moveTo") as? CGFloat)!
            let moveFrom: CGFloat = (i.userData?.value(forKey: "moveFrom") as? CGFloat)!
            let duration: Double = (i.userData?.value(forKey: "duration") as? Double)!
            let isHorizontal: Bool = (i.userData?.value(forKey: "horizontal") as? Bool)!
            
            let actionMoveTo: SKAction!
            let actionMoveFrom: SKAction!
            
            if isHorizontal{
                actionMoveTo = SKAction.moveTo(x: i.position.x + moveTo, duration: TimeInterval(duration))
                actionMoveFrom = SKAction.moveTo(x: i.position.x + moveFrom, duration: TimeInterval(duration))
            }
            else{
                actionMoveTo = SKAction.moveTo(y: i.position.y + moveTo, duration: TimeInterval(duration))
                actionMoveFrom = SKAction.moveTo(y: i.position.y + moveFrom, duration: TimeInterval(duration))
            }
            //i.run(SKAction.sequence([actionMoveTo, actionMoveFrom]))
            i.run(SKAction.repeatForever(SKAction.sequence([actionMoveTo, actionMoveFrom])))
            
        }
        
        if let groundNode = childNode(withName: "playerBottom") as? SKSpriteNode{
            groundNode.physicsBody?.categoryBitMask = PhysicsCategory.PlayerBottom
            groundNode.physicsBody?.contactTestBitMask = PhysicsCategory.Block | PhysicsCategory.MovingBlock
            groundNode.physicsBody?.collisionBitMask = PhysicsCategory.None
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
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if  collision == PhysicsCategory.PlayerBottom | PhysicsCategory.Block{
            playerNode.canJump = true
            print("can jump")
        }
        
        else if collision == PhysicsCategory.PlayerBottom | PhysicsCategory.MovingBlock{
            playerNode.canJump = true
            print("can jump on moving")
        }
        
        if collision == PhysicsCategory.Block | PhysicsCategory.MovingBlock{
            print("block to block")
        }
        
        //do collision comparison
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //same
        if playerNode.canJump{
            playerNode.physicsBody?.velocity = CGVector(dx: (playerNode.physicsBody?.velocity.dx)!, dy: 0)
            playerNode.physicsBody?.applyForce(CGVector(dx: 0, dy: 15000))
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
        
        //playerNode.groundNode?.position = CGPoint(x: playerNode.position.x, y: playerNode.position.y - 27)
        if let groundNode = childNode(withName: "playerBottom") as? SKSpriteNode{
            groundNode.position = CGPoint(x: playerNode.position.x, y: playerNode.position.y - 28)
        }
        
    }
    

}
