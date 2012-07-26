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

#import "CheckPoint.h"

static NSString * ImgBox = @"andreCheckPoint.png";

@implementation CheckPoint

@synthesize type;
@synthesize checked;


+ (id) andreCheckPointWithOrigin:(CGPoint)Origin  
{
    ImgBox=@"andreCheckPoint.png";
    //self.type=1;
	return [[[self alloc] initWithOrigin:Origin ] autorelease];
}

+ (id) liselotCheckPointWithOrigin:(CGPoint)Origin  
{
    ImgBox=@"liselotCheckPoint.png";

	return [[[self alloc] initWithOrigin:Origin ] autorelease];
}


- (id) initWithOrigin:(CGPoint)Origin
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
		            
        [self loadGraphicWithParam1:ImgBox param2:YES param3:NO param4:28 param5:60];
        
        [self addAnimationWithParam1:@"off" param2:[NSMutableArray intArrayWithSize:10 ints:0,0,1,1,0,0,1,1,0,1] param3:12 param4:YES];
        [self addAnimationWithParam1:@"on"  param2:[NSMutableArray intArrayWithSize:1 ints:2] param3:0 param4:NO];
        
        [self play:@"off"];
        checked=NO;
        
        self.originalXPos=Origin.x;
        self.originalYPos=Origin.y;
        
        
        
        
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
