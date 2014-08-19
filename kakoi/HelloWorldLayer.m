//
//  HelloWorldLayer.m
//  kakoi
//
//  Created by Yuki Yamada on 2013/06/13.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		CCSprite *ball = [CCSprite spriteWithFile:@"ball1.png"];
        ball.position = ccp(250, 220);
        [self addChild:ball];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"TestTestTest" fontName:@"AppleGothic" fontSize:24];
        label.position = ccp(250, 120);
        [self addChild:label];
        
        CCRotateBy *rotateBy = [CCRotateBy actionWithDuration:3 angle:360];
        [ball runAction:rotateBy];

        
        CCMenuItemImage *menu1 = [CCMenuItemImage itemWithNormalImage:@"start.png" selectedImage:@"stat.png"
                                                         block:^(id sender){
                                                             CCLOG(@"menu1 tap!");
                                                         }];
        CCMenuItemImage *menu2 = [CCMenuItemImage itemWithNormalImage:@"howtoplay.png" selectedImage:@"howtoplay.png"
                                                         block:^(id sender){
                                                             CCLOG(@"menu2 tap!");
                                                         }];
        CCMenuItemImage *menu3 = [CCMenuItemImage itemWithNormalImage:@"ranking.png" selectedImage:@"ranking.png"
                                                         block:^(id sender){
                                                             CCLOG(@"menu3 tap!");
                                                         }];
        CCMenu *menu = [CCMenu menuWithItems:menu1,menu2,menu3, nil];
        [menu alignItemsVerticallyWithPadding:20.0];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        menu.position = CGPointMake(winSize.width / 2, winSize.height /2 );
        [self addChild:menu];

	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
