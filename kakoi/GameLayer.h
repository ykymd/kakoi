//
//  GameLayer.h
//  kakoi
//
//  Created by Yuki Yamada on 2013/06/13.
//
//

//#import <GameKit/GameKit.h>
#import "cocos2d.h"

#import <AVFoundation/AVFoundation.h>
#import "Drag.h"

// HelloWorldLayer
@interface GameLayer : CCLayer
//<GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CCLabelTTF *lablab;
    CCLabelTTF *lablab2;
    //CCLabelTTF *lablab3;
    
    CCLabelAtlas *timenum;
    
    CCLabelAtlas *combonum;
    CCSprite *l_combo;
    
    double score, combo;
    AVAudioPlayer *gBgm;
    CCLabelTTF *_label;
    
    CGSize winSize;
    
    @private
    int remaintime;
    bool isPlay;
    bool isGameStart;
    float ballcount;
    int maxCombo;
    float getnum;
    double percentage;
}

@property(nonatomic, strong, retain)Drag *drag;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
