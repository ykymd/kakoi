//
//  ResultLayer.h
//  kakoi
//
//  Created by Yuki Yamada on 2013/08/05.
//
//

#import "cocos2d.h"
#import <Twitter/Twitter.h>

@interface ResultLayer : CCLayer
{
    bool canTouch;
    bool showScore;
    
    CCSprite *timeup;
}

@property(nonatomic,assign)double score;
@property(nonatomic,assign)int maxCombo;
@property(nonatomic,assign)float getnum;
@property(nonatomic,assign)float allnum;

@end
