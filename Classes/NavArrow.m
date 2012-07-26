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

#import "NavArrow.h"

static NSString * ImgBox = @"navArrow.png";

@implementation NavArrow

@synthesize maxValue;
@synthesize currentValue;
@synthesize loc1;
@synthesize loc2;
@synthesize loc3;
@synthesize loc4;
@synthesize loc5;
@synthesize loc6;
@synthesize loc7;
@synthesize loc8;
@synthesize loc9;
@synthesize loc10;
@synthesize loc11;
@synthesize loc12;
@synthesize loc13;
@synthesize loc14;




+ (id) navArrowWithOrigin:(CGPoint)Origin  
{
	return [[[self alloc] initWithOrigin:Origin ] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
		
		[self loadGraphicWithParam1:ImgBox param2:YES param3:NO param4:8 param5:20];
        [self addAnimationWithParam1:@"play" param2:[NSMutableArray intArrayWithSize:4 ints:0,1,2,3] param3:5 param4:YES];
        [self play:@"play"];
        

        
	}
	
	return self;	
}


- (void) dealloc
{
    
	[super dealloc];
}




- (void) update
{   
    
    if (currentValue==1) {
        self.x = loc1.x;
        self.y = loc1.y;
    }
    if (currentValue==2) {
        self.x = loc2.x;
        self.y = loc2.y;
    } 

    if (currentValue==3) {
        self.x = loc3.x;
        self.y = loc3.y;
    }
    if (currentValue==4) {
        self.x = loc4.x;
        self.y = loc4.y;
    }
    
    if (currentValue==5) {
        self.x = loc5.x;
        self.y = loc5.y;
    }
    if (currentValue==6) {
        self.x = loc6.x;
        self.y = loc6.y;
    } 
    
    if (currentValue==7) {
        self.x = loc7.x;
        self.y = loc7.y;
    }
    if (currentValue==8) {
        self.x = loc8.x;
        self.y = loc8.y;
    }
    if (currentValue==9) {
        self.x = loc9.x;
        self.y = loc9.y;
    }
    if (currentValue==10) {
        self.x = loc10.x;
        self.y = loc10.y;
    } 
    
    if (currentValue==11) {
        self.x = loc11.x;
        self.y = loc11.y;
    }
    if (currentValue==12) {
        self.x = loc12.x;
        self.y = loc12.y;
    }
    if (currentValue==13) {
        self.x = loc13.x;
        self.y = loc13.y;
    }
    if (currentValue==14) {
        self.x = loc14.x;
        self.y = loc14.y;
    }    
    
    if (currentValue>maxValue) {
        currentValue=1;
    }
    else if (currentValue<1) {
        currentValue=maxValue;
        
    }
    
    self.visible=NO;
    
	[super update];
    
    self.visible=NO;

}


@end
