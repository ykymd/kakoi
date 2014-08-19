//
//  TitleLayer.m
//  kakoi
//
//  Created by Yuki Yamada on 2013/06/13.
//
//

// Import the interfaces
#import "TitleLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "SimpleAudioEngine.h"
#import "GameLayer.h"
#import "CreditLayer.h"


#pragma mark - TitleLayer

// HelloWorldLayer implementation
@implementation TitleLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TitleLayer *layer = [TitleLayer node];
	
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
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"enter.wav"];
    }
	return self;
}

- (void)onEnter
{
    [super onEnter];
    
    //画面サイズを取得
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 再生フラグ
    isPlay = NO;
    
    //BGMの再生
    NSString *path = [[NSBundle mainBundle] pathForResource:@"title" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    tBgm = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    tBgm.numberOfLoops = -1;
    [tBgm prepareToPlay];
    
    // 背景画像用を表示
    CCSprite *backImg;
    if(winSize.width >= 768){
        backImg = [CCSprite spriteWithFile:@"bg_title-ipad.png"];
    }else{
        backImg = [CCSprite spriteWithFile:@"bg_title.png"];
    }
    backImg.position = ccp( winSize.width/2,winSize.height/2 );
    [self addChild:backImg];
    
    /*
    //クレジットボタンを表示する
    CCMenuItemFont *license = [CCMenuItemFont itemWithString:@"License" target:self selector:@selector(pushCreditButton)];
    [license setFontName:@"Arial-BoldMT"];
    [license setFontSize:16];
     
    CCMenu *credits = [CCMenu menuWithItems:license, nil];
    [credits alignItemsVerticallyWithPadding:16];
    [credits setPosition:ccp( 35, 10 )];
    [self addChild:credits];
     */
     
    //メニューを表示する
    CCMenuItemImage *menu1, *menu2, *menu3;
    if(winSize.width >= 768){
        menu1 = [CCMenuItemImage itemWithNormalImage:@"start-ipad.png" selectedImage:@"start1_push-ipad.png"
                                               block:^(id sender){
                                                   CCLOG(@"menu1 tap!");
                                                   [self touchStartButton];
                                               }];
        menu2 = [CCMenuItemImage itemWithNormalImage:@"howtoplay-ipad.png" selectedImage:@"howtoplay_push-ipad.png"
                                               block:^(id sender){
                                                   CCLOG(@"menu2 tap!");
                                                   [self touchTutorialButton];
                                               }];
        menu3 = [CCMenuItemImage itemWithNormalImage:@"ranking-ipad.png" selectedImage:@"ranking_push-ipad.png"
                                               block:^(id sender){
                                                   CCLOG(@"menu3 tap!");
                                                   [self touchRankingButton];
                                               }];
    }else{
        menu1 = [CCMenuItemImage itemWithNormalImage:@"start.png" selectedImage:@"start1_push.png"
                                                            block:^(id sender){
                                                                CCLOG(@"menu1 tap!");
                                                                [self touchStartButton];
                                                            }];
        menu2 = [CCMenuItemImage itemWithNormalImage:@"howtoplay.png" selectedImage:@"howtoplay_push.png"
                                                            block:^(id sender){
                                                                CCLOG(@"menu2 tap!");
                                                                [self touchTutorialButton];
                                                            }];
        menu3 = [CCMenuItemImage itemWithNormalImage:@"ranking.png" selectedImage:@"ranking_push.png"
                                                            block:^(id sender){
                                                                CCLOG(@"menu3 tap!");
                                                                [self touchRankingButton];
                                                            }];
    }
    
    CCMenu *menu = [CCMenu menuWithItems:menu1,menu2,menu3, nil];
    [menu alignItemsVerticallyWithPadding:20.0];
    menu.position = CGPointMake(winSize.width / 2, winSize.height /3 );
    [self addChild:menu];
    
    // アプリバージョン情報
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    CCLabelTTF *lablab = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Ver%@",version] fontName:@"Arial-BoldMT" fontSize:16];
    lablab.position = ccp(winSize.width-30,8);
    [self addChild:lablab z:10];
    
    // In one second transition to the new scene
	[self scheduleOnce:@selector(makeTransition:) delay:0.8];
}

-(void) makeTransition:(ccTime)dt
{
	[tBgm play];
}

-(void)pushCreditButton
{
    CCTransitionFade *trans = [CCTransitionFade transitionWithDuration:1.0 scene:[CreditLayer scene]];
    [[CCDirector sharedDirector] replaceScene:trans];
}

//スタートボタンを押した時の処理
- (void)touchStartButton
{
    [tBgm stop];
    [[SimpleAudioEngine sharedEngine] playEffect:@"enter.wav"];
    CCTransitionFade *trans = [CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer scene]];
    [[CCDirector sharedDirector] replaceScene:trans];
}

//ゲーム説明ボタンを押した時の処理
- (void)touchTutorialButton
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"enter.wav"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mis-w.blogspot.jp/2013/03/kakoi.html"]];
}

//ランキングボタンを押した時の処理
- (void)touchRankingButton
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"enter.wav"];
    [[CCDirector sharedDirector] showBoard];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
    
    [tBgm release];
}

-(void) onExit
{
    [super onExit];
    
    [tBgm stop];
    
    SimpleAudioEngine* simpleAudioEngine = [SimpleAudioEngine sharedEngine];
    [simpleAudioEngine unloadEffect:@"enter.wav"];
}

#pragma mark GameKit delegate
/*
-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
 */

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
 
@end