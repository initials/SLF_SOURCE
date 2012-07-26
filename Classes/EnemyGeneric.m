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

#import "EnemyGeneric.h"

#define ORIGINAL_HEALTH 10


@implementation EnemyGeneric
static NSString * ImgChars = @"chars_50x50.png";
int counter;

@synthesize _index;



+ (id) enemyGenericWithOrigin:(CGPoint)Origin index:(int)Index
{
	return [[[self alloc] initWithOrigin:Origin index:Index] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin index:(int)Index
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
        [self loadGraphicWithParam1:ImgChars param2:YES param3:NO param4:50 param5:80];
        
        self.width = 30;
        self.height = 30;        
        self.offset = CGPointMake(10, 50);

        
        self.health = ORIGINAL_HEALTH;
        self.dead = YES;
        //self.acceleration = CGPointMake(0, -2000);
        
        self._index=Index;
        

        
        [self addAnimationWithParam1:@"playerRun" param2:[NSMutableArray intArrayWithSize:6 ints:6,7,8,9,10,11] param3:16];
        [self addAnimationWithParam1:@"playerRunWithGun" param2:[NSMutableArray intArrayWithSize:6 ints:42,43,44,45,46,47] param3:16];
        [self addAnimationWithParam1:@"playerIdle" param2:[NSMutableArray intArrayWithSize:1 ints:51] param3:0];
        
        [self addAnimationWithParam1:@"playerTalk" param2:[NSMutableArray intArrayWithSize:2 ints:51,48] param3:6 param4:YES];
        [self addAnimationWithParam1:@"workerListen" param2:[NSMutableArray intArrayWithSize:1 ints:0] param3:0];  
        [self addAnimationWithParam1:@"playerListen" param2:[NSMutableArray intArrayWithSize:1 ints:51] param3:0];       
        [self addAnimationWithParam1:@"liselotListen" param2:[NSMutableArray intArrayWithSize:1 ints:2] param3:0];       
        [self addAnimationWithParam1:@"inspectorListen" param2:[NSMutableArray intArrayWithSize:1 ints:3] param3:0];       
        [self addAnimationWithParam1:@"armyListen" param2:[NSMutableArray intArrayWithSize:1 ints:4] param3:0];       
        [self addAnimationWithParam1:@"chefListen" param2:[NSMutableArray intArrayWithSize:1 ints:5] param3:0]; 
        
        [self addAnimationWithParam1:@"workerTalk" param2:[NSMutableArray intArrayWithSize:4 ints:0, 53, 52, 54] param3:6];  
        [self addAnimationWithParam1:@"liselotTalk" param2:[NSMutableArray intArrayWithSize:2 ints:2,55] param3:6 param4:YES];       
        [self addAnimationWithParam1:@"inspectorTalk" param2:[NSMutableArray intArrayWithSize:2 ints:3,56] param3:8];       
        [self addAnimationWithParam1:@"armyTalk" param2:[NSMutableArray intArrayWithSize:2 ints:4,57] param3:6];       
        [self addAnimationWithParam1:@"chefTalk" param2:[NSMutableArray intArrayWithSize:2 ints:5,58] param3:7]; 

        [self addAnimationWithParam1:@"chef_run" param2:[NSMutableArray intArrayWithSize:6 ints:30,31,32,33,34,35] param3:12];
        [self addAnimationWithParam1:@"worker_run" param2:[NSMutableArray intArrayWithSize:6 ints:18,19,20,21,22,23] param3:22];
        [self addAnimationWithParam1:@"army_run" param2:[NSMutableArray intArrayWithSize:6 ints:36,37,38,39,40,41] param3:22];
        [self addAnimationWithParam1:@"inspector_run" param2:[NSMutableArray intArrayWithSize:6 ints:24,25,26,27,28,29] param3:22];

        
        
        
		[self play:@"playerTalk"];
        
	}
	
	return self;	
}


- (void) dealloc
{
	[super dealloc];
}


//- (void) resetSwarm:(int)newMovementType
//{
//    [super resetSwarm:0];
//    health = ORIGINAL_HEALTH ;
//    CGFloat vel = 0;
//    if ([FlxU random] > 0.5) {
//        vel = -80 + ([FlxU random] * 20);
//        self.x = FlxG.width-10;
//    }
//    else {
//        vel = 60 + ([FlxU random] * 20);
//        self.x = 10;
//    }
//    self.velocity = CGPointMake( vel ,0);  //a ? e1 : e2    
//}


- (void) update
{   
    
    if (self._index==0) {
        if (self.velocity.x > 10 || self.velocity.x < -10) 
            [self play:@"army_run"];
        else
            [self play:@"armyTalk"];
    }
    
    else if (self._index==1) {
        if (self.velocity.x > 10 || self.velocity.x < -10) 
            [self play:@"chef_run"];
        else
            [self play:@"chefTalk"];
    }
    
    else if (self._index==2) {
        if (self.velocity.x > 10 || self.velocity.x < -10) 
            [self play:@"inspector_run"];
        else
            [self play:@"inspectorTalk"];    
    }
    
    else if (self._index==3) {
        if (self.velocity.x > 10 || self.velocity.x < -10) 
            [self play:@"worker_run"];
        else
            [self play:@"workerTalk"];     
    }
    
//    NSLog(@"%@", _curAnim.name);
    
    
    [super update];
    
	
}


@end
