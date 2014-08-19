//
//  Ball.h
//  kakoi
//
//  Created by Yuki Yamada on 2013/06/13.
//
//

#import "cocos2d.h"
#import "Drag.h"

@interface Ball : CCSprite {
    Drag *drag;
    @public
    int type;
    bool isExist;
    @private
    CGSize winSize;
    CGPoint vel;
    float existtime;
    float collapsetime;
    bool isIn;
}

+(Ball *)newBall:(Drag*)dr;
-(void)deleteSelf;
-(void)catched;

@end
