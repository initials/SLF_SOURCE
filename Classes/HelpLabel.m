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

#import "HelpLabel.h"

static NSString * ImgBox = @"helpButtonW.png";

@implementation HelpLabel

@synthesize helpString;
@synthesize type;


+ (id) helpLabelWithOrigin:(CGPoint)Origin  
{
	return [[[self alloc] initWithOrigin:Origin ] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
		
        if (FlxG.level <= LEVELS_IN_WORLD  ) {
            
            [self loadGraphicWithParam1:@"helpButtonW.png" param2:YES param3:NO param4:390 param5:50];
            
            
        }
        
        // World 2 - Levels 13 - 24
        else if (FlxG.level <= LEVELS_IN_WORLD*2 ) {
            
            [self loadGraphicWithParam1:@"helpButtonF.png" param2:YES param3:NO param4:390 param5:50];
            
            
        }
        
        //World 3 - Levels 25 - 36h - Management
        
        else if (FlxG.level <= LEVELS_IN_WORLD*3 ) {
            
            [self loadGraphicWithParam1:@"helpButtonM.png" param2:YES param3:NO param4:390 param5:50];
                        
        }        
        
        [self addAnimationWithParam1:@"reveal" param2:[NSMutableArray intArrayWithSize:5 ints:0,0,0,1,2] param3:12 param4:NO];
        [self addAnimationWithParam1:@"static" param2:[NSMutableArray intArrayWithSize:1 ints:0] param3:0 param4:NO];

        [self play:@"static"];
        
        self.width = 390;
        self.height = 50;
        //self.fixed=YES;
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
    
    if (self.scale.x<1) {
        float sx=self.scale.x+0.2;
        float sy=self.scale.y+0.2;
        self.scale = CGPointMake(sx, sy);
    }
	[super update];
    
	
}


@end
