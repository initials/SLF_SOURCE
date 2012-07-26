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

#import "Bottle.h"

static NSString * ImgBottle = @"bottle.png";

@implementation Bottle

+ (id) bottleWithOrigin:(CGPoint)Origin
{
	return [[[self alloc] initWithOrigin:Origin] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
		
		[self loadGraphicWithParam1:ImgBottle param2:YES param3:NO param4:12 param5:26];
        //self.acceleration = CGPointMake(0, 500);
        self.width = 12;
        self.height = 24;
        self.drag = CGPointMake(1500, 0);
        
        [self addAnimationWithParam1:@"grape" param2:[NSMutableArray intArrayWithSize:2 ints:0,1] param3:4];
        [self addAnimationWithParam1:@"orange" param2:[NSMutableArray intArrayWithSize:1 ints:2] param3:0];
        [self addAnimationWithParam1:@"lemonade" param2:[NSMutableArray intArrayWithSize:1 ints:2] param3:0];
        [self addAnimationWithParam1:@"lime" param2:[NSMutableArray intArrayWithSize:1 ints:3] param3:0];
        [self addAnimationWithParam1:@"grapeStatic" param2:[NSMutableArray intArrayWithSize:1 ints:0] param3:0];

        [self play:@"grape"];
        
        originalXPos=Origin.x;
        originalYPos=Origin.y;
        
	}
	
	return self;	
}

- (void) resetPosition
{
    int levelW = FlxG.levelWidth - self.width;
    self.x = levelW * [FlxU random] ;
    self.y = FlxG.levelHeight * [FlxU random] - (self.height*2);

}


- (void) dealloc
{
    
	[super dealloc];
}

- (void) hitBottomWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
    
    [super hitBottomWithParam1:Contact param2:Velocity];
    self.y = roundf(self.y);
    
}



- (void) update
{   
	
	[super update];
	
}


@end
