#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameMgr : NSObject

@property(nonatomic, assign)CCArray *tasklist;

- (void)onUpdate;

@end