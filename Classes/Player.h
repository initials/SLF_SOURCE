/*
 * Copyright (c) 2011-2012 Initials Video Games
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */ 


@interface Player : FlxManagedSprite
{
    CGFloat jump;
    CGFloat jumpLimit;
    BOOL ableToStartJump;
    BOOL isPlayerControlled;
    BOOL isMale;
    BOOL isAirDashing;
    BOOL dontDash;

    BOOL dying;
    BOOL readyToSwitchCharacters;
    
    float jumpInitialMultiplier;
    float jumpInitialTime;
    float jumpSecondaryMultiplier;
    float jumpTimer;
    
    
    
    int jumpCounter;
    float airDashTimer;
    float moveSpeed;
    float timeOnLeftArrow;
    float timeOnRightArrow;
    BOOL canDoubleJump;
    BOOL _canJump;
    BOOL hasDoubleJumped;
    BOOL isPiggyBacking;
    BOOL cutSceneMode;

    
    
    int startsFirst;
    NSString * levelName;
    int andreInitialFlip;
    int liselotInitialFlip;
    
    int followWidth;
    int followHeight;
    
    float levelStartX;
    float levelStartY;
    

}

+ (id) playerWithOrigin:(CGPoint)Origin;
- (id) initWithOrigin:(CGPoint)Origin;
- (void) stopDash;


@property CGFloat jump;
@property CGFloat jumpLimit;
@property BOOL ableToStartJump;
@property BOOL isPlayerControlled;
@property BOOL isMale;
@property    BOOL isAirDashing;
@property    BOOL dontDash;

@property     BOOL dying;
@property     BOOL readyToSwitchCharacters;
@property float jumpInitialMultiplier;
@property float jumpInitialTime;
@property float jumpSecondaryMultiplier;
@property float jumpTimer;
@property int startsFirst;
@property (assign) NSString * levelName;
@property int andreInitialFlip;
@property int liselotInitialFlip;

@property BOOL cutSceneMode;

@property int jumpCounter;
@property float airDashTimer;
@property float moveSpeed;
@property float timeOnLeftArrow;
@property float timeOnRightArrow;
@property BOOL canDoubleJump;
@property BOOL _canJump;
@property BOOL hasDoubleJumped;

@property BOOL isPiggyBacking;

@property int followWidth;
@property int followHeight;

@property float levelStartX;
@property float levelStartY;




@end
