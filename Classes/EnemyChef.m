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

#import "EnemyChef.h"

#define ORIGINAL_HEALTH 10


@implementation EnemyChef
static NSString * ImgChars = @"chars_50x50.png";
int counter;




+ (id) enemyChefWithOrigin:(CGPoint)Origin index:(int)Index;
{
	return [[[self alloc] initWithOrigin:Origin index:Index] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin index:(int)Index
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
        [self loadGraphicWithParam1:ImgChars param2:YES param3:NO param4:50 param5:80];
        
        self.width = 10;
        self.height = 30;        
        self.offset = CGPointMake(20, 50);
        
        self.health = ORIGINAL_HEALTH;
        self.acceleration = CGPointMake(0, 2000);
        
        index = Index;
		originalHealth = ORIGINAL_HEALTH;
        [self addAnimationWithParam1:@"idle" param2:[NSMutableArray intArrayWithSize:1 ints:5] param3:0];
        [self addAnimationWithParam1:@"talk" param2:[NSMutableArray intArrayWithSize:2 ints:5,58] param3:7]; 

        [self addAnimationWithParam1:@"walk" param2:[NSMutableArray intArrayWithSize:6 ints:30,31,32,33,34,35] param3:8];
        [self addAnimationWithParam1:@"run" param2:[NSMutableArray intArrayWithSize:6 ints:30,31,32,33,34,35] param3:14];
        [self addAnimationWithParam1:@"runPreview" param2:[NSMutableArray intArrayWithSize:6 ints:30,31,32,33,34,35] param3:16];
        [self play:@"walk"];
        self.originalXPos = Origin.x;
        self.originalYPos = Origin.y;
        
	}
	
	return self;	
}


- (void) dealloc
{
	[super dealloc];
}


- (void) update
{   
    
    [super update];
    
	
}


@end
