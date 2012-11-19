//
//  TWWordDisplay.m
//  TextWorlds
//
//  Created by Phillip Van Nortwick on 11/19/12.
//
//

#import "TWWordDisplay.h"

@interface TWWordDisplay() {
    CCLabelTTF * _word1A;
    CCLabelTTF * _word1B;
    CCLabelTTF * _word2A;
    CCLabelTTF * _word2B;

    float _width;
    float _height;
    
    NSInteger _playerCnt;
    NSInteger _enemyCnt;
}

@end

@implementation TWWordDisplay

#pragma mark - Core Logic
@synthesize theWord = _theWord;
- (void) setTheWord:(NSString *)theWord {
    //on change, we reset the display
    [self removeAllChildrenWithCleanup:YES];
    
    _theWord = theWord;
    
    //display base labels
    CGSize size = [theWord sizeWithFont:[UIFont fontWithName:@"Courier New" size:40]];
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    
    _word1A = [CCLabelTTF labelWithString:theWord fontName:@"Courier New" fontSize:40];
    _word1A.color = ccc3(0, 0, 150);
    _word1A.position = ccp(windowSize.width/2, windowSize.height - 90 + size.height/3);

    _word2A = [CCLabelTTF labelWithString:theWord fontName:@"Courier New" fontSize:40];
    _word2A.color = ccc3(150, 0, 0);
    _word2A.position = ccp(windowSize.width/2, windowSize.height - 90 - size.height/3);
    
    [self addChild:_word1A];
    [self addChild:_word2A];
    
    _playerCnt = 0;
    _enemyCnt = 0;
}

- (bool) guessFor:(NSInteger *)counter andLabel:(CCLabelTTF *)label andColor:(NSInteger)color {
    
    (*counter)++;
    if(label)
        [self removeChild:label cleanup:YES];
    
    NSString *guessed = [_theWord substringToIndex:*counter];
    label = [CCLabelTTF labelWithString:guessed fontName:@"Courier New" fontSize:40.0f];

    CGSize size = [_theWord sizeWithFont:[UIFont fontWithName:@"Courier New" size:40.0f]];
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    label.anchorPoint = ccp(0, 0.5);
    if(color == 1) {
        label.color = ccc3(220, 220, 255);
        label.position = ccp(windowSize.width/2 - size.width/2, windowSize.height - 90 + size.height/3);
    } else {
        label.color = ccc3(255, 220, 220);
        label.position = ccp(windowSize.width/2 - size.width/2, windowSize.height - 90 - size.height/3);
    }
    
    [self addChild:label];
    
    if(*counter == _theWord.length) {
        //show victory or loss label
        NSString *label;
        if(color == 1)
            label = @"Victory!";
        else
            label = @"You Lost";
        
        CCLabelTTF *labelSprite = [CCLabelTTF labelWithString:label fontName:@"Chalkduster" fontSize:45];
        labelSprite.color = ccc3(150,150,150);
        labelSprite.position = ccp(windowSize.width/2, windowSize.height - 90);
        [self addChild:labelSprite];
        
        return YES;
    }
    return NO;
}

- (bool) playerGuess:(bool)success
{
    if(!success)
        return NO;

    return [self guessFor:&_playerCnt andLabel:_word1B andColor:1];
}

- (bool) enemyGuess:(bool)success
{
    if(!success)
        return NO;
    
    return [self guessFor:&_enemyCnt andLabel:_word2B andColor:2];
}

#pragma mark - UIDisplay

@end
