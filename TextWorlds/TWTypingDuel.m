//
//  TWTypingDuel.m
//  TextWorlds
//
//  Created by Phillip Van Nortwick on 11/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

const float PADDING = 5;
const float KEYBOARD_HEIGHT_IPHONE = 216; //iphone keyboard height

//264 pixels -> viewing height 3.5" screen
//176 extra on 4" screen

#import "TWTypingDuel.h"
#import "AppDelegate.h"
#import "TWKeyboardControl.h"
#import "TWEnemy.h"
#import "TWWordDisplay.h"

@interface TWTypingDuel() {
    TWWordDisplay * _wordLayer;
}

//enemy
@property (nonatomic, strong) TWEnemy *enemy;
@property (nonatomic, strong) NSString *wordLeft;

//display related properties
@property (nonatomic) float width;
@property (nonatomic) float top;

//standard UI elements
@property (nonatomic, strong) CCLabelTTF *score;
@end

@implementation TWTypingDuel
@synthesize enemy = _enemy;
@synthesize width = _width;
@synthesize top = _top;
@synthesize wordLeft = _wordLeft;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
    
    TWWordDisplay *word = [TWWordDisplay node];
    //word.position = ccp(size.width/2, (size.height - KEYBOARD_HEIGHT_IPHONE)/2);
    [scene addChild:word z:1];
    
	TWTypingDuel *layer = [[[TWTypingDuel alloc] initWithWord:word] autorelease]; //[TWTypingDuel node];
    layer.position = ccp(0,KEYBOARD_HEIGHT_IPHONE);
    [scene addChild:layer];
    
	// return the scene
	return scene;
}

- (void) renderWord {
    [_wordLayer setTheWord:@"NINJA"];
    self.wordLeft = @"NINJA";
}

- (void) startTyping {
    [self schedule:@selector(enemyTyped) interval:self.enemy.typingSpeed];
}

- (void) enemyTyped {
    NSString *character;
    if(self.enemy.guess) {
        character = @"X";
        if([_wordLayer enemyGuess:YES]) {
            //enemy won!
            [self showMenu];
        }
    } else {
        character = @"Z";
        [_wordLayer enemyGuess:NO];
    }
    
    //either way show typed letter in the field...
    CCLabelTTF *tempLetter = [CCLabelTTF labelWithString:character fontName:@"Courier New" fontSize:18];
    tempLetter.position = ccp(3*self.width/4 + arc4random_uniform(40) - 20, 180 + arc4random_uniform(20));
    tempLetter.color = ccc3(0,0,255);
    [self addChild:tempLetter];
    
    [tempLetter runAction:[CCSequence actions:
                           [CCDelayTime actionWithDuration:1.0f],
                           [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)],
                           nil]];
}

- (void) setupEnemy
{
    NSUInteger currentLevel;
    
    if(self.enemy) {
        currentLevel = self.enemy.level;
        
        //remove old sprite reference
        [self removeChild:self.enemy.sprite cleanup:YES];
    } else {
        currentLevel = 1;
    }
    
    self.enemy = [[TWEnemy alloc] enemyWithLevel:currentLevel];
    CCSprite *enemySprite = self.enemy.sprite;
    
    enemySprite.anchorPoint = ccp(0.5,0);
    enemySprite.position = ccp(3*self.width/4, 0);
    [self addChild:enemySprite];
    
    [self scheduleOnce:@selector(startTyping) delay:self.enemy.typingSpeed];
}

- (id) initWithWord:(TWWordDisplay *)word {
    CGSize size = [CCDirector sharedDirector].winSize;
    //if( !(self=[super initWithColor:ccc4(255,255,255,255)] )) {
    if(!(self = [super initWithColor:ccc4(255,255,255,255) width:size.width height:size.height - KEYBOARD_HEIGHT_IPHONE])) {
        return self;
    }
    
    _wordLayer = word;

    self.width = size.width;
    self.top = size.height - KEYBOARD_HEIGHT_IPHONE;
    
    //we want to show the keyboard UI
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [app.keyboard becomeFirstResponder];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(handleNotification:) name:@"KeyboardKeyTyped" object:nil];
    
    //static UI elements
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:@"Score" fontName:@"Courier New" fontSize:14];
    scoreLabel.color = ccc3(50,50,50);
    scoreLabel.position = ccp(self.width - PADDING, self.top - PADDING);
    scoreLabel.anchorPoint = ccp(1,1); //position refers to right top corner
    [self addChild:scoreLabel];
    
    self.score = [CCLabelTTF labelWithString:@"0" fontName:@"Courier New" fontSize:18];
    self.score.color = ccc3(0,0,0);
    self.score.position = ccp(self.width - PADDING, self.top - PADDING - [@"Score" sizeWithFont:[UIFont fontWithName:@"Courier New" size:14]].height);
    self.score.anchorPoint = ccp(1,1); //position refers to right top corner
    [self addChild:self.score];
    
    [self renderWord];
    [self setupEnemy];
    
    CCSprite *me = [CCSprite spriteWithFile:@"ninja.png"];
    me.scale = 2.0f;
    me.flipX = YES;
    me.anchorPoint = ccp(0.5, 0.0);
    me.position = ccp(self.width/4, 0);
    [self addChild:me];
    
    return self;
}


#pragma mark - Keyboard & associated functions
//handle user keyboard inputs
- (void) removeSprite:(id)sender {
    [self removeChild:sender cleanup:YES];
}

- (void) handleNotification:(NSNotification *)notification
{
    //for now we only have keyboard notifications, but to be safe
    if(![notification.object isKindOfClass:[NSString class]])
        return;
    
    NSString *character = (NSString *)notification.object;
    
    if(self.wordLeft.length == 0) return;
    
    //kick off animation showing typed letter above character
    CCLabelTTF *tempLetter = [CCLabelTTF labelWithString:character fontName:@"Courier New" fontSize:18];

    tempLetter.position = ccp(self.width/4 + arc4random_uniform(40) - 20, 180 + arc4random_uniform(20));
    tempLetter.color = ccc3(0,0,255);
    [self addChild:tempLetter];

    //typing animation to keep screen active
    [tempLetter runAction:[CCSequence actions:
        [CCDelayTime actionWithDuration:1.0f],
        [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)],
        nil]];

    //check if this is equal to the next letter we need and/or a bonus word on screen?
    if([character isEqualToString:[self.wordLeft substringToIndex:1]]) {
        [_wordLayer playerGuess:YES];
        if(self.wordLeft.length == 1) {
            //victory, stop enemy tries
            self.wordLeft = @"";
            [self showMenu];
            return;
        }
        
        self.wordLeft = [self.wordLeft substringFromIndex:1];
    } else {
        [_wordLayer playerGuess:NO];
    }
}

- (void) showMenu {
    //stop any animations
    [self stopAllActions];
    [self unschedule:@selector(enemyTyped)];
    
    //show menu
    CCMenuItem *menu1 = [CCMenuItemFont itemWithString:@"Restart" target:self selector:@selector(restartGame)];
    
    CCMenu *menu = [CCMenu menuWithItems:menu1, nil];
    menu.color = ccc3(0,0,0);
    
    menu.position = ccp(self.width/2, self.top/2);
    [self addChild:menu];    
}

- (void) restartGame {
    //transition to same scene...
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TWTypingDuel scene] withColor:ccWHITE]];
}

@end
