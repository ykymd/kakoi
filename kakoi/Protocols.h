//
//  Task.h
//  kakoi
//
//  Created by Yuki Yamada on 2013/06/13.
//
//

#import <Foundation/Foundation.h>

@protocol Task <NSObject>

//各種オブジェクトの更新処理
- (int)onUpdate;

- (void)deleteSelf;

@end
