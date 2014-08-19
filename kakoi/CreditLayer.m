//
//  TitleLayer.m
//  kakoi
//
//  Created by Yuki Yamada on 2013/06/13.
//
//

// Import the interfaces
#import "CreditLayer.h"
#import "TitleLayer.h"


#pragma mark - TitleLayer

// HelloWorldLayer implementation
@implementation CreditLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CreditLayer *layer = [CreditLayer node];
	
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
	if(self=[super init]){
    }
	return self;
}

- (void)onEnter
{
    [super onEnter];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCSprite *backImg = [CCSprite spriteWithFile:@"bg_game.png"];
    backImg.position = ccp( winSize.width/2,winSize.height/2 );
    [self addChild:backImg];
    
    CCSprite *license = [CCSprite spriteWithFile:@"license.png"];
    license.position = ccp( winSize.width/2,winSize.height/2 );
    [self addChild:license];
    
    CCMenuItemFont *item = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(pushCreditButton)];
    [item setFontName:@"Arial-BoldMT"];
    [item setFontSize:16];
    
    CCMenu *credits = [CCMenu menuWithItems:item, nil];
    [credits alignItemsVerticallyWithPadding:16];
    [credits setPosition:ccp( 45, 12 )];
    [self addChild:credits];
}

-(void)pushCreditButton
{
    CCTransitionFade *trans = [CCTransitionFade transitionWithDuration:1.0 scene:[TitleLayer scene]];
    [[CCDirector sharedDirector] replaceScene:trans];
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

-(void) onExit
{
    [super onExit];
}


@end