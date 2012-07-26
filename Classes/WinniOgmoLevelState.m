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

#import "OgmoLevelState.h"
#import "WinniOgmoLevelState.h"
#import "WorldSelectState.h"

@implementation WinniOgmoLevelState

static NSString * MusicMegaCannon = @"megacannon.mp3";
int _timeLeft;
BOOL _timeChanged;
int _oldTime;
float textScale=1.0;

- (id) init
{
	if ((self = [super init])) {
		self.bgColor = 0xff35353d;
        
	}
	return self;
}



- (void) create
{       
    _timeChanged=NO;
    _oldTime=0;
    textScale=1.0;
    
    [super create];
        
    timerText = [FlxText textWithWidth:FlxG.width
                                text:@"timeleft"
                                font:@"SmallPixel"
                                size:16];
    timerText.color = 0xffffffff;
    timerText.alignment = @"center";
    timerText.x = 0;
    timerText.y = 4;
    timerText.scrollFactor = CGPointMake(0,0);
    [self add:timerText];    
    
//    [FlxG playMusicWithParam1:MusicMegaCannon param2:0.5];

     
}

- (void) dealloc
{   
    
    
    [super dealloc];
}



- (void) update
{      
    if (!_levelFinished) {
        FlxG.timeLeft-=FlxG.elapsed;
        _timeLeft = FlxG.timeLeft;
    }
    
    //
    //if (FlxG.timeLeft )
    timerText.text =  [NSString stringWithFormat:@"Time left: %d", _timeLeft];
    
    [super update];

    if (_oldTime != _timeLeft) {
        //NSLog(@"changed");
        if (_timeLeft<5) {
            textScale=2;
            [FlxG play:@"joy.caf"];
            
        }
    }
    

    if (textScale>1) {
        textScale-=0.1;
        timerText.scale = CGPointMake(textScale, textScale);

    }
    else {
        textScale=1;
    }
    
    
    
    _oldTime = _timeLeft;

    
    if (FlxG.timeLeft<0) {
        [FlxG pauseMusic];
        [FlxG play:@"error.caf"];
        FlxG.state = [[[WorldSelectState alloc] init] autorelease];
        return; 
    }
    
    
}


@end

