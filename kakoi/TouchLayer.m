//
//  TouchLayer.m
//  kakoi
//
//  Created by Yuki Yamada on 2013/07/24.
//
//

//
//囲い部分の横幅がおかしい
//

#import "TouchLayer.h"
#import "Ball.h"

@interface TouchLayer()

@end

@implementation TouchLayer

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        self.isTouchEnabled = YES;
        drag = [Drag newDrag];
	}
	return self;
}

-(void)onEnter
{
    [super onEnter];
    
    //スコアをリセット
    score = 0;
    
    //コンボ数をリセット
    combo = 0;
    
    // スケジュールを設定
    [self scheduleUpdate]; // メインループ 1秒に60回実行される
}

-(void) update:(ccTime)dt{
    if(drag != nil){
        drag.position = ccp(fabs(drag->current.x + drag->first.x)/2, fabs(drag->current.y + drag->first.y)/2);
        drag.scaleX = (float)(fabs(drag->current.x - drag->first.x)/contentSize_.width);
        drag.scaleY = (float)(fabs(drag->current.y - drag->first.y)/contentSize_.height);
        
        /*
        [drag refreshRect];
        for(Ball *obj in ballMgr.array){
            if([drag checkHit:obj.position]){
                obj.color = ccc3(127, 127, 127);
            }else{
                obj.color = ccc3(255, 255, 255);
            }
        }
         */
    }
}

//タッチの開始
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    drag = [Drag newDrag];
    [drag setOrigin:location];
    [self addChild:drag];

    //CCLOG(@"Touch(%f,%f)",location.x,location.y);
}

//タッチの移動
-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    [drag setSize:location];
    
    //CCLOG(@"Move(%f,%f)",location.x,location.y);
}

//タッチの終了
-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    [drag refreshRect];
    //[self calcScore:[self checkHitBall]];
    //[self checkHitBall];
    
    [drag touchend];
    drag.visible = NO;
    //CCLOG(@"End(%f,%f)",location.x,location.y);
}

//画面上にある球が囲いの中に入っているか
- (void)checkHitBall
{
    int count = 0;
    int yellowcount = 0;
    int base = 0;
    int add_score = 0;
    
    for(Ball *obj in ballMgr.array){
        if(obj == nil){
            [ballMgr.array removeObject:obj];
            continue;
        }
        
        if([drag checkHit:obj.position]){
            count++;
            
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
            [obj deleteSelf];
        }
    }
    
    add_score += 5*count;
    add_score *= pow(2,yellowcount);
    long dragsize = (drag->rect.size.width * drag->rect.size.height);
    if(dragsize <= 0) dragsize = 1;
    add_score *= (self.contentSize.width * self.contentSize.height)/dragsize;
    
    score += add_score;
}

@end
