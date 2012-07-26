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
#import "WorldSelectState.h"
#import "PlayState.h"
#import "LevelMenuState.h"
#import "Bottle.h"
#import "NavArrow.h"
#import "OgmoLevelState.h"
#import "WinniOgmoLevelState.h"


#define MAX_LEVELS 5

static int currentLevelSelected;
static int currentSizeSelected;

FlxSprite * bgCity;
FlxSprite * bgClouds;
FlxSprite * darkenBar;
FlxSprite * sugarbags;
FlxSprite * sugarbagsR;
FlxSprite * shelves;
FlxSprite * arrow;

static NSString * ImgBgGrad = @"level1_bgSmoothGrad_new.png";

static NSString * ImgSmallButton = @"emptySmallButton.png";
static NSString * ImgSmallButtonPressed = @"emptySmallButtonPressed.png";

static NSString * ImgSmallButtonF = @"emptySmallButtonF.png";
static NSString * ImgSmallButtonPressedF = @"emptySmallButtonPressedF.png";

static NSString * ImgSmallButtonM = @"emptySmallButtonM.png";
static NSString * ImgSmallButtonPressedM = @"emptySmallButtonPressedM.png";

static NSString * SndBack = @"ping2.caf";
static NSString * SndSwipe = @"whoosh.caf";
static NSString * SndSelect = @"ping.caf";

FlxSprite * playLevel1;
FlxSprite * playLevel2;
FlxSprite * playLevel3;
FlxSprite * playLevel4;
FlxSprite * playLevel5;


FlxButton * playBtnW;
FlxButton * backBtnW;

FlxButton * playBtnF;
FlxButton * backBtnF;

FlxButton * playBtnM;
FlxButton * backBtnM;



FlxText * swipeInfo;
FlxText * levelInfo;
int bottomOfLevelSticker = 260;
BOOL controlOfTop = YES;


@interface WorldSelectState ()
@end


@implementation WorldSelectState

- (id) init
{
	if ((self = [super init])) {
		self.bgColor = 0xdbd0c2;
	}
	return self;
}

- (void) create
{    
    FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:320];  
    [grad loadGraphic:ImgBgGrad empties:0 autoTile:NO isSpeechBubble:0 isGradient:17];
    [self add:grad];
    
    currentLevelSelected = 1;
    currentSizeSelected = 1;
    controlOfTop=YES;
    
    sugarbags = [FlxSprite spriteWithX:153 y:128 graphic:@"level1_leftSideMG.png"];
    sugarbags.x = 0;
    sugarbags.y = FlxG.height-sugarbags.height;
    [self add:sugarbags];
    sugarbags.velocity = CGPointMake(-300, 0);
    sugarbags.drag = CGPointMake(150, 150); 
    
    shelves = [FlxSprite spriteWithX:210 y:313 graphic:@"L1_Shelf.png"];
    shelves.x = FlxG.width-shelves.width;
    shelves.y = FlxG.height-shelves.height;;
    [self add:shelves];
    shelves.velocity = CGPointMake(-300, 0);
    shelves.drag = CGPointMake(150, 150); 
    
    sugarbagsR = [FlxSprite spriteWithX:153 y:128 graphic:@"level1_rightSideMG.png"];
    sugarbagsR.x = FlxG.width-sugarbagsR.width+302;
    sugarbagsR.y = FlxG.height-sugarbagsR.height+1;
    [self add:sugarbagsR];
    sugarbagsR.velocity = CGPointMake(-300, 0);
    sugarbagsR.drag = CGPointMake(150, 150);    
    
    backBtnW = [[[FlxButton alloc]   initWithX:20
                                                        y:FlxG.height - 50
                                                 callback:[FlashFunction functionWithTarget:self
                                                                                     action:@selector(onBack)]] autorelease];
    [backBtnW loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]  param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
    [backBtnW loadTextWithParam1:[FlxText textWithWidth:backBtnW.width
                                                  text:NSLocalizedString(@"back", @"back")
                                                  font:@"SmallPixel"
                                                  size:16.0] param2:[FlxText textWithWidth:backBtnW.width
                                                                                      text:NSLocalizedString(@"BACK...", @"BACK...")
                                                                                      font:@"SmallPixel"
                                                                                      size:16.0] withXOffset:0 withYOffset:backBtnW.height/4];
    [self add:backBtnW];
    
    backBtnF = [[[FlxButton alloc]   initWithX:20
                                             y:FlxG.height - 50
                                      callback:[FlashFunction functionWithTarget:self
                                                                          action:@selector(onBack)]] autorelease];
    
    [backBtnF loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButtonF] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressedF] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressedF]]; 
    [backBtnF loadTextWithParam1:[FlxText textWithWidth:backBtnF.width
                                                   text:NSLocalizedString(@"back", @"back")
                                                   font:@"SmallPixel"
                                                   size:16.0] param2:[FlxText textWithWidth:backBtnF.width
                                                                                       text:NSLocalizedString(@"BACK...", @"BACK...")
                                                                                       font:@"SmallPixel"
                                                                                       size:16.0] withXOffset:0 withYOffset:backBtnF.height/4];
    backBtnF.visible=NO;
    [self add:backBtnF];
    
    backBtnM = [[[FlxButton alloc]   initWithX:20
                                             y:FlxG.height - 50
                                      callback:[FlashFunction functionWithTarget:self
                                                                          action:@selector(onBack)]] autorelease];
    
    [backBtnM loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButtonM] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressedM] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressedM]]; 
    [backBtnM loadTextWithParam1:[FlxText textWithWidth:backBtnM.width
                                                   text:NSLocalizedString(@"back", @"back")
                                                   font:@"SmallPixel"
                                                   size:16.0] param2:[FlxText textWithWidth:backBtnM.width
                                                                                       text:NSLocalizedString(@"BACK...", @"BACK...")
                                                                                       font:@"SmallPixel"
                                                                                       size:16.0] withXOffset:0 withYOffset:backBtnM.height/4];
    backBtnM.visible=NO;
    [self add:backBtnM];
    
    
    
    
    float ypos=70;
    bottomOfLevelSticker=260;

    if (FlxG.iPad) {
        ypos=120;
        bottomOfLevelSticker=400;

    
    }
    
    playLevel1 = [FlxSprite spriteWithX:FlxG.width/2 - 114 
                                      y:ypos 
                                graphic:@"level1Button.png"];
    [self add:playLevel1];
    
    
    playLevel2 = [FlxSprite spriteWithX:FlxG.width/2 - 114 
                                      y:ypos 
                                graphic:@"level2Button.png"];
    [self add:playLevel2];
    
    playLevel3 = [FlxSprite spriteWithX:FlxG.width/2 - 114 
                                      y:ypos 
                                graphic:@"level3Button.png"];
    [self add:playLevel3];
    
    playLevel4 = [FlxSprite spriteWithX:FlxG.width/2 - 114 
                                      y:ypos 
                                graphic:@"level4Button.png"];
    [self add:playLevel4]; 
    
    
    playLevel5 = [FlxSprite spriteWithX:FlxG.width/2 - 114 
                                      y:ypos 
                                graphic:@"level5Button.png"];
    [self add:playLevel5];   
    
    
    
    playBtnW = [[[FlxButton alloc]      initWithX: FlxG.width/2-60
                                               y:FlxG.height - 50
                                        callback:[FlashFunction functionWithTarget:self
                                                                            action:@selector(onPlay)]] autorelease];
    [playBtnW loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
    [playBtnW loadTextWithParam1:[FlxText textWithWidth:playBtnW.width
                                                  text:NSLocalizedString(@"play", @"play")
                                                  font:@"SmallPixel"
                                                  size:16.0] param2:[FlxText textWithWidth:playBtnW.width
                                                                                      text:NSLocalizedString(@"PLAY...", @"PLAY...")
                                                                                      font:@"SmallPixel"
                                                                                      size:16.0] withXOffset:0 withYOffset:playBtnW.height/4];
    
    [self add:playBtnW];
    
    
    playBtnF = [[[FlxButton alloc]      initWithX: FlxG.width/2-60
                                                y:FlxG.height - 50
                                         callback:[FlashFunction functionWithTarget:self
                                                                             action:@selector(onPlay)]] autorelease];
    [playBtnF loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButtonF] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressedF] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressedF]]; 
    [playBtnF loadTextWithParam1:[FlxText textWithWidth:playBtnF.width
                                                   text:NSLocalizedString(@"play", @"play")
                                                   font:@"SmallPixel"
                                                   size:16.0] param2:[FlxText textWithWidth:playBtnF.width
                                                                                       text:NSLocalizedString(@"PLAY...", @"PLAY...")
                                                                                       font:@"SmallPixel"
                                                                                       size:16.0] withXOffset:0 withYOffset:playBtnF.height/4];
    
    playBtnF.visible=NO;
    [self add:playBtnF];
    
    playBtnM = [[[FlxButton alloc]      initWithX: FlxG.width/2-60
                                                y:FlxG.height - 50
                                         callback:[FlashFunction functionWithTarget:self
                                                                             action:@selector(onPlay)]] autorelease];
    [playBtnM loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButtonM] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressedM] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressedM]]; 
    [playBtnM loadTextWithParam1:[FlxText textWithWidth:playBtnM.width
                                                   text:NSLocalizedString(@"play", @"play")
                                                   font:@"SmallPixel"
                                                   size:16.0] param2:[FlxText textWithWidth:playBtnM.width
                                                                                       text:NSLocalizedString(@"PLAY...", @"PLAY...")
                                                                                       font:@"SmallPixel"
                                                                                       size:16.0] withXOffset:0 withYOffset:playBtnM.height/4];
    
    playBtnM.visible=NO;
    [self add:playBtnM];
    
    
    
    swipeInfo = [FlxText textWithWidth:FlxG.width
                                                   text:@"<< Swipe Left And Right To Change Location >>"
                                                   font:@"SmallPixel"
                                                   size:16];
	swipeInfo.color = 0xffa6605a;
	swipeInfo.alignment = @"center";
	swipeInfo.x = 0;
	swipeInfo.y = 8;
	[self add:swipeInfo]; 
    
    levelInfo = [FlxText textWithWidth:FlxG.width
                                  text:@". _ _ _"
                                  font:@"SmallPixel"
                                  size:16];
	levelInfo.color = 0xffa6605a;
	levelInfo.alignment = @"center";
	levelInfo.x = 0;
	levelInfo.y = playLevel1.y + playLevel1.height - 2;
	[self add:levelInfo]; 
    
    
    navArrow = [NavArrow navArrowWithOrigin:CGPointMake(0, 0)];
    [self add:navArrow]; 
    
    navArrow.currentValue=1;
    navArrow.maxValue=2;
    
    navArrow.loc1=CGPointMake(playBtnF.x-navArrow.width, playBtnF.y+navArrow.height/2);
    navArrow.loc2=CGPointMake(backBtnF.x-navArrow.width, backBtnF.y+navArrow.height/2);
    navArrow.loc3=CGPointMake(0,0);

    
    if (FlxG.gamePad==0) {
        navArrow.visible=NO;
    }
    
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger selectedWorld = [prefs integerForKey:@"CURRENT_WORLD_SELECTED"];
    currentLevelSelected=selectedWorld;
    
    
    switch (currentLevelSelected) {
        case 1:

            levelInfo.text=@". _ _ _ _";
            
            playBtnW.visible=YES;
            backBtnW.visible=YES;
            playBtnF.visible=NO;
            backBtnF.visible=NO;            
            playBtnM.visible=NO;
            backBtnM.visible=NO;
            
            
            
            break;
        case 2:
            
            levelInfo.text=@"_ . _ _ _";
            
            playBtnW.visible=NO;
            backBtnW.visible=NO;
            playBtnF.visible=YES;
            backBtnF.visible=YES;            
            playBtnM.visible=NO;
            backBtnM.visible=NO;
            
            break;
            
        case 3:
                        
            
            levelInfo.text=@"_ _ . _ _";
            
            playBtnW.visible=NO;
            backBtnW.visible=NO;
            playBtnF.visible=NO;
            backBtnF.visible=NO;            
            playBtnM.visible=YES;
            backBtnM.visible=YES;
            
            break;
        case 4:
            
            
            levelInfo.text=@"_ _ _ . _";
            
            playBtnW.visible=NO;
            backBtnW.visible=NO;
            playBtnF.visible=NO;
            backBtnF.visible=NO;            
            playBtnM.visible=YES;
            backBtnM.visible=YES;
            
            break;   
            
        case 5:
            
            
            levelInfo.text=@"_ _ _ _ .";
            
            playBtnW.visible=NO;
            backBtnW.visible=NO;
            playBtnF.visible=NO;
            backBtnF.visible=NO;            
            playBtnM.visible=YES;
            backBtnM.visible=YES;
            
            break;              
            
        default:
            break;
    }

    
    
    
}

- (void) dealloc
{
	//[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}


- (void) update
{    
        
//    if (FlxG.touches.touchesEnded ) {
//        float xleg = FlxG.touches.lastScreenTouchPoint.x-FlxG.touches.screenTouchBeganPoint.x;
//        float yleg = FlxG.touches.lastScreenTouchPoint.y-FlxG.touches.screenTouchBeganPoint.y;
//        float hypotenuse = sqrt((xleg*xleg)+(yleg*yleg));
//        if (hypotenuse>22){
//            float swiperotation = atan2(yleg, xleg) / M_PI * 180;
//            if (swiperotation < -135 || swiperotation > 135 ) { //left
//
//                //NSLog(@"swiped right");
//                
//                [FlxG playWithParam1:SndSwipe param2:0.14 param3:NO];
//
//                //if (FlxG.touches.screenTouchBeganPoint.y < bottomOfLevelSticker) {
//                    currentLevelSelected++;
//                    if (currentLevelSelected>MAX_LEVELS) {
//                        currentLevelSelected=1;
//                    }
//                //}
////                else if (FlxG.touches.screenTouchBeganPoint.y > bottomOfLevelSticker) {
////                    currentSizeSelected++;
////                    if (currentSizeSelected>MAX_LEVELS) {
////                        currentSizeSelected=1;
////                    }
////                }
//                
//                
//            }
//            if (swiperotation < 45 && swiperotation > -45 ) { //right
//
//                //NSLog(@"swiped left");
//                [FlxG playWithParam1:SndSwipe param2:0.14 param3:NO];
//
//                //if (FlxG.touches.screenTouchBeganPoint.y < bottomOfLevelSticker) {
//                    currentLevelSelected--;
//                    if (currentLevelSelected<=0) {
//                        currentLevelSelected=MAX_LEVELS;
//                    }
//                //}
////                else if (FlxG.touches.screenTouchBeganPoint.y > bottomOfLevelSticker) {
////                    currentSizeSelected--;
////                    if (currentSizeSelected<=0) {
////                        currentSizeSelected=MAX_LEVELS;
////                    }
////                }
//                
//            }
//            if (swiperotation < 135 && swiperotation > 45 ) { //down
//                //NSLog(@"swiped down");
//            }				
//            if (swiperotation < -45 && swiperotation > -135 ) { //up
//                //NSLog(@"swiped up");
//            }
//        }
//    }
    

    //float xleg = FlxG.touches.lastScreenTouchPoint.x-FlxG.touches.screenTouchBeganPoint.x;
    //float yleg = FlxG.touches.lastScreenTouchPoint.y-FlxG.touches.screenTouchBeganPoint.y;
    //float hypotenuse = sqrt((xleg*xleg)+(yleg*yleg));
    
    //if (hypotenuse>22){
    if (FlxG.touches.swipedLeft || (FlxG.touches.iCadeRightBegan && controlOfTop)) { //left
        
        //NSLog(@"swiped right");
        
        [FlxG playWithParam1:SndSwipe param2:0.14 param3:NO];
        
        //if (FlxG.touches.screenTouchBeganPoint.y < bottomOfLevelSticker) {
        currentLevelSelected++;
        if (currentLevelSelected>MAX_LEVELS) {
            currentLevelSelected=1;
        }
        //}
        //                else if (FlxG.touches.screenTouchBeganPoint.y > bottomOfLevelSticker) {
        //                    currentSizeSelected++;
        //                    if (currentSizeSelected>MAX_LEVELS) {
        //                        currentSizeSelected=1;
        //                    }
        //                }
        
        
    }
    else if (FlxG.touches.swipedRight  || (FlxG.touches.iCadeLeftBegan && controlOfTop)) { //right
        
        //NSLog(@"swiped left");
        [FlxG playWithParam1:SndSwipe param2:0.14 param3:NO];
        
        //if (FlxG.touches.screenTouchBeganPoint.y < bottomOfLevelSticker) {
        currentLevelSelected--;
        if (currentLevelSelected<=0) {
            currentLevelSelected=MAX_LEVELS;
        }
        
    }
    
    if (FlxG.touches.iCadeDownBegan) {
        if (controlOfTop)
            [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];

        controlOfTop=NO;

    }
    if (FlxG.touches.iCadeUpBegan) {
        if (!controlOfTop)
            [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];

        controlOfTop=YES;

    }    
    if (controlOfTop) {
        navArrow.visible=NO;
        
    }
    else {
        navArrow.visible=YES;
    }
    

    
    
    
    float offx=171;
    float centre=FlxG.width/2-114;
    float scaleP1=0.5;
    float scaleP2=0.25;
    float scaleP3=0.125;
    float scaleP4=0.075;    
    
    float alpha1=0.8;
    float alpha2=0.7;
    float alpha3=0.6;
    float alpha4=0.5;
   
    [self setAllButtonsToNotSelected];
    
    switch (currentLevelSelected) {
        case 1:
            
//            playLevel1.visible = YES;
//            playLevel2.visible = NO;
//            playLevel3.visible = NO;
            
            playLevel1.x = centre;
            playLevel2.x = centre+offx;
            playLevel3.x = centre+offx*1.5 ;
            playLevel4.x = centre+offx*2 ;
            playLevel5.x = centre+offx*2.5 ;
            
            playLevel1.scale = CGPointMake(1, 1);
            playLevel2.scale = CGPointMake(scaleP1, scaleP1);
            playLevel3.scale = CGPointMake(scaleP2, scaleP2);
            playLevel4.scale = CGPointMake(scaleP3, scaleP3);
            playLevel5.scale = CGPointMake(scaleP4, scaleP4);

            playLevel1.alpha = 1;
            playLevel2.alpha = alpha1;
            playLevel3.alpha = alpha2;
            playLevel4.alpha = alpha3;
            playLevel5.alpha = alpha4;

            levelInfo.text=@". _ _ _ _";
            
            playBtnW.visible=YES;
            backBtnW.visible=YES;
            playBtnF.visible=NO;
            backBtnF.visible=NO;            
            playBtnM.visible=NO;
            backBtnM.visible=NO;
            
            if (!controlOfTop) {
                if (navArrow.currentValue==1)
                    playBtnW._selected=YES;
                else if (navArrow.currentValue==2)
                    backBtnW._selected=YES;
            }
            
            
            break;
        case 2:
            
//            playLevel1.visible = NO;
//            playLevel2.visible = YES;
//            playLevel3.visible = NO;
            
            playLevel1.x = centre-offx;
            playLevel2.x = centre;
            playLevel3.x = centre+offx;
            playLevel4.x = centre+offx*1.5;
            playLevel5.x = centre+offx*2;
           
            playLevel1.scale = CGPointMake(scaleP1, scaleP1);
            playLevel2.scale = CGPointMake(1, 1);
            playLevel3.scale = CGPointMake(scaleP1, scaleP1);
            playLevel4.scale = CGPointMake(scaleP2, scaleP2);
            playLevel4.scale = CGPointMake(scaleP3, scaleP3);

            playLevel1.alpha = alpha1;
            playLevel2.alpha = 1;
            playLevel3.alpha = alpha1;
            playLevel4.alpha = alpha2;
            playLevel5.alpha = alpha3;

            
            levelInfo.text=@"_ . _ _ _";
            
            playBtnW.visible=NO;
            backBtnW.visible=NO;
            playBtnF.visible=YES;
            backBtnF.visible=YES;            
            playBtnM.visible=NO;
            backBtnM.visible=NO;
            if (!controlOfTop) {
                if (navArrow.currentValue==1)
                    playBtnF._selected=YES;
                else if (navArrow.currentValue==2)
                    backBtnF._selected=YES;
            }
            break;

        case 3:
            
//            playLevel1.visible = NO;
//            playLevel2.visible = NO;
//            playLevel3.visible = YES;
            
            playLevel1.x = centre-offx*1.5;
            playLevel2.x = centre-offx;
            playLevel3.x = centre;
            playLevel4.x = centre+offx;
            playLevel5.x = centre+offx*1.5;
            
            playLevel1.scale = CGPointMake(scaleP2, scaleP2);
            playLevel2.scale = CGPointMake(scaleP1, scaleP1);
            playLevel3.scale = CGPointMake(1, 1);
            playLevel4.scale = CGPointMake(scaleP1, scaleP1);
            playLevel5.scale = CGPointMake(scaleP2, scaleP2);
            
            playLevel1.alpha = alpha2;
            playLevel2.alpha = alpha1;
            playLevel3.alpha = 1;
            playLevel4.alpha = alpha1;
            playLevel5.alpha = alpha2;
            

            
            levelInfo.text=@"_ _ . _ _";

            playBtnW.visible=NO;
            backBtnW.visible=NO;
            playBtnF.visible=NO;
            backBtnF.visible=NO;            
            playBtnM.visible=YES;
            backBtnM.visible=YES;
            if (!controlOfTop) {
                if (navArrow.currentValue==1)
                    playBtnM._selected=YES;
                else if (navArrow.currentValue==2)
                    backBtnM._selected=YES;
            }            
          
            break;
        case 4:
            
            playLevel1.x = centre-offx*2;
            playLevel2.x = centre-offx*1.5;
            playLevel3.x = centre-offx;
            playLevel4.x = centre;
            playLevel5.x = centre+offx;
            
            playLevel1.scale = CGPointMake(scaleP3, scaleP3);
            playLevel2.scale = CGPointMake(scaleP2, scaleP2);
            playLevel3.scale = CGPointMake(scaleP1, scaleP1);
            playLevel4.scale = CGPointMake(1,1);
            playLevel5.scale = CGPointMake(scaleP1, scaleP1);
            
            playLevel1.alpha = alpha3;
            playLevel2.alpha = alpha2;
            playLevel3.alpha = alpha1;
            playLevel4.alpha = 1;            
            playLevel5.alpha = alpha1;
            
            levelInfo.text=@"_ _ _ . _";
            playBtnW.visible=YES;
            backBtnW.visible=YES;
            playBtnF.visible=NO;
            backBtnF.visible=NO;            
            playBtnM.visible=NO;
            backBtnM.visible=NO;
            if (!controlOfTop) {
                if (navArrow.currentValue==1)
                    playBtnW._selected=YES;
                else if (navArrow.currentValue==2)
                    backBtnW._selected=YES;
            }
            break;
            
        case 5:
            
            playLevel1.x = centre-offx*2.5;
            playLevel2.x = centre-offx*2;
            playLevel3.x = centre-offx*1.5;
            playLevel4.x = centre-offx;
            playLevel5.x = centre;
            
            playLevel1.scale = CGPointMake(scaleP4, scaleP4);

            playLevel2.scale = CGPointMake(scaleP3, scaleP3);
            playLevel3.scale = CGPointMake(scaleP2, scaleP2);
            playLevel4.scale = CGPointMake(scaleP1, scaleP1);
            playLevel5.scale = CGPointMake(1,1);
            
            playLevel1.alpha = alpha4;
            playLevel2.alpha = alpha3;
            playLevel3.alpha = alpha2;
            playLevel4.alpha = alpha1;            
            playLevel5.alpha = 1;
            
            levelInfo.text=@"_ _ _ _ .";
            playBtnW.visible=YES;
            backBtnW.visible=YES;
            playBtnF.visible=NO;
            backBtnF.visible=NO;            
            playBtnM.visible=NO;
            backBtnM.visible=NO;
            if (!controlOfTop) {
                if (navArrow.currentValue==1)
                    playBtnW._selected=YES;
                else if (navArrow.currentValue==2)
                    backBtnW._selected=YES;
            }
            break;            
            
            
        default:
            break;
    }
    
    if (FlxG.touches.iCadeABegan) {
        if (navArrow.currentValue==1)
            [self onPlay];
        else if (navArrow.currentValue==2)
            [self onBack];
    }
    
    if (FlxG.touches.iCadeBBegan) {
        [self onBack];
        return;
    }
    
    if (FlxG.touches.iCadeLeftBegan && !controlOfTop) {
        navArrow.currentValue--;
        [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];

    }
    
    if (FlxG.touches.iCadeRightBegan && !controlOfTop) {
        navArrow.currentValue++;
        [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];

    }    
    
	[super update];
	
    
	
}

- (void) onBack
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:currentLevelSelected forKey:@"CURRENT_WORLD_SELECTED"];
    [prefs synchronize];
    
    [FlxG play:SndBack];

    FlxG.state = [[[MenuState alloc] init] autorelease];
    return;
}

- (void) onPlay
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:currentLevelSelected forKey:@"CURRENT_WORLD_SELECTED"];
    [prefs synchronize];
    
    int level = 1;
    if (currentLevelSelected==1 ) {
        FlxG.winnitron=NO;
        FlxG.oldSchool = NO;
        level=1;
        [FlxG play:SndSelect];
        
        FlxG.level = level;
        FlxG.state = [[[LevelMenuState alloc] init] autorelease];
        return; 
    } else if (currentLevelSelected==2 ) {
        FlxG.winnitron=NO;
        FlxG.oldSchool = NO;
        level=13;
        [FlxG play:SndSelect];
        
        FlxG.level = level;
        FlxG.state = [[[LevelMenuState alloc] init] autorelease];
        return; 
    } else if (currentLevelSelected==3 ) {
        FlxG.winnitron=NO;
        FlxG.oldSchool = NO;
        level=25;
        [FlxG play:SndSelect];
        
        FlxG.level = level;
        FlxG.state = [[[LevelMenuState alloc] init] autorelease];
        return; 
    } else if (currentLevelSelected==4) {
        [FlxG play:SndSelect];
        FlxG.timeLeft= WINNITRON_TIME;
        FlxG.hardCoreMode = NO;
        FlxG.winnitron=YES;
        FlxG.oldSchool = NO;
        FlxG.level = 1;
        FlxG.state = [[[WinniOgmoLevelState alloc] init] autorelease];
        return;  
    } else if (currentLevelSelected==5) {
        [FlxG play:SndSelect];
        FlxG.level = 1;
        FlxG.mlives = 3;
        FlxG.flives = 3;
        
        FlxG.oldSchool = YES;
        FlxG.restartMusic=YES;
        FlxG.state = [[[OgmoLevelState alloc] init] autorelease];
        return;  
    }
        
   
    

}

- (void) setAllButtonsToNotSelected;
{
    playBtnF._selected=NO;
    playBtnM._selected=NO;
    playBtnW._selected=NO;
    backBtnF._selected=NO;
    backBtnM._selected=NO;
    backBtnW._selected=NO;
    
    
    
}

@end

