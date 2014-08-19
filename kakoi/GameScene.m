//
//  GameScene.m
//  kakoi
//
//  Created by Yuki Yamada on 2013/08/05.
//
//

#import "GameScene.h"
#import "GameLayer.h"
#import "TouchLayer.h"

@implementation GameScene

- (id)init
{
    if(self = [super init]){
        // 'layer' is an autorelease object.
        GameLayer *layer = [GameLayer node];
        //TouchLayer *tlayer = [TouchLayer node];
        
        // add layer as a child to scene
        [self addChild: layer];
        //[self addChild:tlayer];
    }
    return self;
}

@end
