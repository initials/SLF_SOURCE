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


#import "Liselot.h"

#define ORIGINAL_HEALTH 10

static NSString * ImgLiselot = @"chars_50x50.png";

@implementation Liselot
//@synthesize dying;
//@synthesize readyToSwitchCharacters;
//@synthesize isMale;
@synthesize isTalking;


+ (id) liselotWithOrigin:(CGPoint)Origin
{
	return [[[self alloc] initWithOrigin:Origin] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
		
		[self loadGraphicWithParam1:ImgLiselot param2:YES param3:NO param4:50 param5:80];
        
        //self.vcpButtonBontrolled=NO;
        
		//gravity
		self.acceleration = CGPointMake(0, 1500);
		
		self.drag = CGPointMake(1900, 1900);
        
        self.width = 10;
        self.height = 41;        
        self.offset = CGPointMake(20, 39);
        self.originalXPos = Origin.x;
        self.originalYPos = Origin.y;
        
        self.levelStartX = Origin.x;
        self.levelStartY = Origin.y;
        
        
        //jump=0;
        
        maxVelocity.x = 300;
        maxVelocity.y = 430;
        self.isMale=NO;

        dying=NO;
        readyToSwitchCharacters=NO;
        
        jump=0;
        jumpCounter=0;
        jumpInitialMultiplier=0.64;   // 0.550
        jumpSecondaryMultiplier=.68;  //1.0
        jumpInitialTime= 0.248;        // 0.095
        jumpTimer=0.34;             //0.170
        
        moveSpeed=200;
        timeOnLeftArrow=0;
        timeOnRightArrow=0;
        
        readyToSwitchCharacters=NO;
        dying=NO;
        ableToStartJump=YES;
        
        maxVelocity.x = 300;
        maxVelocity.y = 430;
        
        onFloor=YES;
        
        jumpCounter=0;
        
        //setting to a large number means air dash won't happen on level start.
        airDashTimer=11110;
        
        cutSceneMode=NO;
        
        
        canDoubleJump=NO;
        _canJump=NO;
        
        hasDoubleJumped=NO;
        
        [self addAnimationWithParam1:@"piggyback" param2:[NSMutableArray intArrayWithSize:6 ints:72,73,74,75,76,77] param3:12 param4:YES];        
        [self addAnimationWithParam1:@"f_run" param2:[NSMutableArray intArrayWithSize:6 ints:12,13,14,15,16,17] param3:16];        
        [self addAnimationWithParam1:@"f_idle" param2:[NSMutableArray intArrayWithSize:1 ints:59] param3:0];
        [self addAnimationWithParam1:@"f_talk" param2:[NSMutableArray intArrayWithSize:6 ints:2,55] param3:12];
        [self addAnimationWithParam1:@"f_jump" param2:[NSMutableArray intArrayWithSize:3 ints:15,16,17] param3:4 param4:YES];
        [self addAnimationWithParam1:@"f_death" param2:[NSMutableArray intArrayWithSize:8 ints:64,64,65,65,66,66,67,67] param3:12 param4:NO];
        
        [self addAnimationWithParam1:@"f_idle_for_cutscene" param2:[NSMutableArray intArrayWithSize:1 ints:2] param3:0];



        [self addAnimationWithParam1:@"m_run" param2:[NSMutableArray intArrayWithSize:6 ints:6,7,8,9,10,11] param3:16];
        [self addAnimationWithParam1:@"m_idle" param2:[NSMutableArray intArrayWithSize:1 ints:1] param3:0];
        [self addAnimationWithParam1:@"m_talk" param2:[NSMutableArray intArrayWithSize:6 ints:1,48,1,49,1,50] param3:12];
        [self addAnimationWithParam1:@"m_jump" param2:[NSMutableArray intArrayWithSize:3 ints:46,47,46] param3:4 param4:YES];
        [self addAnimationWithParam1:@"m_death" param2:[NSMutableArray intArrayWithSize:8 ints:60,60,61,61,62,62,63,63] param3:12 param4:NO];

        
        
        [self play:@"f_idle"];
        
        isTalking=NO;

	}
	
	return self;	
}


- (void) hitTopWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
    [super hitTopWithParam1:Contact param2:Velocity];
}

- (void) hitBottomWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
    [super hitBottomWithParam1:Contact param2:Velocity];
    
    if ([Contact isKindOfClass:[FlxSpriteOnPath class]]) {
        
    }
    else if (self.velocity.y<1) {
        self.y = roundf(self.y);
    }}


- (void) dealloc
{
    
	[super dealloc];
}


- (void) talk:(BOOL)startTalking
{
    if (startTalking) {
        isTalking=YES;
        [self play:@"talk"];
    }
    else if (!startTalking) {
        isTalking=NO;
    }
}



- (void) update
{   
    
//    if (FlxG.touches.swipedLeft || FlxG.touches.swipedRight) {
//        
//        
//        //self.isPlayerControlled=!self.isPlayerControlled;
//                
//        [FlxG playWithParam1:@"trick4.caf" param2:0.6 param3:NO];
//    }
    
    
    if (self.scale.x > 0) {
        if (self.isPiggyBacking) {
            if (self.isMale)
                [self play:@"piggyback"]; 
            else [self play:@"piggyback"];             
        }
        else if (self.velocity.x > 1 && onFloor) {
            if (self.isMale)
                [self play:@"m_run"]; 
            else [self play:@"f_run"];            
        }
        else if (dying || dead) {
            if (self.isMale) [self play:@"m_death"];
            else if (!self.isMale) [self play:@"f_death"];
        }
        else if (!onFloor) {
            if (self.isMale)
                [self play:@"m_jump"];
            else [self play:@"f_jump"];        
        }
        
        else {
            if (self.isMale)
                [self play:@"m_idle"];
            else {
                if (cutSceneMode==YES) {
                    [self play:@"f_idle_for_cutscene"]; 
                } 
                else {
                [self play:@"f_idle"];        
                }
            }
        }
    }
    
    //facing left
    if (self.scale.x < 0) {
        if (self.isPiggyBacking) {
            if (self.isMale)
                [self play:@"piggyback"]; 
            else [self play:@"piggyback"];             
        }
        else if (self.velocity.x < -1 && onFloor) {
            if (self.isMale)
                [self play:@"m_run"]; 
            else [self play:@"f_run"];
        }
        else if (dying || dead) {
            if (self.isMale) [self play:@"m_death"];
            else if (!self.isMale) [self play:@"f_death"];
        }
        else if (!onFloor) {
            if (self.isMale)
                [self play:@"m_jump"];
            else [self play:@"f_jump"];
        }
        else {
            if (self.isMale)
                [self play:@"m_idle"];
            else {
                if (cutSceneMode==YES) {
                    [self play:@"f_idle_for_cutscene"]; 
                } 
                else {
                    [self play:@"f_idle"];        
                }
            }
        }
    } 
    
	[super update];
    if (_curFrame==7) {
        //dying = NO;
        readyToSwitchCharacters=YES;
        
    }

}


@end
