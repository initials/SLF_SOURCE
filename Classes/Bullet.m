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

#import "Bullet.h"

static NSString * ImgBullet = @"tapiocaPearl.png";

@implementation Bullet


@synthesize timer;
@synthesize damage;

+ (id) bulletWithOrigin:(CGPoint)Origin
{
	return [[[self alloc] initWithOrigin:Origin] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
		
		[self loadGraphicWithParam1:ImgBullet param2:YES param3:NO param4:8 param5:8];
        [self addAnimationWithParam1:@"color0" param2:[NSMutableArray intArrayWithSize:1 ints:0] param3:0];
        [self addAnimationWithParam1:@"color1" param2:[NSMutableArray intArrayWithSize:1 ints:1] param3:0];
        [self addAnimationWithParam1:@"color2" param2:[NSMutableArray intArrayWithSize:1 ints:2] param3:0];
        [self addAnimationWithParam1:@"color3" param2:[NSMutableArray intArrayWithSize:1 ints:3] param3:0];
        [self addAnimationWithParam1:@"color4" param2:[NSMutableArray intArrayWithSize:1 ints:4] param3:0];
        [self addAnimationWithParam1:@"color5" param2:[NSMutableArray intArrayWithSize:1 ints:5] param3:0];
        [self addAnimationWithParam1:@"color6" param2:[NSMutableArray intArrayWithSize:1 ints:6] param3:0];
        [self addAnimationWithParam1:@"color7" param2:[NSMutableArray intArrayWithSize:1 ints:7] param3:0];        
        if ([FlxU random]*8 <= 1) {
            [self play:@"color0"];

        } else if ([FlxU random]*8 <= 2) {
            [self play:@"color1"];
            
        } else if ([FlxU random]*8 <= 3) {
            [self play:@"color2"];
            
        } else if ([FlxU random]*8 <= 4) {
            [self play:@"color3"];
            
        } else if ([FlxU random]*8 <= 5) {
            [self play:@"color4"];
            
        } else if ([FlxU random]*8 <= 6) {
            [self play:@"color5"];
            
        } else if ([FlxU random]*8 <= 7) {
            [self play:@"color6"];
            
        } else if ([FlxU random]*8 <= 8) {
            [self play:@"color7"];
            
        }
        
        

		timer = 0.0;
        damage = 1;
	}
	
	return self;	
}


- (void) dealloc
{

	[super dealloc];
}


- (void) update
{   
    if ( self.velocity.x <= 2 && self.velocity.x >= -2 ) {
        //self.dead = YES;
        self.x = 1000;
        self.y = 1000;
    }
    
    if (self.x < 0 || self.x > FlxG.levelWidth || self.y < 0 || self.y > FlxG.levelHeight) {
        self.dead =YES;
    }
    
    
	
	[super update];
	
}


@end
