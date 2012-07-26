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

#import "Player.h"

#define MOVE_SPEED_ON_SUGAR_HIGH 235;
#define JUMP_HEIGHT_ON_SUGAR_HIGH 0.250;
#define MOVE_SPEED_REGULAR 200;
#define JUMP_HEIGHT_REGULAR 0.170;


NSString * ImgPlayer = @"chars_50x50.png";
NSString * SndJump = @"jump.caf";
//int jumpCounter=0;
//
////setting to a large number means air dash won't happen on level start.
//float airDashTimer=11110;
//
//float moveSpeed;
//float timeOnLeftArrow;
//float timeOnRightArrow;
//
//BOOL canDoubleJump=NO;
//BOOL _canJump=NO;
//
//BOOL hasDoubleJumped=NO;

@implementation Player

@synthesize jump;
@synthesize jumpLimit;
@synthesize ableToStartJump;
@synthesize isPlayerControlled;
@synthesize isMale;
@synthesize isAirDashing;
@synthesize dontDash;

@synthesize dying;
@synthesize readyToSwitchCharacters;
@synthesize jumpInitialMultiplier;
@synthesize jumpInitialTime;
@synthesize jumpSecondaryMultiplier;
@synthesize jumpTimer;
@synthesize cutSceneMode;

@synthesize startsFirst;
@synthesize levelName;
@synthesize andreInitialFlip;
@synthesize liselotInitialFlip;

@synthesize jumpCounter;
@synthesize airDashTimer;
@synthesize moveSpeed;
@synthesize timeOnLeftArrow;
@synthesize timeOnRightArrow;
@synthesize canDoubleJump;
@synthesize _canJump;
@synthesize hasDoubleJumped;
@synthesize isPiggyBacking;

@synthesize followWidth;
@synthesize followHeight;

@synthesize levelStartX;
@synthesize levelStartY;


+ (id) playerWithOrigin:(CGPoint)Origin
{
	return [[[self alloc] initWithOrigin:Origin] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
        [self loadGraphicWithParam1:ImgPlayer param2:YES param3:NO param4:50 param5:80];
		
        self.isPlayerControlled=YES;
        self.isMale=YES;
        
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
        
        self.followWidth=0;
        self.followHeight=0;
        
        //jumping variables
        
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
        
        cutSceneMode=NO;
        
        jumpCounter=0;

        //setting to a large number means air dash won't happen on level start.
        airDashTimer=11110;



        canDoubleJump=NO;
        _canJump=NO;

        hasDoubleJumped=NO;
        
        isPiggyBacking=NO;
        
        dontDash=YES;
        
        [self addAnimationWithParam1:@"piggyback" param2:[NSMutableArray intArrayWithSize:6 ints:72,73,74,75,76,77] param3:12 param4:YES]; 
        [self addAnimationWithParam1:@"piggyback_idle" param2:[NSMutableArray intArrayWithSize:1 ints:78] param3:0]; 
        [self addAnimationWithParam1:@"piggyback_jump" param2:[NSMutableArray intArrayWithSize:3 ints:76,77,76] param3:4 param4:YES];
        [self addAnimationWithParam1:@"piggyback_dash" param2:[NSMutableArray intArrayWithSize:1 ints:80] param3:0];

        
        [self addAnimationWithParam1:@"m_run" param2:[NSMutableArray intArrayWithSize:6 ints:10,11,6,7,8,9] param3:16];
        [self addAnimationWithParam1:@"m_run_push_crate" param2:[NSMutableArray intArrayWithSize:6 ints:46,47,42,43,44,45] param3:16 param4:YES];
        [self addAnimationWithParam1:@"m_dash" param2:[NSMutableArray intArrayWithSize:1 ints:79] param3:0];


        [self addAnimationWithParam1:@"m_idle" param2:[NSMutableArray intArrayWithSize:1 ints:51] param3:0];
        [self addAnimationWithParam1:@"m_talk" param2:[NSMutableArray intArrayWithSize:6 ints:51,48,51,49,51,50] param3:12];
        [self addAnimationWithParam1:@"m_jump" param2:[NSMutableArray intArrayWithSize:3 ints:46,47,46] param3:4 param4:YES];
        [self addAnimationWithParam1:@"m_death" param2:[NSMutableArray intArrayWithSize:8 ints:60,60,61,61,62,62,63,63] param3:12 param4:NO];

        [self addAnimationWithParam1:@"f_run" param2:[NSMutableArray intArrayWithSize:6 ints:12,13,14,15,16,17] param3:16]; 
        [self addAnimationWithParam1:@"f_run_push_crate" param2:[NSMutableArray intArrayWithSize:6 ints:69,70,71,81,82,83] param3:16 param4:YES];        

        [self addAnimationWithParam1:@"f_idle" param2:[NSMutableArray intArrayWithSize:1 ints:2] param3:0];
        [self addAnimationWithParam1:@"f_talk" param2:[NSMutableArray intArrayWithSize:6 ints:2,55] param3:12];
        [self addAnimationWithParam1:@"f_jump" param2:[NSMutableArray intArrayWithSize:3 ints:15,16,17] param3:4 param4:YES];
        [self addAnimationWithParam1:@"f_death" param2:[NSMutableArray intArrayWithSize:8 ints:64,64,65,65,66,66,67,67] param3:12 param4:NO];

        [self play:@"m_idle"];
		
	}
	
	return self;	
}


- (void) dealloc
{
	
	[super dealloc];
}

- (void) hitBottomWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
    if ((FlxG.touches.vcpButton2 || FlxG.touches.iCadeA) && jumpCounter>0) {
        ableToStartJump = NO;
    }
    
    else {
        ableToStartJump=YES;
        jumpCounter=0;

    }
    
    
    jump = 0;
    
    canDoubleJump=NO;
    hasDoubleJumped=NO;
    
    //if (!FlxG.touches.touching) jump = 0;

    [super hitBottomWithParam1:Contact param2:Velocity];
        
    
    
    if ([Contact isKindOfClass:[FlxSpriteOnPath class]]) {
        
    }
    else if (self.velocity.y<1) {
        self.y = roundf(self.y);
    }
    
}

- (void) hitTopWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
    
    [super hitTopWithParam1:Contact param2:Velocity];
    
}
- (void) hitRightWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
    moveSpeed = 15;
    
    //[self play:@"m_run_push_crate"];
    
    [super hitRightWithParam1:Contact param2:Velocity];
    
}
- (void) hitLeftWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
    moveSpeed = 15;
    
    //[self play:@"m_run_push_crate"];

    [super hitLeftWithParam1:Contact param2:Velocity];
    
}

- (void) stopDash
{
    airDashTimer=1000000;
}



- (void) update
{        
    //NSLog(@"%f player.m start of update", self.y);
    
//    if (self.isMale)
//        NSLog(@"%@ %f %f, %d", _curAnim.name , self.velocity.y, self.y, onFloor);
    
    airDashTimer+=FlxG.elapsed;
    
    if (onLeft || onRight){
        moveSpeed=115;
    }
    else {
        moveSpeed+=40;
        if (moveSpeed>200) moveSpeed=200;        
    }
    if (FlxG.touches.vcpLeftArrow || FlxG.touches.iCadeLeft) {
        timeOnLeftArrow+=FlxG.elapsed;
    }
    else {
        timeOnLeftArrow=0;
    }
    if (FlxG.touches.vcpRightArrow || FlxG.touches.iCadeRight) {
        timeOnRightArrow+=FlxG.elapsed;
    }
    else {
        timeOnRightArrow=0;
    }
    //NSLog(@"pos  %f  v %f %@ %d", self.y, self.velocity.y, _curAnim.name, onFloor);

    self.isAirDashing=NO;
    
    if (self.isPlayerControlled ) {
    
        if (airDashTimer>0.076) {
            if ((FlxG.touches.vcpLeftArrow || FlxG.touches.iCadeLeft) && !self.dead) {
                //NSLog(@" %f " , timeOnLeftArrow);
                if (timeOnLeftArrow<0.25){
                    self.velocity = CGPointMake(-(150 + (timeOnLeftArrow*200)), self.velocity.y);
                }
                else {
                    self.velocity = CGPointMake(-moveSpeed, self.velocity.y);

                }
                self.scale = CGPointMake(-1, 1);
            } 
            if ((FlxG.touches.vcpRightArrow || FlxG.touches.iCadeRight) && !self.dead) {
                if (timeOnRightArrow<0.25){
                    self.velocity = CGPointMake(150 + (timeOnRightArrow*200), self.velocity.y);
                }
                else {
                    self.velocity = CGPointMake(moveSpeed, self.velocity.y);
                    
                }                
                self.scale = CGPointMake(1, 1);
            } 
            

            //jumping Mario Style
            if(jump >= 0 && (FlxG.touches.vcpButton2 || FlxG.touches.iCadeA) && !self.dead && ableToStartJump)
            {
                // first press of jump
                if (jump==0) {
                    jumpCounter++;
                    [FlxG play:SndJump withVolume:0.3];
                }
                
                jump += FlxG.elapsed;
                if(jump > jumpTimer) jump = -1; //You can't jump for more than the jump timer
            }
            else jump = -1;
            
            if (jump > 0)
            {
                if(jump < jumpInitialTime)
                    velocity.y = -maxVelocity.y*jumpInitialMultiplier; //This is the minimum speed of the jump
                else
                    velocity.y = -maxVelocity.y*jumpSecondaryMultiplier; //The general acceleration of the jump
            } 
        }
        else {
            if (self.scale.x > 0  ) { //FlxG.touches.swipedUp || 
                self.velocity = CGPointMake(600, self.velocity.y);
                self.isAirDashing=YES;
            } else if (self.scale.x < 0 ) { //FlxG.touches.swipedDown  || 
                self.velocity = CGPointMake(-600, self.velocity.y);
                self.isAirDashing=YES;
            }
        }
        
        //jump a second time
        
        if ((!FlxG.touches.vcpButton2 && !FlxG.touches.iCadeA) && !self.onFloor) {
            canDoubleJump=YES;
        }
        
            
        
        //air dash
        if (self.isMale && !self.dead) {
            if (self.scale.x > 0 && ((FlxG.touches.vcpButton1 && FlxG.touches.newTouch) || FlxG.touches.iCadeBBegan) && !self.dead && self.dontDash) { //FlxG.touches.swipedUp || 
                self.velocity = CGPointMake(600, self.velocity.y);
                airDashTimer=0;
                self.isAirDashing=YES;
                [FlxG playWithParam1:@"whoosh.caf" param2:0.1 param3:NO];


            } else if (self.scale.x < 0 && ((FlxG.touches.vcpButton1 && FlxG.touches.newTouch) || FlxG.touches.iCadeBBegan)&& !self.dead && self.dontDash) { //FlxG.touches.swipedDown  || 
                self.velocity = CGPointMake(-600, self.velocity.y);
                airDashTimer=0;
                self.isAirDashing=YES;
                [FlxG playWithParam1:@"whoosh.caf" param2:0.1 param3:NO];


            } 
        }
        
        if (!self.isMale) {
            //NSLog(@"vcp2 %d newt %d jc %d selfonFloor %d num %d" , FlxG.touches.vcpButton2 , FlxG.touches.newTouch , jumpCounter==1  , !self.onFloor, FlxG.touches.numberOfTouches );
            //NSLog(@" vcp1 %d vcp1end %d ", FlxG.touches.vcpButton1TouchesBegan, FlxG.touches.vcpButton1TouchesEnded);

            if ( (FlxG.touches.vcpButton2 || FlxG.touches.iCadeA) && canDoubleJump && !hasDoubleJumped && jumpCounter==1  && !self.onFloor) {
                //NSLog(@"hit a double jump");
                self.velocity = CGPointMake(self.velocity.x, -410);
                jumpCounter++;
                [FlxG play:SndJump withVolume:0.25];

                canDoubleJump=NO;
                hasDoubleJumped=YES;

            }
        }
        
    }
    
    if (self.scale.x > 0) {
        if (self.velocity.x > 1 && onFloor) {
            if (self.isMale){
                if (self.isPiggyBacking) {
                    if (self.isAirDashing)
                        [self play:@"piggyback_dash"];
                    else
                        [self play:@"piggyback"]; 
                }
                else {
                    if (onRight || onLeft)
                        [self play:@"m_run_push_crate"]; 
                    else {
                        if (self.isAirDashing)
                            [self play:@"m_dash"]; 

                        else
                            [self play:@"m_run"]; 
                    }

                }
            }
            else {
                if (onRight || onLeft)
                    [self play:@"f_run_push_crate"]; 
                else
                    [self play:@"f_run"]; 
                
            }
        }
        else if (dying || dead) {
            if (self.isMale) [self play:@"m_death"];
            else if (!self.isMale) [self play:@"f_death"];
        }
        else if (!onFloor) {
            if (self.isMale) {
                if (self.isPiggyBacking) {
                    if (self.isAirDashing)
                        [self play:@"piggyback_dash"];
                    else
                        [self play:@"piggyback_jump"]; 
                }
                else {
                    if (self.isAirDashing)
                        [self play:@"m_dash"]; 
                    
                    else
                        [self play:@"m_jump"]; 
                }           
            }
            else [self play:@"f_jump"];        
        }
        
        else {
            if (self.isMale) {
                if (self.isPiggyBacking) {
                    [self play:@"piggyback_idle"]; 
                }
                else {
                    [self play:@"m_idle"]; 
                }            
            }
            else {
                if (cutSceneMode==YES) {
                    [self play:@"f_idle_for_cutscene"]; 
                } 
                else {
                    [self play:@"f_idle"];        
                }
            }        }
    }
    
    //facing left
    if (self.scale.x < 0) {

        if (self.velocity.x < -1 && onFloor) {
            if (self.isMale){
                if (self.isPiggyBacking) {
                    if (self.isAirDashing)
                        [self play:@"piggyback_dash"];
                    else
                        [self play:@"piggyback"]; 
                }
                else {
                    if (onRight || onLeft)
                        [self play:@"m_run_push_crate"]; 
                    else {
                        if (self.isAirDashing)
                            [self play:@"m_dash"]; 
                        
                        else
                            [self play:@"m_run"]; 
                    }
                }
            }
            else {
                if (onRight || onLeft)
                    [self play:@"f_run_push_crate"]; 
                else
                    [self play:@"f_run"]; 
                
            }
        }
        else if (dying || dead) {
            if (self.isMale) [self play:@"m_death"];
            else if (!self.isMale) [self play:@"f_death"];
        }
        else if (!onFloor) {
            if (self.isMale) {
                if (self.isPiggyBacking) {
                    if (self.isPiggyBacking) {
                        if (self.isAirDashing)
                            [self play:@"piggyback_dash"];
                        else
                            [self play:@"piggyback_jump"]; 
                    }                }
                else {
                    if (self.isAirDashing)
                        [self play:@"m_dash"]; 
                    
                    else
                        [self play:@"m_jump"]; 
                }            
            }
            else [self play:@"f_jump"];        
        }
        
        else {
            if (self.isMale) {
                if (self.isPiggyBacking) {
                    [self play:@"piggyback_idle"]; 
                }
                else {
                    [self play:@"m_idle"]; 
                }            
            }
            else {
                if (cutSceneMode==YES) {
                    [self play:@"f_idle_for_cutscene"]; 
                } 
                else {
                    [self play:@"f_idle"];        
                }
            }        }
    }    
    if (self.y > FlxG.levelHeight) {
        self.dead = YES;
    }

    
    //
    // used when scaling was done after switching.
    // 
//    //scale to correct size after character switch.
//    if (self.scale.y > 1) 
//    {
//        float sy = self.scale.y-0.1;
//        self.scale = CGPointMake(self.scale.x, sy);
//    }   
	
	[super update];
    
    //NSLog(@"dying: %d, curFrame %d ready? %d dead %d", dying, _curFrame, readyToSwitchCharacters, dead);
    
    if (_curFrame==7) {
        //dying = NO;
        readyToSwitchCharacters=YES;
        
    }
    
    //NSLog(@"%f %f", self.x, self.y);
    
    dontDash=YES;

}


@end
