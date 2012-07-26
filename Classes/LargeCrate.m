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

#import "LargeCrate.h"



static NSString * ImgCrate = @"CrateWithLabel.png";
static Player * _player;
static Liselot * _liselot;



@implementation LargeCrate

@synthesize isAboutToExplode;

+ (id) largeCrateWithOrigin:(CGPoint)Origin  withPlayer:(Player *)player  withLiselot:(Liselot *)liselot
{
	return [[[self alloc] initWithOrigin:Origin  withPlayer:(Player *)player  withLiselot:(Liselot *)liselot] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin  withPlayer:(Player *)player  withLiselot:(Liselot *)liselot
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
		
		[self loadGraphicWithParam1:ImgCrate param2:YES param3:NO param4:80 param5:60];
        //self.acceleration = CGPointMake(0, 800);
        self.width = 80;
        self.height = 60;
        //self.drag = CGPointMake(500, 500);
        self.fixed=YES;
        _player = player;
        _liselot=liselot;
        self.originalXPos=Origin.x;
        self.originalYPos=Origin.y;

        
	}
	
	return self;	
}


- (void) dealloc
{
    
	[super dealloc];
}

- (void) hitLeftWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
    
    //[super hitLeftWithParam1:Contact param2:Velocity];
    if (_player.isAirDashing || _liselot.isAirDashing ) {
        //self.x = -1000;
        //self.y = -1000;
        isAboutToExplode=YES;

    }
    
    
}



- (void) hitRightWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
    //[super hitLeftWithParam1:Contact param2:Velocity];
    if (_player.isAirDashing || _liselot.isAirDashing ) {
        //self.x = -1000;
        //self.y = -1000;
        
        isAboutToExplode=YES;

    }
}
- (void) moveOffScreen
{
    self.x=-1000;
    self.y=-1000;
    
    [FlxG playWithParam1:@"grenadeExplosion.caf" param2:0.35 param3:NO];

    [FlxG vibrate];

}

- (void) update
{   

	[super update];
    
    isAboutToExplode=NO;

	
}


@end
