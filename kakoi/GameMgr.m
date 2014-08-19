//
//  GameMgr.m
//  kakoi
//
//  Created by Yuki Yamada on 2013/06/13.
//
//

#import "GameMgr.h"
#import "Ball.h"

@implementation GameMgr

@synthesize tasklist=_tasklist;

- (void)addObject:(id)obj
{
    [_tasklist addObject:obj];
}

- (void)onUpdate{
    /*
    for(id *obj in _tasklist){
        if(![obj onUpdate]){
            [obj removeFromParentAndCleanup:YES];
            [_tasklist removeObject:obj];
        }
    }
     */
}

- (void)search
{
    uint index = 0;
    if((index = [_tasklist indexOfObject:@"drag"])){
        NSLog(@"index = %d",index);
        [_tasklist exchangeObjectAtIndex:index withObjectAtIndex:_tasklist.count];
    }
}

@end