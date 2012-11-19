//
//  TWEnemy.m
//  TextWorlds
//
//  Created by Phillip Van Nortwick on 11/19/12.
//
//

#import "TWEnemy.h"

@interface TWEnemy()
@property (nonatomic, strong) CCSprite *sprite;
@end
    
@implementation TWEnemy
@synthesize type = _type;
@synthesize level = _level;
@synthesize sprite = _sprite;

#pragma mark - AI
/*
 * Guess
 *
 * Returns: True if should type the correct letter next
 */
- (bool) guess {
    //hard coded a 50% success rate...
    if(arc4random_uniform(2) == 0)
        return YES;
    
    return NO;
}

/*
 * TypingSpeed
 *
 * Returns: speed at which guess should be called under typical play
 */
- (float) typingSpeed {
    return 1.0f; //half second
}

#pragma mark - UI Related Functions
- (CCSprite *) sprite
{
    if(_sprite)
        return _sprite;
    
    //create sprite now
    NSString *fileName;
    switch (self.type) {
        //todo: add in actual cases
        default:
            fileName = @"ninja.png";
            break;
    }
    
    _sprite = [CCSprite spriteWithFile:fileName];
    _sprite.scale = 2.0f;
    [_sprite setColor:ccc3(120, 0, 0)];
    
    return _sprite;
}

#pragma mark - Initializors
- (id) enemyWithLevel:(NSUInteger)level {
    //we need to randomly decide the enemy type
    self.type = arc4random_uniform(ENEMY_TYPE_COUNT);
    self.level = level;
    
    return self;
}

@end
