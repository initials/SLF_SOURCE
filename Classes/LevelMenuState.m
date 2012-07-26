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

#import "WorldSelectState.h"
#import "LevelMenuState.h"
#import "PlayState.h"
#import "OgmoLevelState.h"
#import "OgmoCutSceneState.h"
#import "OgmoRevCinematicState.h"
#import "OgmoCinematicState.h"

#import "Bottle.h"
#import "Badge.h"
#import "TalkBadge.h"

#import "NavArrow.h"

static int currentLevelSelected;
static int currentSizeSelected;

FlxSprite * bgCity;
FlxSprite * bgClouds;
FlxSprite * darkenBar;
FlxSprite * sugarbags;
FlxSprite * sugarbagsR;
FlxSprite * shelves;
FlxSprite * arrow;

NavArrow * navArrow;

FlxButton * hcButton;
FlxButton * hcButtonExplain;

FlxButton * normalButton;

static NSString * ImgBgGrad = @"level1_bgSmoothGrad_new.png";
static NSString * ImgSmallButton = @"emptySmallButton.png";
static NSString * ImgLocked = @"emptySmallButtonLocked.png";
static NSString * ImgLockedSelected = @"emptySmallButtonLockedSelected.png";

static NSString * ImgStar = @"capreal.png";
static NSString * Imgstarhc = @"caprealx.png";

static NSString * ImgTalkedToPlain = @"talkedToPlain.png";
static NSString * ImgTalkedToAndre = @"talkedToAndre.png";

static NSString * ImgTalkedToPlainHC = @"talkedToPlain.png";
static NSString * ImgTalkedToAndreHC = @"talkedToAndre.png";


static NSString * ImgSmallButtonPressed = @"emptySmallButtonPressed.png";
static NSString * ImgSmallButtonSelected = @"emptySmallButtonLockedSelected.png";




static NSString * ImgSmallButtonGrey = @"emptySmallButtonGrey.png";
static NSString * ImgSmallButtonPressedGrey = @"emptySmallButtonPressedGrey.png";


static NSString * SndBack = @"ping2.caf";
static NSString * SndSwipe = @"whoosh.caf";
static NSString * SndSelect = @"ping.caf";

int world = 1;

FlxButton * playLevel1;
FlxButton * playLevel2;
FlxButton * playLevel3;
FlxButton * playLevel4;

FlxButton * playBtn;

NSInteger level1;
NSInteger level2;
NSInteger level3;
NSInteger level4;
NSInteger level5;
NSInteger level6;
NSInteger level7;
NSInteger level8;
NSInteger level9;
NSInteger level10;
NSInteger level11;
NSInteger level12;

NSInteger hclevel1;
NSInteger hclevel2;
NSInteger hclevel3;
NSInteger hclevel4;
NSInteger hclevel5;
NSInteger hclevel6;
NSInteger hclevel7;
NSInteger hclevel8;
NSInteger hclevel9;
NSInteger hclevel10;
NSInteger hclevel11;
NSInteger hclevel12;




float gridRow1x1;
float gridRow1x2;
float gridRow1x3;
float gridRow1y ;

float gridRow2y;   

float gridRow3y ;

float gridRow4y;

int frameCounter;



@interface LevelMenuState ()
@end


@implementation LevelMenuState

- (id) init
{
	if ((self = [super init])) {
		self.bgColor = 0xdbd0c2;
	}
	return self;
}

- (void) create
{    
    //NSLog(@"hcm %d", FlxG.hardCoreMode );
    
//    if (FlxG.hardCoreMode) {
//        ImgStar=@"caprealx.png";
//    }
//    else if (!FlxG.hardCoreMode) {
//        ImgStar=@"capreal.png";
//    }
    
    FlxG.restartMusic = YES;
    
    frameCounter=0;
    
    [FlxG levelProgress];
    
    if (FlxG.level>=1 && FlxG.level <= 12) {
        int a = [FlxG levelProgressWarehouse];
        if (a<12) {
            FlxG.hardCoreMode=NO;
        }
    }
    if (FlxG.level>=13 && FlxG.level <= 24) {
        int a = [FlxG levelProgressFactory];
        if (a<12) {
            FlxG.hardCoreMode=NO;
        }
    }    
    if (FlxG.level>=25 && FlxG.level <= 36) {
        int a = [FlxG levelProgressManagement];
        if (a<12) {
            FlxG.hardCoreMode=NO;
        }
    }   

    largeHCText = [FlxText textWithWidth:FlxG.width*3
                                    text:@"HARDCORE\nMODE"
                                    font:@"SmallPixel"
                                    size:140];
    largeHCText.color = 0xffffffff;
    largeHCText.alignment = @"left";
    largeHCText.x = 0;
    largeHCText.y = 0;
    largeHCText.visible=NO;
    
    
    currentLevelSelected = 1;
    currentSizeSelected = 1;
    

    screenDarken  = [FlxSprite spriteWithX:0 y:0 graphic:nil];
	[screenDarken createGraphicWithParam1:FlxG.width param2:FlxG.height param3:0xff000000];
	screenDarken.visible = NO;
    screenDarken.alpha = 0.35;
    screenDarken.x = 0;
    screenDarken.y = 0;
    screenDarken.scrollFactor = CGPointZero;
    screenDarken.drag = CGPointMake(500, 500);
    
        
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if (FlxG.level>=1 && FlxG.level <= 12) {
        ImgStar=@"capreal.png";
        Imgstarhc=@"caprealx.png";
        FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:320];  
        [grad loadGraphic:ImgBgGrad empties:0 autoTile:NO isSpeechBubble:0 isGradient:17];
        [self add:grad];  

        [self add:largeHCText];
        
        
        shelves = [FlxSprite spriteWithX:-30 y:0 graphic:@"L1_Shelf.png"];
        [self add:shelves];
        shelves.velocity = CGPointMake(-300, 0);
        shelves.drag = CGPointMake(150, 150); 
        
        sugarbagsR = [FlxSprite spriteWithX:335 y:140 graphic:@"level1_rightSideMG.png"];
        [self add:sugarbagsR];
        sugarbagsR.velocity = CGPointMake(-300, 0);
        sugarbagsR.drag = CGPointMake(50, 50); 
        
        
        //NSLog(@"World is 1. Warehouse");
        
        FlxG.level=1;
        
        ImgSmallButton=@"emptySmallButton.png";
        ImgSmallButtonPressed = @"emptySmallButtonPressed.png";
        world=1;
        
        level1 = [prefs integerForKey:@"level1"];
        level2 = [prefs integerForKey:@"level2"];
        level3 = [prefs integerForKey:@"level3"];
        level4 = [prefs integerForKey:@"level4"];
        level5 = [prefs integerForKey:@"level5"];
        level6 = [prefs integerForKey:@"level6"];
        level7 = [prefs integerForKey:@"level7"];
        level8 = [prefs integerForKey:@"level8"];
        level9 = [prefs integerForKey:@"level9"];
        level10 = [prefs integerForKey:@"level10"];
        level11 = [prefs integerForKey:@"level11"];
        level12 = [prefs integerForKey:@"level12"]; 
        
        hclevel1 = [prefs integerForKey:@"hclevel1"];
        hclevel2 = [prefs integerForKey:@"hclevel2"];
        hclevel3 = [prefs integerForKey:@"hclevel3"];
        hclevel4 = [prefs integerForKey:@"hclevel4"];
        hclevel5 = [prefs integerForKey:@"hclevel5"];
        hclevel6 = [prefs integerForKey:@"hclevel6"];
        hclevel7 = [prefs integerForKey:@"hclevel7"];
        hclevel8 = [prefs integerForKey:@"hclevel8"];
        hclevel9 = [prefs integerForKey:@"hclevel9"];
        hclevel10 = [prefs integerForKey:@"hclevel10"];
        hclevel11 = [prefs integerForKey:@"hclevel11"];
        hclevel12 = [prefs integerForKey:@"hclevel12"]; 
        
        
        if (!FlxG.hardCoreMode) {
            heading = [FlxText textWithWidth:FlxG.width
                                        text:@"Warehouse"
                                        font:@"SmallPixel"
                                        size:16];
            heading.color = 0xffa6605a;
            heading.alignment = @"center";
            heading.x = 0;
            heading.y = 8;
            [self add:heading];
            

        } else if (FlxG.hardCoreMode) {
            
            heading = [FlxText textWithWidth:FlxG.width
                                        text:@"Warehouse - Hardcore Mode"
                                        font:@"SmallPixel"
                                        size:16];
            heading.color = 0xffa6605a;
            heading.alignment = @"center";
            heading.x = 0;
            heading.y = 8;
            [self add:heading];
            

        }
        
        
        FlxSprite * item1 = [FlxSprite spriteWithX:120 y:-40 graphic:@"CrateWithLabel.png"];
        [self add:item1];
        item1.velocity = CGPointMake(0, 300);
        item1.drag = CGPointMake(150, 150); 
        FlxSprite * item2 = [FlxSprite spriteWithX:250 y:-40 graphic:@"CrateWithLabel.png"];
        [self add:item2];
        item2.velocity = CGPointMake(0, 300);
        item2.drag = CGPointMake(150, 150); 
        FlxSprite * item3 = [FlxSprite spriteWithX:370 y:-40 graphic:@"CrateWithLabel.png"];
        [self add:item3];
        item3.velocity = CGPointMake(0, 300);
        item3.drag = CGPointMake(150, 150); 
        
        if (FlxG.iPad) {
            item1.y+=64;
            item2.y+=64;
            item3.y+=64;
            //shelves.y+=64;
            //sugarbags.y+=64;
            
        }
        
    }
    else if (FlxG.level>=13 && FlxG.level <= 24) {
        ImgStar=@"caprealF.png";
        Imgstarhc=@"caprealxF.png";
        //NSLog(@"World is 2. factory");
        FlxG.level=13;

        ImgSmallButton=@"emptySmallButtonF.png";
        ImgSmallButtonPressed = @"emptySmallButtonPressedF.png";
        world=2;
        
        
        level1 = [prefs integerForKey:@"level13"];
        level2 = [prefs integerForKey:@"level14"];
        level3 = [prefs integerForKey:@"level15"];
        level4 = [prefs integerForKey:@"level16"];
        level5 = [prefs integerForKey:@"level17"];
        level6 = [prefs integerForKey:@"level18"];
        level7 = [prefs integerForKey:@"level19"];
        level8 = [prefs integerForKey:@"level20"];
        level9 = [prefs integerForKey:@"level21"];
        level10 = [prefs integerForKey:@"level22"];
        level11 = [prefs integerForKey:@"level23"];
        level12 = [prefs integerForKey:@"level24"];
        
        hclevel1 = [prefs integerForKey:@"hclevel13"];
        hclevel2 = [prefs integerForKey:@"hclevel14"];
        hclevel3 = [prefs integerForKey:@"hclevel15"];
        hclevel4 = [prefs integerForKey:@"hclevel16"];
        hclevel5 = [prefs integerForKey:@"hclevel17"];
        hclevel6 = [prefs integerForKey:@"hclevel18"];
        hclevel7 = [prefs integerForKey:@"hclevel19"];
        hclevel8 = [prefs integerForKey:@"hclevel20"];
        hclevel9 = [prefs integerForKey:@"hclevel21"];
        hclevel10 = [prefs integerForKey:@"hclevel22"];
        hclevel11 = [prefs integerForKey:@"hclevel23"];
        hclevel12 = [prefs integerForKey:@"hclevel24"];
        
        FlxSprite * item2 = [FlxSprite spriteWithX:0 y:0 graphic:@"level2_BG.png"];
        [self add:item2]; 
        

        [self add:largeHCText];
        
        
        FlxSprite * item1 = [FlxSprite spriteWithX:350 y:-150 graphic:@"level2_tank.png"];
        [self add:item1];
        item1.velocity = CGPointMake(0, 300);
        item1.drag = CGPointMake(150, 150); 
        FlxSprite * item3 = [FlxSprite spriteWithX:0 y:-140 graphic:@"level2_MG2.png"];
        [self add:item3];
        item3.velocity = CGPointMake(0, 280);
        item3.drag = CGPointMake(150, 150);  
        
        if (FlxG.iPad) {
//            item1.y+=64;
//            item3.y+=64;
            item1.x+=32;
            
        }
        
        if (!FlxG.hardCoreMode) {
            heading = [FlxText textWithWidth:FlxG.width
                                        text:@"Factory"
                                        font:@"SmallPixel"
                                        size:16];
            heading.color = 0xff66ceb9;
            heading.alignment = @"center";
            heading.x = 0;
            heading.y = 8;
            [self add:heading];
            
        }
        else         if (FlxG.hardCoreMode) {
            heading = [FlxText textWithWidth:FlxG.width
                                        text:@"Factory - Hardcore Mode"
                                        font:@"SmallPixel"
                                        size:16];
            heading.color = 0xff66ceb9;
            heading.alignment = @"center";
            heading.x = 0;
            heading.y = 8;
            [self add:heading];
            

        } 

    }
    else if (FlxG.level>=25 && FlxG.level <= 36) {
        ImgStar=@"caprealM.png";
        Imgstarhc=@"caprealxM.png";
        //NSLog(@"World is 3. mgmt");
        FlxG.level=25;

        ImgSmallButton=@"emptySmallButtonM.png";
        ImgSmallButtonPressed = @"emptySmallButtonPressedM.png";
        world=3;
        
        level1 = [prefs integerForKey:@"level25"];
        level2 = [prefs integerForKey:@"level26"];
        level3 = [prefs integerForKey:@"level27"];
        level4 = [prefs integerForKey:@"level28"];
        level5 = [prefs integerForKey:@"level29"];
        level6 = [prefs integerForKey:@"level30"];
        level7 = [prefs integerForKey:@"level31"];
        level8 = [prefs integerForKey:@"level32"];
        level9 = [prefs integerForKey:@"level33"];
        level10 = [prefs integerForKey:@"level34"];
        level11 = [prefs integerForKey:@"level35"];
        level12 = [prefs integerForKey:@"level36"]; 

        hclevel1 = [prefs integerForKey:@"hclevel25"];
        hclevel2 = [prefs integerForKey:@"hclevel26"];
        hclevel3 = [prefs integerForKey:@"hclevel27"];
        hclevel4 = [prefs integerForKey:@"hclevel28"];
        hclevel5 = [prefs integerForKey:@"hclevel29"];
        hclevel6 = [prefs integerForKey:@"hclevel30"];
        hclevel7 = [prefs integerForKey:@"hclevel31"];
        hclevel8 = [prefs integerForKey:@"hclevel32"];
        hclevel9 = [prefs integerForKey:@"hclevel33"];
        hclevel10 = [prefs integerForKey:@"hclevel34"];
        hclevel11 = [prefs integerForKey:@"hclevel35"];
        hclevel12 = [prefs integerForKey:@"hclevel36"]; 
        
        
        self.bgColor = 0xdfc296;

        FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:320];  
        [grad loadGraphic:@"level3_gradient.png" empties:0 autoTile:NO isSpeechBubble:0 isGradient:17];
        [self add:grad];
        


        [self add:largeHCText];
        
        FlxSprite * item3 = [FlxSprite spriteWithX:-20 y:120 graphic:@"level3_painting1.png"];
        [self add:item3];
        item3.velocity = CGPointMake(300, 0);
        item3.drag = CGPointMake(150, 150); 
        FlxSprite * item4 = [FlxSprite spriteWithX:-120 y:140 graphic:@"level3_painting2.png"];
        [self add:item4];
        item4.velocity = CGPointMake(300, 0);
        item4.drag = CGPointMake(150, 150); 
        FlxSprite * item5 = [FlxSprite spriteWithX:-220 y:160 graphic:@"level3_painting3.png"];
        [self add:item5];
        item5.velocity = CGPointMake(300, 0);
        item5.drag = CGPointMake(150, 150); 
        
        FlxSprite * item1 = [FlxSprite spriteWithX:120 y:-50 graphic:@"level3_desk1.png"];
        [self add:item1];
        item1.velocity = CGPointMake(0, 300);
        item1.drag = CGPointMake(150, 150); 
        
        FlxSprite * item2 = [FlxSprite spriteWithX:340 y:-50 graphic:@"level3_desk2.png"];
        [self add:item2];
        item2.velocity = CGPointMake(0, 300);
        item2.drag = CGPointMake(150, 150); 
        
        if (FlxG.iPad) {
            item1.y+=64;
            item2.y+=64;
            
        }
        
        if (!FlxG.hardCoreMode) {
            
            heading = [FlxText textWithWidth:FlxG.width
                                        text:@"Management"
                                        font:@"SmallPixel"
                                        size:16];
            heading.color = 0xffb24714;
            heading.alignment = @"center";
            heading.x = 0;
            heading.y = 8;
            [self add:heading];
            

        }
        else         if (FlxG.hardCoreMode) {
            
            heading = [FlxText textWithWidth:FlxG.width
                                        text:@"Management - Hardcore Mode"
                                        font:@"SmallPixel"
                                        size:16];
            heading.color = 0xffb24714;
            heading.alignment = @"center";
            heading.x = 0;
            heading.y = 8;
            [self add:heading];
            

        }
        
    }
    
    //NSLog(@" LEVEL COMPLETION STATS %d , %d , %d , %d , %d , %d, %d , %d , %d, %d , %d , %d", level1, level2, level3,  level4, level5, level6, level7, level8, level9,level10, level11, level12 );

    

    [self add:screenDarken];

    
  
    
    backBtn = [[[FlxButton alloc]   initWithX:40
                                                        y:FlxG.height - 50
                                                 callback:[FlashFunction functionWithTarget:self
                                                                                     action:@selector(onBack)]] autorelease];
    [backBtn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
    [backBtn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                  text:NSLocalizedString(@"back", @"back")
                                                  font:@"SmallPixel"
                                                  size:16.0] param2:[FlxText textWithWidth:backBtn.width
                                                                                      text:NSLocalizedString(@"BACK...", @"BACK...")
                                                                                      font:@"SmallPixel"
                                                                                      size:16.0] withXOffset:0 withYOffset:backBtn.height/4];
    [self add:backBtn];
    
    
    
    if (FlxG.level>=1 && FlxG.level <= 12) {
        int a = [FlxG levelProgressWarehouse];
        
        hcButton = [[[FlxButton alloc]   initWithX:320
                                                 y:FlxG.height - 50
                                          callback:[FlashFunction functionWithTarget:self
                                                                              action:@selector(onHC)]] autorelease];
        [hcButton loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [hcButton loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                       text:NSLocalizedString(@"HardCore", @"HardCore")
                                                       font:@"SmallPixel"
                                                       size:16.0] param2:[FlxText textWithWidth:backBtn.width
                                                                                           text:NSLocalizedString(@"HardCore", @"HardCore")
                                                                                           font:@"SmallPixel"
                                                                                           size:16.0] withXOffset:0 withYOffset:backBtn.height/4];
        [self add:hcButton];
        
        normalButton = [[[FlxButton alloc]   initWithX:320
                                                     y:FlxG.height - 50
                                              callback:[FlashFunction functionWithTarget:self
                                                                                  action:@selector(onHC)]] autorelease];
        [normalButton loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [normalButton loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                           text:NSLocalizedString(@"normal", @"normal")
                                                           font:@"SmallPixel"
                                                           size:16.0] param2:[FlxText textWithWidth:backBtn.width
                                                                                               text:NSLocalizedString(@"normal", @"normal")
                                                                                               font:@"SmallPixel"
                                                                                               size:16.0] withXOffset:0 withYOffset:backBtn.height/4];
        [self add:normalButton];
        normalButton.visible=NO;
        
        hcButtonExplain = [[[FlxButton alloc]   initWithX:320
                                                        y:FlxG.height - 50
                                                 callback:[FlashFunction functionWithTarget:self
                                                                                     action:@selector(onHCExplain)]] autorelease];
        [hcButtonExplain loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButtonGrey] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressedGrey]  param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressedGrey]]; 
        [hcButtonExplain loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                              text:NSLocalizedString(@"HardCore", @"HardCore")
                                                              font:@"SmallPixel"
                                                              size:16.0] param2:[FlxText textWithWidth:backBtn.width
                                                                                                  text:NSLocalizedString(@"HardCore", @"HardCore")
                                                                                                  font:@"SmallPixel"
                                                                                                  size:16.0] withXOffset:0 withYOffset:backBtn.height/4];
        [self add:hcButtonExplain];
        
        if (a==12) {
            hcButtonExplain.visible=NO;
        }
        else {
            hcButton.visible=NO;
        }
    }
    if (FlxG.level>=13 && FlxG.level <= 24) {
        int a = [FlxG levelProgressFactory];

        hcButton = [[[FlxButton alloc]   initWithX:320
                                                 y:FlxG.height - 50
                                          callback:[FlashFunction functionWithTarget:self
                                                                              action:@selector(onHC)]] autorelease];
        [hcButton loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [hcButton loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                       text:NSLocalizedString(@"HardCore", @"HardCore")
                                                       font:@"SmallPixel"
                                                       size:16.0] param2:[FlxText textWithWidth:backBtn.width
                                                                                           text:NSLocalizedString(@"HardCore", @"HardCore")
                                                                                           font:@"SmallPixel"
                                                                                           size:16.0] withXOffset:0 withYOffset:backBtn.height/4];
        [self add:hcButton];
        
        normalButton = [[[FlxButton alloc]   initWithX:320
                                                     y:FlxG.height - 50
                                              callback:[FlashFunction functionWithTarget:self
                                                                                  action:@selector(onHC)]] autorelease];
        [normalButton loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [normalButton loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                           text:NSLocalizedString(@"normal", @"normal")
                                                           font:@"SmallPixel"
                                                           size:16.0] param2:[FlxText textWithWidth:backBtn.width
                                                                                               text:NSLocalizedString(@"normal", @"normal")
                                                                                               font:@"SmallPixel"
                                                                                               size:16.0] withXOffset:0 withYOffset:backBtn.height/4];
        [self add:normalButton];
        normalButton.visible=NO;
        
        hcButtonExplain = [[[FlxButton alloc]   initWithX:320
                                                        y:FlxG.height - 50
                                                 callback:[FlashFunction functionWithTarget:self
                                                                                     action:@selector(onHCExplain)]] autorelease];
        [hcButtonExplain loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButtonGrey] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressedGrey]  param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressedGrey]]; 
        [hcButtonExplain loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                              text:NSLocalizedString(@"HardCore", @"HardCore")
                                                              font:@"SmallPixel"
                                                              size:16.0] param2:[FlxText textWithWidth:backBtn.width
                                                                                                  text:NSLocalizedString(@"HardCore", @"HardCore")
                                                                                                  font:@"SmallPixel"
                                                                                                  size:16.0] withXOffset:0 withYOffset:backBtn.height/4];
        [self add:hcButtonExplain];
        
        if (a==12) {
            hcButtonExplain.visible=NO;
        }
        else {
            hcButton.visible=NO;
        }
    }   
    
    if (FlxG.level>=25 && FlxG.level <= 36) {
        int a = [FlxG levelProgressManagement];

        hcButton = [[[FlxButton alloc]   initWithX:320
                                                 y:FlxG.height - 50
                                          callback:[FlashFunction functionWithTarget:self
                                                                              action:@selector(onHC)]] autorelease];
        [hcButton loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [hcButton loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                       text:NSLocalizedString(@"HardCore", @"HardCore")
                                                       font:@"SmallPixel"
                                                       size:16.0] param2:[FlxText textWithWidth:backBtn.width
                                                                                           text:NSLocalizedString(@"HardCore", @"HardCore")
                                                                                           font:@"SmallPixel"
                                                                                           size:16.0] withXOffset:0 withYOffset:backBtn.height/4];
        [self add:hcButton];
        
        normalButton = [[[FlxButton alloc]   initWithX:320
                                                     y:FlxG.height - 50
                                              callback:[FlashFunction functionWithTarget:self
                                                                                  action:@selector(onHC)]] autorelease];
        [normalButton loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [normalButton loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                           text:NSLocalizedString(@"normal", @"normal")
                                                           font:@"SmallPixel"
                                                           size:16.0] param2:[FlxText textWithWidth:backBtn.width
                                                                                               text:NSLocalizedString(@"normal", @"normal")
                                                                                               font:@"SmallPixel"
                                                                                               size:16.0] withXOffset:0 withYOffset:backBtn.height/4];
        [self add:normalButton];
        normalButton.visible=NO;
        
        hcButtonExplain = [[[FlxButton alloc]   initWithX:320
                                                        y:FlxG.height - 50
                                                 callback:[FlashFunction functionWithTarget:self
                                                                                     action:@selector(onHCExplain)]] autorelease];
        [hcButtonExplain loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButtonGrey] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressedGrey]  param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressedGrey]]; 
        [hcButtonExplain loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                              text:NSLocalizedString(@"HardCore", @"HardCore")
                                                              font:@"SmallPixel"
                                                              size:16.0] param2:[FlxText textWithWidth:backBtn.width
                                                                                                  text:NSLocalizedString(@"HardCore", @"HardCore")
                                                                                                  font:@"SmallPixel"
                                                                                                  size:16.0] withXOffset:0 withYOffset:backBtn.height/4];
        [self add:hcButtonExplain];
        
        if (a==12) {
            hcButtonExplain.visible=NO;
        }
        else {
            hcButton.visible=NO;
        }
    }
    
    
    
    ///////////////////////
    //
    ////////////////////////
    
    gridRow1x1 =40;
    gridRow1x2 =180;
    gridRow1x3 =320;
    gridRow1y = 50 ;

    gridRow2y = 100;   

    gridRow3y = 150;

    gridRow4y = 200;
    
    if (FlxG.iPad) {
        gridRow1x1 =40;
        gridRow1x2 =196;
        gridRow1x3 =352;
        
        gridRow1y = 50 ;
        
        gridRow2y = 110;   
        
        gridRow3y = 170;
        
        gridRow4y = 230;        
    }
    
    
    
    
    l1Btn = [[[FlxButton alloc]   initWithX:gridRow1x1
                                                      y:gridRow1y
                                                 callback:[FlashFunction functionWithTarget:self
                                                                                     action:@selector(onl1Btn)]] autorelease];
    [l1Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
    [l1Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                  text:NSLocalizedString(@"Level 1", @"Level 1")
                                                  font:@"SmallPixel"
                                                  size:16.0] param2:[FlxText textWithWidth:l1Btn.width
                                                                                      text:NSLocalizedString(@"LEVEL 1", @"LEVEL 1")
                                                                                      font:@"SmallPixel"
                                                                                      size:16.0] withXOffset:0 withYOffset:l1Btn.height/4];
    [self add:l1Btn];
    
    
    
    
    if (level2>=1) {
        l2Btn = [[[FlxButton alloc]   initWithX:gridRow1x2
                                                          y:gridRow1y
                                                   callback:[FlashFunction functionWithTarget:self
                                                                                       action:@selector(onl2Btn)]] autorelease];
        [l2Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l2Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                    text:NSLocalizedString(@"Level 2", @"Level 2")
                                                    font:@"SmallPixel"
                                                    size:16.0] param2:[FlxText textWithWidth:l2Btn.width
                                                                                        text:NSLocalizedString(@"LEVEL 2", @"LEVEL 2")
                                                                                        font:@"SmallPixel"
                                                                                        size:16.0] withXOffset:0 withYOffset:l2Btn.height/4];
        [self add:l2Btn];
    } else {
//        lockedGraphic2Btn = [FlxSprite spriteWithX:gridRow1x2 y:gridRow1y graphic:ImgLocked];
//        [self add:lockedGraphic2Btn];
        
        l2Btn = [[[FlxButton alloc]   initWithX:gridRow1x2
                                              y:gridRow1y
                                       callback:[FlashFunction functionWithTarget:self
                                                                           action:@selector(dontPlayLevel)]] autorelease];
        [l2Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
        [l2Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                    text:NSLocalizedString(@"", @"")
                                                    font:@"SmallPixel"
                                                    size:16.0] param2:[FlxText textWithWidth:l2Btn.width
                                                                                        text:NSLocalizedString(@"", @"")
                                                                                        font:@"SmallPixel"
                                                                                        size:16.0] withXOffset:0 withYOffset:l2Btn.height/4];
        [self add:l2Btn];
        
        
    }
    
    
    if (level3>=1) {
        l3Btn = [[[FlxButton alloc]   initWithX:gridRow1x3
                                                          y:gridRow1y
                                                   callback:[FlashFunction functionWithTarget:self
                                                                                       action:@selector(onl3Btn)]] autorelease];
        [l3Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l3Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                    text:NSLocalizedString(@"Level 3", @"Level 3")
                                                    font:@"SmallPixel"
                                                    size:16.0] param2:[FlxText textWithWidth:l3Btn.width
                                                                                        text:NSLocalizedString(@"LEVEL 3", @"LEVEL 3")
                                                                                        font:@"SmallPixel"
                                                                                        size:16.0] withXOffset:0 withYOffset:l3Btn.height/4];
        [self add:l3Btn];
    }else {
//        lockedGraphic3Btn = [FlxSprite spriteWithX:gridRow1x3 y:gridRow1y graphic:ImgLocked];
//        [self add:lockedGraphic3Btn];

        l3Btn = [[[FlxButton alloc]   initWithX:gridRow1x3
                                              y:gridRow1y
                                       callback:[FlashFunction functionWithTarget:self
                                                                           action:@selector(dontPlayLevel)]] autorelease];
        [l3Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
        [l3Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                    text:NSLocalizedString(@"", @"")
                                                    font:@"SmallPixel"
                                                    size:16.0] param2:[FlxText textWithWidth:l2Btn.width
                                                                                        text:NSLocalizedString(@"", @"")
                                                                                        font:@"SmallPixel"
                                                                                        size:16.0] withXOffset:0 withYOffset:l2Btn.height/4];
        [self add:l3Btn];
        
        
    
    }
    
    
    
    if (level4>=1) {
        l4Btn = [[[FlxButton alloc]   initWithX:gridRow1x1
                                                          y:gridRow2y
                                                   callback:[FlashFunction functionWithTarget:self
                                                                                       action:@selector(onl4Btn)]] autorelease];
        [l4Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l4Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                    text:NSLocalizedString(@"Level 4", @"Level 4")
                                                    font:@"SmallPixel"
                                                    size:16.0] param2:[FlxText textWithWidth:l4Btn.width
                                                                                        text:NSLocalizedString(@"LEVEL 4", @"LEVEL 4")
                                                                                        font:@"SmallPixel"
                                                                                        size:16.0] withXOffset:0 withYOffset:l4Btn.height/4];
        [self add:l4Btn];
    }else {
//        lockedGraphic4Btn = [FlxSprite spriteWithX:gridRow1x1 y:gridRow2y graphic:ImgLocked];
//        [self add:lockedGraphic4Btn];
        
        l4Btn = [[[FlxButton alloc]   initWithX:gridRow1x1
                                              y:gridRow2y
                                       callback:[FlashFunction functionWithTarget:self
                                                                           action:@selector(dontPlayLevel)]] autorelease];
        [l4Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
        [l4Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                    text:NSLocalizedString(@"", @"")
                                                    font:@"SmallPixel"
                                                    size:16.0] param2:[FlxText textWithWidth:l2Btn.width
                                                                                        text:NSLocalizedString(@"", @"")
                                                                                        font:@"SmallPixel"
                                                                                        size:16.0] withXOffset:0 withYOffset:l2Btn.height/4];
        [self add:l4Btn];
        
        
    }
    
    
    if (level5>=1) {
        l5Btn = [[[FlxButton alloc]   initWithX:gridRow1x2
                                                          y:gridRow2y
                                                   callback:[FlashFunction functionWithTarget:self
                                                                                       action:@selector(onl5Btn)]] autorelease];
        [l5Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l5Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                    text:NSLocalizedString(@"Level 5", @"Level 5")
                                                    font:@"SmallPixel"
                                                    size:16.0] param2:[FlxText textWithWidth:l5Btn.width
                                                                                        text:NSLocalizedString(@"LEVEL 5", @"LEVEL 5")
                                                                                        font:@"SmallPixel"
                                                                                        size:16.0] withXOffset:0 withYOffset:l5Btn.height/4];
        [self add:l5Btn];
    }else {
//        lockedGraphic5Btn = [FlxSprite spriteWithX:gridRow1x2 y:gridRow2y graphic:ImgLocked];
//        [self add:lockedGraphic5Btn];
        
        
        l5Btn = [[[FlxButton alloc]   initWithX:gridRow1x2
                                              y:gridRow2y
                                       callback:[FlashFunction functionWithTarget:self
                                                                           action:@selector(dontPlayLevel)]] autorelease];
        [l5Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
        [l5Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                    text:NSLocalizedString(@"", @"")
                                                    font:@"SmallPixel"
                                                    size:16.0] param2:[FlxText textWithWidth:l5Btn.width
                                                                                        text:NSLocalizedString(@"", @"")
                                                                                        font:@"SmallPixel"
                                                                                        size:16.0] withXOffset:0 withYOffset:l5Btn.height/4];
        [self add:l5Btn];
        
        
    }
    
    if (level6>=1) {
        l6Btn = [[[FlxButton alloc]   initWithX:gridRow1x3
                                                          y:gridRow2y
                                                   callback:[FlashFunction functionWithTarget:self
                                                                                       action:@selector(onl6Btn)]] autorelease];
        [l6Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l6Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                    text:NSLocalizedString(@"Level 6", @"Level 6")
                                                    font:@"SmallPixel"
                                                    size:16.0] param2:[FlxText textWithWidth:l6Btn.width
                                                                                        text:NSLocalizedString(@"LEVEL 6", @"LEVEL 6")
                                                                                        font:@"SmallPixel"
                                                                                        size:16.0] withXOffset:0 withYOffset:l6Btn.height/4];
        [self add:l6Btn];
    }else {
//        lockedGraphic6Btn = [FlxSprite spriteWithX:gridRow1x3 y:gridRow2y graphic:ImgLocked];
//        [self add:lockedGraphic6Btn];
        
        l6Btn = [[[FlxButton alloc]   initWithX:gridRow1x3
                                              y:gridRow2y
                                       callback:[FlashFunction functionWithTarget:self
                                                                           action:@selector(dontPlayLevel)]] autorelease];
        [l6Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
        [l6Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                    text:NSLocalizedString(@"", @"")
                                                    font:@"SmallPixel"
                                                    size:16.0] param2:[FlxText textWithWidth:l6Btn.width
                                                                                        text:NSLocalizedString(@"", @"")
                                                                                        font:@"SmallPixel"
                                                                                        size:16.0] withXOffset:0 withYOffset:l6Btn.height/4];
        [self add:l6Btn];        
        
    }
    
    
    
    if (level7>=1) {
        l7Btn = [[[FlxButton alloc]   initWithX:gridRow1x1
                                                          y:gridRow3y
                                                   callback:[FlashFunction functionWithTarget:self
                                                                                       action:@selector(onl7Btn)]] autorelease];
        [l7Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l7Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                    text:NSLocalizedString(@"Level 7", @"Level 7")
                                                    font:@"SmallPixel"
                                                    size:16.0] param2:[FlxText textWithWidth:l7Btn.width
                                                                                        text:NSLocalizedString(@"LEVEL 7", @"LEVEL 7")
                                                                                        font:@"SmallPixel"
                                                                                        size:16.0] withXOffset:0 withYOffset:l7Btn.height/4];
        [self add:l7Btn];
    }else {
//        lockedGraphic7Btn = [FlxSprite spriteWithX:gridRow1x1 y:gridRow3y graphic:ImgLocked];
//        [self add:lockedGraphic7Btn];

        l7Btn = [[[FlxButton alloc]   initWithX:gridRow1x1
                                              y:gridRow3y
                                       callback:[FlashFunction functionWithTarget:self
                                                                           action:@selector(dontPlayLevel)]] autorelease];
        [l7Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
        [l7Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                    text:NSLocalizedString(@"", @"")
                                                    font:@"SmallPixel"
                                                    size:16.0] param2:[FlxText textWithWidth:l7Btn.width
                                                                                        text:NSLocalizedString(@"", @"")
                                                                                        font:@"SmallPixel"
                                                                                        size:16.0] withXOffset:0 withYOffset:l7Btn.height/4];
        [self add:l7Btn];
        
    
    
    }
        
        
        
    if (level8>=1) {
        l8Btn = [[[FlxButton alloc]   initWithX:gridRow1x2
                                                          y:gridRow3y
                                                   callback:[FlashFunction functionWithTarget:self
                                                                                       action:@selector(onl8Btn)]] autorelease];
        [l8Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l8Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                    text:NSLocalizedString(@"Level 8", @"Level 8")
                                                    font:@"SmallPixel"
                                                    size:16.0] param2:[FlxText textWithWidth:l8Btn.width
                                                                                        text:NSLocalizedString(@"LEVEL 8", @"LEVEL 8")
                                                                                        font:@"SmallPixel"
                                                                                        size:16.0] withXOffset:0 withYOffset:l8Btn.height/4];
        [self add:l8Btn];
    }else {
//        lockedGraphic8Btn = [FlxSprite spriteWithX:gridRow1x2 y:gridRow3y graphic:ImgLocked];
//        [self add:lockedGraphic8Btn];

        l8Btn = [[[FlxButton alloc]   initWithX:gridRow1x2
                                              y:gridRow3y
                                       callback:[FlashFunction functionWithTarget:self
                                                                           action:@selector(dontPlayLevel)]] autorelease];
        [l8Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
        [l8Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                    text:NSLocalizedString(@"", @"")
                                                    font:@"SmallPixel"
                                                    size:16.0] param2:[FlxText textWithWidth:l8Btn.width
                                                                                        text:NSLocalizedString(@"", @"")
                                                                                        font:@"SmallPixel"
                                                                                        size:16.0] withXOffset:0 withYOffset:l8Btn.height/4];
        [self add:l8Btn];
        
    
    }
    
        
        
    if (level9>=1) {
        l9Btn = [[[FlxButton alloc]   initWithX:gridRow1x3
                                                          y:gridRow3y
                                                   callback:[FlashFunction functionWithTarget:self
                                                                                       action:@selector(onl9Btn)]] autorelease];
        [l9Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l9Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                    text:NSLocalizedString(@"Level 9", @"Level 9")
                                                    font:@"SmallPixel"
                                                    size:16.0] param2:[FlxText textWithWidth:l9Btn.width
                                                                                        text:NSLocalizedString(@"LEVEL 9", @"LEVEL 9")
                                                                                        font:@"SmallPixel"
                                                                                        size:16.0] withXOffset:0 withYOffset:l9Btn.height/4];
        [self add:l9Btn];
    }else {
//        lockedGraphic9Btn = [FlxSprite spriteWithX:gridRow1x3 y:gridRow3y graphic:ImgLocked];
//        [self add:lockedGraphic9Btn];
        

        l9Btn = [[[FlxButton alloc]   initWithX:gridRow1x3
                                              y:gridRow3y
                                       callback:[FlashFunction functionWithTarget:self
                                                                           action:@selector(dontPlayLevel)]] autorelease];
        [l9Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
        [l9Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                    text:NSLocalizedString(@"", @"")
                                                    font:@"SmallPixel"
                                                    size:16.0] param2:[FlxText textWithWidth:l9Btn.width
                                                                                        text:NSLocalizedString(@"", @"")
                                                                                        font:@"SmallPixel"
                                                                                        size:16.0] withXOffset:0 withYOffset:l9Btn.height/4];
        [self add:l9Btn];
        
        
    
    }
    
    
    
    
    if (level10>=1) {
        l10Btn = [[[FlxButton alloc]   initWithX:gridRow1x1
                                                           y:gridRow4y
                                                    callback:[FlashFunction functionWithTarget:self
                                                                                        action:@selector(onl10Btn)]] autorelease];
        [l10Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l10Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                     text:NSLocalizedString(@"Level 10", @"Level 10")
                                                     font:@"SmallPixel"
                                                     size:16.0] param2:[FlxText textWithWidth:l10Btn.width
                                                                                         text:NSLocalizedString(@"LEVEL 10", @"LEVEL 10")
                                                                                         font:@"SmallPixel"
                                                                                         size:16.0] withXOffset:0 withYOffset:l10Btn.height/4];
        [self add:l10Btn];
    }else {
//        lockedGraphic10Btn = [FlxSprite spriteWithX:gridRow1x1 y:gridRow4y graphic:ImgLocked];
//        [self add:lockedGraphic10Btn];

        l10Btn = [[[FlxButton alloc]   initWithX:gridRow1x1
                                               y:gridRow4y
                                        callback:[FlashFunction functionWithTarget:self
                                                                            action:@selector(dontPlayLevel)]] autorelease];
        [l10Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
        [l10Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                     text:NSLocalizedString(@"", @"")
                                                     font:@"SmallPixel"
                                                     size:16.0] param2:[FlxText textWithWidth:l10Btn.width
                                                                                         text:NSLocalizedString(@"", @"")
                                                                                         font:@"SmallPixel"
                                                                                         size:16.0] withXOffset:0 withYOffset:l10Btn.height/4];
        [self add:l10Btn];
        
    
    
    }
    
    
    if (level11>=1) {    
        l11Btn = [[[FlxButton alloc]   initWithX:gridRow1x2
                                                           y:gridRow4y
                                                    callback:[FlashFunction functionWithTarget:self
                                                                                        action:@selector(onl11Btn)]] autorelease];
        [l11Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l11Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                     text:NSLocalizedString(@"Level 11", @"Level 11")
                                                     font:@"SmallPixel"
                                                     size:16.0] param2:[FlxText textWithWidth:l11Btn.width
                                                                                         text:NSLocalizedString(@"LEVEL 11", @"LEVEL 11")
                                                                                         font:@"SmallPixel"
                                                                                         size:16.0] withXOffset:0 withYOffset:l11Btn.height/4];
        [self add:l11Btn];
    }else {
//        lockedGraphic11Btn = [FlxSprite spriteWithX:gridRow1x2 y:gridRow4y graphic:ImgLocked];
//        [self add:lockedGraphic11Btn];
        
        l11Btn = [[[FlxButton alloc]   initWithX:gridRow1x2
                                               y:gridRow4y
                                        callback:[FlashFunction functionWithTarget:self
                                                                            action:@selector(dontPlayLevel)]] autorelease];
        [l11Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
        [l11Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                     text:NSLocalizedString(@"", @"")
                                                     font:@"SmallPixel"
                                                     size:16.0] param2:[FlxText textWithWidth:l11Btn.width
                                                                                         text:NSLocalizedString(@"", @"")
                                                                                         font:@"SmallPixel"
                                                                                         size:16.0] withXOffset:0 withYOffset:l11Btn.height/4];
        [self add:l11Btn];
        
        
    }
        
        
        
    if (level12>=1) {    
        l12Btn = [[[FlxButton alloc]   initWithX:gridRow1x3
                                                           y:gridRow4y
                                                    callback:[FlashFunction functionWithTarget:self
                                                                                        action:@selector(onl12Btn)]] autorelease];
        [l12Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l12Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                     text:NSLocalizedString(@"Level 12", @"Level 12")
                                                     font:@"SmallPixel"
                                                     size:16.0] param2:[FlxText textWithWidth:l12Btn.width
                                                                                         text:NSLocalizedString(@"LEVEL 12", @"LEVEL 12")
                                                                                         font:@"SmallPixel"
                                                                                         size:16.0] withXOffset:0 withYOffset:l12Btn.height/4];
        [self add:l12Btn];
    }else {
//        lockedGraphic12Btn = [FlxSprite spriteWithX:gridRow1x3 y:gridRow4y graphic:ImgLocked];
//        [self add:lockedGraphic12Btn];

        l12Btn = [[[FlxButton alloc]   initWithX:gridRow1x3
                                               y:gridRow4y
                                        callback:[FlashFunction functionWithTarget:self
                                                                            action:@selector(dontPlayLevel)]] autorelease];
        [l12Btn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
        [l12Btn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                     text:NSLocalizedString(@"", @"")
                                                     font:@"SmallPixel"
                                                     size:16.0] param2:[FlxText textWithWidth:l12Btn.width
                                                                                         text:NSLocalizedString(@"", @"")
                                                                                         font:@"SmallPixel"
                                                                                         size:16.0] withXOffset:0 withYOffset:l12Btn.height/4];
        [self add:l12Btn];
        
        
    
    }
    
    
    
    
    
    //HC Buttons
    
    
    l1BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x1
                                            y:gridRow1y
                                     callback:[FlashFunction functionWithTarget:self
                                                                         action:@selector(onl1Btn)]] autorelease];
    [l1BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
    [l1BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                  text:NSLocalizedString(@"level 1x", @"level 1x")
                                                  font:@"SmallPixel"
                                                  size:16.0] param2:[FlxText textWithWidth:l1BtnHC.width
                                                                                      text:NSLocalizedString(@"level 1x", @"level 1x")
                                                                                      font:@"SmallPixel"
                                                                                      size:16.0] withXOffset:0 withYOffset:l1BtnHC.height/4];
    [self add:l1BtnHC];
    
    
    if (hclevel2>=1) {
        l2BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x2
                                                y:gridRow1y
                                         callback:[FlashFunction functionWithTarget:self
                                                                             action:@selector(onl2Btn)]] autorelease];
        [l2BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l2BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                      text:NSLocalizedString(@"level 2x", @"level 2x")
                                                      font:@"SmallPixel"
                                                      size:16.0] param2:[FlxText textWithWidth:l2BtnHC.width
                                                                                          text:NSLocalizedString(@"level 2x", @"level 2x")
                                                                                          font:@"SmallPixel"
                                                                                          size:16.0] withXOffset:0 withYOffset:l2BtnHC.height/4];
        [self add:l2BtnHC];
    } else {
//        lockedGraphic2BtnHC = [FlxSprite spriteWithX:gridRow1x2 y:gridRow1y graphic:ImgLocked];
//        [self add:lockedGraphic2BtnHC];
        
        l2BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x2
                                                y:gridRow1y
                                         callback:[FlashFunction functionWithTarget:self
                                                                             action:@selector(dontPlayLevel)]] autorelease];
        [l2BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
        [l2BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                      text:NSLocalizedString(@"", @"")
                                                      font:@"SmallPixel"
                                                      size:16.0] param2:[FlxText textWithWidth:l2BtnHC.width
                                                                                          text:NSLocalizedString(@"", @"")
                                                                                          font:@"SmallPixel"
                                                                                          size:16.0] withXOffset:0 withYOffset:l2BtnHC.height/4];
        [self add:l2BtnHC];
        
    }
    
    
    if (hclevel3>=1) {
        l3BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x3
                                                y:gridRow1y
                                         callback:[FlashFunction functionWithTarget:self
                                                                             action:@selector(onl3Btn)]] autorelease];
        [l3BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l3BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                      text:NSLocalizedString(@"level 3x", @"level 3x")
                                                      font:@"SmallPixel"
                                                      size:16.0] param2:[FlxText textWithWidth:l3BtnHC.width
                                                                                          text:NSLocalizedString(@"level 3x", @"level 3x")
                                                                                          font:@"SmallPixel"
                                                                                          size:16.0] withXOffset:0 withYOffset:l3BtnHC.height/4];
        [self add:l3BtnHC];
    }else {
//        lockedGraphic3BtnHC = [FlxSprite spriteWithX:gridRow1x3 y:gridRow1y graphic:ImgLocked];
//        [self add:lockedGraphic3BtnHC];
        
        l3BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x3
                                                y:gridRow1y
                                         callback:[FlashFunction functionWithTarget:self
                                                                             action:@selector(dontPlayLevel)]] autorelease];
        [l3BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
        [l3BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                      text:NSLocalizedString(@"", @"")
                                                      font:@"SmallPixel"
                                                      size:16.0] param2:[FlxText textWithWidth:l3BtnHC.width
                                                                                          text:NSLocalizedString(@"", @"")
                                                                                          font:@"SmallPixel"
                                                                                          size:16.0] withXOffset:0 withYOffset:l3BtnHC.height/4];
        [self add:l3BtnHC];
        
        
    }
    
    
    
    if (hclevel4>=1) {
        l4BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x1
                                                y:gridRow2y
                                         callback:[FlashFunction functionWithTarget:self
                                                                             action:@selector(onl4Btn)]] autorelease];
        [l4BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l4BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                      text:NSLocalizedString(@"level 4x", @"level 4x")
                                                      font:@"SmallPixel"
                                                      size:16.0] param2:[FlxText textWithWidth:l4BtnHC.width
                                                                                          text:NSLocalizedString(@"level 4x", @"level 4x")
                                                                                          font:@"SmallPixel"
                                                                                          size:16.0] withXOffset:0 withYOffset:l4BtnHC.height/4];
        [self add:l4BtnHC];
    }else {
        l4BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x1
                                                y:gridRow2y
                                         callback:[FlashFunction functionWithTarget:self
                                                                             action:@selector(dontPlayLevel)]] autorelease];
        [l4BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
//        [l4BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
//                                                      text:NSLocalizedString(@"level 4x", @"level 4x")
//                                                      font:@"SmallPixel"
//                                                      size:16.0] param2:[FlxText textWithWidth:l4BtnHC.width
//                                                                                          text:NSLocalizedString(@"level 4x", @"level 4x")
//                                                                                          font:@"SmallPixel"
//                                                                                          size:16.0] withXOffset:0 withYOffset:l4BtnHC.height/4];
        [self add:l4BtnHC];
    }
    
    
    if (hclevel5>=1) {
        l5BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x2
                                                y:gridRow2y
                                         callback:[FlashFunction functionWithTarget:self
                                                                             action:@selector(onl5Btn)]] autorelease];
        [l5BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l5BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                      text:NSLocalizedString(@"level 5x", @"level 5x")
                                                      font:@"SmallPixel"
                                                      size:16.0] param2:[FlxText textWithWidth:l5BtnHC.width
                                                                                          text:NSLocalizedString(@"level 5x", @"level 5x")
                                                                                          font:@"SmallPixel"
                                                                                          size:16.0] withXOffset:0 withYOffset:l5BtnHC.height/4];
        [self add:l5BtnHC];
    }else {
//        lockedGraphic5BtnHC = [FlxSprite spriteWithX:gridRow1x2 y:gridRow2y graphic:ImgLocked];
//        [self add:lockedGraphic5BtnHC];
        
        l5BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x2
                                                y:gridRow2y
                                         callback:[FlashFunction functionWithTarget:self
                                                                             action:@selector(onl5Btn)]] autorelease];
        [l5BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
//        [l5BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
//                                                      text:NSLocalizedString(@"level 5x", @"level 5x")
//                                                      font:@"SmallPixel"
//                                                      size:16.0] param2:[FlxText textWithWidth:l5BtnHC.width
//                                                                                          text:NSLocalizedString(@"level 5x", @"level 5x")
//                                                                                          font:@"SmallPixel"
//                                                                                          size:16.0] withXOffset:0 withYOffset:l5BtnHC.height/4];
        [self add:l5BtnHC];
        
        
    }
    
    if (hclevel6>=1) {
        l6BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x3
                                                y:gridRow2y
                                         callback:[FlashFunction functionWithTarget:self
                                                                             action:@selector(onl6Btn)]] autorelease];
        [l6BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l6BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                      text:NSLocalizedString(@"level 6x", @"level 6x")
                                                      font:@"SmallPixel"
                                                      size:16.0] param2:[FlxText textWithWidth:l6BtnHC.width
                                                                                          text:NSLocalizedString(@"level 6x", @"level 6x")
                                                                                          font:@"SmallPixel"
                                                                                          size:16.0] withXOffset:0 withYOffset:l6BtnHC.height/4];
        [self add:l6BtnHC];
    }else {
//        lockedGraphic6BtnHC = [FlxSprite spriteWithX:gridRow1x3 y:gridRow2y graphic:ImgLocked];
//        [self add:lockedGraphic6BtnHC];
        
        l6BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x3
                                                y:gridRow2y
                                         callback:[FlashFunction functionWithTarget:self
                                                                             action:@selector(dontPlayLevel)]] autorelease];
        [l6BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
//        [l6BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
//                                                      text:NSLocalizedString(@"level 6x", @"level 6x")
//                                                      font:@"SmallPixel"
//                                                      size:16.0] param2:[FlxText textWithWidth:l6BtnHC.width
//                                                                                          text:NSLocalizedString(@"level 6x", @"level 6x")
//                                                                                          font:@"SmallPixel"
//                                                                                          size:16.0] withXOffset:0 withYOffset:l6BtnHC.height/4];
        [self add:l6BtnHC];
        
        
    }
    
    
    
    if (hclevel7>=1) {
        l7BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x1
                                                y:gridRow3y
                                         callback:[FlashFunction functionWithTarget:self
                                                                             action:@selector(onl7Btn)]] autorelease];
        [l7BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l7BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                      text:NSLocalizedString(@"level 7x", @"level 7x")
                                                      font:@"SmallPixel"
                                                      size:16.0] param2:[FlxText textWithWidth:l7BtnHC.width
                                                                                          text:NSLocalizedString(@"level 7x", @"level 7x")
                                                                                          font:@"SmallPixel"
                                                                                          size:16.0] withXOffset:0 withYOffset:l7BtnHC.height/4];
        [self add:l7BtnHC];
    }else {
//        lockedGraphic7BtnHC = [FlxSprite spriteWithX:gridRow1x1 y:gridRow3y graphic:ImgLocked];
//        [self add:lockedGraphic7BtnHC];
        
        l7BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x1
                                                y:gridRow3y
                                         callback:[FlashFunction functionWithTarget:self
                                                                             action:@selector(dontPlayLevel)]] autorelease];
        [l7BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
//        [l7BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
//                                                      text:NSLocalizedString(@"level 7x", @"level 7x")
//                                                      font:@"SmallPixel"
//                                                      size:16.0] param2:[FlxText textWithWidth:l7BtnHC.width
//                                                                                          text:NSLocalizedString(@"level 7x", @"level 7x")
//                                                                                          font:@"SmallPixel"
//                                                                                          size:16.0] withXOffset:0 withYOffset:l7BtnHC.height/4];
        [self add:l7BtnHC];
        
        
    }
    
    
    
    if (hclevel8>=1) {
        l8BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x2
                                                y:gridRow3y
                                         callback:[FlashFunction functionWithTarget:self
                                                                             action:@selector(onl8Btn)]] autorelease];
        [l8BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l8BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                      text:NSLocalizedString(@"level 8x", @"level 8x")
                                                      font:@"SmallPixel"
                                                      size:16.0] param2:[FlxText textWithWidth:l8BtnHC.width
                                                                                          text:NSLocalizedString(@"level 8x", @"level 8x")
                                                                                          font:@"SmallPixel"
                                                                                          size:16.0] withXOffset:0 withYOffset:l8BtnHC.height/4];
        [self add:l8BtnHC];
    }else {
//        lockedGraphic8BtnHC = [FlxSprite spriteWithX:gridRow1x2 y:gridRow3y graphic:ImgLocked];
//        [self add:lockedGraphic8BtnHC];
        
        l8BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x2
                                                y:gridRow3y
                                         callback:[FlashFunction functionWithTarget:self
                                                                             action:@selector(dontPlayLevel)]] autorelease];
        [l8BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
//        [l8BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
//                                                      text:NSLocalizedString(@"level 8x", @"level 8x")
//                                                      font:@"SmallPixel"
//                                                      size:16.0] param2:[FlxText textWithWidth:l8BtnHC.width
//                                                                                          text:NSLocalizedString(@"level 8x", @"level 8x")
//                                                                                          font:@"SmallPixel"
//                                                                                          size:16.0] withXOffset:0 withYOffset:l8BtnHC.height/4];
        [self add:l8BtnHC];
        
        
    }
    
    
    
    if (hclevel9>=1) {
        l9BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x3
                                                y:gridRow3y
                                         callback:[FlashFunction functionWithTarget:self
                                                                             action:@selector(onl9Btn)]] autorelease];
        [l9BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l9BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                      text:NSLocalizedString(@"level 9x", @"level 9x")
                                                      font:@"SmallPixel"
                                                      size:16.0] param2:[FlxText textWithWidth:l9BtnHC.width
                                                                                          text:NSLocalizedString(@"level 9x", @"level 9x")
                                                                                          font:@"SmallPixel"
                                                                                          size:16.0] withXOffset:0 withYOffset:l9BtnHC.height/4];
        [self add:l9BtnHC];
    }else {
//        lockedGraphic9BtnHC = [FlxSprite spriteWithX:gridRow1x3 y:gridRow3y graphic:ImgLocked];
//        [self add:lockedGraphic9BtnHC];
        
        l9BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x3
                                                y:gridRow3y
                                         callback:[FlashFunction functionWithTarget:self
                                                                             action:@selector(dontPlayLevel)]] autorelease];
        [l9BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
//        [l9BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
//                                                      text:NSLocalizedString(@"level 9x", @"level 9x")
//                                                      font:@"SmallPixel"
//                                                      size:16.0] param2:[FlxText textWithWidth:l9BtnHC.width
//                                                                                          text:NSLocalizedString(@"level 9x", @"level 9x")
//                                                                                          font:@"SmallPixel"
//                                                                                          size:16.0] withXOffset:0 withYOffset:l9BtnHC.height/4];
        [self add:l9BtnHC];
        
        
    }
    
    
    
    
    if (hclevel10>=1) {
        l10BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x1
                                                 y:gridRow4y
                                          callback:[FlashFunction functionWithTarget:self
                                                                              action:@selector(onl10Btn)]] autorelease];
        [l10BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l10BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                       text:NSLocalizedString(@"level 10x", @"level 10x")
                                                       font:@"SmallPixel"
                                                       size:16.0] param2:[FlxText textWithWidth:l10BtnHC.width
                                                                                           text:NSLocalizedString(@"level 10x", @"level 10x")
                                                                                           font:@"SmallPixel"
                                                                                           size:16.0] withXOffset:0 withYOffset:l10BtnHC.height/4];
        [self add:l10BtnHC];
    }else {
//        lockedGraphic10BtnHC = [FlxSprite spriteWithX:gridRow1x1 y:gridRow4y graphic:ImgLocked];
//        [self add:lockedGraphic10BtnHC];
        
        l10BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x1
                                                 y:gridRow4y
                                          callback:[FlashFunction functionWithTarget:self
                                                                              action:@selector(dontPlayLevel)]] autorelease];
        [l10BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
//        [l10BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
//                                                       text:NSLocalizedString(@"level 10x", @"level 10x")
//                                                       font:@"SmallPixel"
//                                                       size:16.0] param2:[FlxText textWithWidth:l10BtnHC.width
//                                                                                           text:NSLocalizedString(@"level 10x", @"level 10x")
//                                                                                           font:@"SmallPixel"
//                                                                                           size:16.0] withXOffset:0 withYOffset:l10BtnHC.height/4];
        [self add:l10BtnHC];
        
        
    }
    
    
    if (hclevel11>=1) {    
        l11BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x2
                                                 y:gridRow4y
                                          callback:[FlashFunction functionWithTarget:self
                                                                              action:@selector(onl11Btn)]] autorelease];
        [l11BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l11BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                       text:NSLocalizedString(@"level 11x", @"level 11x")
                                                       font:@"SmallPixel"
                                                       size:16.0] param2:[FlxText textWithWidth:l11BtnHC.width
                                                                                           text:NSLocalizedString(@"level 11x", @"level 11x")
                                                                                           font:@"SmallPixel"
                                                                                           size:16.0] withXOffset:0 withYOffset:l11BtnHC.height/4];
        [self add:l11BtnHC];
    }else {
//        lockedGraphic11BtnHC = [FlxSprite spriteWithX:gridRow1x2 y:gridRow4y graphic:ImgLocked];
//        [self add:lockedGraphic11BtnHC];
        
        l11BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x2
                                                 y:gridRow4y
                                          callback:[FlashFunction functionWithTarget:self
                                                                              action:@selector(dontPlayLevel)]] autorelease];
        [l11BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
//        [l11BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
//                                                       text:NSLocalizedString(@"level 11x", @"level 11x")
//                                                       font:@"SmallPixel"
//                                                       size:16.0] param2:[FlxText textWithWidth:l11BtnHC.width
//                                                                                           text:NSLocalizedString(@"level 11x", @"level 11x")
//                                                                                           font:@"SmallPixel"
//                                                                                           size:16.0] withXOffset:0 withYOffset:l11BtnHC.height/4];
        [self add:l11BtnHC];
        
        
    }
    
    
    
    if (hclevel12>=1) {    
        l12BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x3
                                                 y:gridRow4y
                                          callback:[FlashFunction functionWithTarget:self
                                                                              action:@selector(onl12Btn)]] autorelease];
        [l12BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
        [l12BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                       text:NSLocalizedString(@"level 12x", @"level 12x")
                                                       font:@"SmallPixel"
                                                       size:16.0] param2:[FlxText textWithWidth:l12BtnHC.width
                                                                                           text:NSLocalizedString(@"level 12x", @"level 12x")
                                                                                           font:@"SmallPixel"
                                                                                           size:16.0] withXOffset:0 withYOffset:l12BtnHC.height/4];
        [self add:l12BtnHC];
    }else {
//        lockedGraphic12BtnHC = [FlxSprite spriteWithX:gridRow1x3 y:gridRow4y graphic:ImgLocked];
//        [self add:lockedGraphic12BtnHC];
        
        l12BtnHC = [[[FlxButton alloc]   initWithX:gridRow1x3
                                                 y:gridRow4y
                                          callback:[FlashFunction functionWithTarget:self
                                                                              action:@selector(onl12Btn)]] autorelease];
        [l12BtnHC loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgLocked] param2:[FlxSprite spriteWithGraphic:ImgLockedSelected] param3:[FlxSprite spriteWithGraphic:ImgLockedSelected]]; 
//        [l12BtnHC loadTextWithParam1:[FlxText textWithWidth:backBtn.width
//                                                       text:NSLocalizedString(@"level 12x", @"level 12x")
//                                                       font:@"SmallPixel"
//                                                       size:16.0] param2:[FlxText textWithWidth:l12BtnHC.width
//                                                                                           text:NSLocalizedString(@"level 12x", @"level 12x")
//                                                                                           font:@"SmallPixel"
//                                                                                           size:16.0] withXOffset:0 withYOffset:l12BtnHC.height/4];
        [self add:l12BtnHC];
        
        
    }
    
    
    l1BtnHC.visible = l2BtnHC.visible = l3BtnHC.visible = l4BtnHC.visible = l5BtnHC.visible = l6BtnHC.visible = l7BtnHC.visible = l8BtnHC.visible = l9BtnHC.visible = l10BtnHC.visible = l11BtnHC.visible = l12BtnHC.visible=NO;
    
    lockedGraphic2BtnHC.visible = lockedGraphic3BtnHC.visible = lockedGraphic4BtnHC.visible = lockedGraphic5BtnHC.visible = lockedGraphic6BtnHC.visible = lockedGraphic7BtnHC.visible = lockedGraphic8BtnHC.visible = lockedGraphic9BtnHC.visible = lockedGraphic10BtnHC.visible = lockedGraphic11BtnHC.visible = lockedGraphic12BtnHC.visible=NO;

    
    ///////////////////////////////////////////
    //
    ///////////////////////////////////////////
    
    
    
    [self addBottleCapBadges];
    
    [self arrangeBottleCapBadges];
    
    [self addTalkedToIcons];
    
    [self arrangeTalkedToIcons];
    
    [self arrangeTalkedToIconsHC];

//    
//    [self addHCTalkedToIcons];
    
//    NSLog(@"HCM=%d", FlxG.hardCoreMode);
    
    if (FlxG.hardCoreMode==1) {

        [self startAsHardCoreMode];
    }
    
    
    
    navArrow = [NavArrow navArrowWithOrigin:CGPointMake(0, 0)];
    [self add:navArrow]; 
    
    navArrow.currentValue=1;
    navArrow.maxValue=14;
    
    navArrow.loc1=CGPointMake(gridRow1x1-navArrow.width, gridRow1y+navArrow.height/2);
    navArrow.loc2=CGPointMake(gridRow1x2-navArrow.width, gridRow1y+navArrow.height/2);
    navArrow.loc3=CGPointMake(gridRow1x3-navArrow.width, gridRow1y+navArrow.height/2);
    
    navArrow.loc4=CGPointMake(gridRow1x1-navArrow.width, gridRow2y+navArrow.height/2);
    navArrow.loc5=CGPointMake(gridRow1x2-navArrow.width, gridRow2y+navArrow.height/2);
    navArrow.loc6=CGPointMake(gridRow1x3-navArrow.width, gridRow2y+navArrow.height/2);
    
    navArrow.loc7=CGPointMake(gridRow1x1-navArrow.width, gridRow3y+navArrow.height/2);
    navArrow.loc8=CGPointMake(gridRow1x2-navArrow.width, gridRow3y+navArrow.height/2);    
    navArrow.loc9=CGPointMake(gridRow1x3-navArrow.width, gridRow3y+navArrow.height/2);
    
    navArrow.loc10=CGPointMake(gridRow1x1-navArrow.width, gridRow4y+navArrow.height/2);
    navArrow.loc11=CGPointMake(gridRow1x2-navArrow.width, gridRow4y+navArrow.height/2);
    navArrow.loc12=CGPointMake(gridRow1x3-navArrow.width, gridRow4y+navArrow.height/2); 
    
    navArrow.loc13=CGPointMake(backBtn.x-navArrow.width, backBtn.y+navArrow.height/2);
    navArrow.loc14=CGPointMake(320-navArrow.width, FlxG.height - 50+navArrow.height/2);    
    
    
    if (FlxG.gamePad==0) {
    } 
    else {
        l1Btn._selected=YES;
    }
    
    
    
    
}

- (void) addBottleCapBadges
{
    star1 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:ImgStar];
    star1.scale=CGPointMake(0, 0);
    [self add:star1];
    
    star2 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:ImgStar];
    star2.scale=CGPointMake(0, 0);
    [self add:star2];
    
    star3 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:ImgStar];
    star3.scale=CGPointMake(0, 0);
    [self add:star3];
    
    star4 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:ImgStar];
    star4.scale=CGPointMake(0, 0);
    [self add:star4];  
    
    star5 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:ImgStar];
    star5.scale=CGPointMake(0, 0);
    [self add:star5];
    
    star6 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:ImgStar];
    star6.scale=CGPointMake(0, 0);
    [self add:star6];
    
    star7 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:ImgStar];
    star7.scale=CGPointMake(0, 0);
    [self add:star7];
    
    star8 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:ImgStar];
    star8.scale=CGPointMake(0, 0);
    [self add:star8];
    
    star9 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:ImgStar];
    star9.scale=CGPointMake(0, 0);
    [self add:star9];   
    
    star10 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:ImgStar];
    star10.scale=CGPointMake(0, 0);
    [self add:star10];
    
    star11 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:ImgStar];
    star11.scale=CGPointMake(0, 0);
    [self add:star11];
    
    star12 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:ImgStar];
    star12.scale=CGPointMake(0, 0);
    [self add:star12];
    
    
    starhc1 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:Imgstarhc];
    starhc1.scale=CGPointMake(0, 0);
    [self add:starhc1];
    
    starhc2 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:Imgstarhc];
    starhc2.scale=CGPointMake(0, 0);
    [self add:starhc2];
    
    starhc3 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:Imgstarhc];
    starhc3.scale=CGPointMake(0, 0);
    [self add:starhc3];
    
    starhc4 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:Imgstarhc];
    starhc4.scale=CGPointMake(0, 0);
    [self add:starhc4];  
    
    starhc5 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:Imgstarhc];
    starhc5.scale=CGPointMake(0, 0);
    [self add:starhc5];
    
    starhc6 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:Imgstarhc];
    starhc6.scale=CGPointMake(0, 0);
    [self add:starhc6];
    
    starhc7 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:Imgstarhc];
    starhc7.scale=CGPointMake(0, 0);
    [self add:starhc7];
    
    starhc8 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:Imgstarhc];
    starhc8.scale=CGPointMake(0, 0);
    [self add:starhc8];
    
    starhc9 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:Imgstarhc];
    starhc9.scale=CGPointMake(0, 0);
    [self add:starhc9];   
    
    starhc10 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:Imgstarhc];
    starhc10.scale=CGPointMake(0, 0);
    [self add:starhc10];
    
    starhc11 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:Imgstarhc];
    starhc11.scale=CGPointMake(0, 0);
    [self add:starhc11];
    
    starhc12 = [Badge badgeWithOrigin:CGPointMake(-100,-100) withImage:Imgstarhc];
    starhc12.scale=CGPointMake(0, 0);
    [self add:starhc12];
    
    
}

- (void) arrangeBottleCapBadges
{
    int i;
    int space = 16;
    int ox= 92;
    int oy = -12;
    
    
    //level1
    if (level1>=2) {
        star1.x = gridRow1x1+ox;
        star1.y = gridRow1y+oy;
        star1.scale=CGPointMake(0, 0);
    }
    if (hclevel1>=2) {
        starhc1.x = gridRow1x1+ox;
        starhc1.y = gridRow1y+oy;
        starhc1.scale=CGPointMake(0, 0);        
        starhc1.visible=NO;
    }  
    
    
    if (level2>=2) {
        star2.x = gridRow1x2+ox;
        star2.y = gridRow1y+oy;
        star2.scale=CGPointMake(0, 0);
    }
    if (hclevel2>=2) {
        starhc2.x = gridRow1x2+ox;
        starhc2.y = gridRow1y+oy;
        starhc2.scale=CGPointMake(0, 0);        
        starhc2.visible=NO;
    }
    
    if (level3>=2) {
        star3.x = gridRow1x3+ox;
        star3.y = gridRow1y+oy;
        star3.scale=CGPointMake(0, 0);
    }
    if (hclevel3>=2) {
        starhc3.x = gridRow1x3+ox;
        starhc3.y = gridRow1y+oy;
        starhc3.scale=CGPointMake(0, 0);        
        starhc3.visible=NO;
    }
    
    
    //row 2
    if (level4>=2) {
        star4.x = gridRow1x1+ox;
        star4.y = gridRow2y+oy;
        star4.scale=CGPointMake(0, 0);
    }
    if (hclevel4>=2) {
        starhc4.x = gridRow1x1+ox;
        starhc4.y = gridRow2y+oy;
        starhc4.scale=CGPointMake(0, 0);        
        starhc4.visible=NO;
    }  
    
    
    if (level5>=2) {
        star5.x = gridRow1x2+ox;
        star5.y = gridRow2y+oy;
        star5.scale=CGPointMake(0, 0);
    }
    if (hclevel5>=2) {
        starhc5.x = gridRow1x2+ox;
        starhc5.y = gridRow2y+oy;
        starhc5.scale=CGPointMake(0, 0);        
        starhc5.visible=NO;
    }
    
    if (level6>=2) {
        star6.x = gridRow1x3+ox;
        star6.y = gridRow2y+oy;
        star6.scale=CGPointMake(0, 0);
    }
    if (hclevel6>=2) {
        starhc6.x = gridRow1x3+ox;
        starhc6.y = gridRow2y+oy;
        starhc6.scale=CGPointMake(0, 0);        
        starhc6.visible=NO;
    }
    
    
    // row 3
    if (level7>=2) {
        star7.x = gridRow1x1+ox;
        star7.y = gridRow3y+oy;
        star7.scale=CGPointMake(0, 0);
    }
    if (hclevel7>=2) {
        starhc7.x = gridRow1x1+ox;
        starhc7.y = gridRow3y+oy;
        starhc7.scale=CGPointMake(0, 0);        
        starhc7.visible=NO;
    }  
    
    
    if (level8>=2) {
        star8.x = gridRow1x2+ox;
        star8.y = gridRow3y+oy;
        star8.scale=CGPointMake(0, 0);
    }
    if (hclevel8>=2) {
        starhc8.x = gridRow1x2+ox;
        starhc8.y = gridRow3y+oy;
        starhc8.scale=CGPointMake(0, 0);        
        starhc8.visible=NO;
    }
    
    if (level9>=2) {
        star9.x = gridRow1x3+ox;
        star9.y = gridRow3y+oy;
        star9.scale=CGPointMake(0, 0);
    }
    if (hclevel9>=2) {
        starhc9.x = gridRow1x3+ox;
        starhc9.y = gridRow3y+oy;
        starhc9.scale=CGPointMake(0, 0);        
        starhc9.visible=NO;
    }
    
    
    //row 2
    if (level10>=2) {
        star10.x = gridRow1x1+ox;
        star10.y = gridRow4y+oy;
        star10.scale=CGPointMake(0, 0);
    }
    if (hclevel10>=2) {
        starhc10.x = gridRow1x1+ox;
        starhc10.y = gridRow4y+oy;
        starhc10.scale=CGPointMake(0, 0);        
        starhc10.visible=NO;
    }  
    
    
    if (level11>=2) {
        star11.x = gridRow1x2+ox;
        star11.y = gridRow4y+oy;
        star11.scale=CGPointMake(0, 0);
    }
    if (hclevel11>=2) {
        starhc11.x = gridRow1x2+ox;
        starhc11.y = gridRow4y+oy;
        starhc11.scale=CGPointMake(0, 0);        
        starhc11.visible=NO;
    }
    
    if (level12>=2) {
        star12.x = gridRow1x3+ox;
        star12.y = gridRow4y+oy;
        star12.scale=CGPointMake(0, 0);
    }
    if (hclevel12>=2) {
        starhc12.x = gridRow1x3+ox;
        starhc12.y = gridRow4y+oy;
        starhc12.scale=CGPointMake(0, 0);        
        starhc12.visible=NO;
    }
    
    
    
}


- (void) addTalkedToIcons
{
    talkedToPlain1 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlain]; 
    talkedToPlain2 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlain]; 
    talkedToPlain3 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlain]; 
    talkedToPlain4 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlain]; 
    talkedToPlain5 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlain]; 
    talkedToPlain6 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlain]; 
    talkedToPlain7 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlain]; 
    talkedToPlain8 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlain]; 
    talkedToPlain9 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlain]; 
    talkedToPlain10 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlain]; 
    talkedToPlain11 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlain]; 
    talkedToPlain12 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlain]; 

    [self add:talkedToPlain1];
    [self add:talkedToPlain2];
    [self add:talkedToPlain3];
    [self add:talkedToPlain4];
    [self add:talkedToPlain5];
    [self add:talkedToPlain6];
    [self add:talkedToPlain7];
    [self add:talkedToPlain8];
    [self add:talkedToPlain9];
    [self add:talkedToPlain10];
    [self add:talkedToPlain11];
    [self add:talkedToPlain12];
    
    talkedToAndre1 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndre];
    talkedToAndre2 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndre]; 
    talkedToAndre3 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndre]; 
    talkedToAndre4 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndre]; 
    talkedToAndre5 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndre]; 
    talkedToAndre6 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndre]; 
    talkedToAndre7 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndre]; 
    talkedToAndre8 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndre]; 
    talkedToAndre9 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndre]; 
    talkedToAndre10 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndre]; 
    talkedToAndre11 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndre]; 
    talkedToAndre12 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndre]; 

    [self add:talkedToAndre1];
    [self add:talkedToAndre2];
    [self add:talkedToAndre3];
    [self add:talkedToAndre4];
    [self add:talkedToAndre5];
    [self add:talkedToAndre6];
    [self add:talkedToAndre7];
    [self add:talkedToAndre8];
    [self add:talkedToAndre9];
    [self add:talkedToAndre10];
    [self add:talkedToAndre11];
    [self add:talkedToAndre12];
    
    talkedToPlainHC1 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlainHC]; 
    talkedToPlainHC2 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlainHC]; 
    talkedToPlainHC3 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlainHC]; 
    talkedToPlainHC4 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlainHC]; 
    talkedToPlainHC5 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlainHC]; 
    talkedToPlainHC6 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlainHC]; 
    talkedToPlainHC7 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlainHC]; 
    talkedToPlainHC8 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlainHC]; 
    talkedToPlainHC9 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlainHC]; 
    talkedToPlainHC10 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlainHC]; 
    talkedToPlainHC11 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlainHC]; 
    talkedToPlainHC12 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100,-100) withImage:ImgTalkedToPlainHC]; 
    
    [self add:talkedToPlainHC1];
    [self add:talkedToPlainHC2];
    [self add:talkedToPlainHC3];
    [self add:talkedToPlainHC4];
    [self add:talkedToPlainHC5];
    [self add:talkedToPlainHC6];
    [self add:talkedToPlainHC7];
    [self add:talkedToPlainHC8];
    [self add:talkedToPlainHC9];
    [self add:talkedToPlainHC10];
    [self add:talkedToPlainHC11];
    [self add:talkedToPlainHC12];
    
    talkedToAndreHC1 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndreHC];
    talkedToAndreHC2 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndreHC]; 
    talkedToAndreHC3 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndreHC]; 
    talkedToAndreHC4 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndreHC]; 
    talkedToAndreHC5 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndreHC]; 
    talkedToAndreHC6 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndreHC]; 
    talkedToAndreHC7 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndreHC]; 
    talkedToAndreHC8 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndreHC]; 
    talkedToAndreHC9 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndreHC]; 
    talkedToAndreHC10 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndreHC]; 
    talkedToAndreHC11 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndreHC]; 
    talkedToAndreHC12 = [TalkBadge talkBadgeWithOrigin:CGPointMake(-100, -100) withImage:ImgTalkedToAndreHC]; 
    
    [self add:talkedToAndreHC1];
    [self add:talkedToAndreHC2];
    [self add:talkedToAndreHC3];
    [self add:talkedToAndreHC4];
    [self add:talkedToAndreHC5];
    [self add:talkedToAndreHC6];
    [self add:talkedToAndreHC7];
    [self add:talkedToAndreHC8];
    [self add:talkedToAndreHC9];
    [self add:talkedToAndreHC10];
    [self add:talkedToAndreHC11];
    [self add:talkedToAndreHC12];
    


}

- (void) arrangeTalkedToIconsHC
{
    
    NSInteger ARMYHC1 ;
    NSInteger ARMYHC2 ;
    NSInteger ARMYHC3 ;
    NSInteger ARMYHC4 ;
    NSInteger ARMYHC5 ;
    NSInteger ARMYHC6 ;
    NSInteger ARMYHC7 ;
    NSInteger ARMYHC8 ;
    NSInteger ARMYHC9 ;
    NSInteger ARMYHC10 ;
    NSInteger ARMYHC11 ;
    NSInteger ARMYHC12; 
    
    NSInteger CHEFHC1 ;
    NSInteger CHEFHC2 ;
    NSInteger CHEFHC3 ;
    NSInteger CHEFHC4 ;
    NSInteger CHEFHC5 ;
    NSInteger CHEFHC6 ;
    NSInteger CHEFHC7;
    NSInteger CHEFHC8 ;
    NSInteger CHEFHC9 ;
    NSInteger CHEFHC10 ;
    NSInteger CHEFHC11 ;
    NSInteger CHEFHC12 ; 
    
    NSInteger INSPECTORHC1 ;
    NSInteger INSPECTORHC2 ;
    NSInteger INSPECTORHC3 ;
    NSInteger INSPECTORHC4;
    NSInteger INSPECTORHC5 ;
    NSInteger INSPECTORHC6 ;
    NSInteger INSPECTORHC7 ;
    NSInteger INSPECTORHC8 ;
    NSInteger INSPECTORHC9 ;
    NSInteger INSPECTORHC10 ;
    NSInteger INSPECTORHC11 ;
    NSInteger INSPECTORHC12 ; 
    
    NSInteger WORKERHC1 ;
    NSInteger WORKERHC2 ;
    NSInteger WORKERHC3 ;
    NSInteger WORKERHC4 ;
    NSInteger WORKERHC5 ; 
    NSInteger WORKERHC6 ; 
    NSInteger WORKERHC7 ; 
    NSInteger WORKERHC8 ; 
    NSInteger WORKERHC9 ; 
    NSInteger WORKERHC10 ; 
    NSInteger WORKERHC11 ;
    NSInteger WORKERHC12 ;
    
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //    NSLog(@"the level is %d", FlxG.level);
    
    if (FlxG.level>=1 && FlxG.level <= 12) {
        ARMYHC1 = [prefs integerForKey:@"TALKED_TO_ARMYHC1"];
        ARMYHC2 = [prefs integerForKey:@"TALKED_TO_ARMYHC2"];
        ARMYHC3 = [prefs integerForKey:@"TALKED_TO_ARMYHC3"];
        ARMYHC4 = [prefs integerForKey:@"TALKED_TO_ARMYHC4"];
        ARMYHC5 = [prefs integerForKey:@"TALKED_TO_ARMYHC5"];
        ARMYHC6 = [prefs integerForKey:@"TALKED_TO_ARMYHC6"];
        ARMYHC7 = [prefs integerForKey:@"TALKED_TO_ARMYHC7"];
        ARMYHC8 = [prefs integerForKey:@"TALKED_TO_ARMYHC8"];
        ARMYHC9 = [prefs integerForKey:@"TALKED_TO_ARMYHC9"];
        ARMYHC10 = [prefs integerForKey:@"TALKED_TO_ARMYHC10"];
        ARMYHC11 = [prefs integerForKey:@"TALKED_TO_ARMYHC11"];
        ARMYHC12 = [prefs integerForKey:@"TALKED_TO_ARMYHC12"]; 
        
        CHEFHC1 = [prefs integerForKey:@"TALKED_TO_CHEFHC1"];
        CHEFHC2 = [prefs integerForKey:@"TALKED_TO_CHEFHC2"];
        CHEFHC3 = [prefs integerForKey:@"TALKED_TO_CHEFHC3"];
        CHEFHC4 = [prefs integerForKey:@"TALKED_TO_CHEFHC4"];
        CHEFHC5 = [prefs integerForKey:@"TALKED_TO_CHEFHC5"];
        CHEFHC6 = [prefs integerForKey:@"TALKED_TO_CHEFHC6"];
        CHEFHC7 = [prefs integerForKey:@"TALKED_TO_CHEFHC7"];
        CHEFHC8 = [prefs integerForKey:@"TALKED_TO_CHEFHC8"];
        CHEFHC9 = [prefs integerForKey:@"TALKED_TO_CHEFHC9"];
        CHEFHC10 = [prefs integerForKey:@"TALKED_TO_CHEFHC10"];
        CHEFHC11 = [prefs integerForKey:@"TALKED_TO_CHEFHC11"];
        CHEFHC12 = [prefs integerForKey:@"TALKED_TO_CHEFHC12"]; 
        
        INSPECTORHC1 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC1"];
        INSPECTORHC2 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC2"];
        INSPECTORHC3 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC3"];
        INSPECTORHC4 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC4"];
        INSPECTORHC5 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC5"];
        INSPECTORHC6 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC6"];
        INSPECTORHC7 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC7"];
        INSPECTORHC8 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC8"];
        INSPECTORHC9 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC9"];
        INSPECTORHC10 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC10"];
        INSPECTORHC11 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC11"];
        INSPECTORHC12 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC12"]; 
        
        WORKERHC1 = [prefs integerForKey:@"TALKED_TO_WORKERHC1"];
        WORKERHC2 = [prefs integerForKey:@"TALKED_TO_WORKERHC2"];
        WORKERHC3 = [prefs integerForKey:@"TALKED_TO_WORKERHC3"];
        WORKERHC4 = [prefs integerForKey:@"TALKED_TO_WORKERHC4"];
        WORKERHC5 = [prefs integerForKey:@"TALKED_TO_WORKERHC5"];
        WORKERHC6 = [prefs integerForKey:@"TALKED_TO_WORKERHC6"];
        WORKERHC7 = [prefs integerForKey:@"TALKED_TO_WORKERHC7"];
        WORKERHC8 = [prefs integerForKey:@"TALKED_TO_WORKERHC8"];
        WORKERHC9 = [prefs integerForKey:@"TALKED_TO_WORKERHC9"];
        WORKERHC10 = [prefs integerForKey:@"TALKED_TO_WORKERHC10"];
        WORKERHC11 = [prefs integerForKey:@"TALKED_TO_WORKERHC11"];
        WORKERHC12 = [prefs integerForKey:@"TALKED_TO_WORKERHC12"]; 
        
    }
    else if (FlxG.level>=13 && FlxG.level <= 24) {
        
        ARMYHC1 = [prefs integerForKey:@"TALKED_TO_ARMYHC13"];
        ARMYHC2 = [prefs integerForKey:@"TALKED_TO_ARMYHC14"];
        ARMYHC3 = [prefs integerForKey:@"TALKED_TO_ARMYHC15"];
        ARMYHC4 = [prefs integerForKey:@"TALKED_TO_ARMYHC16"];
        ARMYHC5 = [prefs integerForKey:@"TALKED_TO_ARMYHC17"];
        ARMYHC6 = [prefs integerForKey:@"TALKED_TO_ARMYHC18"];
        ARMYHC7 = [prefs integerForKey:@"TALKED_TO_ARMYHC19"];
        ARMYHC8 = [prefs integerForKey:@"TALKED_TO_ARMYHC20"];
        ARMYHC9 = [prefs integerForKey:@"TALKED_TO_ARMYHC21"];
        ARMYHC10 = [prefs integerForKey:@"TALKED_TO_ARMYHC22"];    
        ARMYHC11 = [prefs integerForKey:@"TALKED_TO_ARMYHC23"];
        ARMYHC12 = [prefs integerForKey:@"TALKED_TO_ARMYHC24"];
        
        CHEFHC1 = [prefs integerForKey:@"TALKED_TO_CHEFHC13"];
        CHEFHC2 = [prefs integerForKey:@"TALKED_TO_CHEFHC14"];
        CHEFHC3 = [prefs integerForKey:@"TALKED_TO_CHEFHC15"];
        CHEFHC4 = [prefs integerForKey:@"TALKED_TO_CHEFHC16"];
        CHEFHC5 = [prefs integerForKey:@"TALKED_TO_CHEFHC17"];
        CHEFHC6 = [prefs integerForKey:@"TALKED_TO_CHEFHC18"];
        CHEFHC7 = [prefs integerForKey:@"TALKED_TO_CHEFHC19"];
        CHEFHC8 = [prefs integerForKey:@"TALKED_TO_CHEFHC20"];
        CHEFHC9 = [prefs integerForKey:@"TALKED_TO_CHEFHC21"];
        CHEFHC10 = [prefs integerForKey:@"TALKED_TO_CHEFHC22"];    
        CHEFHC11 = [prefs integerForKey:@"TALKED_TO_CHEFHC23"];
        CHEFHC12 = [prefs integerForKey:@"TALKED_TO_CHEFHC24"];
        
        INSPECTORHC1 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC13"];
        INSPECTORHC2 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC14"];
        INSPECTORHC3 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC15"];
        INSPECTORHC4 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC16"];
        INSPECTORHC5 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC17"];
        INSPECTORHC6 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC18"];
        INSPECTORHC7 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC19"];
        INSPECTORHC8 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC20"];
        INSPECTORHC9 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC21"];
        INSPECTORHC10 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC22"];    
        INSPECTORHC11 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC23"];
        INSPECTORHC12 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC24"];
        
        WORKERHC1 = [prefs integerForKey:@"TALKED_TO_WORKERHC13"];
        WORKERHC2 = [prefs integerForKey:@"TALKED_TO_WORKERHC14"];
        WORKERHC3 = [prefs integerForKey:@"TALKED_TO_WORKERHC15"];
        WORKERHC4 = [prefs integerForKey:@"TALKED_TO_WORKERHC16"];
        WORKERHC5 = [prefs integerForKey:@"TALKED_TO_WORKERHC17"];
        WORKERHC6 = [prefs integerForKey:@"TALKED_TO_WORKERHC18"];
        WORKERHC7 = [prefs integerForKey:@"TALKED_TO_WORKERHC19"];
        WORKERHC8 = [prefs integerForKey:@"TALKED_TO_WORKERHC20"];
        WORKERHC9 = [prefs integerForKey:@"TALKED_TO_WORKERHC21"];
        WORKERHC10 = [prefs integerForKey:@"TALKED_TO_WORKERHC22"];    
        WORKERHC11 = [prefs integerForKey:@"TALKED_TO_WORKERHC23"];
        WORKERHC12 = [prefs integerForKey:@"TALKED_TO_WORKERHC24"];
        
    }
    
    else if (FlxG.level>=25 && FlxG.level <= 36) {
        
        ARMYHC1 = [prefs integerForKey:@"TALKED_TO_ARMYHC25"];
        ARMYHC2 = [prefs integerForKey:@"TALKED_TO_ARMYHC26"];
        ARMYHC3 = [prefs integerForKey:@"TALKED_TO_ARMYHC27"];
        ARMYHC4 = [prefs integerForKey:@"TALKED_TO_ARMYHC28"];
        ARMYHC5 = [prefs integerForKey:@"TALKED_TO_ARMYHC29"];
        ARMYHC6 = [prefs integerForKey:@"TALKED_TO_ARMYHC30"];
        ARMYHC7 = [prefs integerForKey:@"TALKED_TO_ARMYHC31"];
        ARMYHC8 = [prefs integerForKey:@"TALKED_TO_ARMYHC32"];
        ARMYHC9 = [prefs integerForKey:@"TALKED_TO_ARMYHC33"];
        ARMYHC10 = [prefs integerForKey:@"TALKED_TO_ARMYHC34"];
        ARMYHC11 = [prefs integerForKey:@"TALKED_TO_ARMYHC35"];
        ARMYHC12 = [prefs integerForKey:@"TALKED_TO_ARMYHC36"];
        
        CHEFHC1 = [prefs integerForKey:@"TALKED_TO_CHEFHC25"];
        CHEFHC2 = [prefs integerForKey:@"TALKED_TO_CHEFHC26"];
        CHEFHC3 = [prefs integerForKey:@"TALKED_TO_CHEFHC27"];
        CHEFHC4 = [prefs integerForKey:@"TALKED_TO_CHEFHC28"];
        CHEFHC5 = [prefs integerForKey:@"TALKED_TO_CHEFHC29"];
        CHEFHC6 = [prefs integerForKey:@"TALKED_TO_CHEFHC30"];
        CHEFHC7 = [prefs integerForKey:@"TALKED_TO_CHEFHC31"];
        CHEFHC8 = [prefs integerForKey:@"TALKED_TO_CHEFHC32"];
        CHEFHC9 = [prefs integerForKey:@"TALKED_TO_CHEFHC33"];
        CHEFHC10 = [prefs integerForKey:@"TALKED_TO_CHEFHC34"];
        CHEFHC11 = [prefs integerForKey:@"TALKED_TO_CHEFHC35"];
        CHEFHC12 = [prefs integerForKey:@"TALKED_TO_CHEFHC36"];
        
        INSPECTORHC1 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC25"];
        INSPECTORHC2 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC26"];
        INSPECTORHC3 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC27"];
        INSPECTORHC4 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC28"];
        INSPECTORHC5 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC29"];
        INSPECTORHC6 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC30"];
        INSPECTORHC7 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC31"];
        INSPECTORHC8 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC32"];
        INSPECTORHC9 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC33"];
        INSPECTORHC10 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC34"];
        INSPECTORHC11 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC35"];
        INSPECTORHC12 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC36"];
        
        WORKERHC1 = [prefs integerForKey:@"TALKED_TO_WORKERHC25"];
        WORKERHC2 = [prefs integerForKey:@"TALKED_TO_WORKERHC26"];
        WORKERHC3 = [prefs integerForKey:@"TALKED_TO_WORKERHC27"];
        WORKERHC4 = [prefs integerForKey:@"TALKED_TO_WORKERHC28"];
        WORKERHC5 = [prefs integerForKey:@"TALKED_TO_WORKERHC29"];
        WORKERHC6 = [prefs integerForKey:@"TALKED_TO_WORKERHC30"];
        WORKERHC7 = [prefs integerForKey:@"TALKED_TO_WORKERHC31"];
        WORKERHC8 = [prefs integerForKey:@"TALKED_TO_WORKERHC32"];
        WORKERHC9 = [prefs integerForKey:@"TALKED_TO_WORKERHC33"];
        WORKERHC10 = [prefs integerForKey:@"TALKED_TO_WORKERHC34"];
        WORKERHC11 = [prefs integerForKey:@"TALKED_TO_WORKERHC35"];
        WORKERHC12 = [prefs integerForKey:@"TALKED_TO_WORKERHC36"];
        
    }
    
    int i;
    int space = 16;
    int ox= 72;
    int oy = -12;
    
    //    NSLog(@"%d%d%d%d", ARMYHC1, CHEFHC1, INSPECTORHC1, WORKERHC1);
    
    if (ARMYHC1>=1 || CHEFHC1>=1 || INSPECTORHC1>=1 || WORKERHC1>=1) {
        talkedToPlainHC1.x=gridRow1x1+ox;
        talkedToPlainHC1.y=gridRow1y+oy;
    }    
    if (ARMYHC2>=1 || CHEFHC2>=1 || INSPECTORHC2>=1 || WORKERHC2>=1) {
        talkedToPlainHC2.x=gridRow1x2+ox;
        talkedToPlainHC2.y=gridRow1y+oy;
    }  
    if (ARMYHC3>=1 || CHEFHC3>=1 || INSPECTORHC3>=1 || WORKERHC3>=1) {
        talkedToPlainHC3.x=gridRow1x3+ox;
        talkedToPlainHC3.y=gridRow1y+oy;
    } 
    if (ARMYHC4>=1 || CHEFHC4>=1 || INSPECTORHC4>=1 || WORKERHC4>=1) {
        talkedToPlainHC4.x=gridRow1x1+ox;
        talkedToPlainHC4.y=gridRow2y+oy;
    }   
    if (ARMYHC5>=1 || CHEFHC5>=1 || INSPECTORHC5>=1 || WORKERHC5>=1) {
        talkedToPlainHC5.x=gridRow1x2+ox;
        talkedToPlainHC5.y=gridRow2y+oy;
    }    
    if (ARMYHC6>=1 || CHEFHC6>=1 || INSPECTORHC6>=1 || WORKERHC6>=1) {
        talkedToPlainHC6.x=gridRow1x3+ox;
        talkedToPlainHC6.y=gridRow2y+oy;
    }
    if (ARMYHC7>=1 || CHEFHC7>=1 || INSPECTORHC7>=1 || WORKERHC7>=1) {
        talkedToPlainHC7.x=gridRow1x1+ox;
        talkedToPlainHC7.y=gridRow3y+oy;
    }
    if (ARMYHC8>=1 || CHEFHC8>=1 || INSPECTORHC8>=1 || WORKERHC8>=1) {
        talkedToPlainHC8.x=gridRow1x2+ox;
        talkedToPlainHC8.y=gridRow3y+oy;
    }
    if (ARMYHC9>=1 || CHEFHC9>=1 || INSPECTORHC9>=1 || WORKERHC9>=1) {
        talkedToPlainHC9.x=gridRow1x3+ox;
        talkedToPlainHC9.y=gridRow3y+oy;
    }
    if (ARMYHC10>=1 || CHEFHC10>=1 || INSPECTORHC10>=1 || WORKERHC10>=1) {
        talkedToPlainHC10.x=gridRow1x1+ox;
        talkedToPlainHC10.y=gridRow4y+oy;
    }   
    if (ARMYHC11>=1 || CHEFHC11>=1 || INSPECTORHC11>=1 || WORKERHC11>=1) {
        talkedToPlainHC11.x=gridRow1x2+ox;
        talkedToPlainHC11.y=gridRow4y+oy;
    }
    if (ARMYHC12>=1 || CHEFHC12>=1 || INSPECTORHC12>=1 || WORKERHC12>=1) {
        talkedToPlainHC12.x=gridRow1x3+ox;
        talkedToPlainHC12.y=gridRow4y+oy;
    }
    
    
    
    
    
    //
    
    NSInteger ANDREHC1 ;
    NSInteger ANDREHC2 ;
    NSInteger ANDREHC3 ;
    NSInteger ANDREHC4 ;
    NSInteger ANDREHC5 ;
    NSInteger ANDREHC6 ;
    NSInteger ANDREHC7 ;
    NSInteger ANDREHC8 ;
    NSInteger ANDREHC9 ;
    NSInteger ANDREHC10 ;
    NSInteger ANDREHC11 ;
    NSInteger ANDREHC12; 
    
    if (FlxG.level>=1 && FlxG.level <= 12) {
        ANDREHC1 = [prefs integerForKey:@"TALKED_TO_ANDREHC1"];
        ANDREHC2 = [prefs integerForKey:@"TALKED_TO_ANDREHC2"];
        ANDREHC3 = [prefs integerForKey:@"TALKED_TO_ANDREHC3"];
        ANDREHC4 = [prefs integerForKey:@"TALKED_TO_ANDREHC4"];
        ANDREHC5 = [prefs integerForKey:@"TALKED_TO_ANDREHC5"];
        ANDREHC6 = [prefs integerForKey:@"TALKED_TO_ANDREHC6"];
        ANDREHC7 = [prefs integerForKey:@"TALKED_TO_ANDREHC7"];
        ANDREHC8 = [prefs integerForKey:@"TALKED_TO_ANDREHC8"];
        ANDREHC9 = [prefs integerForKey:@"TALKED_TO_ANDREHC9"];
        ANDREHC10 = [prefs integerForKey:@"TALKED_TO_ANDREHC10"];
        ANDREHC11 = [prefs integerForKey:@"TALKED_TO_ANDREHC11"];
        ANDREHC12 = [prefs integerForKey:@"TALKED_TO_ANDREHC12"]; 
        
        
    }
    if (FlxG.level>=13 && FlxG.level <= 24) {
        
        ANDREHC1 = [prefs integerForKey:@"TALKED_TO_ANDREHC13"];
        ANDREHC2 = [prefs integerForKey:@"TALKED_TO_ANDREHC14"];
        ANDREHC3 = [prefs integerForKey:@"TALKED_TO_ANDREHC15"];
        ANDREHC4 = [prefs integerForKey:@"TALKED_TO_ANDREHC16"];
        ANDREHC5 = [prefs integerForKey:@"TALKED_TO_ANDREHC17"];
        ANDREHC6 = [prefs integerForKey:@"TALKED_TO_ANDREHC18"];
        ANDREHC7 = [prefs integerForKey:@"TALKED_TO_ANDREHC19"];
        ANDREHC8 = [prefs integerForKey:@"TALKED_TO_ANDREHC20"];
        ANDREHC9 = [prefs integerForKey:@"TALKED_TO_ANDREHC21"];
        ANDREHC10 = [prefs integerForKey:@"TALKED_TO_ANDREHC22"];    
        ANDREHC11 = [prefs integerForKey:@"TALKED_TO_ANDREHC23"];
        ANDREHC12 = [prefs integerForKey:@"TALKED_TO_ANDREHC24"];
        
        
    }
    
    if (FlxG.level>=25 && FlxG.level <= 36) {
        
        ANDREHC1 = [prefs integerForKey:@"TALKED_TO_ANDREHC25"];
        ANDREHC2 = [prefs integerForKey:@"TALKED_TO_ANDREHC26"];
        ANDREHC3 = [prefs integerForKey:@"TALKED_TO_ANDREHC27"];
        ANDREHC4 = [prefs integerForKey:@"TALKED_TO_ANDREHC28"];
        ANDREHC5 = [prefs integerForKey:@"TALKED_TO_ANDREHC29"];
        ANDREHC6 = [prefs integerForKey:@"TALKED_TO_ANDREHC30"];
        ANDREHC7 = [prefs integerForKey:@"TALKED_TO_ANDREHC31"];
        ANDREHC8 = [prefs integerForKey:@"TALKED_TO_ANDREHC32"];
        ANDREHC9 = [prefs integerForKey:@"TALKED_TO_ANDREHC33"];
        ANDREHC10 = [prefs integerForKey:@"TALKED_TO_ANDREHC34"];
        ANDREHC11 = [prefs integerForKey:@"TALKED_TO_ANDREHC35"];
        ANDREHC12 = [prefs integerForKey:@"TALKED_TO_ANDREHC36"];
        
        
        
    }
    
    space = 16;
    ox= 50;
    
    if (ANDREHC1>=1) {
        talkedToAndreHC1.x=gridRow1x1+ox;
        talkedToAndreHC1.y=gridRow1y+oy;
    }
    if (ANDREHC2>=1) {
        talkedToAndreHC2.x=gridRow1x2+ox;
        talkedToAndreHC2.y=gridRow1y+oy;
    }  
    if (ANDREHC3>=1) {
        talkedToAndreHC3.x=gridRow1x3+ox;
        talkedToAndreHC3.y=gridRow1y+oy;
    } 
    if (ANDREHC4>=1) {
        talkedToAndreHC4.x=gridRow1x1+ox;
        talkedToAndreHC4.y=gridRow2y+oy;
    }   
    if (ANDREHC5>=1) {
        talkedToAndreHC5.x=gridRow1x2+ox;
        talkedToAndreHC5.y=gridRow2y+oy;
    }    
    if (ANDREHC6>=1) {
        talkedToAndreHC6.x=gridRow1x3+ox;
        talkedToAndreHC6.y=gridRow2y+oy;
    }
    if (ANDREHC7>=1) {
        talkedToAndreHC7.x=gridRow1x1+ox;
        talkedToAndreHC7.y=gridRow3y+oy;
    }
    if (ANDREHC8>=1) {
        talkedToAndreHC8.x=gridRow1x2+ox;
        talkedToAndreHC8.y=gridRow3y+oy;
    }
    if (ANDREHC9>=1) {
        talkedToAndreHC9.x=gridRow1x3+ox;
        talkedToAndreHC9.y=gridRow3y+oy;
    }
    if (ANDREHC10>=1) {
        talkedToAndreHC10.x=gridRow1x1+ox;
        talkedToAndreHC10.y=gridRow4y+oy;
    }   
    if (ANDREHC11>=1) {
        talkedToAndreHC11.x=gridRow1x2+ox;
        talkedToAndreHC11.y=gridRow4y+oy;
    }
    if (ANDREHC12>=1) {
        talkedToAndreHC12.x=gridRow1x3+ox;
        talkedToAndreHC12.y=gridRow4y+oy;
    }
    
    
    
}

- (void) arrangeTalkedToIcons
{
    
    NSInteger ARMY1 ;
    NSInteger ARMY2 ;
    NSInteger ARMY3 ;
    NSInteger ARMY4 ;
    NSInteger ARMY5 ;
    NSInteger ARMY6 ;
    NSInteger ARMY7 ;
    NSInteger ARMY8 ;
    NSInteger ARMY9 ;
    NSInteger ARMY10 ;
    NSInteger ARMY11 ;
    NSInteger ARMY12; 
    
    NSInteger CHEF1 ;
    NSInteger CHEF2 ;
    NSInteger CHEF3 ;
    NSInteger CHEF4 ;
    NSInteger CHEF5 ;
    NSInteger CHEF6 ;
    NSInteger CHEF7;
    NSInteger CHEF8 ;
    NSInteger CHEF9 ;
    NSInteger CHEF10 ;
    NSInteger CHEF11 ;
    NSInteger CHEF12 ; 
    
    NSInteger INSPECTOR1 ;
    NSInteger INSPECTOR2 ;
    NSInteger INSPECTOR3 ;
    NSInteger INSPECTOR4;
    NSInteger INSPECTOR5 ;
    NSInteger INSPECTOR6 ;
    NSInteger INSPECTOR7 ;
    NSInteger INSPECTOR8 ;
    NSInteger INSPECTOR9 ;
    NSInteger INSPECTOR10 ;
    NSInteger INSPECTOR11 ;
    NSInteger INSPECTOR12 ; 
    
    NSInteger WORKER1 ;
    NSInteger WORKER2 ;
    NSInteger WORKER3 ;
    NSInteger WORKER4 ;
    NSInteger WORKER5 ; 
    NSInteger WORKER6 ; 
    NSInteger WORKER7 ; 
    NSInteger WORKER8 ; 
    NSInteger WORKER9 ; 
    NSInteger WORKER10 ; 
    NSInteger WORKER11 ;
    NSInteger WORKER12 ;
    
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
//    NSLog(@"the level is %d", FlxG.level);
    
    if (FlxG.level>=1 && FlxG.level <= 12) {
        ARMY1 = [prefs integerForKey:@"TALKED_TO_ARMY1"];
        ARMY2 = [prefs integerForKey:@"TALKED_TO_ARMY2"];
        ARMY3 = [prefs integerForKey:@"TALKED_TO_ARMY3"];
        ARMY4 = [prefs integerForKey:@"TALKED_TO_ARMY4"];
        ARMY5 = [prefs integerForKey:@"TALKED_TO_ARMY5"];
        ARMY6 = [prefs integerForKey:@"TALKED_TO_ARMY6"];
        ARMY7 = [prefs integerForKey:@"TALKED_TO_ARMY7"];
        ARMY8 = [prefs integerForKey:@"TALKED_TO_ARMY8"];
        ARMY9 = [prefs integerForKey:@"TALKED_TO_ARMY9"];
        ARMY10 = [prefs integerForKey:@"TALKED_TO_ARMY10"];
        ARMY11 = [prefs integerForKey:@"TALKED_TO_ARMY11"];
        ARMY12 = [prefs integerForKey:@"TALKED_TO_ARMY12"]; 
        
        CHEF1 = [prefs integerForKey:@"TALKED_TO_CHEF1"];
        CHEF2 = [prefs integerForKey:@"TALKED_TO_CHEF2"];
        CHEF3 = [prefs integerForKey:@"TALKED_TO_CHEF3"];
        CHEF4 = [prefs integerForKey:@"TALKED_TO_CHEF4"];
        CHEF5 = [prefs integerForKey:@"TALKED_TO_CHEF5"];
        CHEF6 = [prefs integerForKey:@"TALKED_TO_CHEF6"];
        CHEF7 = [prefs integerForKey:@"TALKED_TO_CHEF7"];
        CHEF8 = [prefs integerForKey:@"TALKED_TO_CHEF8"];
        CHEF9 = [prefs integerForKey:@"TALKED_TO_CHEF9"];
        CHEF10 = [prefs integerForKey:@"TALKED_TO_CHEF10"];
        CHEF11 = [prefs integerForKey:@"TALKED_TO_CHEF11"];
        CHEF12 = [prefs integerForKey:@"TALKED_TO_CHEF12"]; 
        
        INSPECTOR1 = [prefs integerForKey:@"TALKED_TO_INSPECTOR1"];
        INSPECTOR2 = [prefs integerForKey:@"TALKED_TO_INSPECTOR2"];
        INSPECTOR3 = [prefs integerForKey:@"TALKED_TO_INSPECTOR3"];
        INSPECTOR4 = [prefs integerForKey:@"TALKED_TO_INSPECTOR4"];
        INSPECTOR5 = [prefs integerForKey:@"TALKED_TO_INSPECTOR5"];
        INSPECTOR6 = [prefs integerForKey:@"TALKED_TO_INSPECTOR6"];
        INSPECTOR7 = [prefs integerForKey:@"TALKED_TO_INSPECTOR7"];
        INSPECTOR8 = [prefs integerForKey:@"TALKED_TO_INSPECTOR8"];
        INSPECTOR9 = [prefs integerForKey:@"TALKED_TO_INSPECTOR9"];
        INSPECTOR10 = [prefs integerForKey:@"TALKED_TO_INSPECTOR10"];
        INSPECTOR11 = [prefs integerForKey:@"TALKED_TO_INSPECTOR11"];
        INSPECTOR12 = [prefs integerForKey:@"TALKED_TO_INSPECTOR12"]; 
        
        WORKER1 = [prefs integerForKey:@"TALKED_TO_WORKER1"];
        WORKER2 = [prefs integerForKey:@"TALKED_TO_WORKER2"];
        WORKER3 = [prefs integerForKey:@"TALKED_TO_WORKER3"];
        WORKER4 = [prefs integerForKey:@"TALKED_TO_WORKER4"];
        WORKER5 = [prefs integerForKey:@"TALKED_TO_WORKER5"];
        WORKER6 = [prefs integerForKey:@"TALKED_TO_WORKER6"];
        WORKER7 = [prefs integerForKey:@"TALKED_TO_WORKER7"];
        WORKER8 = [prefs integerForKey:@"TALKED_TO_WORKER8"];
        WORKER9 = [prefs integerForKey:@"TALKED_TO_WORKER9"];
        WORKER10 = [prefs integerForKey:@"TALKED_TO_WORKER10"];
        WORKER11 = [prefs integerForKey:@"TALKED_TO_WORKER11"];
        WORKER12 = [prefs integerForKey:@"TALKED_TO_WORKER12"]; 
        
    }
    else if (FlxG.level>=13 && FlxG.level <= 24) {

         ARMY1 = [prefs integerForKey:@"TALKED_TO_ARMY13"];
         ARMY2 = [prefs integerForKey:@"TALKED_TO_ARMY14"];
         ARMY3 = [prefs integerForKey:@"TALKED_TO_ARMY15"];
         ARMY4 = [prefs integerForKey:@"TALKED_TO_ARMY16"];
         ARMY5 = [prefs integerForKey:@"TALKED_TO_ARMY17"];
         ARMY6 = [prefs integerForKey:@"TALKED_TO_ARMY18"];
         ARMY7 = [prefs integerForKey:@"TALKED_TO_ARMY19"];
         ARMY8 = [prefs integerForKey:@"TALKED_TO_ARMY20"];
         ARMY9 = [prefs integerForKey:@"TALKED_TO_ARMY21"];
         ARMY10 = [prefs integerForKey:@"TALKED_TO_ARMY22"];    
         ARMY11 = [prefs integerForKey:@"TALKED_TO_ARMY23"];
         ARMY12 = [prefs integerForKey:@"TALKED_TO_ARMY24"];
        
         CHEF1 = [prefs integerForKey:@"TALKED_TO_CHEF13"];
         CHEF2 = [prefs integerForKey:@"TALKED_TO_CHEF14"];
         CHEF3 = [prefs integerForKey:@"TALKED_TO_CHEF15"];
         CHEF4 = [prefs integerForKey:@"TALKED_TO_CHEF16"];
         CHEF5 = [prefs integerForKey:@"TALKED_TO_CHEF17"];
         CHEF6 = [prefs integerForKey:@"TALKED_TO_CHEF18"];
         CHEF7 = [prefs integerForKey:@"TALKED_TO_CHEF19"];
         CHEF8 = [prefs integerForKey:@"TALKED_TO_CHEF20"];
         CHEF9 = [prefs integerForKey:@"TALKED_TO_CHEF21"];
         CHEF10 = [prefs integerForKey:@"TALKED_TO_CHEF22"];    
         CHEF11 = [prefs integerForKey:@"TALKED_TO_CHEF23"];
         CHEF12 = [prefs integerForKey:@"TALKED_TO_CHEF24"];
        
         INSPECTOR1 = [prefs integerForKey:@"TALKED_TO_INSPECTOR13"];
         INSPECTOR2 = [prefs integerForKey:@"TALKED_TO_INSPECTOR14"];
         INSPECTOR3 = [prefs integerForKey:@"TALKED_TO_INSPECTOR15"];
         INSPECTOR4 = [prefs integerForKey:@"TALKED_TO_INSPECTOR16"];
         INSPECTOR5 = [prefs integerForKey:@"TALKED_TO_INSPECTOR17"];
         INSPECTOR6 = [prefs integerForKey:@"TALKED_TO_INSPECTOR18"];
         INSPECTOR7 = [prefs integerForKey:@"TALKED_TO_INSPECTOR19"];
         INSPECTOR8 = [prefs integerForKey:@"TALKED_TO_INSPECTOR20"];
         INSPECTOR9 = [prefs integerForKey:@"TALKED_TO_INSPECTOR21"];
         INSPECTOR10 = [prefs integerForKey:@"TALKED_TO_INSPECTOR22"];    
         INSPECTOR11 = [prefs integerForKey:@"TALKED_TO_INSPECTOR23"];
         INSPECTOR12 = [prefs integerForKey:@"TALKED_TO_INSPECTOR24"];
        
         WORKER1 = [prefs integerForKey:@"TALKED_TO_WORKER13"];
         WORKER2 = [prefs integerForKey:@"TALKED_TO_WORKER14"];
         WORKER3 = [prefs integerForKey:@"TALKED_TO_WORKER15"];
         WORKER4 = [prefs integerForKey:@"TALKED_TO_WORKER16"];
         WORKER5 = [prefs integerForKey:@"TALKED_TO_WORKER17"];
         WORKER6 = [prefs integerForKey:@"TALKED_TO_WORKER18"];
         WORKER7 = [prefs integerForKey:@"TALKED_TO_WORKER19"];
         WORKER8 = [prefs integerForKey:@"TALKED_TO_WORKER20"];
         WORKER9 = [prefs integerForKey:@"TALKED_TO_WORKER21"];
         WORKER10 = [prefs integerForKey:@"TALKED_TO_WORKER22"];    
         WORKER11 = [prefs integerForKey:@"TALKED_TO_WORKER23"];
         WORKER12 = [prefs integerForKey:@"TALKED_TO_WORKER24"];
        
    }
    
    else if (FlxG.level>=25 && FlxG.level <= 36) {
    
         ARMY1 = [prefs integerForKey:@"TALKED_TO_ARMY25"];
         ARMY2 = [prefs integerForKey:@"TALKED_TO_ARMY26"];
         ARMY3 = [prefs integerForKey:@"TALKED_TO_ARMY27"];
         ARMY4 = [prefs integerForKey:@"TALKED_TO_ARMY28"];
         ARMY5 = [prefs integerForKey:@"TALKED_TO_ARMY29"];
         ARMY6 = [prefs integerForKey:@"TALKED_TO_ARMY30"];
         ARMY7 = [prefs integerForKey:@"TALKED_TO_ARMY31"];
         ARMY8 = [prefs integerForKey:@"TALKED_TO_ARMY32"];
         ARMY9 = [prefs integerForKey:@"TALKED_TO_ARMY33"];
         ARMY10 = [prefs integerForKey:@"TALKED_TO_ARMY34"];
         ARMY11 = [prefs integerForKey:@"TALKED_TO_ARMY35"];
         ARMY12 = [prefs integerForKey:@"TALKED_TO_ARMY36"];

         CHEF1 = [prefs integerForKey:@"TALKED_TO_CHEF25"];
         CHEF2 = [prefs integerForKey:@"TALKED_TO_CHEF26"];
         CHEF3 = [prefs integerForKey:@"TALKED_TO_CHEF27"];
         CHEF4 = [prefs integerForKey:@"TALKED_TO_CHEF28"];
         CHEF5 = [prefs integerForKey:@"TALKED_TO_CHEF29"];
         CHEF6 = [prefs integerForKey:@"TALKED_TO_CHEF30"];
         CHEF7 = [prefs integerForKey:@"TALKED_TO_CHEF31"];
         CHEF8 = [prefs integerForKey:@"TALKED_TO_CHEF32"];
         CHEF9 = [prefs integerForKey:@"TALKED_TO_CHEF33"];
         CHEF10 = [prefs integerForKey:@"TALKED_TO_CHEF34"];
         CHEF11 = [prefs integerForKey:@"TALKED_TO_CHEF35"];
         CHEF12 = [prefs integerForKey:@"TALKED_TO_CHEF36"];
        
         INSPECTOR1 = [prefs integerForKey:@"TALKED_TO_INSPECTOR25"];
         INSPECTOR2 = [prefs integerForKey:@"TALKED_TO_INSPECTOR26"];
         INSPECTOR3 = [prefs integerForKey:@"TALKED_TO_INSPECTOR27"];
         INSPECTOR4 = [prefs integerForKey:@"TALKED_TO_INSPECTOR28"];
         INSPECTOR5 = [prefs integerForKey:@"TALKED_TO_INSPECTOR29"];
         INSPECTOR6 = [prefs integerForKey:@"TALKED_TO_INSPECTOR30"];
         INSPECTOR7 = [prefs integerForKey:@"TALKED_TO_INSPECTOR31"];
         INSPECTOR8 = [prefs integerForKey:@"TALKED_TO_INSPECTOR32"];
         INSPECTOR9 = [prefs integerForKey:@"TALKED_TO_INSPECTOR33"];
         INSPECTOR10 = [prefs integerForKey:@"TALKED_TO_INSPECTOR34"];
         INSPECTOR11 = [prefs integerForKey:@"TALKED_TO_INSPECTOR35"];
         INSPECTOR12 = [prefs integerForKey:@"TALKED_TO_INSPECTOR36"];

         WORKER1 = [prefs integerForKey:@"TALKED_TO_WORKER25"];
         WORKER2 = [prefs integerForKey:@"TALKED_TO_WORKER26"];
         WORKER3 = [prefs integerForKey:@"TALKED_TO_WORKER27"];
         WORKER4 = [prefs integerForKey:@"TALKED_TO_WORKER28"];
         WORKER5 = [prefs integerForKey:@"TALKED_TO_WORKER29"];
         WORKER6 = [prefs integerForKey:@"TALKED_TO_WORKER30"];
         WORKER7 = [prefs integerForKey:@"TALKED_TO_WORKER31"];
         WORKER8 = [prefs integerForKey:@"TALKED_TO_WORKER32"];
         WORKER9 = [prefs integerForKey:@"TALKED_TO_WORKER33"];
         WORKER10 = [prefs integerForKey:@"TALKED_TO_WORKER34"];
         WORKER11 = [prefs integerForKey:@"TALKED_TO_WORKER35"];
         WORKER12 = [prefs integerForKey:@"TALKED_TO_WORKER36"];
        
    }
    
    int i;
    int space = 16;
    int ox= 72;
    int oy = -12;
    
//    NSLog(@"%d%d%d%d", ARMY1, CHEF1, INSPECTOR1, WORKER1);
    
    if (ARMY1>=1 || CHEF1>=1 || INSPECTOR1>=1 || WORKER1>=1) {
        talkedToPlain1.x=gridRow1x1+ox;
        talkedToPlain1.y=gridRow1y+oy;
    }    
    if (ARMY2>=1 || CHEF2>=1 || INSPECTOR2>=1 || WORKER2>=1) {
        talkedToPlain2.x=gridRow1x2+ox;
        talkedToPlain2.y=gridRow1y+oy;
    }  
    if (ARMY3>=1 || CHEF3>=1 || INSPECTOR3>=1 || WORKER3>=1) {
        talkedToPlain3.x=gridRow1x3+ox;
        talkedToPlain3.y=gridRow1y+oy;
    } 
    if (ARMY4>=1 || CHEF4>=1 || INSPECTOR4>=1 || WORKER4>=1) {
        talkedToPlain4.x=gridRow1x1+ox;
        talkedToPlain4.y=gridRow2y+oy;
    }   
    if (ARMY5>=1 || CHEF5>=1 || INSPECTOR5>=1 || WORKER5>=1) {
        talkedToPlain5.x=gridRow1x2+ox;
        talkedToPlain5.y=gridRow2y+oy;
    }    
    if (ARMY6>=1 || CHEF6>=1 || INSPECTOR6>=1 || WORKER6>=1) {
        talkedToPlain6.x=gridRow1x3+ox;
        talkedToPlain6.y=gridRow2y+oy;
    }
    if (ARMY7>=1 || CHEF7>=1 || INSPECTOR7>=1 || WORKER7>=1) {
        talkedToPlain7.x=gridRow1x1+ox;
        talkedToPlain7.y=gridRow3y+oy;
    }
    if (ARMY8>=1 || CHEF8>=1 || INSPECTOR8>=1 || WORKER8>=1) {
        talkedToPlain8.x=gridRow1x2+ox;
        talkedToPlain8.y=gridRow3y+oy;
    }
    if (ARMY9>=1 || CHEF9>=1 || INSPECTOR9>=1 || WORKER9>=1) {
        talkedToPlain9.x=gridRow1x3+ox;
        talkedToPlain9.y=gridRow3y+oy;
    }
    if (ARMY10>=1 || CHEF10>=1 || INSPECTOR10>=1 || WORKER10>=1) {
        talkedToPlain10.x=gridRow1x1+ox;
        talkedToPlain10.y=gridRow4y+oy;
    }   
    if (ARMY11>=1 || CHEF11>=1 || INSPECTOR11>=1 || WORKER11>=1) {
        talkedToPlain11.x=gridRow1x2+ox;
        talkedToPlain11.y=gridRow4y+oy;
    }
    if (ARMY12>=1 || CHEF12>=1 || INSPECTOR12>=1 || WORKER12>=1) {
        talkedToPlain12.x=gridRow1x3+ox;
        talkedToPlain12.y=gridRow4y+oy;
    }
  

    
    
    
    //
    
    NSInteger ANDRE1 ;
    NSInteger ANDRE2 ;
    NSInteger ANDRE3 ;
    NSInteger ANDRE4 ;
    NSInteger ANDRE5 ;
    NSInteger ANDRE6 ;
    NSInteger ANDRE7 ;
    NSInteger ANDRE8 ;
    NSInteger ANDRE9 ;
    NSInteger ANDRE10 ;
    NSInteger ANDRE11 ;
    NSInteger ANDRE12; 
        
    if (FlxG.level>=1 && FlxG.level <= 12) {
        ANDRE1 = [prefs integerForKey:@"TALKED_TO_ANDRE1"];
        ANDRE2 = [prefs integerForKey:@"TALKED_TO_ANDRE2"];
        ANDRE3 = [prefs integerForKey:@"TALKED_TO_ANDRE3"];
        ANDRE4 = [prefs integerForKey:@"TALKED_TO_ANDRE4"];
        ANDRE5 = [prefs integerForKey:@"TALKED_TO_ANDRE5"];
        ANDRE6 = [prefs integerForKey:@"TALKED_TO_ANDRE6"];
        ANDRE7 = [prefs integerForKey:@"TALKED_TO_ANDRE7"];
        ANDRE8 = [prefs integerForKey:@"TALKED_TO_ANDRE8"];
        ANDRE9 = [prefs integerForKey:@"TALKED_TO_ANDRE9"];
        ANDRE10 = [prefs integerForKey:@"TALKED_TO_ANDRE10"];
        ANDRE11 = [prefs integerForKey:@"TALKED_TO_ANDRE11"];
        ANDRE12 = [prefs integerForKey:@"TALKED_TO_ANDRE12"]; 
        
        
    }
    if (FlxG.level>=13 && FlxG.level <= 24) {
        
        ANDRE1 = [prefs integerForKey:@"TALKED_TO_ANDRE13"];
        ANDRE2 = [prefs integerForKey:@"TALKED_TO_ANDRE14"];
        ANDRE3 = [prefs integerForKey:@"TALKED_TO_ANDRE15"];
        ANDRE4 = [prefs integerForKey:@"TALKED_TO_ANDRE16"];
        ANDRE5 = [prefs integerForKey:@"TALKED_TO_ANDRE17"];
        ANDRE6 = [prefs integerForKey:@"TALKED_TO_ANDRE18"];
        ANDRE7 = [prefs integerForKey:@"TALKED_TO_ANDRE19"];
        ANDRE8 = [prefs integerForKey:@"TALKED_TO_ANDRE20"];
        ANDRE9 = [prefs integerForKey:@"TALKED_TO_ANDRE21"];
        ANDRE10 = [prefs integerForKey:@"TALKED_TO_ANDRE22"];    
        ANDRE11 = [prefs integerForKey:@"TALKED_TO_ANDRE23"];
        ANDRE12 = [prefs integerForKey:@"TALKED_TO_ANDRE24"];
        
        
    }
    
    if (FlxG.level>=25 && FlxG.level <= 36) {
        
        ANDRE1 = [prefs integerForKey:@"TALKED_TO_ANDRE25"];
        ANDRE2 = [prefs integerForKey:@"TALKED_TO_ANDRE26"];
        ANDRE3 = [prefs integerForKey:@"TALKED_TO_ANDRE27"];
        ANDRE4 = [prefs integerForKey:@"TALKED_TO_ANDRE28"];
        ANDRE5 = [prefs integerForKey:@"TALKED_TO_ANDRE29"];
        ANDRE6 = [prefs integerForKey:@"TALKED_TO_ANDRE30"];
        ANDRE7 = [prefs integerForKey:@"TALKED_TO_ANDRE31"];
        ANDRE8 = [prefs integerForKey:@"TALKED_TO_ANDRE32"];
        ANDRE9 = [prefs integerForKey:@"TALKED_TO_ANDRE33"];
        ANDRE10 = [prefs integerForKey:@"TALKED_TO_ANDRE34"];
        ANDRE11 = [prefs integerForKey:@"TALKED_TO_ANDRE35"];
        ANDRE12 = [prefs integerForKey:@"TALKED_TO_ANDRE36"];
        
        
        
    }
    
     space = 16;
     ox= 50;
    
    if (ANDRE1>=1) {
        talkedToAndre1.x=gridRow1x1+ox;
        talkedToAndre1.y=gridRow1y+oy;
    }
    if (ANDRE2>=1) {
        talkedToAndre2.x=gridRow1x2+ox;
        talkedToAndre2.y=gridRow1y+oy;
    }  
    if (ANDRE3>=1) {
        talkedToAndre3.x=gridRow1x3+ox;
        talkedToAndre3.y=gridRow1y+oy;
    } 
    if (ANDRE4>=1) {
        talkedToAndre4.x=gridRow1x1+ox;
        talkedToAndre4.y=gridRow2y+oy;
    }   
    if (ANDRE5>=1) {
        talkedToAndre5.x=gridRow1x2+ox;
        talkedToAndre5.y=gridRow2y+oy;
    }    
    if (ANDRE6>=1) {
        talkedToAndre6.x=gridRow1x3+ox;
        talkedToAndre6.y=gridRow2y+oy;
    }
    if (ANDRE7>=1) {
        talkedToAndre7.x=gridRow1x1+ox;
        talkedToAndre7.y=gridRow3y+oy;
    }
    if (ANDRE8>=1) {
        talkedToAndre8.x=gridRow1x2+ox;
        talkedToAndre8.y=gridRow3y+oy;
    }
    if (ANDRE9>=1) {
        talkedToAndre9.x=gridRow1x3+ox;
        talkedToAndre9.y=gridRow3y+oy;
    }
    if (ANDRE10>=1) {
        talkedToAndre10.x=gridRow1x1+ox;
        talkedToAndre10.y=gridRow4y+oy;
    }   
    if (ANDRE11>=1) {
        talkedToAndre11.x=gridRow1x2+ox;
        talkedToAndre11.y=gridRow4y+oy;
    }
    if (ANDRE12>=1) {
        talkedToAndre12.x=gridRow1x3+ox;
        talkedToAndre12.y=gridRow4y+oy;
    }
    


}

- (void) addHCTalkedToIcons

{
    
    NSInteger ARMYHC1 ;
    NSInteger ARMYHC2 ;
    NSInteger ARMYHC3 ;
    NSInteger ARMYHC4 ;
    NSInteger ARMYHC5 ;
    NSInteger ARMYHC6 ;
    NSInteger ARMYHC7 ;
    NSInteger ARMYHC8 ;
    NSInteger ARMYHC9 ;
    NSInteger ARMYHC10 ;
    NSInteger ARMYHC11 ;
    NSInteger ARMYHC12; 
    
    NSInteger CHEFHC1 ;
    NSInteger CHEFHC2 ;
    NSInteger CHEFHC3 ;
    NSInteger CHEFHC4 ;
    NSInteger CHEFHC5 ;
    NSInteger CHEFHC6 ;
    NSInteger CHEFHC7;
    NSInteger CHEFHC8 ;
    NSInteger CHEFHC9 ;
    NSInteger CHEFHC10 ;
    NSInteger CHEFHC11 ;
    NSInteger CHEFHC12 ; 
    
    NSInteger INSPECTORHC1 ;
    NSInteger INSPECTORHC2 ;
    NSInteger INSPECTORHC3 ;
    NSInteger INSPECTORHC4;
    NSInteger INSPECTORHC5 ;
    NSInteger INSPECTORHC6 ;
    NSInteger INSPECTORHC7 ;
    NSInteger INSPECTORHC8 ;
    NSInteger INSPECTORHC9 ;
    NSInteger INSPECTORHC10 ;
    NSInteger INSPECTORHC11 ;
    NSInteger INSPECTORHC12 ; 
    
    NSInteger WORKERHC1 ;
    NSInteger WORKERHC2 ;
    NSInteger WORKERHC3 ;
    NSInteger WORKERHC4 ;
    NSInteger WORKERHC5 ; 
    NSInteger WORKERHC6 ; 
    NSInteger WORKERHC7 ; 
    NSInteger WORKERHC8 ; 
    NSInteger WORKERHC9 ; 
    NSInteger WORKERHC10 ; 
    NSInteger WORKERHC11 ;
    NSInteger WORKERHC12 ;
    
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if (FlxG.level>=1 && FlxG.level <= 12) {
        ARMYHC1 = [prefs integerForKey:@"TALKED_TO_ARMYHC1"];
        ARMYHC2 = [prefs integerForKey:@"TALKED_TO_ARMYHC2"];
        ARMYHC3 = [prefs integerForKey:@"TALKED_TO_ARMYHC3"];
        ARMYHC4 = [prefs integerForKey:@"TALKED_TO_ARMYHC4"];
        ARMYHC5 = [prefs integerForKey:@"TALKED_TO_ARMYHC5"];
        ARMYHC6 = [prefs integerForKey:@"TALKED_TO_ARMYHC6"];
        ARMYHC7 = [prefs integerForKey:@"TALKED_TO_ARMYHC7"];
        ARMYHC8 = [prefs integerForKey:@"TALKED_TO_ARMYHC8"];
        ARMYHC9 = [prefs integerForKey:@"TALKED_TO_ARMYHC9"];
        ARMYHC10 = [prefs integerForKey:@"TALKED_TO_ARMYHC10"];
        ARMYHC11 = [prefs integerForKey:@"TALKED_TO_ARMYHC11"];
        ARMYHC12 = [prefs integerForKey:@"TALKED_TO_ARMYHC12"]; 
        
        CHEFHC1 = [prefs integerForKey:@"TALKED_TO_CHEFHC1"];
        CHEFHC2 = [prefs integerForKey:@"TALKED_TO_CHEFHC2"];
        CHEFHC3 = [prefs integerForKey:@"TALKED_TO_CHEFHC3"];
        CHEFHC4 = [prefs integerForKey:@"TALKED_TO_CHEFHC4"];
        CHEFHC5 = [prefs integerForKey:@"TALKED_TO_CHEFHC5"];
        CHEFHC6 = [prefs integerForKey:@"TALKED_TO_CHEFHC6"];
        CHEFHC7 = [prefs integerForKey:@"TALKED_TO_CHEFHC7"];
        CHEFHC8 = [prefs integerForKey:@"TALKED_TO_CHEFHC8"];
        CHEFHC9 = [prefs integerForKey:@"TALKED_TO_CHEFHC9"];
        CHEFHC10 = [prefs integerForKey:@"TALKED_TO_CHEFHC10"];
        CHEFHC11 = [prefs integerForKey:@"TALKED_TO_CHEFHC11"];
        CHEFHC12 = [prefs integerForKey:@"TALKED_TO_CHEFHC12"]; 
        
        INSPECTORHC1 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC1"];
        INSPECTORHC2 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC2"];
        INSPECTORHC3 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC3"];
        INSPECTORHC4 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC4"];
        INSPECTORHC5 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC5"];
        INSPECTORHC6 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC6"];
        INSPECTORHC7 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC7"];
        INSPECTORHC8 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC8"];
        INSPECTORHC9 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC9"];
        INSPECTORHC10 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC10"];
        INSPECTORHC11 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC11"];
        INSPECTORHC12 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC12"]; 
        
        WORKERHC1 = [prefs integerForKey:@"TALKED_TO_WORKERHC1"];
        WORKERHC2 = [prefs integerForKey:@"TALKED_TO_WORKERHC2"];
        WORKERHC3 = [prefs integerForKey:@"TALKED_TO_WORKERHC3"];
        WORKERHC4 = [prefs integerForKey:@"TALKED_TO_WORKERHC4"];
        WORKERHC5 = [prefs integerForKey:@"TALKED_TO_WORKERHC5"];
        WORKERHC6 = [prefs integerForKey:@"TALKED_TO_WORKERHC6"];
        WORKERHC7 = [prefs integerForKey:@"TALKED_TO_WORKERHC7"];
        WORKERHC8 = [prefs integerForKey:@"TALKED_TO_WORKERHC8"];
        WORKERHC9 = [prefs integerForKey:@"TALKED_TO_WORKERHC9"];
        WORKERHC10 = [prefs integerForKey:@"TALKED_TO_WORKERHC10"];
        WORKERHC11 = [prefs integerForKey:@"TALKED_TO_WORKERHC11"];
        WORKERHC12 = [prefs integerForKey:@"TALKED_TO_WORKERHC12"]; 
        
    }
    if (FlxG.level>=13 && FlxG.level <= 24) {
        
        ARMYHC1 = [prefs integerForKey:@"TALKED_TO_ARMYHC13"];
        ARMYHC2 = [prefs integerForKey:@"TALKED_TO_ARMYHC14"];
        ARMYHC3 = [prefs integerForKey:@"TALKED_TO_ARMYHC15"];
        ARMYHC4 = [prefs integerForKey:@"TALKED_TO_ARMYHC16"];
        ARMYHC5 = [prefs integerForKey:@"TALKED_TO_ARMYHC17"];
        ARMYHC6 = [prefs integerForKey:@"TALKED_TO_ARMYHC18"];
        ARMYHC7 = [prefs integerForKey:@"TALKED_TO_ARMYHC19"];
        ARMYHC8 = [prefs integerForKey:@"TALKED_TO_ARMYHC20"];
        ARMYHC9 = [prefs integerForKey:@"TALKED_TO_ARMYHC21"];
        ARMYHC10 = [prefs integerForKey:@"TALKED_TO_ARMYHC22"];    
        ARMYHC11 = [prefs integerForKey:@"TALKED_TO_ARMYHC23"];
        ARMYHC12 = [prefs integerForKey:@"TALKED_TO_ARMYHC24"];
        
        CHEFHC1 = [prefs integerForKey:@"TALKED_TO_CHEFHC13"];
        CHEFHC2 = [prefs integerForKey:@"TALKED_TO_CHEFHC14"];
        CHEFHC3 = [prefs integerForKey:@"TALKED_TO_CHEFHC15"];
        CHEFHC4 = [prefs integerForKey:@"TALKED_TO_CHEFHC16"];
        CHEFHC5 = [prefs integerForKey:@"TALKED_TO_CHEFHC17"];
        CHEFHC6 = [prefs integerForKey:@"TALKED_TO_CHEFHC18"];
        CHEFHC7 = [prefs integerForKey:@"TALKED_TO_CHEFHC19"];
        CHEFHC8 = [prefs integerForKey:@"TALKED_TO_CHEFHC20"];
        CHEFHC9 = [prefs integerForKey:@"TALKED_TO_CHEFHC21"];
        CHEFHC10 = [prefs integerForKey:@"TALKED_TO_CHEFHC22"];    
        CHEFHC11 = [prefs integerForKey:@"TALKED_TO_CHEFHC23"];
        CHEFHC12 = [prefs integerForKey:@"TALKED_TO_CHEFHC24"];
        
        INSPECTORHC1 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC13"];
        INSPECTORHC2 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC14"];
        INSPECTORHC3 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC15"];
        INSPECTORHC4 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC16"];
        INSPECTORHC5 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC17"];
        INSPECTORHC6 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC18"];
        INSPECTORHC7 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC19"];
        INSPECTORHC8 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC20"];
        INSPECTORHC9 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC21"];
        INSPECTORHC10 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC22"];    
        INSPECTORHC11 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC23"];
        INSPECTORHC12 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC24"];
        
        WORKERHC1 = [prefs integerForKey:@"TALKED_TO_WORKERHC13"];
        WORKERHC2 = [prefs integerForKey:@"TALKED_TO_WORKERHC14"];
        WORKERHC3 = [prefs integerForKey:@"TALKED_TO_WORKERHC15"];
        WORKERHC4 = [prefs integerForKey:@"TALKED_TO_WORKERHC16"];
        WORKERHC5 = [prefs integerForKey:@"TALKED_TO_WORKERHC17"];
        WORKERHC6 = [prefs integerForKey:@"TALKED_TO_WORKERHC18"];
        WORKERHC7 = [prefs integerForKey:@"TALKED_TO_WORKERHC19"];
        WORKERHC8 = [prefs integerForKey:@"TALKED_TO_WORKERHC20"];
        WORKERHC9 = [prefs integerForKey:@"TALKED_TO_WORKERHC21"];
        WORKERHC10 = [prefs integerForKey:@"TALKED_TO_WORKERHC22"];    
        WORKERHC11 = [prefs integerForKey:@"TALKED_TO_WORKERHC23"];
        WORKERHC12 = [prefs integerForKey:@"TALKED_TO_WORKERHC24"];
        
    }
    
    if (FlxG.level>=25 && FlxG.level <= 36) {
        
        ARMYHC1 = [prefs integerForKey:@"TALKED_TO_ARMYHC25"];
        ARMYHC2 = [prefs integerForKey:@"TALKED_TO_ARMYHC26"];
        ARMYHC3 = [prefs integerForKey:@"TALKED_TO_ARMYHC27"];
        ARMYHC4 = [prefs integerForKey:@"TALKED_TO_ARMYHC28"];
        ARMYHC5 = [prefs integerForKey:@"TALKED_TO_ARMYHC29"];
        ARMYHC6 = [prefs integerForKey:@"TALKED_TO_ARMYHC30"];
        ARMYHC7 = [prefs integerForKey:@"TALKED_TO_ARMYHC31"];
        ARMYHC8 = [prefs integerForKey:@"TALKED_TO_ARMYHC32"];
        ARMYHC9 = [prefs integerForKey:@"TALKED_TO_ARMYHC33"];
        ARMYHC10 = [prefs integerForKey:@"TALKED_TO_ARMYHC34"];
        ARMYHC11 = [prefs integerForKey:@"TALKED_TO_ARMYHC35"];
        ARMYHC12 = [prefs integerForKey:@"TALKED_TO_ARMYHC36"];
        
        CHEFHC1 = [prefs integerForKey:@"TALKED_TO_CHEFHC25"];
        CHEFHC2 = [prefs integerForKey:@"TALKED_TO_CHEFHC26"];
        CHEFHC3 = [prefs integerForKey:@"TALKED_TO_CHEFHC27"];
        CHEFHC4 = [prefs integerForKey:@"TALKED_TO_CHEFHC28"];
        CHEFHC5 = [prefs integerForKey:@"TALKED_TO_CHEFHC29"];
        CHEFHC6 = [prefs integerForKey:@"TALKED_TO_CHEFHC30"];
        CHEFHC7 = [prefs integerForKey:@"TALKED_TO_CHEFHC31"];
        CHEFHC8 = [prefs integerForKey:@"TALKED_TO_CHEFHC32"];
        CHEFHC9 = [prefs integerForKey:@"TALKED_TO_CHEFHC33"];
        CHEFHC10 = [prefs integerForKey:@"TALKED_TO_CHEFHC34"];
        CHEFHC11 = [prefs integerForKey:@"TALKED_TO_CHEFHC35"];
        CHEFHC12 = [prefs integerForKey:@"TALKED_TO_CHEFHC36"];
        
        INSPECTORHC1 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC25"];
        INSPECTORHC2 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC26"];
        INSPECTORHC3 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC27"];
        INSPECTORHC4 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC28"];
        INSPECTORHC5 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC29"];
        INSPECTORHC6 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC30"];
        INSPECTORHC7 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC31"];
        INSPECTORHC8 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC32"];
        INSPECTORHC9 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC33"];
        INSPECTORHC10 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC34"];
        INSPECTORHC11 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC35"];
        INSPECTORHC12 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC36"];
        
        WORKERHC1 = [prefs integerForKey:@"TALKED_TO_WORKERHC25"];
        WORKERHC2 = [prefs integerForKey:@"TALKED_TO_WORKERHC26"];
        WORKERHC3 = [prefs integerForKey:@"TALKED_TO_WORKERHC27"];
        WORKERHC4 = [prefs integerForKey:@"TALKED_TO_WORKERHC28"];
        WORKERHC5 = [prefs integerForKey:@"TALKED_TO_WORKERHC29"];
        WORKERHC6 = [prefs integerForKey:@"TALKED_TO_WORKERHC30"];
        WORKERHC7 = [prefs integerForKey:@"TALKED_TO_WORKERHC31"];
        WORKERHC8 = [prefs integerForKey:@"TALKED_TO_WORKERHC32"];
        WORKERHC9 = [prefs integerForKey:@"TALKED_TO_WORKERHC33"];
        WORKERHC10 = [prefs integerForKey:@"TALKED_TO_WORKERHC34"];
        WORKERHC11 = [prefs integerForKey:@"TALKED_TO_WORKERHC35"];
        WORKERHC12 = [prefs integerForKey:@"TALKED_TO_WORKERHC36"];
        
    }
    
    int i;
    int space = 16;
    int ox= 72;
    int oy = -12;
    
    if (ARMYHC1>=1 || CHEFHC1>=1 || INSPECTORHC1>=1 || WORKERHC1>=1) {
        talkedToPlainHC1.x=gridRow1x1+ox;
        talkedToPlainHC1.y=gridRow1y+oy;
    }    
    if (ARMYHC2>=1 || CHEFHC2>=1 || INSPECTORHC2>=1 || WORKERHC2>=1) {
        talkedToPlainHC2.x=gridRow1x2+ox;
        talkedToPlainHC2.y=gridRow1y+oy;
    }  
    if (ARMYHC3>=1 || CHEFHC3>=1 || INSPECTORHC3>=1 || WORKERHC3>=1) {
        talkedToPlainHC3.x=gridRow1x3+ox;
        talkedToPlainHC3.y=gridRow1y+oy;
    } 
    if (ARMYHC4>=1 || CHEFHC4>=1 || INSPECTORHC4>=1 || WORKERHC4>=1) {
        talkedToPlainHC4.x=gridRow1x1+ox;
        talkedToPlainHC4.y=gridRow2y+oy;
    }   
    if (ARMYHC5>=1 || CHEFHC5>=1 || INSPECTORHC5>=1 || WORKERHC5>=1) {
        talkedToPlainHC5.x=gridRow1x2+ox;
        talkedToPlainHC5.y=gridRow2y+oy;
    }    
    if (ARMYHC6>=1 || CHEFHC6>=1 || INSPECTORHC6>=1 || WORKERHC6>=1) {
        talkedToPlainHC6.x=gridRow1x3+ox;
        talkedToPlainHC6.y=gridRow2y+oy;
    }
    if (ARMYHC7>=1 || CHEFHC7>=1 || INSPECTORHC7>=1 || WORKERHC7>=1) {
        talkedToPlainHC7.x=gridRow1x1+ox;
        talkedToPlainHC7.y=gridRow3y+oy;
    }
    if (ARMYHC8>=1 || CHEFHC8>=1 || INSPECTORHC8>=1 || WORKERHC8>=1) {
        talkedToPlainHC8.x=gridRow1x2+ox;
        talkedToPlainHC8.y=gridRow3y+oy;
    }
    if (ARMYHC9>=1 || CHEFHC9>=1 || INSPECTORHC9>=1 || WORKERHC9>=1) {
        talkedToPlainHC9.x=gridRow1x3+ox;
        talkedToPlainHC9.y=gridRow3y+oy;
    }
    if (ARMYHC10>=1 || CHEFHC10>=1 || INSPECTORHC10>=1 || WORKERHC10>=1) {
        talkedToPlainHC10.x=gridRow1x1+ox;
        talkedToPlainHC10.y=gridRow4y+oy;
    }   
    if (ARMYHC11>=1 || CHEFHC11>=1 || INSPECTORHC11>=1 || WORKERHC11>=1) {
        talkedToPlainHC11.x=gridRow1x2+ox;
        talkedToPlainHC11.y=gridRow4y+oy;
    }
    if (ARMYHC12>=1 || CHEFHC12>=1 || INSPECTORHC12>=1 || WORKERHC12>=1) {
        talkedToPlainHC12.x=gridRow1x3+ox;
        talkedToPlainHC12.y=gridRow4y+oy;
    }    
    
    
    
    
    //
    
    NSInteger ANDREHC1 ;
    NSInteger ANDREHC2 ;
    NSInteger ANDREHC3 ;
    NSInteger ANDREHC4 ;
    NSInteger ANDREHC5 ;
    NSInteger ANDREHC6 ;
    NSInteger ANDREHC7 ;
    NSInteger ANDREHC8 ;
    NSInteger ANDREHC9 ;
    NSInteger ANDREHC10 ;
    NSInteger ANDREHC11 ;
    NSInteger ANDREHC12; 
    
    if (FlxG.level>=1 && FlxG.level <= 12) {
        ANDREHC1 = [prefs integerForKey:@"TALKED_TO_ANDREHC1"];
        ANDREHC2 = [prefs integerForKey:@"TALKED_TO_ANDREHC2"];
        ANDREHC3 = [prefs integerForKey:@"TALKED_TO_ANDREHC3"];
        ANDREHC4 = [prefs integerForKey:@"TALKED_TO_ANDREHC4"];
        ANDREHC5 = [prefs integerForKey:@"TALKED_TO_ANDREHC5"];
        ANDREHC6 = [prefs integerForKey:@"TALKED_TO_ANDREHC6"];
        ANDREHC7 = [prefs integerForKey:@"TALKED_TO_ANDREHC7"];
        ANDREHC8 = [prefs integerForKey:@"TALKED_TO_ANDREHC8"];
        ANDREHC9 = [prefs integerForKey:@"TALKED_TO_ANDREHC9"];
        ANDREHC10 = [prefs integerForKey:@"TALKED_TO_ANDREHC10"];
        ANDREHC11 = [prefs integerForKey:@"TALKED_TO_ANDREHC11"];
        ANDREHC12 = [prefs integerForKey:@"TALKED_TO_ANDREHC12"]; 
        
        
    }
    if (FlxG.level>=13 && FlxG.level <= 24) {
        
        ANDREHC1 = [prefs integerForKey:@"TALKED_TO_ANDREHC13"];
        ANDREHC2 = [prefs integerForKey:@"TALKED_TO_ANDREHC14"];
        ANDREHC3 = [prefs integerForKey:@"TALKED_TO_ANDREHC15"];
        ANDREHC4 = [prefs integerForKey:@"TALKED_TO_ANDREHC16"];
        ANDREHC5 = [prefs integerForKey:@"TALKED_TO_ANDREHC17"];
        ANDREHC6 = [prefs integerForKey:@"TALKED_TO_ANDREHC18"];
        ANDREHC7 = [prefs integerForKey:@"TALKED_TO_ANDREHC19"];
        ANDREHC8 = [prefs integerForKey:@"TALKED_TO_ANDREHC20"];
        ANDREHC9 = [prefs integerForKey:@"TALKED_TO_ANDREHC21"];
        ANDREHC10 = [prefs integerForKey:@"TALKED_TO_ANDREHC22"];    
        ANDREHC11 = [prefs integerForKey:@"TALKED_TO_ANDREHC23"];
        ANDREHC12 = [prefs integerForKey:@"TALKED_TO_ANDREHC24"];
        
        
    }
    
    if (FlxG.level>=25 && FlxG.level <= 36) {
        
        ANDREHC1 = [prefs integerForKey:@"TALKED_TO_ANDREHC25"];
        ANDREHC2 = [prefs integerForKey:@"TALKED_TO_ANDREHC26"];
        ANDREHC3 = [prefs integerForKey:@"TALKED_TO_ANDREHC27"];
        ANDREHC4 = [prefs integerForKey:@"TALKED_TO_ANDREHC28"];
        ANDREHC5 = [prefs integerForKey:@"TALKED_TO_ANDREHC29"];
        ANDREHC6 = [prefs integerForKey:@"TALKED_TO_ANDREHC30"];
        ANDREHC7 = [prefs integerForKey:@"TALKED_TO_ANDREHC31"];
        ANDREHC8 = [prefs integerForKey:@"TALKED_TO_ANDREHC32"];
        ANDREHC9 = [prefs integerForKey:@"TALKED_TO_ANDREHC33"];
        ANDREHC10 = [prefs integerForKey:@"TALKED_TO_ANDREHC34"];
        ANDREHC11 = [prefs integerForKey:@"TALKED_TO_ANDREHC35"];
        ANDREHC12 = [prefs integerForKey:@"TALKED_TO_ANDREHC36"];
        
        
        
    }
    
    space = 16;
    ox= 50;
    
    if (ANDREHC1>=1) {
        talkedToAndreHC1.x=gridRow1x1+ox;
        talkedToAndreHC1.y=gridRow1y+oy;
    }
    if (ANDREHC2>=1) {
        talkedToAndreHC2.x=gridRow1x2+ox;
        talkedToAndreHC2.y=gridRow1y+oy;
    }  
    if (ANDREHC3>=1) {
        talkedToAndreHC3.x=gridRow1x3+ox;
        talkedToAndreHC3.y=gridRow1y+oy;
    } 
    if (ANDREHC4>=1) {
        talkedToAndreHC4.x=gridRow1x1+ox;
        talkedToAndreHC4.y=gridRow2y+oy;
    }   
    if (ANDREHC5>=1) {
        talkedToAndreHC5.x=gridRow1x2+ox;
        talkedToAndreHC5.y=gridRow2y+oy;
    }    
    if (ANDREHC6>=1) {
        talkedToAndreHC6.x=gridRow1x3+ox;
        talkedToAndreHC6.y=gridRow2y+oy;
    }
    if (ANDREHC7>=1) {
        talkedToAndreHC7.x=gridRow1x1+ox;
        talkedToAndreHC7.y=gridRow3y+oy;
    }
    if (ANDREHC8>=1) {
        talkedToAndreHC8.x=gridRow1x2+ox;
        talkedToAndreHC8.y=gridRow3y+oy;
    }
    if (ANDREHC9>=1) {
        talkedToAndreHC9.x=gridRow1x3+ox;
        talkedToAndreHC9.y=gridRow3y+oy;
    }
    if (ANDREHC10>=1) {
        talkedToAndreHC10.x=gridRow1x1+ox;
        talkedToAndreHC10.y=gridRow4y+oy;
    }   
    if (ANDREHC11>=1) {
        talkedToAndreHC11.x=gridRow1x2+ox;
        talkedToAndreHC11.y=gridRow4y+oy;
    }
    if (ANDREHC12>=1) {
        talkedToAndreHC12.x=gridRow1x3+ox;
        talkedToAndreHC12.y=gridRow4y+oy;
    }    
    
    
}



- (void) addStars 
{
    int i;
    int space = 16;
    int ox= 92;
    int oy = -12;
    
    
    if (level1>=2) {
        //for (i=1; i<level1; i++) {
        
        //star1 = [FlxSprite spriteWithX:((gridRow1x1) )+ox y:gridRow1y+oy graphic:ImgStar]; //+i*space
        star1 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x1) )+ox, gridRow1y+oy) withImage:ImgStar];
        star1.scale=CGPointMake(0, 0);
        [self add:star1];

        
        //}
    }
    if (hclevel1>=2) {
        starhc1 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x1) )+ox, gridRow1y+oy) withImage:Imgstarhc];
        starhc1.visible=NO;
        [self add:starhc1];
    }    
    
    
    
    
//    if (level2>=2) {
//        for (i=1; i<level2; i++) {
//            FlxSprite * star = [FlxSprite spriteWithX:((gridRow1x2)+i*space )+ox y:gridRow1y+oy graphic:ImgStar];
//            [self add:star];
//        }
//    }
    
    if (level2>=2) {
        //star2 = [FlxSprite spriteWithX:((gridRow1x2) )+ox y:gridRow1y+oy graphic:ImgStar];
        
        star2 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x2) )+ox, gridRow1y+oy)  withImage:ImgStar];
        star2.scale=CGPointMake(0, 0);
        
        [self add:star2];
    }
    if (hclevel2>=2) {
        starhc2 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x2) )+ox, gridRow1y+oy)  withImage:Imgstarhc];
        starhc2.visible=NO;
        [self add:starhc2];
    }
    
    
    if (level3>=2) {
        //star3 = [FlxSprite spriteWithX:((gridRow1x3) )+ox y:gridRow1y+oy graphic:ImgStar];
        
        star3 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x3) )+ox, gridRow1y+oy)  withImage:ImgStar];
        star3.scale=CGPointMake(0, 0);
        
        [self add:star3];
    }
    if (hclevel3>=2) {
        starhc3 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x3) )+ox, gridRow1y+oy)  withImage:Imgstarhc];
        starhc3.visible=NO;
        [self add:starhc3];
    }
    
    
    
    if (level4>=2) {
        star4 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x1) )+ox, gridRow2y+oy)  withImage:ImgStar];
        star4.scale=CGPointMake(0, 0);
        [self add:star4];
    }
    if (hclevel4>=2) {
        starhc4 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x1) )+ox, gridRow2y+oy)  withImage:Imgstarhc];
        starhc4.visible=NO;
        [self add:starhc4];
    }    
    if (level5>=2) {
        star5 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x2) )+ox, gridRow2y+oy)  withImage:ImgStar];
        star5.scale=CGPointMake(0, 0);
        [self add:star5];
    }    
    if (hclevel5>=2) {
        starhc5 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x2) )+ox, gridRow2y+oy)  withImage:Imgstarhc];
        starhc5.visible=NO;
        [self add:starhc5];
    }  
    
    
    if (level6>=2) {
        star6 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x3) )+ox, gridRow2y+oy)  withImage:ImgStar];
        star6.scale=CGPointMake(0, 0);        
        [self add:star6];
    }
    if (hclevel6>=2) {
        starhc6 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x3) )+ox, gridRow2y+oy)  withImage:Imgstarhc];
        starhc6.visible=NO;
        [self add:starhc6];
    }
    
    if (level7>=2) {
        star7 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x1) )+ox, gridRow3y+oy)  withImage:ImgStar];
        star7.scale=CGPointMake(0, 0);          
        [self add:star7];
    }
    if (hclevel7>=2) {
        starhc7 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x1) )+ox, gridRow3y+oy)  withImage:Imgstarhc];
        starhc7.visible=NO;
        [self add:starhc7];
    }
    
    
    
    if (level8>=2) {
        star8 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x2) )+ox, gridRow3y+oy)  withImage:ImgStar];
        star8.scale=CGPointMake(0, 0);  
        
        [self add:star8];
    }
    if (hclevel8>=2) {
        starhc8 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x2) )+ox, gridRow3y+oy)  withImage:Imgstarhc];
        starhc8.visible=NO;
        [self add:starhc8];
    }
    
    
    
    if (level9>=2) {
        star9 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x3) )+ox, gridRow3y+oy)  withImage:ImgStar];
        star9.scale=CGPointMake(0, 0);  
        [self add:star9];
    }
    if (hclevel9>=2) {
        starhc9 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x3) )+ox, gridRow3y+oy)  withImage:Imgstarhc];
        starhc9.visible=NO;
        [self add:starhc9];
    }    
    

    
    if (level10>=2) {
        star10 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x1) )+ox, gridRow4y+oy)  withImage:ImgStar];
        star10.scale=CGPointMake(0, 0);  
        [self add:star10];
    }
    if (hclevel10>=2) {
        starhc10 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x1) )+ox, gridRow4y+oy)  withImage:Imgstarhc];
        starhc10.visible=NO;
        [self add:starhc10];
    }    
    
    
    
    if (level11>=2) {
        star11 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x2) )+ox, gridRow4y+oy)  withImage:ImgStar];
        star11.scale=CGPointMake(0, 0);  
        [self add:star11];
    }
    if (hclevel11>=2) {
        starhc11 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x2) )+ox, gridRow4y+oy)  withImage:Imgstarhc];
        starhc11.visible=NO;
        [self add:starhc11];
    }    
    
    
    
    
    if (level12>=2) {
        star12 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x3) )+ox, gridRow4y+oy)  withImage:ImgStar];
        star12.scale=CGPointMake(0, 0);  
        [self add:star12];
    }
    if (hclevel12>=2) {
        starhc12 = [Badge badgeWithOrigin:CGPointMake(((gridRow1x3) )+ox, gridRow4y+oy)  withImage:Imgstarhc];
        starhc12.visible=NO;
        [self add:starhc12];
    }    
    
    
    if (FlxG.hardCoreMode) {
        
        star1.visible = star2.visible = star3.visible = star4.visible = star5.visible = star6.visible = star7.visible = star8.visible = star9.visible = star10.visible = star11.visible = star12.visible=NO;
        
        starhc1.visible = starhc2.visible = starhc3.visible = starhc4.visible = starhc5.visible = starhc6.visible = starhc7.visible = starhc8.visible = starhc9.visible = starhc10.visible = starhc11.visible = starhc12.visible=YES;       
        
        screenDarken.visible=YES;
        
    }
    else if (!FlxG.hardCoreMode) {
        
        star1.visible = star2.visible = star3.visible = star4.visible = star5.visible = star6.visible = star7.visible = star8.visible = star9.visible = star10.visible = star11.visible = star12.visible=YES;
        
        starhc1.visible = starhc2.visible = starhc3.visible = starhc4.visible = starhc5.visible = starhc6.visible = starhc7.visible = starhc8.visible = starhc9.visible = starhc10.visible = starhc11.visible = starhc12.visible=NO;  
        
        screenDarken.visible=NO;
        
    }
    
    
    
    
}

- (void) dealloc
{
	//[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}


- (void) update
{    
    
    if (FlxG.touches.iCadeDownBegan ) {
        
        [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];

        if (navArrow.currentValue==10 ||  navArrow.currentValue==11 ) {
            navArrow.currentValue=13;            
        }
        else if (navArrow.currentValue==12 ) {
            navArrow.currentValue=14;            
        }
        else if (navArrow.currentValue==13 ) {
            navArrow.currentValue=1;            
        }        
        else if (navArrow.currentValue==14 ) {
            navArrow.currentValue=3;            
        }         
        else {
            navArrow.currentValue+=3;            
        }
    }
    
    
    
    
    
    else if (FlxG.touches.iCadeUpBegan ) {
        
        [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];

        if (navArrow.currentValue==1 || navArrow.currentValue==2) {
            navArrow.currentValue=13;
        }        
        else if (navArrow.currentValue==3 ) {
            navArrow.currentValue=14;            
        }
        else if (navArrow.currentValue==13 ) {
            navArrow.currentValue=10;            
        }        
        else if (navArrow.currentValue==14 ) {
            navArrow.currentValue=12;            
        } 
        else {
            navArrow.currentValue-=3;            
        }    
    }    
    else if (FlxG.touches.iCadeRightBegan) {
        [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];

        navArrow.currentValue++;
    }
    else if (FlxG.touches.iCadeLeftBegan) {
        [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];

        navArrow.currentValue--;
    }
    
    [self setAllButtonsToNotSelected];
    
    if (FlxG.gamePad!=0) {
        
        if (navArrow.currentValue==1) {
            if (l1Btn.visible) {
                l1Btn._selected=YES;
            }
            if (l1BtnHC.visible) {
                l1BtnHC._selected=YES;
            }        
        } 
        if (navArrow.currentValue==2) {
            if (l2Btn.visible) {
                l2Btn._selected=YES;
            }
            if (l2BtnHC.visible) {
                l2BtnHC._selected=YES;
            } 
        }
        if (navArrow.currentValue==3) {
            if (l3Btn.visible) {
                l3Btn._selected=YES;
                
            }
            if (l3BtnHC.visible) {
                l3BtnHC._selected=YES;
            } 
        }
        
        if (navArrow.currentValue==4) {
            if (l4Btn.visible) {
                l4Btn._selected=YES;  
            }
            if (l4BtnHC.visible) {
                l4BtnHC._selected=YES;
            }        
        } 
        if (navArrow.currentValue==5) {
            if (l5Btn.visible) {
                l5Btn._selected=YES;
            }
            if (l5BtnHC.visible) {
                l5BtnHC._selected=YES;
            }
        }
        if (navArrow.currentValue==6) {
            if (l6Btn.visible) {
                l6Btn._selected=YES;  
            }
            if (l6BtnHC.visible) {
                l6BtnHC._selected=YES;
            }
        }
        
        if (navArrow.currentValue==7) {
            if (l7Btn.visible) {
                l7Btn._selected=YES;
            }
            if (l7BtnHC.visible) {
                l7BtnHC._selected=YES;
            }
        } 
        if (navArrow.currentValue==8) {
            if (l8Btn.visible) {
                l8Btn._selected=YES;
            }
            if (l8BtnHC.visible) {
                l8BtnHC._selected=YES;
            }
        }
        if (navArrow.currentValue==9) {
            if (l9Btn.visible) {
                l9Btn._selected=YES;
            }
            if (l9BtnHC.visible) {
                l9BtnHC._selected=YES;
            }
        }
        
        if (navArrow.currentValue==10) {
            if (l10Btn.visible) {
                l10Btn._selected=YES;
            }
            if (l10BtnHC.visible) {
                l10BtnHC._selected=YES;
            }
        } 
        if (navArrow.currentValue==11) {
            if (l11Btn.visible) {
                l11Btn._selected=YES;
            }
            if (l11BtnHC.visible) {
                l11BtnHC._selected=YES;
            }
        }
        if (navArrow.currentValue==12) {
            if (l12Btn.visible) {
                l12Btn._selected=YES;
            }
            if (l12BtnHC.visible) {
                l12BtnHC._selected=YES;
            }
        }
        
        if (navArrow.currentValue==13) {
            backBtn._selected=YES;
            
        }
        if (navArrow.currentValue==14) {
            if (hcButton.visible) {
                hcButton._selected=YES;
            }
            else if (hcButtonExplain.visible) {
                hcButtonExplain._selected=YES;
            }
            else if (normalButton.visible) {
                normalButton._selected=YES;
            }
        }        
    }
    
    if ( FlxG.touches.iCadeABegan ) {
        
        if (navArrow.currentValue==1) {
            if (l1Btn.visible || l1BtnHC.visible) {
                [self onl1Btn];
            }
        } 
        if (navArrow.currentValue==2) {
            if (level2>=1 && !FlxG.hardCoreMode) {
                [self onl2Btn];
            }
            else if (hclevel2>=1 && FlxG.hardCoreMode) {
                [self onl2Btn];
            }
            else {
                [self dontPlayLevel];
            }
            
//            if (l2Btn.visible || l2BtnHC.visible) {
//                [self onl2Btn];
//            }
        }
        if (navArrow.currentValue==3) {
            if (level3>=1 && !FlxG.hardCoreMode) {
                [self onl3Btn];
            }
            else if (hclevel3>=1 && FlxG.hardCoreMode) {
                [self onl3Btn];
            }
            else {
                [self dontPlayLevel];
            }
        }
        
        if (navArrow.currentValue==4) {
            if (level4>=1 && !FlxG.hardCoreMode) {
                [self onl4Btn];
            }
            else if (hclevel4>=1 && FlxG.hardCoreMode) {
                [self onl4Btn];
            }
            else {
                [self dontPlayLevel];
            }
        } 
        if (navArrow.currentValue==5) {
            if (level5>=1 && !FlxG.hardCoreMode) {
                [self onl5Btn];
            }
            else if (hclevel5>=1 && FlxG.hardCoreMode) {
                [self onl5Btn];
            }
            else {
                [self dontPlayLevel];
            }
        }
        if (navArrow.currentValue==6) {
            if (level6>=1 && !FlxG.hardCoreMode) {
                [self onl6Btn];
            }
            else if (hclevel6>=1 && FlxG.hardCoreMode) {
                [self onl6Btn];
            }
            else {
                [self dontPlayLevel];
            }
        }
        
        if (navArrow.currentValue==7) {
            if (level7>=1 && !FlxG.hardCoreMode) {
                [self onl7Btn];
            }
            else if (hclevel7>=1 && FlxG.hardCoreMode) {
                [self onl7Btn];
            }
            else {
                [self dontPlayLevel];
            }
        } 
        if (navArrow.currentValue==8) {
            if (level8>=1 && !FlxG.hardCoreMode) {
                [self onl8Btn];
            }
            else if (hclevel8>=1 && FlxG.hardCoreMode) {
                [self onl8Btn];
            }
            else {
                [self dontPlayLevel];
            }
        }
        if (navArrow.currentValue==9) {
            if (level9>=1 && !FlxG.hardCoreMode) {
                [self onl9Btn];
            }
            else if (hclevel9>=1 && FlxG.hardCoreMode) {
                [self onl9Btn];
            }
            else {
                [self dontPlayLevel];
            }
        }
        
        if (navArrow.currentValue==10) {
            if (level10>=1 && !FlxG.hardCoreMode) {
                [self onl10Btn];
            }
            else if (hclevel10>=1 && FlxG.hardCoreMode) {
                [self onl10Btn];
            }
            else {
                [self dontPlayLevel];
            }
        } 
        if (navArrow.currentValue==11) {
            if (level11>=1 && !FlxG.hardCoreMode) {
                [self onl11Btn];
            }
            else if (hclevel11>=1 && FlxG.hardCoreMode) {
                [self onl11Btn];
            }
            else {
                [self dontPlayLevel];
            }
        }
        if (navArrow.currentValue==12) {
            if (level12>=1 && !FlxG.hardCoreMode) {
                [self onl12Btn];
            }
            else if (hclevel12>=1 && FlxG.hardCoreMode) {
                [self onl12Btn];
            }
            else {
                [self dontPlayLevel];
            }
        }
        
        if (navArrow.currentValue==13) {
            backBtn._selected=YES;
            [self onBack];
            
        }
        if (navArrow.currentValue==14) {
            if (hcButton.visible) {
                hcButton._selected=YES;
                [self onHC];
            }
            else if (hcButtonExplain.visible) {
                hcButtonExplain._selected=YES;
                [self onHCExplain];
            }
            else if (normalButton.visible) {
                normalButton._selected=YES;
                [self onHC];
            }
        }        
        
    }

    
    
    
    
    
    
    if (FlxG.touches.iCadeBBegan) {
        [self onBack];
    }
    
    
    if (UNIT_TESTING == 1) {
        if ([FlxU random]<0.1) {
            [self onl2Btn];
        }
    }
    
    frameCounter++;
    int amt=2;
    if (frameCounter <= amt*1) {
        talkedToAndre1.scale = CGPointMake(0, 0);
        talkedToAndreHC1.scale = CGPointMake(0, 0);
        
    } 
    if (frameCounter <= amt*2) {
        talkedToPlain1.scale = CGPointMake(0, 0);
        talkedToPlainHC1.scale = CGPointMake(0, 0);

        talkedToAndre2.scale = CGPointMake(0, 0);
        talkedToAndreHC2.scale = CGPointMake(0, 0);
        
    }    
    if (frameCounter <= amt*3) {
        star1.scale = CGPointMake(0, 0);        
        starhc1.scale = CGPointMake(0, 0);
        
        talkedToPlain2.scale = CGPointMake(0, 0);
        talkedToPlainHC2.scale = CGPointMake(0, 0);

        talkedToAndre3.scale = CGPointMake(0, 0);
        talkedToAndreHC3.scale = CGPointMake(0, 0);


    }
    if (frameCounter <= amt*4) {
        star2.scale = CGPointMake(0, 0);
        starhc2.scale = CGPointMake(0, 0);
        talkedToPlain3.scale = CGPointMake(0, 0);
        talkedToPlainHC3.scale = CGPointMake(0, 0);
        
        talkedToAndre4.scale = CGPointMake(0, 0);
        talkedToAndreHC4.scale = CGPointMake(0, 0);

    }  
    if (frameCounter <= amt*5) {
        star3.scale = CGPointMake(0, 0);
        starhc3.scale = CGPointMake(0, 0);
        talkedToPlain4.scale = CGPointMake(0, 0);
        talkedToPlainHC4.scale = CGPointMake(0, 0);
        
        talkedToAndre5.scale = CGPointMake(0, 0);
        talkedToAndreHC5.scale = CGPointMake(0, 0);

    }
    if (frameCounter <= amt*6) {
        star4.scale = CGPointMake(0, 0);
        starhc4.scale = CGPointMake(0, 0);
        talkedToPlain5.scale = CGPointMake(0, 0);
        talkedToPlainHC5.scale = CGPointMake(0, 0);
        
        talkedToAndre6.scale = CGPointMake(0, 0);
        talkedToAndreHC6.scale = CGPointMake(0, 0);

    }    
    if (frameCounter <= amt*7) {
        star5.scale = CGPointMake(0, 0);
        starhc5.scale = CGPointMake(0, 0);
        talkedToPlain6.scale = CGPointMake(0, 0);
        talkedToPlainHC6.scale = CGPointMake(0, 0);
        
        talkedToAndre7.scale = CGPointMake(0, 0);
        talkedToAndreHC7.scale = CGPointMake(0, 0);

    }
    if (frameCounter <= amt*8) {
        star6.scale = CGPointMake(0, 0);
        starhc6.scale = CGPointMake(0, 0);
        talkedToPlain7.scale = CGPointMake(0, 0);
        talkedToPlainHC7.scale = CGPointMake(0, 0);
        
        talkedToAndre8.scale = CGPointMake(0, 0);
        talkedToAndreHC8.scale = CGPointMake(0, 0);

    } 
    if (frameCounter <= amt*9) {
        star7.scale = CGPointMake(0, 0);
        starhc7.scale = CGPointMake(0, 0);
        talkedToPlain8.scale = CGPointMake(0, 0);
        talkedToPlainHC8.scale = CGPointMake(0, 0);
        
        talkedToAndre9.scale = CGPointMake(0, 0);
        talkedToAndreHC9.scale = CGPointMake(0, 0);

    }
    if (frameCounter <= amt*10) {
        star8.scale = CGPointMake(0, 0);
        starhc8.scale = CGPointMake(0, 0);
        talkedToPlain9.scale = CGPointMake(0, 0);
        talkedToPlainHC9.scale = CGPointMake(0, 0);
        
        talkedToAndre10.scale = CGPointMake(0, 0);
        talkedToAndreHC10.scale = CGPointMake(0, 0);

    }    
    if (frameCounter <= amt*11) {
        star9.scale = CGPointMake(0, 0);
        starhc9.scale = CGPointMake(0, 0);
        talkedToPlain10.scale = CGPointMake(0, 0);
        talkedToPlainHC10.scale = CGPointMake(0, 0);
        
        talkedToAndre11.scale = CGPointMake(0, 0);
        talkedToAndreHC11.scale = CGPointMake(0, 0);

    }
    if (frameCounter <= amt*12) {
        star10.scale = CGPointMake(0, 0);
        starhc10.scale = CGPointMake(0, 0);
        talkedToPlain11.scale = CGPointMake(0, 0);
        talkedToPlainHC11.scale = CGPointMake(0, 0);
        
        talkedToAndre12.scale = CGPointMake(0, 0);
        talkedToAndreHC12.scale = CGPointMake(0, 0);

    }  
    
    if (frameCounter <= amt*13) {
        star11.scale = CGPointMake(0, 0);
        starhc11.scale = CGPointMake(0, 0);
        talkedToPlain12.scale = CGPointMake(0, 0);
        talkedToPlainHC12.scale = CGPointMake(0, 0);

        
    } 
    
    if (frameCounter <= amt*14) {
        star12.scale = CGPointMake(0, 0);
        starhc12.scale = CGPointMake(0, 0);

        
    } 
    
	[super update];
	
}

- (void) onBack
{
    [FlxG stop:@"tagtone3.caf"];

    [FlxG play:SndBack];

    FlxG.state = [[[WorldSelectState alloc] init] autorelease];
    return;
}

- (void) play
{
    [FlxG play:SndSelect];
    [FlxG stop:@"tagtone3.caf"];


    FlxG.state = [[[OgmoLevelState alloc] init] autorelease];
    return; 
}



- (void) onl1Btn
{
    //[self play];
    [FlxG play:SndSelect];
    [FlxG stop:@"tagtone3.caf"];

    if (!FlxG.hardCoreMode) {
        FlxG.level = FlxG.level+100;
        FlxG.state = [[[OgmoRevCinematicState alloc] init] autorelease];
        //FlxG.state = [[[OgmoCinematicState alloc] init] autorelease];

        
        return; 
    }
    else {
        FlxG.state = [[[OgmoLevelState alloc] init] autorelease];
        return; 
    }
    
}
- (void) onl2Btn
{
    FlxG.level=FlxG.level+1;
    [self play];
}
- (void) onl3Btn
{
    FlxG.level=FlxG.level+2;
    [self play];
}
- (void) onl4Btn
{
    FlxG.level=FlxG.level+3;
    [self play];
}
- (void) onl5Btn
{
    FlxG.level=FlxG.level+4;
    [self play];
}
- (void) onl6Btn
{
    FlxG.level=FlxG.level+5;
    [self play];
}
- (void) onl7Btn
{
    FlxG.level=FlxG.level+6;
    [self play];
}
- (void) onl8Btn
{
    FlxG.level=FlxG.level+7;
    [self play];
}
- (void) onl9Btn
{
    FlxG.level=FlxG.level+8;
    [self play];
}
- (void) onl10Btn
{
    FlxG.level=FlxG.level+9;
    [self play];
}
- (void) onl11Btn
{
    FlxG.level=FlxG.level+10;
    [self play];
}
- (void) onl12Btn
{
    FlxG.level=FlxG.level+11;
    [self play];
}

- (void) onHC
{
    frameCounter=0;
    
    FlxG.hardCoreMode=!FlxG.hardCoreMode;
    
    if (FlxG.hardCoreMode) {
        
        [[FlxG quake] startWithIntensity:0.0125 duration:0.2];

        hcButton.visible=NO;
        normalButton.visible=YES;
        
        if (FlxG.level>=1 && FlxG.level <= 12) {
            heading.text=@"Warehouse - Hardcore Mode";
        }
        else if (FlxG.level>=13 && FlxG.level <= 24) {
            heading.text=@"Factory - Hardcore Mode";
        }
        else if (FlxG.level>=25 && FlxG.level <= 36) {
            heading.text=@"Management - Hardcore Mode";
        }
        
        largeHCText.x=480;
        largeHCText.visible=YES;
        largeHCText.velocity = CGPointMake(-400, 0);
        
        if (![FlxG playing:@"tagtone3.caf"])
            [FlxG play:@"tagtone3.caf" withVolume:1.0 looped:NO];
        
        [FlxG pauseMusic];
        
        starhc1.scale = starhc2.scale = starhc3.scale = starhc4.scale = starhc5.scale = starhc6.scale = starhc7.scale = starhc8.scale = starhc9.scale = starhc10.scale = starhc11.scale = starhc12.scale=CGPointMake(0, 0);
        
        star1.visible = star2.visible = star3.visible = star4.visible = star5.visible = star6.visible = star7.visible = star8.visible = star9.visible = star10.visible = star11.visible = star12.visible=NO;
        
        starhc1.visible = starhc2.visible = starhc3.visible = starhc4.visible = starhc5.visible = starhc6.visible = starhc7.visible = starhc8.visible = starhc9.visible = starhc10.visible = starhc11.visible = starhc12.visible=YES;       
        
        screenDarken.visible=YES;
        
        talkedToPlain1.visible = talkedToPlain2.visible = talkedToPlain3.visible = talkedToPlain4.visible = talkedToPlain5.visible = talkedToPlain6.visible = talkedToPlain7.visible = talkedToPlain8.visible = talkedToPlain9.visible = talkedToPlain10.visible = talkedToPlain11.visible = talkedToPlain12.visible=NO; 
        
        talkedToAndre1.visible = talkedToAndre2.visible = talkedToAndre3.visible = talkedToAndre4.visible = talkedToAndre5.visible = talkedToAndre6.visible = talkedToAndre7.visible = talkedToAndre8.visible = talkedToAndre9.visible = talkedToAndre10.visible = talkedToAndre11.visible = talkedToAndre12.visible=NO; 
        
        talkedToPlainHC1.visible = talkedToPlainHC2.visible = talkedToPlainHC3.visible = talkedToPlainHC4.visible = talkedToPlainHC5.visible = talkedToPlainHC6.visible = talkedToPlainHC7.visible = talkedToPlainHC8.visible = talkedToPlainHC9.visible = talkedToPlainHC10.visible = talkedToPlainHC11.visible = talkedToPlainHC12.visible=YES; 
        
        talkedToAndreHC1.visible = talkedToAndreHC2.visible = talkedToAndreHC3.visible = talkedToAndreHC4.visible = talkedToAndreHC5.visible = talkedToAndreHC6.visible = talkedToAndreHC7.visible = talkedToAndreHC8.visible = talkedToAndreHC9.visible = talkedToAndreHC10.visible = talkedToAndreHC11.visible = talkedToAndreHC12.visible=YES; 
        
        l1Btn.visible = l2Btn.visible = l3Btn.visible = l4Btn.visible = l5Btn.visible = l6Btn.visible = l7Btn.visible = l8Btn.visible = l9Btn.visible = l10Btn.visible = l11Btn.visible = l12Btn.visible=NO;
        
        lockedGraphic2Btn.visible = lockedGraphic3Btn.visible = lockedGraphic4Btn.visible = lockedGraphic5Btn.visible = lockedGraphic6Btn.visible = lockedGraphic7Btn.visible = lockedGraphic8Btn.visible = lockedGraphic9Btn.visible = lockedGraphic10Btn.visible = lockedGraphic11Btn.visible = lockedGraphic12Btn.visible=NO;
        
        l1BtnHC.visible = l2BtnHC.visible = l3BtnHC.visible = l4BtnHC.visible = l5BtnHC.visible = l6BtnHC.visible = l7BtnHC.visible = l8BtnHC.visible = l9BtnHC.visible = l10BtnHC.visible = l11BtnHC.visible = l12BtnHC.visible=YES;
        
        lockedGraphic2BtnHC.visible = lockedGraphic3BtnHC.visible = lockedGraphic4BtnHC.visible = lockedGraphic5BtnHC.visible = lockedGraphic6BtnHC.visible = lockedGraphic7BtnHC.visible = lockedGraphic8BtnHC.visible = lockedGraphic9BtnHC.visible = lockedGraphic10BtnHC.visible = lockedGraphic11BtnHC.visible = lockedGraphic12BtnHC.visible=YES;
        
    }
    else if (!FlxG.hardCoreMode) {

        hcButton.visible=YES;
        normalButton.visible=NO;
        //[FlxG playMusic:@"echo.mp3"];
        [FlxG stop:@"tagtone3.caf"];
        
        if (FlxG.level>=1 && FlxG.level <= 12) {
            heading.text=@"Warehouse";
        }
        else if (FlxG.level>=13 && FlxG.level <= 24) {
            heading.text=@"Factory";
        }
        else if (FlxG.level>=25 && FlxG.level <= 36) {
            heading.text=@"Management";
        }
        largeHCText.visible=NO;
        
        star1.scale = star2.scale = star3.scale = star4.scale = star5.scale = star6.scale = star7.scale = star8.scale = star9.scale = star10.scale = star11.scale = star12.scale=CGPointMake(0, 0);
        

        star1.visible = star2.visible = star3.visible = star4.visible = star5.visible = star6.visible = star7.visible = star8.visible = star9.visible = star10.visible = star11.visible = star12.visible=YES;
        

        starhc1.visible = starhc2.visible = starhc3.visible = starhc4.visible = starhc5.visible = starhc6.visible = starhc7.visible = starhc8.visible = starhc9.visible = starhc10.visible = starhc11.visible = starhc12.visible=NO;  
        
        screenDarken.visible=NO;        
        
        talkedToPlain1.visible = talkedToPlain2.visible = talkedToPlain3.visible = talkedToPlain4.visible = talkedToPlain5.visible = talkedToPlain6.visible = talkedToPlain7.visible = talkedToPlain8.visible = talkedToPlain9.visible = talkedToPlain10.visible = talkedToPlain11.visible = talkedToPlain12.visible=YES; 
        
        talkedToAndre1.visible = talkedToAndre2.visible = talkedToAndre3.visible = talkedToAndre4.visible = talkedToAndre5.visible = talkedToAndre6.visible = talkedToAndre7.visible = talkedToAndre8.visible = talkedToAndre9.visible = talkedToAndre10.visible = talkedToAndre11.visible = talkedToAndre12.visible=YES; 
        
        talkedToPlainHC1.visible = talkedToPlainHC2.visible = talkedToPlainHC3.visible = talkedToPlainHC4.visible = talkedToPlainHC5.visible = talkedToPlainHC6.visible = talkedToPlainHC7.visible = talkedToPlainHC8.visible = talkedToPlainHC9.visible = talkedToPlainHC10.visible = talkedToPlainHC11.visible = talkedToPlainHC12.visible=NO; 
        
        talkedToAndreHC1.visible = talkedToAndreHC2.visible = talkedToAndreHC3.visible = talkedToAndreHC4.visible = talkedToAndreHC5.visible = talkedToAndreHC6.visible = talkedToAndreHC7.visible = talkedToAndreHC8.visible = talkedToAndreHC9.visible = talkedToAndreHC10.visible = talkedToAndreHC11.visible = talkedToAndreHC12.visible=NO; 
        
        l1Btn.visible = l2Btn.visible = l3Btn.visible = l4Btn.visible = l5Btn.visible = l6Btn.visible = l7Btn.visible = l8Btn.visible = l9Btn.visible = l10Btn.visible = l11Btn.visible = l12Btn.visible=YES;
        
        lockedGraphic2Btn.visible = lockedGraphic3Btn.visible = lockedGraphic4Btn.visible = lockedGraphic5Btn.visible = lockedGraphic6Btn.visible = lockedGraphic7Btn.visible = lockedGraphic8Btn.visible = lockedGraphic9Btn.visible = lockedGraphic10Btn.visible = lockedGraphic11Btn.visible = lockedGraphic12Btn.visible=YES;
        
        l1BtnHC.visible = l2BtnHC.visible = l3BtnHC.visible = l4BtnHC.visible = l5BtnHC.visible = l6BtnHC.visible = l7BtnHC.visible = l8BtnHC.visible = l9BtnHC.visible = l10BtnHC.visible = l11BtnHC.visible = l12BtnHC.visible=NO;
        
        lockedGraphic2BtnHC.visible = lockedGraphic3BtnHC.visible = lockedGraphic4BtnHC.visible = lockedGraphic5BtnHC.visible = lockedGraphic6BtnHC.visible = lockedGraphic7BtnHC.visible = lockedGraphic8BtnHC.visible = lockedGraphic9BtnHC.visible = lockedGraphic10BtnHC.visible = lockedGraphic11BtnHC.visible = lockedGraphic12BtnHC.visible=NO;
        
    }
    
}


- (void) startAsHardCoreMode
{    
    hcButton.visible=NO;
    normalButton.visible=YES;
    
    if (FlxG.level>=1 && FlxG.level <= 12) {
        heading.text=@"Warehouse - Hardcore Mode";
    }
    else if (FlxG.level>=13 && FlxG.level <= 24) {
        heading.text=@"Factory - Hardcore Mode";
    }
    else if (FlxG.level>=25 && FlxG.level <= 36) {
        heading.text=@"Management - Hardcore Mode";
    }
    
    largeHCText.x=480;
    largeHCText.visible=YES;
    largeHCText.velocity = CGPointMake(-400, 0);
    
    if (![FlxG playing:@"tagtone3.caf"])
        [FlxG play:@"tagtone3.caf" withVolume:1.0 looped:NO];
        
    star1.visible = star2.visible = star3.visible = star4.visible = star5.visible = star6.visible = star7.visible = star8.visible = star9.visible = star10.visible = star11.visible = star12.visible=NO;
    
    starhc1.visible = starhc2.visible = starhc3.visible = starhc4.visible = starhc5.visible = starhc6.visible = starhc7.visible = starhc8.visible = starhc9.visible = starhc10.visible = starhc11.visible = starhc12.visible=YES;       
    
    screenDarken.visible=YES;
    
    talkedToPlain1.visible = talkedToPlain2.visible = talkedToPlain3.visible = talkedToPlain4.visible = talkedToPlain5.visible = talkedToPlain6.visible = talkedToPlain7.visible = talkedToPlain8.visible = talkedToPlain9.visible = talkedToPlain10.visible = talkedToPlain11.visible = talkedToPlain12.visible=NO; 
    
    talkedToAndre1.visible = talkedToAndre2.visible = talkedToAndre3.visible = talkedToAndre4.visible = talkedToAndre5.visible = talkedToAndre6.visible = talkedToAndre7.visible = talkedToAndre8.visible = talkedToAndre9.visible = talkedToAndre10.visible = talkedToAndre11.visible = talkedToAndre12.visible=NO; 
    
    talkedToPlainHC1.visible = talkedToPlainHC2.visible = talkedToPlainHC3.visible = talkedToPlainHC4.visible = talkedToPlainHC5.visible = talkedToPlainHC6.visible = talkedToPlainHC7.visible = talkedToPlainHC8.visible = talkedToPlainHC9.visible = talkedToPlainHC10.visible = talkedToPlainHC11.visible = talkedToPlainHC12.visible=YES; 
    
    talkedToAndreHC1.visible = talkedToAndreHC2.visible = talkedToAndreHC3.visible = talkedToAndreHC4.visible = talkedToAndreHC5.visible = talkedToAndreHC6.visible = talkedToAndreHC7.visible = talkedToAndreHC8.visible = talkedToAndreHC9.visible = talkedToAndreHC10.visible = talkedToAndreHC11.visible = talkedToAndreHC12.visible=YES;     
        
    
    
    l1Btn.visible = l2Btn.visible = l3Btn.visible = l4Btn.visible = l5Btn.visible = l6Btn.visible = l7Btn.visible = l8Btn.visible = l9Btn.visible = l10Btn.visible = l11Btn.visible = l12Btn.visible=NO;
    
    lockedGraphic2Btn.visible = lockedGraphic3Btn.visible = lockedGraphic4Btn.visible = lockedGraphic5Btn.visible = lockedGraphic6Btn.visible = lockedGraphic7Btn.visible = lockedGraphic8Btn.visible = lockedGraphic9Btn.visible = lockedGraphic10Btn.visible = lockedGraphic11Btn.visible = lockedGraphic12Btn.visible=NO;
    
    l1BtnHC.visible = l2BtnHC.visible = l3BtnHC.visible = l4BtnHC.visible = l5BtnHC.visible = l6BtnHC.visible = l7BtnHC.visible = l8BtnHC.visible = l9BtnHC.visible = l10BtnHC.visible = l11BtnHC.visible = l12BtnHC.visible=YES;
    
    lockedGraphic2BtnHC.visible = lockedGraphic3BtnHC.visible = lockedGraphic4BtnHC.visible = lockedGraphic5BtnHC.visible = lockedGraphic6BtnHC.visible = lockedGraphic7BtnHC.visible = lockedGraphic8BtnHC.visible = lockedGraphic9BtnHC.visible = lockedGraphic10BtnHC.visible = lockedGraphic11BtnHC.visible = lockedGraphic12BtnHC.visible=YES;
    
    
}

- (void) onHCExplain
{

    [FlxG playWithParam1:@"error.caf" param2:1.0 param3:NO];
    [[FlxG quake] startWithIntensity:0.01 duration:0.2];
    
    if (FlxG.gamePad!=0) {
        [FlxG showAlertWithTitle:@"Hardcore mode is locked" message:@"Collect all twelve bottle caps on this world to unlock harder and faster levels."];
        
    }
    else if (FlxG.gamePad==0) {
        [FlxG showUIAlertWithTitle:@"Hardcore mode is locked" message:@"Collect all twelve bottle caps on this world to unlock harder and faster levels."];
    }
    
}

- (void) dontPlayLevel
{
    [FlxG playWithParam1:@"error.caf" param2:1.0 param3:NO];
    [[FlxG quake] startWithIntensity:0.01 duration:0.2];
    
    
    //[FlxG showAlertWithTitle:@"This level is locked" message:@"Complete the previous level to unlock."];
    
}



- (void) setAllButtonsToNotSelected;
{
    l1Btn._selected=NO;
    l2Btn._selected=NO;
    l3Btn._selected=NO;
    l4Btn._selected=NO;
    l5Btn._selected=NO;
    l6Btn._selected=NO;
    l7Btn._selected=NO;
    l8Btn._selected=NO;
    l9Btn._selected=NO;
    l10Btn._selected=NO;
    l11Btn._selected=NO;
    l12Btn._selected=NO;

    l1BtnHC._selected=NO;
    l2BtnHC._selected=NO;
    l3BtnHC._selected=NO;
    l4BtnHC._selected=NO;
    l5BtnHC._selected=NO;
    l6BtnHC._selected=NO;
    l7BtnHC._selected=NO;
    l8BtnHC._selected=NO;
    l9BtnHC._selected=NO;
    l10BtnHC._selected=NO;
    l11BtnHC._selected=NO;
    l12BtnHC._selected=NO;
    
    hcButtonExplain._selected=NO;
    hcButton._selected=NO;
    backBtn._selected=NO;
    normalButton._selected=NO;
    
    
}

@end

