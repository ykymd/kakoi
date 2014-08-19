//
//  Ball.m
//  kakoi
//
//  Created by Yuki Yamada on 2013/06/13.
//
//

#import "Ball.h"
#import "SimpleAudioEngine.h"

@implementation Ball

+(Ball *)newBall:(Drag*)dr
{
    Ball *ball = [Ball spriteWithFile:@"ball1.png"];
    [ball set:dr];
    return ball;
}

-(void)set:(Drag*)dr
{
    //存在フラグをセット
    isExist=YES;
    
    //SEを鳴らしても良いか
    isIn = YES;
    
    self->drag = dr;
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"SE_IN.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"SE_OUT.wav"];
    
    //画面サイズを取得
    winSize = [[CCDirector sharedDirector] winSize];
    position_ = CGPointMake(CCRANDOM_0_1()*(winSize.width-contentSize_.width/2), CCRANDOM_0_1()*(winSize.height-contentSize_.height/2));
    vel = CGPointMake(CCRANDOM_MINUS1_1()*8, CCRANDOM_MINUS1_1()*8);
    collapsetime = CCRANDOM_0_1()*600+300;
    int rand = CCRANDOM_0_1()*4;
    switch(rand){
        case 0:
        case 1:
            type = 0;
            if(winSize.width >= 768){
                [self setTexture:[[CCTextureCache sharedTextureCache] addImage: @"ball1-ipad.png"]];
            }else{
                [self setTexture:[[CCTextureCache sharedTextureCache] addImage: @"ball1.png"]];
            }
            break;
        case 2:
            //得点2倍
            type = 1;
            if(winSize.width >= 768){
                [self setTexture:[[CCTextureCache sharedTextureCache] addImage: @"ball2-ipad.png"]];
            }else{
                [self setTexture:[[CCTextureCache sharedTextureCache] addImage: @"ball2.png"]];
            }
            break;
        case 3:
            type = 2;
            if(winSize.width >= 768){
                [self setTexture:[[CCTextureCache sharedTextureCache] addImage: @"ball3-ipad.png"]];
            }else{
                [self setTexture:[[CCTextureCache sharedTextureCache] addImage: @"ball3.png"]];
            }
            break;
    }
    
    [self schedule:@selector(onUpdate)];
    [self fire:vel];
}

- (void)onUpdate
{
    if(drag != nil && [self hitDrag]){
        self.color = ccc3(127, 127, 127);
        if(isIn){
            [[SimpleAudioEngine sharedEngine] playEffect:@"SE_IN.wav"];
            isIn = NO;
        }
    }else{
        self.color = ccc3(255, 255, 255);
        if(!isIn){
            [[SimpleAudioEngine sharedEngine] playEffect:@"SE_OUT.wav"];
            isIn = YES;
        }
    }
    
    [self hitWall];
    position_.x += vel.x;
    position_.y += vel.y;
    [self collapse];
}

-(void)fire:(CGPoint)_velocity
{
    float speed = sqrt(_velocity.x*_velocity.x+_velocity.y*_velocity.y);
    
    // ボールにアクションを設定
    CCRotateBy *rotate = [CCRotateBy actionWithDuration:speed angle:360];
    CCRepeatForever *r_rotate = [CCRepeatForever actionWithAction:rotate];
    
    // アクション開始
    [self runAction:r_rotate];
}

-(void)hitWall{
    if(position_.x > winSize.width - contentSize_.width/2){
        position_.x = winSize.width - contentSize_.width/2;
        vel.x *= -1;
    }else if(position_.x <  contentSize_.width/2){
        position_.x = contentSize_.width/2;
        vel.x *= -1;
    }
    if(position_.y > winSize.height - contentSize_.height/2){
        position_.y = winSize.height - contentSize_.height/2;
        vel.y *= -1;
    }else if(position_.y <  contentSize_.height/2){
        position_.y = contentSize_.height/2;
        vel.y *= -1;
    }
}

-(bool)hitDrag
{
    [drag refreshRect];
    return CGRectContainsPoint(drag->rect, self.position);
}

-(void)collapse
{
    existtime++;
    if(existtime > collapsetime && isExist){
        isExist = NO;
        // ボールにアクションを設定
        id fade = [CCFadeOut actionWithDuration:0.2f];
        id func = [CCCallFunc actionWithTarget:self selector:@selector(deleteSelf)];
        // アクション開始
        [self runAction:[CCSequence actions:fade, func, nil]];
    }
}

-(void)catched
{
    [self unschedule:@selector(onUpdate)];
    id scale = [CCScaleTo actionWithDuration:0.3f scale:0];
    id func = [CCCallFunc actionWithTarget:self selector:@selector(deleteSelf)];
    [self runAction:[CCSequence actions:scale, func, nil]];
    isExist = YES;
}

-(void)deleteSelf{
    // レイヤーから削除
    [self removeFromParentAndCleanup:YES];
}

- (void)dealloc
{
    [super dealloc];
    
    self = nil;
}

@end
