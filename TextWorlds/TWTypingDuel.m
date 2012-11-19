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

@interface TWTypingDuel()
@property (nonatomic, strong) CCLabelTTF *activeWord;
@property (nonatomic, strong) CCLabelTTF *score;
@end

@implementation TWTypingDuel
@synthesize activeWord;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TWTypingDuel *layer = [TWTypingDuel node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

- (void) renderWord {
    if(self.activeWord) {
        [self removeChild:self.activeWord cleanup:YES];
    }
    
    self.activeWord = [CCLabelTTF labelWithString:@"Word" fontName:@"Courier New" fontSize:32];
    self.activeWord.color = ccc3(0,0,0);
    
    CGSize size = [CCDirector sharedDirector].winSize;
    //for now center word
    self.activeWord.position = ccp(size.width/2, KEYBOARD_HEIGHT_IPHONE + (size.height - KEYBOARD_HEIGHT_IPHONE)/2);
    
    [self addChild:self.activeWord];
}

- (id) init {
    if( !(self=[super initWithColor:ccc4(255,255,255,255)] )) {
        return self;
    }
    CGSize size = [CCDirector sharedDirector].winSize;
    
    //we want to show the keyboard UI
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [app.keyboard becomeFirstResponder];

    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:@"Score" fontName:@"Courier New" fontSize:14];
    scoreLabel.color = ccc3(50,50,50);
    scoreLabel.position = ccp(size.width - PADDING, size.height - PADDING);
    scoreLabel.anchorPoint = ccp(1,1); //position refers to right top corner
    [self addChild:scoreLabel];
    
    self.score = [CCLabelTTF labelWithString:@"0" fontName:@"Courier New" fontSize:18];
    self.score.color = ccc3(0,0,0);
    self.score.position = ccp(size.width - PADDING, size.height - PADDING - [@"Score" sizeWithFont:[UIFont fontWithName:@"Courier New" size:14]].height);
    self.score.anchorPoint = ccp(1,1); //position refers to right top corner
    [self addChild:self.score];
    
    [self renderWord];
    
    return self;
}
@end
