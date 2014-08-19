//
//  GameLayer.m
//  kakoi
//
//  Created by Yuki Yamada on 2013/06/13.
//
//

// Import the interfaces
#import "GameLayer.h"
#import "ResultLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "Ball.h"
#import <GameKit/GameKit.h>

#pragma mark - GameLayer

// HelloWorldLayer implementation
@implementation GameLayer

@synthesize drag;

NSString const *bgms[2] = {@"kakoi",@"kakoi2"};

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
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
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"initKAKOI.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"failedKAKOI.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"successKAKOI.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"initBall.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"countdown.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"timeup.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"paaan.wav"];
        
        srandom(time(NULL));
        self.isTouchEnabled = YES;
        remaintime = 30*60;
	}
	return self;
}

- (void)onEnter
{
    [super onEnter];
    
    //画面サイズを取得
    winSize = [[CCDirector sharedDirector] winSize];
    
    //スコアをリセット
    score = 0;
    
    //コンボ数をリセット
    combo = 0;
    maxCombo = 0;
    
    //球カウントをリセット
    ballcount = 100;
    
    //球出現数をリセット
    getnum = 0;
    
    percentage = (320*640) / (winSize.width*winSize.height);
    
    //背景を描画
    CCSprite *backImg;
    if(winSize.width >= 768){
        backImg = [CCSprite spriteWithFile:@"bg_game-ipad.png"];
    }else{
        backImg = [CCSprite spriteWithFile:@"bg_game.png"];
    }
    backImg.position = ccp( winSize.width/2,winSize.height/2 );
    [self addChild:backImg];
    
    // 再生フラグ
    isPlay = NO;
    
    drag = [Drag sharedManager];
    [drag set];
    [self addChild:drag z:2];
    
    //BGMの再生
    NSString *path = [[NSBundle mainBundle] pathForResource:@"kakoi2" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    gBgm = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    gBgm.numberOfLoops = -1;
    [gBgm prepareToPlay];
    
    /*
    NSString *timelabel = [NSString stringWithFormat:@"残り時間:%d秒",remaintime];
    lablab = [CCLabelTTF labelWithString:timelabel fontName:@"Arial-BoldMT" fontSize:24];
    lablab.position = ccp(80,468);
    [self addChild:lablab z:10];
     */
    
    if(winSize.width >= 768){
        timenum = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%.0d",remaintime/60] charMapFile:@"num60.png" itemWidth:60 itemHeight:60 startCharMap:'0'];
    }else{
        timenum = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%.0d",remaintime/60] charMapFile:@"num24.png" itemWidth:24 itemHeight:24 startCharMap:'0'];
    }
    timenum.position = ccp(winSize.width-timenum.contentSize.width, winSize.height-timenum.contentSize.height);
    [self addChild:timenum z:10];
    
    NSString *scorelabel = [NSString stringWithFormat:@"Score:%.0f",score];
    if(winSize.width >= 768){
        lablab2 = [CCLabelTTF labelWithString:scorelabel fontName:@"Arial-BoldMT" fontSize:48];
    }else{
        lablab2 = [CCLabelTTF labelWithString:scorelabel fontName:@"Arial-BoldMT" fontSize:24];
    }
    lablab2.position = ccp(lablab2.contentSize.width/2,winSize.height-lablab2.contentSize.height/2);
    [self addChild:lablab2 z:10];
    
    if(winSize.width >= 768){
        l_combo = [CCSprite spriteWithFile:@"combo1-ipad.png"];
    }else{
        l_combo = [CCSprite spriteWithFile:@"combo1.png"];
    }
    l_combo.position = ccp(winSize.width-l_combo.contentSize.width/2 ,l_combo.contentSize.height/2);
    l_combo.visible = NO;
    [self addChild:l_combo z:10];
    
    if(winSize.width >= 768){
        combonum = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%.0f",combo] charMapFile:@"num60-ipad.png" itemWidth:120 itemHeight:120 startCharMap:'0'];
    }else{
        combonum = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%.0f",combo] charMapFile:@"num60.png" itemWidth:60 itemHeight:60 startCharMap:'0'];
    }
    combonum.position = ccp(winSize.width-l_combo.contentSize.width-combonum.contentSize.width/2, 0);
    combonum.visible = NO;
    [self addChild:combonum z:10];
    
    /*
    NSString *combolabel = [NSString stringWithFormat:@"%.0fCOMBO!!",combo];
    lablab3 = [CCLabelTTF labelWithString:combolabel fontName:@"Arial-BoldMT" fontSize:36];
    lablab3.position = ccp(220,18);
    lablab3.visible = NO;
    [self addChild:lablab3 z:10];
     */
    
    CCSprite *timebar;
    if(winSize.width >= 768){
        timebar = [CCSprite spriteWithFile:@"timebar-ipad.png"];
    }else{
        timebar = [CCSprite spriteWithFile:@"timebar.png"];
    }
    timebar.position = ccp(winSize.width/2,timebar.contentSize.height/2);
    [self addChild:timebar];
    
    [self scheduleOnce:@selector(gameStart:) delay:1.0];
}

-(void)gameStart:(ccTime)dt
{
    isGameStart = YES;
    
    // スケジュールを設定
    [self schedule:@selector(onScheduleAddBall:) interval:0.1]; //球の追加
    [self schedule:@selector(onScheduleTimeCount:) interval:1/60]; //残り時間の減少
    
    [gBgm play];
}

// 1/60秒に1回実行されるループ処理
-(void)onScheduleTimeCount:(ccTime)delta{
    remaintime--;
    
    if(remaintime <= 0){
        remaintime = 0;
        if(isGameStart)
            [self gameSet];
    }
    
    //[lablab setString:[NSString stringWithFormat:@"残り時間:%.2f秒",(float)remaintime/60]];
    [timenum setString:[NSString stringWithFormat:@"%.0f",(float)remaintime/60]];
    [lablab2 setString:[NSString stringWithFormat:@"Score:%.0f",score]];
    lablab2.position = ccp(lablab2.contentSize.width/2,winSize.height-lablab2.contentSize.height/2);
    //[lablab3 setString:[NSString stringWithFormat:@"%.0fCOMBO!!",combo]];
    [combonum setString:[NSString stringWithFormat:@"%.0f",combo]];
    //l_combo.position = ccp(winSize.width-l_combo.contentSize.width/2 ,l_combo.contentSize.height/2);
    combonum.position = ccp(winSize.width-l_combo.contentSize.width-combonum.contentSize.width, 0);
    
    if(combo > 0){
        if(combo == 10){
            if(winSize.width >= 768){
                [l_combo setTexture:[[CCTextureCache sharedTextureCache] addImage: @"combo2-ipad.png"]];
            }else{
                [l_combo setTexture:[[CCTextureCache sharedTextureCache] addImage: @"combo2.png"]];
            }
        }
        combonum.visible = YES;
        l_combo.visible = YES;
    }else{
        combonum.visible = NO;
        l_combo.visible = NO;
    }
    
    [CCAnimation animationWithAnimationFrames:nil delayPerUnit:100 loops:1];
}

// 1秒に1回実行されるループ処理
-(void)onScheduleAddBall:(ccTime)delta{
    if(isGameStart){
        int rand = CCRANDOM_0_1()*8;
        if(rand == 0){
            Ball *ball = [Ball newBall:drag];
            [ball setOpacity:0];
            [self addChild:ball z:1 tag:ballcount];
            [ball runAction:[CCFadeIn actionWithDuration:0.2f]];
            [[SimpleAudioEngine sharedEngine] playEffect:@"initBall.wav"];
            ballcount++;
        }
    }
}

//タッチの開始
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if(isGameStart){
        [[SimpleAudioEngine sharedEngine] playEffect:@"initKAKOI.wav"];
        drag = [Drag sharedManager];
        [drag setOrigin:location];
    }
    //CCLOG(@"Touch(%f,%f)",location.x,location.y);
}

//タッチの移動
-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if(isGameStart){
        [drag setSize:location];
    }
    //CCLOG(@"Move(%f,%f)",location.x,location.y);
}

//タッチの終了
-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(isGameStart){
        [drag refreshRect];
        [self checkHitBall];
        [drag touchend];
    }
    //CCLOG(@"End(%f,%f)",location.x,location.y);
}

-(void)ccTouchCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(isGameStart){
        [drag refreshRect];
        [drag touchend];
    }
}

//画面上にある球が囲いの中に入っているか
- (void)checkHitBall
{
    int count = 0;
    int yellowcount = 0;
    int base = 0;
    int add_score = 0;
    
    CCArray *array = [self getBalls];
    
    for(Ball *obj in array){
        if(obj != nil){
            if([drag checkHit:obj.position]){
                count++;
                getnum++;   //全体の取得数を加算
            
                switch(obj->type){
                    case 0:
                        //通常得点
                        base = 10;
                        break;
                    case 1:
                        //得点2倍
                        base = 0;
                        yellowcount++;
                        break;
                    case 2:
                        //減点
                        base = -10;
                        break;
                }
            
                add_score += (combo*base + base);
                
                if(obj->isExist){
                    [obj catched];
                }
            }
        }
    }

    add_score += 5*count;
    add_score *= pow(2,yellowcount);
    long dragsize = (drag->rect.size.width * drag->rect.size.height);
    if(dragsize > 0) add_score *= 1+((self.contentSize.width * self.contentSize.height)/dragsize)/50 * percentage;
    
    score += add_score;
    if(score <= 0){
        score = 0;
    }
    if(count <= 0){
        combo = 0;
        if(winSize.width >= 768){
            [l_combo setTexture:[[CCTextureCache sharedTextureCache] addImage: @"combo1-ipad.png"]];
        }else{
            [l_combo setTexture:[[CCTextureCache sharedTextureCache] addImage: @"combo1.png"]];
        }
        [[SimpleAudioEngine sharedEngine] playEffect:@"failedKAKOI.wav"];
    }else{
        combo++;
        id scale = [CCScaleBy actionWithDuration:0.1f scale:1.5];
        id scale2 = [scale reverse];
        [combonum runAction:[CCSequence actions:scale,scale2,nil]];
        //[l_combo runAction:[CCSequence actions:scale,scale2,nil]];
        if(combo >= 10){
            [[SimpleAudioEngine sharedEngine] playEffect:@"paaan.wav"];
        }else{
            [[SimpleAudioEngine sharedEngine] playEffect:@"successKAKOI.wav"];
        }
    }
    
    if(maxCombo < combo) maxCombo = combo;  //最大コンボ数を更新
}

- (CCArray *)getBalls
{
    CCArray *array = [[[CCArray alloc] init] autorelease];
    
    for(int i=100; i<ballcount; i++){
        CCNode *node = [self getChildByTag:i];
        if(node != nil){
            [array addObject:node];
        }
    }
    
    //[array addObject:nil];
    
    return array;
}

- (void)gameSet
{
    isGameStart = NO;
    [gBgm stop];
    [drag unscheduleUpdate];
    drag->updating = NO;
    drag.visible = NO;
    [drag removeFromParentAndCleanup:YES];
    [[SimpleAudioEngine sharedEngine] playEffect:@"timeup.wav"];
    CCArray *balls = [self getBalls];
    
    for(Ball *ball in balls){
        [ball unschedule:@selector(onUpdate)];
        [self unschedule:@selector(onScheduleAddBall:)];
        [self unschedule:@selector(onScheduleTimeCount:)];
    }
    
    //LeaderBoardにスコアを送信する
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:@"1"];
    NSInteger scoreR;
    scoreR=(NSInteger)score;
    scoreReporter.value = scoreR;
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil)
        {
            // 報告エラーの処理
            NSLog(@"error %@",error);
        }
    }];

    //レイヤーを切り替える
    CCScene *scene = [[CCDirector sharedDirector] runningScene];
    
    CCLayerColor *colorLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 127)];
    ResultLayer *layer = [ResultLayer new];
    layer.score = score;
    layer.getnum = getnum;
    layer.allnum = ballcount-100;
    layer.maxCombo = maxCombo;
    
    [scene addChild:colorLayer];
    [scene addChild:layer];
    [layer release];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
    
    //[lablab release];
    //[lablab2 release];
    //[lablab3 release];
    [gBgm release];
}

- (void)onExit
{
    [super onExit];
    
    [gBgm stop];
}
/*
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
 */
    
@end