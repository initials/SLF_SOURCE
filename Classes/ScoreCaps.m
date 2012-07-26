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

#import "ScoreCaps.h"

static NSString * ImgCaps = @"scorecaps.png";

@implementation ScoreCaps

@synthesize canScale;
@synthesize scaleRate;
@synthesize sound;

+ (id) scoreCapsWithOrigin:(CGPoint)Origin
{
	return [[[self alloc] initWithOrigin:Origin] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
		
		[self loadGraphicWithParam1:ImgCaps param2:YES param3:NO param4:16 param5:16];
        [self addAnimationWithParam1:@"regular" param2:[NSMutableArray intArrayWithSize:1 ints:0] param3:0];
        [self addAnimationWithParam1:@"hardcore" param2:[NSMutableArray intArrayWithSize:1 ints:1] param3:0];
        [self addAnimationWithParam1:@"heart" param2:[NSMutableArray intArrayWithSize:1 ints:2] param3:0];
        [self play:@"heart"];
        self.scale = CGPointMake(0, 0);
        canScale=YES;
        scaleRate=0.1;
        sound = @"scoreCap1.caf";
	}
	
	return self;	
}

- (void) dealloc
{
    
	[super dealloc];
}

- (void) beginScale
{
    
}

- (void) update
{   
	if (self.visible && canScale) {
        if (self.scale.x<1) {
            float x2 = self.scale.x+scaleRate;
            float y2 = self.scale.y+scaleRate;
            self.scale=CGPointMake(x2, y2);
        }
        else  {
            self.scale = CGPointMake(1, 1);
            
            [FlxG playWithParam1:sound param2:0.4 param3:NO];
            
            if (FlxG.hardCoreMode) {
                [self play:@"hardcore"];
            }
            else {
                [self play:@"regular"];
            }
            canScale=NO;
            
        }
    }
	[super update];
	
}


@end






















































