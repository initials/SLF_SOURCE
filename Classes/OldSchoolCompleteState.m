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
#import "OldSchoolCompleteState.h"


@implementation OldSchoolCompleteState

- (id) init
{
	if ((self = [super init])) {
		self.bgColor = 0xff4343e7;
        
        
        
        
	}
	return self;
}



- (void) create
{        
    txt = [FlxText textWithWidth:FlxG.width-40
                                    text:@"Congrats"
                                    font:nil
                                    size:8.0];
    
	txt.color = 0xffa5a5ff;
	txt.alignment = @"center";
	txt.x = 20;
	txt.y = 40;
    txt.size = 16;
	[self add:txt];
    

    
    
    
    
    [FlxG pauseMusic];
    
    
       
    
  

    
    txt.text = @"You have completed OLD SCHOOL mode\n\nYou are person number: ";
    
    
    
}

- (void) dealloc
{
    
    [super dealloc];
}



- (void) update
{       
    
}




@end

