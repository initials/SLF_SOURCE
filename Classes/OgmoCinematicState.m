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
#import "OgmoCinematicState.h"
#import "OptionState.h"

int f1,f2,f3,f4,f5,f6,f7,f8;
BOOL beginFade;
int frameLimit;

@implementation OgmoCinematicState

- (id) init
{
	if ((self = [super init])) {
		self.bgColor = 0xff35353d;
        recA = [[NSMutableString alloc] initWithString:@"0"];
        recB = [[NSMutableString alloc] initWithString:@"0"];
        recL = [[NSMutableString alloc] initWithString:@"0"];
        recR = [[NSMutableString alloc] initWithString:@"0"];
        recSwipe = [[NSMutableString alloc] initWithString:@"0"];
        recSwipeUp = [[NSMutableString alloc] initWithString:@"0"];
        
        
        
        
	}
	return self;
}



- (void) create
{       
    
    //[FlxG setMaxElapsed:0.01];

    
    //
    // ARE WE RECORDING OR PLAYBACK
    //
    
    recording=NO;
    
    
    beginFade=NO;

    
    [super create];
    
    [FlxG setMaxElapsed:0.0285];
    
    liselot.isPlayerControlled=NO;
    
    //player.jumpTimer=0.45; // 0.34
        
    if (!recording){
        
        if (FlxG.level==101) {
            f1=269;
            f2=308;
            f3=336;
            f4=367;
            f5=423;
            f6=450;
            frameLimit=460;
            
            buttonAString=@"000000000000000000000000000000000000000000000000000000001110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            buttonBString=@"000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111110000000011110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            buttonLString=@"000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            buttonRString=@"000000000000000000000000000000000000000000000001111111111000000000011111111000000000000000000000000000000000000000000000000000000000000011111111111111111000000001111111111111111100000000000000000000000000000000000011111111000000000000000000000001111100000000000000000000000000000111111111111100000000000000000000111111110000000000000000000111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111100000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            buttonSwipeString=@"000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            buttonSwipeUpString=@"000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
        }
        
        if (FlxG.level==113) {
            frameLimit=560;
            f1=282;
            f2=318;
            f3=349;
            f4=376;
            f5=421;
            f6=447;
            
            buttonAString=@"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            buttonBString=@"0000000000000000000000000000000000000000000000000000000000000000000000011100000000000000000000000000000000000000000000000000000011111111111000000000000000011110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            buttonLString=@"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            buttonRString=@"0000000000000000000011111111111111111111111111111111110000000000000000011111111111111100000000000000000000000000000000000000111111111111111110000000000000000000111111111111111111111111111111111111111111111111111100000000000000000011111111100000000000000001111111111111111000000000000000000000001111111111000000000000000000011111111111100000000000000000111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            buttonSwipeString=@"0000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            buttonSwipeUpString=@"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            
            
            
        }

        if (FlxG.level==125) {
            frameLimit=525;
            f1=326;
            f2=359;
            f3=390;
            f4=420;
            f5=479;
            f6=515;
            buttonAString=@"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            buttonBString=@"00000000000000000000000000000000000000000000000000000000000000000000000011111111111100000000000000001111110000000000000000111111100000000000000000111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            buttonLString=@"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            buttonRString=@"00000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111000000000011111111111111110000001111111111111110000000111111111111110000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111100000000000000000000111111111111111110000000000000000000001111111111000000000000000000011111111110000000000000000000001111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111110000000000000000000000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000000000000000000000000";
            buttonSwipeString=@"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            buttonSwipeUpString=@"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            
        }
        
        frameNumber=0;
        
        buttonA.visible=NO;
        buttonB.visible=NO;
        buttonLeft.visible=NO;
        buttonRight.visible=NO;
        FlxG.touches.humanControlled=NO;
        pauseGraphic.visible=NO;
    }
    else if (recording) {
        f1=999999999;
        f2=999999999;
        f3=999999999;
        f4=999999999;
        f5=999999999;
        f6=999999999;
        frameLimit=999999999;
        
    }
    
   
    
    [FlxG playMusic:@"farewell.mp3"];
    
    speechBubblex = [FlxTileblock tileblockWithX:40 y:180 width:240 height:60];  
    [speechBubblex loadGraphic:@"speechBubbleTiles.png" empties:0 autoTile:NO isSpeechBubble:12];
    speechBubblex.visible=NO;
    speechBubblex.scrollFactor  = CGPointMake(1, 1);
    [self add:speechBubblex];
    
    speechBubbleTextx = [FlxText textWithWidth:236
                                         text:@" "
                                         font:@"Flixel"
                                         size:16.0];
    speechBubbleTextx.color = 0x00000000;
	speechBubbleTextx.alignment = @"center";
	speechBubbleTextx.x = speechBubble.x;
	speechBubbleTextx.y = speechBubble.y;
    speechBubbleTextx.shadow = 0x00000000;
    speechBubbleTextx.visible = NO;
    speechBubbleTextx.scrollFactor = CGPointMake(1, 1);
	[self add:speechBubbleTextx];
    
    enemyWorker = [EnemyGeneric enemyGenericWithOrigin:CGPointMake(1610,240) index:0  ];
    enemyWorker.scale = CGPointMake(-1, 1);
    [self add:enemyWorker];
    [enemyWorker play:@"workerListen"];
    
    enemyArmy = [EnemyGeneric enemyGenericWithOrigin:CGPointMake(1660, 240) index:0  ];
    enemyArmy.scale = CGPointMake(-1, 1);
    [self add:enemyArmy];
    [enemyArmy play:@"armyListen"];
    
    enemyChef = [EnemyGeneric enemyGenericWithOrigin:CGPointMake(1710, 240) index:0  ];
    enemyChef.scale = CGPointMake(-1, 1);
    [self add:enemyChef];
    [enemyChef play:@"chefListen"];
    
    enemyInspector = [EnemyGeneric enemyGenericWithOrigin:CGPointMake(1760, 240) index:0  ];
    enemyInspector.scale = CGPointMake(-1, 1);
    [self add:enemyInspector];
    [enemyInspector play:@"inspectorListen"];
    
    enemyArmy.alpha=0;
    enemyWorker.alpha=0;
    enemyChef.alpha=0;
    enemyInspector.alpha=0;
    
    if (FlxG.level==101) {
        //keep locations the same.
    }
    
    if (FlxG.level==113) {
        float offset=300;
        enemyArmy.x-=offset;
        enemyChef.x-=offset;
        enemyInspector.x-=offset;
        enemyWorker.x-=offset;
        
    }
    
    
    
    cineBarUpper  = [FlxSprite spriteWithX:0 y:0 graphic:nil];
	[cineBarUpper createGraphicWithParam1:FlxG.width param2:FlxG.height/5 param3:0xff000000];
    cineBarUpper.x = 0;
    cineBarUpper.y = 0 - (FlxG.height/5);
    cineBarUpper.scrollFactor = CGPointZero;
    cineBarUpper.velocity = CGPointMake(0, 50);
    cineBarUpper.drag = CGPointMake(22, 22);
    
	[self add:cineBarUpper];    
    
    cineBarLower  = [FlxSprite spriteWithX:0 y:0 graphic:nil];
	[cineBarLower createGraphicWithParam1:FlxG.width param2:FlxG.height/5 param3:0xff000000];
    cineBarLower.x = 0;
    cineBarLower.y = FlxG.height;
    cineBarLower.scrollFactor = CGPointZero;
    cineBarLower.velocity = CGPointMake(0, -50);
    cineBarLower.drag = CGPointMake(22, 22);
	[self add:cineBarLower];  
    
    FlxText * skipText = [FlxText textWithWidth:FlxG.width-10
                                           text:@" Skip cut scene "
                                           font:@"SmallPixel"
                                           size:8.0];
    skipText.color = 0xffffffff;
	skipText.alignment = @"right";
	skipText.x = 0;
	skipText.y = 10;
    skipText.shadow = 0x00000000;
    skipText.scrollFactor = CGPointZero;
	[self add:skipText]; 
    
    nextText = [FlxText textWithWidth:FlxG.width-10
                                           text:@" Tap to continue "
                                           font:@"SmallPixel"
                                           size:16.0];
    nextText.color = 0xffffffff;
	nextText.alignment = @"right";
	nextText.x = 0;
	nextText.y = FlxG.height-28;
    nextText.shadow = 0x00000000;
    nextText.scrollFactor = CGPointZero;
    nextText.alpha=0;
	[self add:nextText];     
    
    fadeOut  = [FlxSprite spriteWithX:0 y:0 graphic:nil];
	[fadeOut createGraphicWithParam1:FlxG.width param2:FlxG.height param3:0xff000000];
	fadeOut.visible = NO;
    fadeOut.alpha = 0;
    fadeOut.x = 0;
    fadeOut.y = 0;
    fadeOut.scrollFactor = CGPointZero;
    fadeOut.drag = CGPointMake(500, 500);
	[self add:fadeOut];
    
    
    liselot.scale=CGPointMake(-1, 1);
    
    
    
    
}

- (void) dealloc
{
    [recA release];
    [recB release];
    [recL release];
    [recR release];    
    [recSwipe release];    
    [recSwipeUp release];    
    
    
    [super dealloc];
}



- (void) update
{      
    
    //NSLog(@"%f", FlxG.elapsed);
    
    //NSLog(@"%d %d %d", [[buttonLString substringFromIndex:frameNumber]isEqualToString:@"1"], [[buttonRString substringFromIndex:frameNumber]isEqualToString:@"1"], frameNumber);
    
    //    if (FlxG.touches.touchesBegan) {
    //        NSLog(@"%d", frameNumber);
    //    }
    
    if (!recording) {
        NSString * newL = [buttonLString substringWithRange:NSMakeRange(frameNumber, 1)];
        NSString * newR = [buttonRString substringWithRange:NSMakeRange(frameNumber, 1)];
        NSString * newA = [buttonAString substringWithRange:NSMakeRange(frameNumber, 1)];
        NSString * newB = [buttonBString substringWithRange:NSMakeRange(frameNumber, 1)];
        NSString * newSwipe = [buttonSwipeString substringWithRange:NSMakeRange(frameNumber, 1)];
        NSString * newSwipeUp = [buttonSwipeUpString substringWithRange:NSMakeRange(frameNumber, 1)];
        
        
        FlxG.touches.newTouch=YES;
        if ([newA isEqualToString:@"1"]) {
            FlxG.touches.vcpButton1=YES;
        }
        else
        {
            FlxG.touches.vcpButton1=NO;
        }
        
        if ([newB isEqualToString:@"1"]) {
            FlxG.touches.vcpButton2=YES;
        }
        else
        {
            FlxG.touches.vcpButton2=NO;
        } 
        
        if ([newL isEqualToString:@"1"]) {
            FlxG.touches.vcpLeftArrow=YES;
        }
        else
        {
            FlxG.touches.vcpLeftArrow=NO;
        }
        
        if ([newR isEqualToString:@"1"]) {
            FlxG.touches.vcpRightArrow=YES;
        }
        else
        {
            FlxG.touches.vcpRightArrow=NO;
        } 
        
        if ([newSwipe isEqualToString:@"1"]) {
            //FlxG.touches.swipedUp=YES;
            //FlxG.touches.swipedDown=YES;
            
            
            [super switchCharacters:NO flicker:0 withSound:YES followReset:NO];
            
        }
        else
        {
//            FlxG.touches.swipedUp=NO;
//            FlxG.touches.swipedDown=NO;
        }  
        
        if ([newSwipeUp isEqualToString:@"1"]) {
            if (!player.isPiggyBacking) {
                [FlxG playWithParam1:@"SndOnShoulders.caf" param2:0.35 param3:NO];
            }
            if (!player.isMale) {
                [self switchCharacters:YES flicker:0 withSound:NO followReset:NO] ;
            }
            liselot.isPiggyBacking=!liselot.isPiggyBacking;
            liselot.visible=!liselot.visible;
            player.isPiggyBacking=!player.isPiggyBacking;        }
        else
        {
        }        
        
        
        
        if (!paused) {
            frameNumber++;
            nextText.alpha=0;
        }
        else {
            nextText.alpha+=0.05;
            [enemyArmy update];
            [enemyChef update];
            [enemyInspector update];
            [enemyWorker update];
            //[player update];
            //[liselot update];
            [ge update];
            
        }
        
    }
    
    else if (recording) {
        if (FlxG.touches.vcpButton1) {
            [recA appendString:@"1"];            
        }
        else {
            [recA appendString:@"0"];
        }
        
        if (FlxG.touches.vcpButton2) {
            [recB appendString:@"1"];            
        }
        else {   
            [recB appendString:@"0"];            
        }
        if (FlxG.touches.vcpLeftArrow) {
            [recL appendString:@"1"];            
        }
        else {
            [recL appendString:@"0"];
        }
        
        if (FlxG.touches.vcpRightArrow) {
            [recR appendString:@"1"];            
        }
        else {   
            [recR appendString:@"0"];            
        }       
        
        if (FlxG.touches.swipedUp || FlxG.touches.swipedDown ) {
            [recSwipe appendString:@"1"];            
        }
        else {   
            [recSwipe appendString:@"0"];            
        }         
        if (FlxG.touches.swipedLeft || FlxG.touches.swipedRight ) {
            [recSwipeUp appendString:@"1"];   
//            liselot.isPlayerControlled=!liselot.isPlayerControlled;

        }
        else {   
            [recSwipeUp appendString:@"0"];            
        }        
        
    }
    
    if (frameNumber==f1){
        if (FlxG.level==101) {
            [self talkTo:enemyWorker];
            speechBubbleTextx.text=@"I'm going to need more money.";   
            paused=YES;
            [enemyWorker play:@"workerTalk"];
        }
        if (FlxG.level==113) {
            [self talkTo:enemyWorker];
            speechBubbleTextx.text=@"Down here, you play by my rules.";   
            paused=YES;
            [enemyWorker play:@"workerTalk"];
        }
        if (FlxG.level==125) {
            [self talkTo:enemyWorker];
            speechBubbleTextx.text=@"So this is how the other half work.";   
            paused=YES;
            [enemyWorker play:@"workerTalk"];

        }
    }
    else if (frameNumber==f2){
        if (FlxG.level==101) {

            [self talkTo:enemyArmy];
            speechBubbleTextx.text=@"Our contract offer runs out today.";   
            paused=YES;
            [enemyArmy play:@"armyTalk"];
        }
        if (FlxG.level==113) {
            [self talkTo:enemyArmy];
            speechBubbleTextx.text=@"You still haven't signed our contract.";   
            paused=YES;
            [enemyArmy play:@"armyTalk"];           
        }
        if (FlxG.level==125) {
            [self talkTo:enemyArmy];
            speechBubbleTextx.text=@"Our offer runs out today. No extensions.";   
            paused=YES;
            [enemyArmy play:@"armyTalk"];  
            
        }       
        
    } 
    else if (frameNumber==f3){
        if (FlxG.level==101) {
            [self talkTo:enemyChef];
            speechBubbleTextx.text=@"I'll be in the lab. Mixing new flavors.";   
            paused=YES;
            [enemyChef play:@"chefTalk"];
        }
        if (FlxG.level==113) {
            [self talkTo:enemyChef];
            speechBubbleTextx.text=@"I've created a new durian flavor.";   
            paused=YES;
            [enemyChef play:@"chefTalk"];            
        }
        if (FlxG.level==125) {
            [self talkTo:enemyChef];
            speechBubbleTextx.text=@"The durian flavor has not been popular.";   
            paused=YES;
            [enemyChef play:@"chefTalk"]; 
            
        } 

    }    
    
    else if (frameNumber==f4){
        if (FlxG.level==101) {

            [self talkTo:enemyInspector];
            speechBubbleTextx.text=@"Clean this place up, it's a mess!";   
            paused=YES;
            [enemyInspector play:@"inspectorTalk"];
        }
        if (FlxG.level==113) {
            [self talkTo:enemyInspector];
            speechBubbleTextx.text=@"If I find any dirt in here...";   
            paused=YES;
            [enemyInspector play:@"inspectorTalk"];           
        }
        if (FlxG.level==125) {
            [self talkTo:enemyInspector];
            speechBubbleTextx.text=@"So this is where the paper trail starts.";   
            paused=YES;
            [enemyInspector play:@"inspectorTalk"]; 
            
        } 
        
    } 
    else if (frameNumber==f5){
        if (FlxG.level==101) {

            [self talkTo:player];
            speechBubbleTextx.text=@"This is our factory.";   
            paused=YES;
            [player play:@"m_talk"];
        }
        if (FlxG.level==113) {
            [self talkTo:player];
            speechBubbleTextx.text=@"The ol' factory has treated us well.";   
            paused=YES;
            [player play:@"f_talk"];
        }
        if (FlxG.level==125) {
            [self talkTo:player];
            speechBubbleTextx.text=@"We work hard keeping things running.";   
            paused=YES;
            [player play:@"f_talk"];
            
        } 
        
    } 
    else if (frameNumber==f6){
        if (FlxG.level==101) {

            [self talkTo:player];
            speechBubbleTextx.text=@"Let's do this.\nTogether!";   
            paused=YES;
            [player play:@"f_talk"];
        }
        if (FlxG.level==113) {
            [self talkTo:player];
            speechBubbleTextx.text=@"Hard work equals results.";   
            paused=YES;
            [player play:@"m_talk"];
        }
        if (FlxG.level==125) {
            [self talkTo:player];
            speechBubbleTextx.text=@"Let's run it better than ever.";   
            paused=YES;
            [player play:@"m_talk"];
            
        } 
        
    } 
    
    
    [super update];
    
    if (_levelFinished  ){ //|| FlxG.touches.touchesBegan
        
        [self finishLevel];
        
    }
    
    if (!recording) {
    
        if (FlxG.touches.touchesBegan && FlxG.touches.screenTouchBeganPoint.y<FlxG.height/5) {
            beginFade=YES; 
        }
        
        else if (FlxG.touches.touchesBegan && FlxG.touches.screenTouchBeganPoint.y>FlxG.height/5) {
            //NSLog(@"%d", frameNumber);
            if (frameNumber==f1){
                enemyWorker.velocity=CGPointMake(100, 0);
                enemyWorker.scale=CGPointMake(1, 1);
                [enemyWorker play:@"workerRun"];
                
            }
            else if (frameNumber==f2){
                enemyArmy.velocity=CGPointMake(100, 0);
                enemyArmy.scale=CGPointMake(1, 1);
                [enemyArmy play:@"armyRun"];
            }    
            else if (frameNumber==f3){
                enemyChef.velocity=CGPointMake(100, 0);
                enemyChef.scale=CGPointMake(1, 1);
                [enemyChef play:@"chefRun"];
            }     
            else if (frameNumber==f4){
                enemyInspector.velocity=CGPointMake(100, 0);
                enemyInspector.scale=CGPointMake(1, 1);
                [enemyInspector play:@"inspectorRun"];
            }           
            else if (frameNumber==f5){

                
            } 
            else if (frameNumber==f6){

                
            }         
            
            paused=NO;
            speechBubblex.visible=NO;
            speechBubbleTextx.visible=NO;
            
            
        }
        
    }
    
    if (frameNumber>frameLimit || beginFade) {
        fadeOut.visible=YES;
        fadeOut.alpha+=0.025;
        
    }
    if (fadeOut.alpha==1) {
        [self finishLevel];
        FlxG.state = [[[OgmoLevelState alloc] init] autorelease];
        return; 
    }
    
    enemyArmy.alpha+=0.025;
    enemyWorker.alpha+=0.025;
    enemyChef.alpha+=0.025;
    enemyInspector.alpha+=0.025;
    
}

-(void) talkTo:(FlxSprite *)character
{
    speechBubblex.x=character.x-90;
    speechBubblex.y=character.y-80;
    speechBubblex.visible=YES;
    speechBubbleTextx.visible=YES;
    speechBubbleTextx.x=character.x+2-90;
    speechBubbleTextx.y=character.y+2-80;
    
    
}

- (void) switchCharacters
{
    [super switchCharacters:NO flicker:0 withSound:YES followReset:NO];
    [player flicker:0];
    [liselot flicker:0];
    
}

-(void) finishLevel
{
    if (recording) {
                
        //NSLog(@"buttonAString=@\"%@\";\nbuttonBString=@\"%@\";\nbuttonLString=@\"%@\";\nbuttonRString=@\"%@\";\nbuttonSwipeString=@\"%@\";\nbuttonSwipeUpString=@\"%@\";\n", recA, recB, recL, recR,recSwipe,recSwipeUp);

    }
    
    FlxG.level=FlxG.level-100;
    

}




@end

