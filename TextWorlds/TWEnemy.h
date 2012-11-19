//
//  TWEnemy.h
//  TextWorlds
//
//  Created by Phillip Van Nortwick on 11/19/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define ENEMY_TYPE_COUNT 2

typedef enum EnemyType : NSUInteger EnemyType;
enum EnemyType : NSUInteger {
    EnemyNinja,
    EnemyPirate
};

@interface TWEnemy : NSObject
//type - determines appearance of enemy (pirate, etc)
@property (nonatomic) EnemyType type;
@property (nonatomic) NSUInteger level;

- (float) typingSpeed;
- (bool) guess;

//UI properties
- (CCSprite *) sprite;

//initializors
- (id) enemyWithLevel:(NSUInteger)level; //random enemy type

@end
