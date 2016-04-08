//
//  GameStartScene.m
//  M4W3App3-BreakOut
//
//  Created by Ajay Thakur on 4/7/16.
//  Copyright © 2016 Ajay Thaur. All rights reserved.
//

#import "GameStartScene.h"
#import "GameScene.h"

@implementation GameStartScene

-(void)didMoveToView:(SKView *)view {
    
    // Add background SPrite
    SKSpriteNode *backgroundImageNode = [SKSpriteNode spriteNodeWithImageNamed:@"starfield1024x768"];
    backgroundImageNode.position = CGPointMake(CGRectGetMidX(self.frame),
                                               CGRectGetMidY(self.frame));
    backgroundImageNode.name = @"Background";
    backgroundImageNode.zPosition = 0;
    
    /* Setup your scene here */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    myLabel.name = @"StartGame";
    myLabel.text = @"Play Game";
    myLabel.fontColor = [UIColor greenColor];
    myLabel.fontSize = 90;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    myLabel.zPosition = 1.0;
    [self addChild:backgroundImageNode];
    [self addChild:myLabel];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    if (touches) {
        SKView * skView = (SKView *)self.view;
        
        GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
