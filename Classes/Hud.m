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

#import "Hud.h"

static NSString * ImgChars = @"currentChar.png";
static NSString * ImgHeart = @"heart.png";
FlxSprite * heartM;
FlxSprite * heartF;
FlxSprite * heartM2;
FlxSprite * heartF2;
FlxSprite * heartM3;
FlxSprite * heartF3;

@implementation Hud

@synthesize mLives;
@synthesize fLives;

+ (id) hudWithOrigin:(CGPoint)Origin
{
	return [[[self alloc] initWithOrigin:Origin] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
        
        heartF = [[FlxSprite spriteWithX:0 y:0 graphic:ImgHeart] retain];
        heartM = [[FlxSprite spriteWithX:2 y:2 graphic:ImgHeart] retain];
        heartF2 = [[FlxSprite spriteWithX:30 y:22 graphic:ImgHeart] retain];
        heartM2 = [[FlxSprite spriteWithX:30 y:8 graphic:ImgHeart] retain];
        heartF3 = [[FlxSprite spriteWithX:40 y:22 graphic:ImgHeart] retain];
        heartM3 = [[FlxSprite spriteWithX:40 y:8 graphic:ImgHeart] retain];
        
        heartF2.x = heartM2.x = 30;
        heartF2.y = 22;
        heartM2.y = 8;
        heartF3.x = heartM3.x = 40;
        heartF3.y = 22;
        heartM3.y = 8;
        
        if (FlxG.oldSchool) {

            
            mLives=FlxG.mlives;
            fLives=FlxG.flives;
            
            [self syncLives];
            
        }
        else {
            heartM2.visible = heartM3.visible = heartF2.visible = heartF3.visible = NO;
            mLives=1;
            fLives=1;

        }
		
		[self loadGraphicWithParam1:ImgChars param2:YES param3:NO param4:14 param5:28];
        [self addAnimationWithParam1:@"m_selected" param2:[NSMutableArray intArrayWithSize:0 ints:0] param3:0 param4:NO];
        [self addAnimationWithParam1:@"f_selected" param2:[NSMutableArray intArrayWithSize:0 ints:1] param3:0 param4:NO];
        
         [self addAnimationWithParam1:@"both_selected" param2:[NSMutableArray intArrayWithSize:3 ints:0,1,2] param3:24 param4:YES];       

        self.x = 4;
        self.y = 4;

        heartF.x = heartM.x = 20;
        heartF.y = 22;
        heartM.y = 8;
        
        
        
        heartM.scrollFactor = CGPointZero;
        heartF.scrollFactor = CGPointZero;
        heartM2.scrollFactor = CGPointZero;
        heartF2.scrollFactor = CGPointZero;        
        heartM3.scrollFactor = CGPointZero;
        heartF3.scrollFactor = CGPointZero;
        
        [self play:@"m_selected"];
        
        
	}
	
	return self;	
}

- (void) switchCharacters
{
    if (_curAnim.name==@"m_selected") {
        [self play:@"f_selected"];
    } else if (_curAnim.name==@"f_selected") {
        [self play:@"m_selected"];
    }
}

- (void) subtractLifeFrom:(NSString *)Character
{
    if (!FlxG.oldSchool) {
        if ([Character isEqualToString:@"male"]) {
            mLives--;
            heartM.alpha=0;
        }
        if ([Character isEqualToString:@"female"]) {
            fLives--;
            heartF.alpha=0;
        }
    }
    else {
        if ([Character isEqualToString:@"male"]) {
            mLives--;
            [self syncLives];
        }
        if ([Character isEqualToString:@"female"]) {
            fLives--;
            [self syncLives];
        }   
        FlxG.mlives = mLives;
        FlxG.flives = fLives;
    }
    
    
}

- (void) resetLives
{
    if (!FlxG.oldSchool) {
        mLives=1;
        fLives=1;
        heartF.alpha=1;
        heartM.alpha=1;
        [self play:@"m_selected"];
    }


}

- (void) syncLives
{
    if (mLives==1) {
        heartM.alpha=1;
        heartM2.alpha = 0;
        heartM3.alpha = 0;
    }
    else if (mLives==0) {
        heartM.alpha=0;
        heartM2.alpha = 0;
        heartM3.alpha = 0;      
    } 
    else if (mLives==2) {
        heartM.alpha=1;
        heartM2.alpha = 1;
        heartM3.alpha = 0;      
    } 
    else if (mLives>=3) {
        heartM.alpha=1;
        heartM2.alpha = 1;
        heartM3.alpha = 1;      
    } 
    
    
    
    
    
    if (fLives==1) {
        heartF.alpha=1;
        heartF2.alpha = 0;
        heartF3.alpha = 0;
    }
    else if (fLives==0) {
        heartF.alpha=0;
        heartF2.alpha = 0;
        heartF3.alpha = 0;
    }     
    else if (fLives==2) {
        heartF.alpha=1;
        heartF2.alpha = 1;
        heartF3.alpha = 0;      
    } 
    else if (fLives>=3) {
        heartF.alpha=1;
        heartF2.alpha = 1;
        heartF3.alpha = 1;      
    }    
    
    FlxG.mlives = mLives;
    FlxG.flives = fLives;
    
    
}

- (void) render
{
    [heartM render];
    [heartF render];
    [heartM2 render];
    [heartF2 render];
    [heartM3 render];
    [heartF3 render];
    [super render];
}


- (void) dealloc
{
    [heartM release];
    [heartF release];
    [heartM2 release];
    [heartF2 release];    
    [heartM3 release];
    [heartF3 release];
    
	[super dealloc];
}


- (void) update
{   
    [heartM update];
    [heartF update];
    [heartM2 update];
    [heartF2 update];    
    [heartM3 update];
    [heartF3 update];    
    
	[super update];

}


@end
