//
//  GameScene.m
//  SpriteKitDemo
//
//  Created by Ajay Thakur on 4/8/16.
//  Copyright (c) 2016 Ajay Thaur. All rights reserved.
//

#import "GameScene.h"
#import "GameOverScene.h"

@interface GameScene () <SKPhysicsContactDelegate>

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    // Enclose evrything in Physics body
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsWorld.contactDelegate = self; // Delegate for contacts
    self.physicsBody.contactTestBitMask = 0x0;
    self.name = @"Boundary";
    
    /* Setup your scene here */
    SKSpriteNode *backgroundImageNode = [SKSpriteNode spriteNodeWithImageNamed:@"starfieldLessBright1024x768"];
    backgroundImageNode.position = CGPointMake(self.size.width/2, self.size.height/2);
    backgroundImageNode.name = @"Background";
    backgroundImageNode.zPosition = 0.0;
    
    [self removeAllChildren];
    [self addChild:backgroundImageNode];
    
    // Add a vortex field
    SKFieldNode *vortexField = [SKFieldNode vortexField];
    vortexField.position = CGPointMake(self.size.width/2, self.size.height/2);
    vortexField.zPosition = 0.1;
    [self addChild:vortexField];
    
    // Add 10 balls
    for (NSInteger i = 0; i < 10; i++) {
        SKSpriteNode *ball = [self addBallAt:CGPointMake(arc4random_uniform(self.size.width), arc4random_uniform(self.size.height)) ofType:i%3];
        ball.zPosition = i*0.1+0.1;
        ball.name = [NSString stringWithFormat:@"Ball%ld",i];
        [self addChild:ball];
    }
    
    // Add static blocks on top.
    NSInteger astroidsThatFits = self.frame.size.width/150;
    for (NSInteger i = 0; i < astroidsThatFits; i++) {
        SKSpriteNode *astroid = [self addAAstroidAt:CGPointMake(100.0 + i * 150, self.frame.size.height - 50.0) ofType:i%3];
        astroid.zPosition = 1.6 + i*0.1;
        astroid.name = [NSString stringWithFormat:@"Astroid%ld",i];
        [self addChild:astroid];
    }
}

- (SKSpriteNode *) addBallAt: (CGPoint) position ofType:(NSInteger) type {
    SKSpriteNode *ball;
    
    switch (type) {
        case 0:
            ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball50x50"];
            break;
        case 1:
            ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball2_50x50"];
            break;
        default:
            ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball3_50x50"];
            break;
    }
    
    ball.position = position;
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.height/2.0];
    ball.physicsBody.dynamic = YES;
    ball.physicsBody.friction = 0.0;
    ball.physicsBody.restitution = 1.0;
    ball.physicsBody.linearDamping = 0.0;
    ball.physicsBody.angularDamping = 0.0;
    ball.physicsBody.allowsRotation = YES;
    ball.physicsBody.mass = 1.0;
    ball.physicsBody.velocity = CGVectorMake(350.0*type, 250.0*type);
    ball.physicsBody.angularVelocity = arc4random_uniform(10.0);
    ball.physicsBody.affectedByGravity = NO;
    ball.physicsBody.contactTestBitMask = 0x1;
    return ball;
}

- (SKSpriteNode *) addAAstroidAt: (CGPoint) position ofType:(NSInteger) type {
    SKSpriteNode *astroid;
    switch (type) {
        case 0:
            astroid = [SKSpriteNode spriteNodeWithImageNamed:@"asteroid100x25"];
            break;
        case 1:
            astroid = [SKSpriteNode spriteNodeWithImageNamed:@"lamoose100x25"];
            break;
        default:
            astroid = [SKSpriteNode spriteNodeWithImageNamed:@"moonrock100x25"];
            break;
    }
    astroid.position = position;
    astroid.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100, 25)];
    astroid.physicsBody.dynamic = NO;
    astroid.physicsBody.friction = 0.0;
    astroid.physicsBody.restitution = 1.0;
    astroid.physicsBody.linearDamping = 0.0;
    astroid.physicsBody.angularDamping = 0.0;
    astroid.physicsBody.allowsRotation = NO;
    astroid.physicsBody.affectedByGravity = NO;
    astroid.physicsBody.contactTestBitMask = 0x2;
    return astroid;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if (touches.allObjects.count > 1) {
        SKView * skView = (SKView *)self.view;
        
        GameOverScene *scene = [GameOverScene nodeWithFileNamed:@"GameOverScene"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    } else {
        // Increase speed of all balls when multiple fingers are touched.
        for (SKNode *node in self.children) {
            if ([node.name containsString:@"Ball"]) {
                node.position = CGPointMake(arc4random_uniform(self.size.width), arc4random_uniform(self.size.height));
                node.physicsBody.velocity = (CGVectorMake(arc4random_uniform(500), arc4random_uniform(500)));
                node.physicsBody.angularVelocity = arc4random_uniform(10.0);
            }
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}


#pragma mark -- PhysicsContacts
- (void)didBeginContact:(SKPhysicsContact *)contact {
    NSString *bodyA = contact.bodyA.node.name;
    NSString *bodyB = contact.bodyB.node.name;
    
    if ([bodyA containsString:@"Ball"] && [bodyB containsString:@"Ball"]) {
        [self runAction:[SKAction playSoundFileNamed:@"kick.wav" waitForCompletion:NO]];
    } else if ([bodyA containsString:@"Astroid"] || [bodyB containsString:@"Astroid"]) {
        [self runAction:[SKAction playSoundFileNamed:@"ping.wav" waitForCompletion:NO]];
    } else {
        ;
    }
    
}

- (void) didEndContact:(SKPhysicsContact *)contact {
    
}


@end
