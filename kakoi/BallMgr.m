//
//  BallMgr.m
//  kakoi
//
//  Created by Yuki Yamada on 2013/08/04.
//
//

#import "BallMgr.h"

@implementation BallMgr

@synthesize array=_array;

- (id)init
{
    if(self = [super init]){
        _array = [[CCArray alloc] init];
    }
    return self;
}

@end
