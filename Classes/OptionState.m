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

#import "MenuState.h"

#import "OptionState.h"

#import "OgmoCutSceneState.h"

#import "ButtonAdjustState.h"

int c; 

static NSString * ImgBack = @"back.png";
static NSString * ImgBgGrad = @"level1_bgSmoothGrad_new.png";
static NSString * ImgTiles = @"level1_tiles.png";

static NSString * ImgEmptyButton = @"emptySmallButton.png";
static NSString * ImgEmptyButtonPressed = @"emptySmallButtonPressed.png";

static NSString * ImgEmptyButtonLarge = @"emptyButton.png";
static NSString * ImgEmptyButtonPressedLarge = @"emptyButtonPressed.png";

static NSString * SndBack = @"ping2";

NSInteger hc;

BOOL areYouSure;
FlxButton * clear;
FlxButton * clearSure;
FlxButton * clearDone;



FlxSprite * bgCity;
FlxSprite * bgClouds;

FlxText * headingText;


int cycles;


@interface OptionState ()
@end


@implementation OptionState

- (id) init
{
	if ((self = [super init])) {
		self.bgColor = 0xffdad7be;
	}
	return self;
}

- (void) create
{    
    
    //disable swipes so finger tracking works.
    
    FlxGame * game = [FlxG game];
    [game enableSwipeRecognizer:YES];
    
    FlxG.level = 1;
    FlxG.hardCoreMode=NO;
    
    areYouSure=NO;
    
    aboutText = [FlxText textWithWidth:FlxG.width-40
								  text:@"How to play:\n\nAndre\nPress A to dash. You can break up big crates this way.\nPress B to jump.\n\nLiselot\nPress A while facing an enemy to stop and talk.\nPress A while pushing a crate to slide it across the floor.\nPress B to jump. Press B again in the air to double jump.\n\nGet both Andre and Liselot to the exit to finish the level.\n\nScoring:\nCollect the bottle to recieve a bottle cap badge for the level. Talk to Andre to recieve a speech bubble badge for the level. Talk to a co-worker to recieve a speech bubble badge for the level.\nSwipe or press left or right on an external controller to cycle through button layouts."
								  font:nil
								  size:8.0];
    
	aboutText.color = 0xff312f2f;
	aboutText.alignment = @"center";
	aboutText.x = 20;
	aboutText.y = 50;
    //aboutText.velocity = CGPointMake(0, 200);
	[self add:aboutText];
    
    FlxTileblock * gradTopBar = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:40];  
    [gradTopBar loadGraphic:ImgTiles empties:0 autoTile:YES];
    [self add:gradTopBar]; 
    
    gradTopBar = [FlxTileblock tileblockWithX:0 y:FlxG.height-40 width:FlxG.width height:40];  
    [gradTopBar loadGraphic:ImgTiles empties:0 autoTile:YES];
    [self add:gradTopBar]; 
    
    headingText = [FlxText textWithWidth:FlxG.width
                                    text:@"HELP"
                                    font:@"SmallPixel"
                                    size:16.0];
	headingText.color = 0xffffffff;
	headingText.alignment = @"center";
	headingText.x = 0;
	headingText.y = 8;
	[self add:headingText];
    
    back = [[[FlxButton alloc]      initWithX:20
                                            y:FlxG.height-40
                                     callback:[FlashFunction functionWithTarget:self
                                                                         action:@selector(onBack)]] autorelease];
    [back loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgEmptyButton] param2:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed]];
    [back loadTextWithParam1:[FlxText textWithWidth:back.width
                                               text:NSLocalizedString(@"back", @"back")
                                               font:@"SmallPixel"
                                               size:16.0] param2:[FlxText textWithWidth:back.width
                                                                                   text:NSLocalizedString(@"back ...", @"back ...")
                                                                                   font:@"SmallPixel"
                                                                                   size:16.0] withXOffset:0 withYOffset:back.height/4] ;	
    back.visible=NO;
    [self add:back];
    
    
    editButtonsBtn = [[[FlxButton alloc]      initWithX:FlxG.width-200
                                            y:FlxG.height-40
                                     callback:[FlashFunction functionWithTarget:self
                                                                         action:@selector(onEditButtons)]] autorelease];
    [editButtonsBtn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgEmptyButtonLarge] param2:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressedLarge] param3:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressedLarge]];
    [editButtonsBtn loadTextWithParam1:[FlxText textWithWidth:editButtonsBtn.width
                                               text:NSLocalizedString(@"edit buttons", @"edit buttons")
                                               font:@"SmallPixel"
                                               size:16.0] param2:[FlxText textWithWidth:editButtonsBtn.width
                                                                                   text:NSLocalizedString(@"edit buttons", @"edit buttons")
                                                                                   font:@"SmallPixel"
                                                                                   size:16.0] withXOffset:0 withYOffset:back.height/4] ;	
    editButtonsBtn.visible=NO;
    [self add:editButtonsBtn];
    
    if (FlxG.gamePad==0) {
        back._selected=NO;
    } 
    else {
        back._selected=YES;
    }
    
    
    
    
//    watchBtn = [[[FlxButton alloc]      initWithX:FlxG.width-182-20
//                                             y:FlxG.height-40
//                                      callback:[FlashFunction functionWithTarget:self
//                                                                          action:@selector(onWatch)]] autorelease];
//    [watchBtn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:@"emptyButton.png"] param2:[FlxSprite spriteWithGraphic:@"emptyButtonPressed.png"]];
//    [watchBtn loadTextWithParam1:[FlxText textWithWidth:182
//                                                text:NSLocalizedString(@"how to play", @"how to play")
//                                                font:@"SmallPixel"
//                                                size:16.0] param2:[FlxText textWithWidth:182
//                                                                                    text:NSLocalizedString(@"how to play", @"how to play")
//                                                                                    font:@"SmallPixel"
//                                                                                    size:16.0] withXOffset:0 withYOffset:back.height/4] ;	
//    watchBtn.visible=NO;
//    [self add:watchBtn];
    
    
    
    gamePadText = [FlxText textWithWidth:FlxG.width-40
								  text:@"No gamepad detected."
								  font:nil
								  size:8.0];
    
	gamePadText.color = 0xff312f00; //0xff312f2f
	gamePadText.alignment = @"center";
	gamePadText.x = 20;
	gamePadText.y = FlxG.height - 60;
	[self add:gamePadText];

    

	
}

- (void) dealloc
{
	[super dealloc];
}


- (void) update
{   
    
    
//    if (FlxG.touches.iCadeLeftBegan) {
//        NSLog(@"left");
//    }    
//    if (FlxG.touches.iCadeRightBegan) {
//        NSLog(@"right");
//    }    
//    if (FlxG.touches.iCadeUpBegan) {
//        NSLog(@"up");
//    }    
//    if (FlxG.touches.iCadeDownBegan) {
//        NSLog(@"down");
//    }
//    
//    if (FlxG.touches.iCadeStartBegan) {
//        NSLog(@"start");
//    }    
//    if (FlxG.touches.iCadeLeftBumperBegan) {
//        NSLog(@"lb");
//    }    
//    if (FlxG.touches.iCadeSelectBegan) {
//        NSLog(@"sel");
//    }    
//    if (FlxG.touches.iCadeRightBumperBegan) {
//        NSLog(@"rb");
//    }    
//    if (FlxG.touches.iCadeYBegan) {
//        NSLog(@"y");
//    }    
//    if (FlxG.touches.iCadeBBegan) {
//        NSLog(@"b");
//    }    
//    if (FlxG.touches.iCadeABegan) {
//        NSLog(@"a");
//    }    
//    if (FlxG.touches.iCadeXBegan) {
//        NSLog(@"x");
//    }     
//    
    
//    if (FlxG.touches.iCadeLeft) {
//        NSLog(@"left");
//    }    
//    if (FlxG.touches.iCadeRight) {
//        NSLog(@"right");
//    }    
//    if (FlxG.touches.iCadeUp) {
//        NSLog(@"up");
//    }    
//    if (FlxG.touches.iCadeRightBumper) {
//        NSLog(@"down");
//    }
//    
//    if (FlxG.touches.iCadeStart) {
//        NSLog(@"start");
//    }    
//    if (FlxG.touches.iCadeLeftBumper) {
//        NSLog(@"lb");
//    }    
//    if (FlxG.touches.iCadeSelect) {
//        NSLog(@"sel");
//    }    
//    if (FlxG.touches.iCadeRightBumper) {
//        NSLog(@"rb");
//    }    
//    if (FlxG.touches.iCadeY) {
//        NSLog(@"y");
//    }    
//    if (FlxG.touches.iCadeB) {
//        NSLog(@"b");
//    }    
//    if (FlxG.touches.iCadeA) {
//        NSLog(@"a");
//    }    
//    if (FlxG.touches.iCadeX) {
//        NSLog(@"x");
//    } 
    
    if (FlxG.touches.iCadeLeftBegan || FlxG.touches.iCadeRightBegan  ) {
        
        [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];
        if (back._selected) {
            editButtonsBtn._selected=YES;
            back._selected=NO;
        }
        else if (editButtonsBtn._selected) {
            editButtonsBtn._selected=NO;
            back._selected=YES;
        }
        
    }
    
    if (FlxG.touches.iCadeUpBegan  || FlxG.touches.swipedLeft ) {
      
        if (FlxG.gamePad==0) {
            FlxG.gamePad=1;
        }
        else if (FlxG.gamePad==1) {
            FlxG.gamePad=2;
        }
        else if (FlxG.gamePad==2) {
            FlxG.gamePad=3;
        }
        else if (FlxG.gamePad==3) {
            FlxG.gamePad=0;
        }
        
        [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:FlxG.gamePad forKey:@"GAME_PAD"];
        [prefs synchronize];

    }
    
    if (FlxG.touches.iCadeDownBegan || FlxG.touches.swipedRight) {
        
        if (FlxG.gamePad==0) {
            FlxG.gamePad=3;
        }
        else if (FlxG.gamePad==1) {
            FlxG.gamePad=0;
        }
        else if (FlxG.gamePad==2) {
            FlxG.gamePad=1;
        }
        else if (FlxG.gamePad==3) {
            FlxG.gamePad=2;
        }
        [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:FlxG.gamePad forKey:@"GAME_PAD"];
        [prefs synchronize];
        
    }    
    
    
    
    if (FlxG.gamePad==0) {
        gamePadText.text=@"Touch screen [No external gamepad]";
        
    }
    else if (FlxG.gamePad==1) {
        gamePadText.text=@"Gamepad button layout: iCade";
        
    }
    else if (FlxG.gamePad==2) {
        gamePadText.text=@"Gamepad button layout: iControlPad v2.0";
    }    
    else if (FlxG.gamePad==3) {
        gamePadText.text=@"Gamepad button layout: iControlPad v2.1a";
    }        
    
    //NSLog(@"%d", FlxG.gamePad );
    
    if (cycles>0){
        watchBtn.visible=YES;
        back.visible=YES;
        editButtonsBtn.visible=YES;
    }
    cycles++;
    
    if (FlxG.touches.iCadeBBegan) {
        [self onBack];
        return;
    }
    if (FlxG.touches.iCadeABegan) {
        if (back._selected) {
            [self onBack];
            return;
        }
        else if (editButtonsBtn._selected) {
            [self onEditButtons];
            return;
        }
    }
    
    
	[super update];
	
}

- (void) onWatch
{
    FlxG.level=1001;
    FlxG.hardCoreMode=NO;
    [FlxG playWithParam1:@"ping.caf" param2:PING_VOL param3:NO];

	FlxG.state = [[[OgmoCutSceneState alloc] init] autorelease];
    return;
    
}

- (void) onBack
{
    [FlxG playWithParam1:@"ping2.caf" param2:PING2_VOL param3:NO];

	FlxG.state = [[[MenuState alloc] init] autorelease];
    return;
}

- (void) onEditButtons
{
    [FlxG playWithParam1:@"ping2.caf" param2:PING2_VOL param3:NO];
    
	FlxG.state = [[[ButtonAdjustState alloc] init] autorelease];
    return;
}


@end

