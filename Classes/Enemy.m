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

#import "Enemy.h"
#define POINTS_FOR_HURT 0
#define POINTS_FOR_KILL 0
#define ORIGINAL_HEALTH 0

@implementation Enemy


@synthesize timer;
@synthesize originalHealth;
@synthesize index;
@synthesize limitX;
@synthesize limitY;
@synthesize isTalking;
@synthesize originalVelocity;

@synthesize canRun;


+ (id) enemyWithOrigin:(CGPoint)Origin index:(int)Index
{
	return [[[self alloc] initWithOrigin:Origin index:Index] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin index:(int)Index
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
		
        //speechBubble = [[FlxSprite spriteWithX:0 y:0 graphic:@"speechBubbleTiles.png"] retain];
        
		//gravity
		self.acceleration = CGPointMake(0, 0);
		self.velocity = CGPointMake(20, 0);
		//self.drag = CGPointMake(10, 10);
        
        self.originalXPos = Origin.x;
        self.originalYPos = Origin.y;
        isTalking=NO;
        canRun = YES;

                
        		
	}
	
	return self;	
}

- (void) hitLeftWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
    //NSLog(@"hit left");
    //velocity.x = -velocity.x;
    CGFloat i = self.velocity.x * -1;
    self.velocity = CGPointMake(i, 0);
    
    //self.x = self.x + 10;
    
    //[super hitLeftWithParam1:Contact param2:Velocity];
}

- (void) hitRightWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
    //NSLog(@"hit Right vel %f", self.velocity.x);
    //velocity.x = -velocity.x;
    
    CGFloat i = self.velocity.x * -1;
    self.velocity = CGPointMake(i, 0);
    //self.x = self.x -= 20;
    
    //NSLog(@"hit Right vel %f", self.velocity.x);

    //self.x = self.x - 10;
    
    //[super hitRightWithParam1:Contact param2:Velocity];
}

- (void) dealloc
{
	//[speechBubble release];
	[super dealloc];
}

- (void) hurt:(float)Damage
{
    [self flicker:0.25];
    self.health -= Damage;
    if (self.health <= 0 && self.dead == NO) {
        dead = YES;
        //visible = NO;
        //self.x = 1000;
        //self.y = 1000;
        self.velocity = CGPointMake(self.velocity.x,-250);
        self.angularVelocity = self.velocity.x*2;
        [self flicker:0.75];
        //self.acceleration = CGPointMake(0,0);

    }
    else {
        [FlxG play:@"deathSFX.caf"];

    }
}

- (NSString *) getCurAnim {
    return _curAnim.name;
}

- (void) run {
    if (canRun && self.onFloor) {
        self.velocity = CGPointMake(self.velocity.x*2.45, self.velocity.y);
        canRun=NO;
    }
}

- (void) runAndJump 
{
    [self runAndJump:400];
    
}

- (void) runAndJump:(float)jumpHeight
{
    if (canRun && self.onFloor) {
        self.velocity = CGPointMake(self.velocity.x*2.45, jumpHeight * -1);
        canRun=NO;
    }
}

- (void) runJumpAndTurn:(float)jumpHeight;
{
    if (canRun && self.onFloor) {
        self.velocity = CGPointMake(self.velocity.x*-2.45, jumpHeight * -1);
        self.scale=CGPointMake(self.scale.x*-1, self.scale.y);
        canRun=NO;
    }
}


- (void) render
{
    //[speechBubble render];
    [super render];
}

- (void) talk:(BOOL)startTalking
{
    if (startTalking) {
        isTalking=YES;
        self.velocity=CGPointMake(0, 0);
        [self play:@"talk"];
    }
    else if (!startTalking) {
        [self play:@"walk"];
        isTalking=NO;
        if (self.scale.x==1) {
            self.velocity=CGPointMake(originalVelocity,0 );
        } else if (self.scale.x==-1) {
            self.velocity=CGPointMake(originalVelocity*-1,0 );
        }
    }
}


- (void) update
{   
    
    if (self.x >= limitX ) {    
        self.x = limitX-1;
        CGFloat i = self.velocity.x * -1;
        //self.velocity = CGPointMake(i, 0);
        
        self.velocity = CGPointMake(-self.originalVelocity, self.velocity.y);
        [self play:@"walk"];
        
        //NSLog(@">=");
        //NSLog(@"x==%f, oX==%f", self.x, limitX);

        
        canRun=YES;
    } else if (self.x <= originalXPos) {
        self.x = originalXPos+1;
        CGFloat i = self.velocity.x * -1;
        //self.velocity = CGPointMake(i, 0);  
        
        self.velocity = CGPointMake(self.originalVelocity, self.velocity.y);
        [self play:@"walk"];
        
        //NSLog(@"<=");
        //NSLog(@"x==%f, oX==%f", self.x, originalXPos);

        
        canRun=YES;
    }
    
    if (!isTalking) {
        if (self.velocity.x >= 0) {
            self.scale = CGPointMake(1, 1);
        }
        else {
            self.scale = CGPointMake(-1, 1);
        }
    }
    
    

	[super update];
    //NSLog(@"bottom update vel %f", self.velocity.x);

}


@end
