//
//  TWWordDisplay.h
//  TextWorlds
//
//  Created by Phillip Van Nortwick on 11/19/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TWWordDisplay : CCLayer

@property (nonatomic, strong) NSString *theWord;
- (bool) playerGuess:(bool)success;
- (bool) enemyGuess:(bool)success;

@end
