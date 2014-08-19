//
//  Drag.m
//  kakoi
//
//  Created by Yuki Yamada on 2013/06/20.
//
//

#import "Drag.h"

@implementation Drag

//@synthesize isExist, isCatch;

static Drag* sharedHistory = nil;

+ (Drag*)sharedManager {
    @synchronized(self) {
        if (sharedHistory == nil) {
            sharedHistory = [Drag spriteWithFile:@"drag.png"];
            [sharedHistory set];
        }
    }
    return sharedHistory;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedHistory == nil) {
            sharedHistory = [super allocWithZone:zone];
            return sharedHistory;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;  // シングルトン状態を保持するため何もせず self を返す
}

- (id)retain {
    return self;  // シングルトン状態を保持するため何もせず self を返す
}

- (unsigned)retainCount {
    return UINT_MAX;  // 解放できないインスタンスを表すため unsigned int 値の最大値 UINT_MAX を返す
}

- (oneway void)release {
    // シングルトン状態を保持するため何もしない
}

- (id)autorelease {
    return self;  // シングルトン状態を保持するため何もせず self を返す
}

-(void)set
{
    [self setTexture:[[CCTextureCache sharedTextureCache] addImage: @"drag.png"]];
    if(!updating){
        [self scheduleUpdate];
    }
    updating = YES;
    size.width = contentSize_.width;
    size.height = contentSize_.height;
    _isCatch = NO;
}

-(void)update:(ccTime)dt
{
    self.position = ccp(fabs(current.x + first.x)/2, fabs(current.y + first.y)/2);
    //self.position = ccp(current.x, current.y);
    self.scaleX = fabs(current.x - first.x)/size.width;
    self.scaleY = fabs(current.y - first.y)/size.height;
}

-(void)setOrigin:(CGPoint)point
{
    visible_ = YES;
    first = point;
    current = point;
    position_ = point;
    //isExist = YES;
    _isCatch = NO;
}

-(void)setSize:(CGPoint)point;
{
    current = point;
    //position_ = ccp(fabs(current.x + first.x)/2, fabs(current.y + first.y)/2);
    //scaleX_ = fabs(current.x - first.x)/size.width;
    //scaleY_ = fabs(current.y - first.y)/size.height;
}

-(void)touchend
{
    visible_ = NO;
    first = CGPointMake(0, 0);
    current = CGPointMake(0, 0);
    _isCatch = YES;
    //[self removeFromParentAndCleanup:YES];
}

- (void)refreshRect
{
    rect = CGRectMake((first.x > current.x) ? current.x : first.x, (first.y > current.y) ? current .y : first.y, fabs(current.x - first.x), fabs(current.y - first.y));
}

- (bool)checkHit:(CGPoint)point
{
    return CGRectContainsPoint(rect, point);
}

@end
