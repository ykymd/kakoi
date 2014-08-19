//
//  ResultLayer.m
//  kakoi
//
//  Created by Yuki Yamada on 2013/08/05.
//
//

#import "ResultLayer.h"
#import "TitleLayer.h"
#import "GameLayer.h"

@implementation ResultLayer

@synthesize score;

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        self.isTouchEnabled = NO;
	}
	return self;
}

- (void)onEnter
{
    [super onEnter];

    //画面サイズを取得
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    if(winSize.width >= 768){
        timeup = [CCSprite spriteWithFile:@"timeup-ipad.png"];
    }else{
        timeup = [CCSprite spriteWithFile:@"timeup.png"];
    }
    timeup.position = ccp(winSize.width/2, winSize.height/2);
    timeup.scaleY = 0;
    [self addChild:timeup];
    
    id pop = [CCScaleTo actionWithDuration:0.2f scale:1.0];
    [timeup runAction:pop];
    
    [self scheduleOnce:@selector(makeTransition:) delay:0.3];
}

-(void) makeTransition:(ccTime)dt
{
    self.isTouchEnabled = YES;
}

-(void)showScore
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    NSString *scorelabel = [NSString stringWithFormat:@"Score"];
    CCLabelTTF *lablab = [CCLabelTTF labelWithString:scorelabel fontName:@"Arial-BoldMT" fontSize:48];
    lablab.position = ccp(winSize.width/2,winSize.height/2);
    [self addChild:lablab];
    
    NSString *scorelabel2 = [NSString stringWithFormat:@"%.0f",score];
    CCLabelTTF *lablab2 = [CCLabelTTF labelWithString:scorelabel2 fontName:@"Arial-BoldMT" fontSize:48];
    lablab2.position = ccp(winSize.width/2,winSize.height/2-lablab.contentSize.height/2-lablab2.contentSize.height/2);
    [self addChild:lablab2];
    
    NSString *scorelabel3 = [NSString stringWithFormat:@"MaxCombo:%d", _maxCombo];
    CCLabelTTF *lablab3 = [CCLabelTTF labelWithString:scorelabel3 fontName:@"Arial-BoldMT" fontSize:18];
    lablab3.position = ccp(winSize.width/2,winSize.height/2-lablab.contentSize.height-lablab2.contentSize.height-lablab3.contentSize.height/2);
    [self addChild:lablab3];
    
    NSString *scorelabel4 = [NSString stringWithFormat:@"Rate:%.0f/%.0f(%.2f%%)", _getnum, _allnum, _getnum/_allnum*100];
    CCLabelTTF *lablab4 = [CCLabelTTF labelWithString:scorelabel4 fontName:@"Arial-BoldMT" fontSize:18];
    lablab4.position = ccp(winSize.width/2,winSize.height/2-lablab.contentSize.height-lablab2.contentSize.height-lablab3.contentSize.height-lablab4.contentSize.height/2);
    [self addChild:lablab4];
    
    CCMenuItemFont *item = [CCMenuItemFont itemWithString:@"<Back" target:self selector:@selector(BackToTitle)];
    item.fontName = @"Arial-BoldMT";
    [item setFontSize:32];
    
    CCMenu *back = [CCMenu menuWithItems:item, nil];
    [back alignItemsVerticallyWithPadding:16];
    [back setPosition:ccp( 45, 16 )];
    [self addChild:back];
    
    CCMenuItemFont *item2 = [CCMenuItemFont itemWithString:@"Tweet" target:self selector:@selector(Tweet)];
    item2.fontName = @"Arial-BoldMT";
    [item2 setFontSize:32];
    
    CCMenu *tweetbtn = [CCMenu menuWithItems:item2, nil];
    [tweetbtn alignItemsVerticallyWithPadding:16];
    [tweetbtn setPosition:ccp(winSize.width-45, 16)];
    [self addChild:tweetbtn];
    
    CCMenuItemFont *item3 = [CCMenuItemFont itemWithString:@"Retry" target:self selector:@selector(Retry)];
    item3.fontName = @"Arial-BoldMT";
    [item3 setFontSize:32];
    
    CCMenu *retrybtn = [CCMenu menuWithItems:item3, nil];
    [retrybtn alignItemsVerticallyWithPadding:16];
    [retrybtn setPosition:ccp(winSize.width/2, 16)];
    [self addChild:retrybtn];
    
    if(winSize.width >= 768){
        [lablab setFontSize:96];
        [lablab2 setFontSize:96];
        [lablab3 setFontSize:36];
        [lablab4 setFontSize:36];
        lablab.position = ccp(winSize.width/2,winSize.height/2);
        lablab2.position = ccp(winSize.width/2,winSize.height/2-lablab.contentSize.height/2-lablab2.contentSize.height/2);
        lablab3.position = ccp(winSize.width/2,winSize.height/2-lablab.contentSize.height-lablab2.contentSize.height-lablab3.contentSize.height/2);
        lablab4.position = ccp(winSize.width/2,winSize.height/2-lablab.contentSize.height-lablab2.contentSize.height-lablab3.contentSize.height-lablab4.contentSize.height/2);
    }
    
    /*
    CCLabelAtlas *scorelab = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%.0f",score] charMapFile:@"num75.png" itemWidth:75 itemHeight:75 startCharMap:0];
    scorelab.position = ccp(winSize.width/2,lablab.position.y-48-75);
    [self addChild:scorelab];
     */
    
    //id move = [CCMoveTo actionWithDuration:0.4f position:ccp(winSize.width/2,scorelab.position.y)];
    //[scorelab runAction:move];
}

-(void)BackToTitle
{
    CCTransitionFade *trans = [CCTransitionFade transitionWithDuration:1.0 scene:[TitleLayer scene]];
    [[CCDirector sharedDirector] replaceScene:trans];
}

-(void)Tweet
{
    UIViewController *viewController = [UIViewController new];
    
    if ([TWTweetComposeViewController canSendTweet]){
        TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
        
        NSString *message = [NSString stringWithFormat:@"KAKOIをプレイ! Score:%.0lf #KAKOI", score];
        [tweetViewController setInitialText:message];
        NSURL *url = [NSURL URLWithString:@"AppStore.com/kakoi"];
        [tweetViewController addURL:url];
        
        tweetViewController.completionHandler = ^(TWTweetComposeViewControllerResult result) {
            if(result == TWTweetComposeViewControllerResultDone) {
                // "送信"した場合
            } else if(result == TWTweetComposeViewControllerResultCancelled) {
                // "キャンセル"した場合
            }
            [viewController dismissViewControllerAnimated:YES completion:nil];
        };
        
        [[[CCDirector sharedDirector] view] addSubview:viewController.view];
        [viewController presentViewController:tweetViewController animated:YES completion:nil];
        
    }else{
        // Twitterが利用できない場合
    }
}

-(void)Retry
{
    CCTransitionFade *trans = [CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer scene]];
    [[CCDirector sharedDirector] replaceScene:trans];

}

//タッチの終了
-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    if(!showScore){
        showScore = YES;
        id move = [CCMoveTo actionWithDuration:0.4f position:ccp(winSize.width/2,winSize.height-timeup.contentSize.height/2)];
        [timeup runAction:move];
        [self showScore];
    }
    //CCLOG(@"End(%f,%f)",location.x,location.y);
    //CCTransitionFade *trans = [CCTransitionFade transitionWithDuration:1.0 scene:[TitleLayer scene]];
    //[[CCDirector sharedDirector] replaceScene:trans];
}

@end
