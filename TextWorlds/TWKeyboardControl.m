//
//  TWKeyboardControl.m
//  TextWorlds
//
//  Created by Phillip Van Nortwick on 11/18/12.
//
//

#import "TWKeyboardControl.h"
@interface TWKeyboardControl() <UIKeyInput>
@end

@implementation TWKeyboardControl
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)insertText:(NSString *)text {
    text = [text uppercaseString];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KeyboardKeyTyped" object:text];
}

- (void)deleteBackward {
    // Handle the delete key
}

- (BOOL)hasText {
    // Return whether there's any text present
    return YES;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
