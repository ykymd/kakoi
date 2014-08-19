//
//  Drag.h
//  kakoi
//
//  Created by Yuki Yamada on 2013/06/20.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Drag : CCSprite
{
    @public
    CGPoint first;
    CGPoint current;
    CGRect rect;
    CGSize size;
    double add_score;
    BOOL updating;
    double score;
}

//@property(nonatomic)bool isExist;   //存在しているか
@property(nonatomic)bool isCatch;   //指を画面から離してキャッチ状態か

+(Drag *)sharedManager;
-(void)set;
-(void)setOrigin:(CGPoint)point;
-(void)setSize:(CGPoint)point;
-(void)touchend;
- (void)refreshRect;
- (bool)checkHit:(CGPoint)point;

@end