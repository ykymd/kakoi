//
//  TitleLayer.h
//  kakoi
//
//  Created by Yuki Yamada on 2013/06/13.
//
//

//#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#import <AVFoundation/AVFoundation.h>

// HelloWorldLayer
@interface TitleLayer : CCLayer<GKLeaderboardViewControllerDelegate>
{
    bool isPlay;
    AVAudioPlayer *tBgm;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
