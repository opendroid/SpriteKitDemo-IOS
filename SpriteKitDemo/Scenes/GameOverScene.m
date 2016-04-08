//
//  GameOverScene.m
//  M4W3App3-BreakOut
//
//  Created by Ajay Thakur on 4/7/16.
//  Copyright © 2016 Ajay Thaur. All rights reserved.
//
//  Sound files:
//    1. ping.wav: http://www.freesound.org/people/JarredGibb/sounds/217461/
//    2. bang.mp3: http://www.freesound.org/people/cydon/sounds/268553/
//    3. kick.wav: http://www.freesound.org/people/smileylovers/sounds/148634/
//  Image files:

//
//

#import "GameOverScene.h"
#import "GameScene.h"

@implementation GameOverScene
-(void)didMoveToView:(SKView *)view {
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    // Add background SPrite
    SKSpriteNode *backgroundImageNode = [SKSpriteNode spriteNodeWithImageNamed:@"starfield1024x768"];
    backgroundImageNode.position = CGPointMake(CGRectGetMidX(self.frame),
                                               CGRectGetMidY(self.frame));
    backgroundImageNode.name = @"Background";
    backgroundImageNode.zPosition = 0;
    
    /* Setup your scene here */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    myLabel.name = @"GameOver";
    myLabel.text = @"Game Over";
    myLabel.fontSize = 90;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    myLabel.zPosition = 1.0;
    
    SKLabelNode *label2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    label2.text = @"Replay";
    label2.name = @"Replay";
    label2.fontSize = 45;
    label2.fontColor = [UIColor greenColor];
    label2.position = CGPointMake(CGRectGetMidX(self.frame),
                                  CGRectGetMidY(self.frame)-200.0);
    label2.zPosition = 2.0;
    
    SKSpriteNode *ball1 = [SKSpriteNode spriteNodeWithImageNamed:@"ball50x50"];
    ball1.name = @"Ball1";
    ball1.position = CGPointMake((0.1 * self.frame.size.width)/2, (0.2*self.frame.size.height)/2);
    ball1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball1.size.height/2.0];
    ball1.physicsBody.dynamic = YES;
    ball1.physicsBody.friction = 0.0;
    ball1.physicsBody.restitution = 1.0;
    ball1.physicsBody.linearDamping = 0.0;
    ball1.physicsBody.angularDamping = 0.0;
    ball1.physicsBody.allowsRotation = NO;
    ball1.physicsBody.mass = 1.0;
    ball1.physicsBody.velocity = CGVectorMake(400.0, 500.0);
    ball1.physicsBody.affectedByGravity = NO;
    ball1.zPosition = 0.5;
    
    
    SKSpriteNode *ball2 = [SKSpriteNode spriteNodeWithImageNamed:@"ball2_50x50"];
    ball2.name = @"Ball2";
    ball2.position = CGPointMake((0.1 * self.frame.size.width)/2+100, (0.2*self.frame.size.height)/2+100);
    ball2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball1.size.height/2.0];
    ball2.physicsBody.dynamic = YES;
    ball2.physicsBody.friction = 0.0;
    ball2.physicsBody.restitution = 1.0;
    ball2.physicsBody.linearDamping = 0.0;
    ball2.physicsBody.angularDamping = 0.0;
    ball2.physicsBody.allowsRotation = NO;
    ball2.physicsBody.mass = 1.0;
    ball2.physicsBody.velocity = CGVectorMake(500.0, 400.0);
    ball2.physicsBody.affectedByGravity = NO;
    ball2.zPosition = 0.6;
    
    [self removeAllChildren];
    [self insertChild:backgroundImageNode atIndex:0];
    [self insertChild:myLabel atIndex:1];
    [self insertChild:label2 atIndex:2];
    [self insertChild:ball1 atIndex:3];
    [self insertChild:ball2 atIndex:4];
    
    // Join the two balls using a spring attached at center of both balls
    CGPoint ball1Anchor = CGPointMake(ball1.position.x, ball1.position.y);
    CGPoint ball2Anchor = CGPointMake(ball2.position.x, ball2.position.y);
    SKPhysicsJointSpring *joint = [SKPhysicsJointSpring jointWithBodyA:ball1.physicsBody bodyB:ball2.physicsBody anchorA:ball1Anchor anchorB:ball2Anchor];
    joint.damping = 0.0;
    joint.frequency = 1.5;
    [self.physicsWorld addJoint:joint];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (touches.count < 2) {
        SKView * skView = (SKView *)self.view;
        GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        // Present the scene.
        [skView presentScene:scene];
    } else {
        // Increase speed when multiple fingers are touched.
        SKNode *ball = [self childNodeWithName:@"Ball1"];
        ball.physicsBody.velocity = (CGVectorMake(500, 400));
        
        CGPoint location = [touches.allObjects[0] locationInNode:self];
        ball.position = CGPointMake(location.x, location.y);
        NSLog(@"touchesBegan: count:%ld, (%f,%f), ball at: (%f,%f)",touches.allObjects.count, location.x,location.y, ball.position.x, ball.position.y);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [touches.allObjects[0] locationInNode:self];
    SKNode *ball = [self childNodeWithName:@"Ball1"];
    
    NSLog(@"touchesEnded: count:%ld, (%f,%f), ball at: (%f,%f)",touches.allObjects.count, location.x,location.y, ball.position.x, ball.position.y);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [touches.allObjects[0] locationInNode:self];
    SKNode *ball = [self childNodeWithName:@"Ball1"];
    
    NSLog(@"touchesMoved: count:%ld, (%f,%f), ball at: (%f,%f)",touches.allObjects.count, location.x,location.y, ball.position.x, ball.position.y);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [touches.allObjects[0] locationInNode:self];
    SKNode *ball = [self childNodeWithName:@"Ball1"];
    
    NSLog(@"touchesCancelled: count:%ld, (%f,%f), ball at: (%f,%f)",touches.allObjects.count, location.x,location.y, ball.position.x, ball.position.y);
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
