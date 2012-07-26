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

#import "StatsState.h"

#import "EnemyArmy.h"
#import "EnemyChef.h"
#import "EnemyInspector.h"
#import "EnemyWorker.h"
#import "Enemy.h"

#import "EnemyGeneric.h"

#import "FlxImageInfo.h"

#define NUMBER_OF_LEVELS 24;

int c; 

static NSString * SndBack = @"ping2.caf";

static NSString * ImgEmptyButton = @"emptySmallButtonM.png";
static NSString * ImgEmptyButtonPressed = @"emptySmallButtonPressedM.png";
static NSString * ImgBgGrad = @"level3_gradient.png";
static NSString * SndSwipe = @"whoosh.caf";

BOOL areYouSure;

FlxButton * clear;
FlxButton * clearSure;
FlxButton * clearDone;

FlxSprite * bgCity;
FlxSprite * bgClouds;


FlxText * pageStatus;
FlxText * achText;

FlxText * killedBy;
FlxText * totalCrates;

//FlxText * hardcoreStatus;


FlxText * headingText;
FlxText * headingTextShadow;

NSInteger hc;
NSInteger levelsPoints, levelsComplete;
NSInteger hclevelsPoints, hclevelsComplete ;

@implementation StatsState

- (id) init
{
	if ((self = [super init])) {
		self.bgColor = 0xdfc296;
	}
	return self;
}

- (void) create
{            
    [FlxG checkAchievement:kViewStats];
    upperPart=NO;
    
    areYouSure=NO;
    
    FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:320];  
    [grad loadGraphic:ImgBgGrad];
    [self add:grad]; 
    
    FlxTileblock * gradTopBar = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:40];  
    [gradTopBar loadGraphic:@"level3_tiles.png" empties:0 autoTile:YES];
    [self add:gradTopBar]; 
    
    gradTopBar = [FlxTileblock tileblockWithX:0 y:FlxG.height-40 width:FlxG.width height:40];  
    [gradTopBar loadGraphic:@"level3_tiles.png" empties:0 autoTile:YES];
    [self add:gradTopBar]; 
    
    //[self loadLevelBlocksFromImage];

    headingText = [FlxText textWithWidth:FlxG.width
                                    text:@"STATISTICS"
                                    font:@"SmallPixel"
                                    size:16.0];
	headingText.color = 0xffb24714;
	headingText.alignment = @"center";
	headingText.x = 0;
	headingText.y = 8;
	[self add:headingText];
    
    back = [[[FlxButton alloc]      initWithX:20
                                            y:FlxG.height-40
                                     callback:[FlashFunction functionWithTarget:self
                                                                         action:@selector(onBack)]] autorelease];
    [back loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgEmptyButton] param2:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed]  param3:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed]];
    [back loadTextWithParam1:[FlxText textWithWidth:back.width
                                                   text:NSLocalizedString(@"back", @"back")
                                                   font:@"SmallPixel"
                                                   size:16.0] param2:[FlxText textWithWidth:back.width
                                                                                       text:NSLocalizedString(@"back ...", @"back ...")
                                                                                       font:@"SmallPixel"
                                                                                       size:16.0] withXOffset:0 withYOffset:back.height/4] ;
	
	[self add:back];
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSInteger existingNumberOfArmyKilledBy = [prefs integerForKey:@"KILLED_BY_ARMY"];
    
    NSInteger existingNumberOfChefKilledBy = [prefs integerForKey:@"KILLED_BY_CHEF"];
    
    NSInteger existingNumberOfInspectorKilledBy = [prefs integerForKey:@"KILLED_BY_INSPECTOR"];
    
    NSInteger existingNumberOfWorkerKilledBy = [prefs integerForKey:@"KILLED_BY_WORKER"];

    NSInteger level1,level2,level3,level4,level5,
    level6, level7,level8,level9,level10,
    level11,level12,level13,level14,level15,
    level16, level17,level18,level19,level20,
    level21,level22,level23,level24    ,level25,
    level26,level27,level28,level29, level30,
    level31,level32,level33,level34,level35,level36;
    
    NSInteger hclevel1,hclevel2,hclevel3,hclevel4,hclevel5,
    hclevel6, hclevel7,hclevel8,hclevel9,hclevel10,
    hclevel11,hclevel12,hclevel13,hclevel14,hclevel15,
    hclevel16,hclevel17,hclevel18,hclevel19,hclevel20,
    hclevel21,hclevel22,hclevel23,hclevel24    ,hclevel25,
    hclevel26,hclevel27,hclevel28,hclevel29, hclevel30,
    hclevel31,hclevel32,hclevel33,hclevel34,hclevel35,hclevel36;
    
    
    
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

      level13 = [prefs integerForKey:@"level13"];
      level14 = [prefs integerForKey:@"level14"];
      level15 = [prefs integerForKey:@"level15"];
      level16 = [prefs integerForKey:@"level16"];
      level17 = [prefs integerForKey:@"level17"];
      level18 = [prefs integerForKey:@"level18"];
      level19 = [prefs integerForKey:@"level19"];
      level20 = [prefs integerForKey:@"level20"];
      level21 = [prefs integerForKey:@"level21"];
      level22 = [prefs integerForKey:@"level22"];
      level23 = [prefs integerForKey:@"level23"];
      level24 = [prefs integerForKey:@"level24"];

      level25 = [prefs integerForKey:@"level25"];
      level26 = [prefs integerForKey:@"level26"];
      level27 = [prefs integerForKey:@"level27"];
      level28 = [prefs integerForKey:@"level28"];
      level29 = [prefs integerForKey:@"level29"];
      level30 = [prefs integerForKey:@"level30"];
      level31 = [prefs integerForKey:@"level31"];
      level32 = [prefs integerForKey:@"level32"];
      level33 = [prefs integerForKey:@"level33"];
      level34 = [prefs integerForKey:@"level34"];
      level35 = [prefs integerForKey:@"level35"];
      level36 = [prefs integerForKey:@"level36"];    

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

      hclevel13 = [prefs integerForKey:@"hclevel13"];
      hclevel14 = [prefs integerForKey:@"hclevel14"];
      hclevel15 = [prefs integerForKey:@"hclevel15"];
      hclevel16 = [prefs integerForKey:@"hclevel16"];
      hclevel17 = [prefs integerForKey:@"hclevel17"];
      hclevel18 = [prefs integerForKey:@"hclevel18"];
      hclevel19 = [prefs integerForKey:@"hclevel19"];
      hclevel20 = [prefs integerForKey:@"hclevel20"];
      hclevel21 = [prefs integerForKey:@"hclevel21"];
      hclevel22 = [prefs integerForKey:@"hclevel22"];
      hclevel23 = [prefs integerForKey:@"hclevel23"];
      hclevel24 = [prefs integerForKey:@"hclevel24"];

      hclevel25 = [prefs integerForKey:@"hclevel25"];
      hclevel26 = [prefs integerForKey:@"hclevel26"];
      hclevel27 = [prefs integerForKey:@"hclevel27"];
      hclevel28 = [prefs integerForKey:@"hclevel28"];
      hclevel29 = [prefs integerForKey:@"hclevel29"];
      hclevel30 = [prefs integerForKey:@"hclevel30"];
      hclevel31 = [prefs integerForKey:@"hclevel31"];
      hclevel32 = [prefs integerForKey:@"hclevel32"];
      hclevel33 = [prefs integerForKey:@"hclevel33"];
      hclevel34 = [prefs integerForKey:@"hclevel34"];
      hclevel35 = [prefs integerForKey:@"hclevel35"];
      hclevel36 = [prefs integerForKey:@"hclevel36"]; 
    
    
    levelsComplete = 0;
    if (level1>=1) levelsComplete++;
    if (level2>=1) levelsComplete++;
    if (level3>=1) levelsComplete++;
    if (level4>=1) levelsComplete++;
    if (level5>=1) levelsComplete++;
    if (level6>=1) levelsComplete++;
    if (level7>=1) levelsComplete++;
    if (level8>=1) levelsComplete++;
    if (level9>=1) levelsComplete++;
    if (level10>=1) levelsComplete++;
    
    if (level11>=1) levelsComplete++;
    if (level12>=1) levelsComplete++;
    if (level13>=1) levelsComplete++;
    if (level14>=1) levelsComplete++;
    if (level15>=1) levelsComplete++;
    if (level16>=1) levelsComplete++;
    if (level17>=1) levelsComplete++;
    if (level18>=1) levelsComplete++;
    if (level19>=1) levelsComplete++;
    if (level20>=1) levelsComplete++;

    if (level21>=1) levelsComplete++;
    if (level22>=1) levelsComplete++;
    if (level23>=1) levelsComplete++;
    if (level24>=1) levelsComplete++;
    if (level25>=1) levelsComplete++;
    if (level26>=1) levelsComplete++;
    if (level27>=1) levelsComplete++;
    if (level28>=1) levelsComplete++;
    if (level29>=1) levelsComplete++;
    if (level30>=1) levelsComplete++;   
    if (level31>=1) levelsComplete++;
    if (level32>=1) levelsComplete++;
    if (level33>=1) levelsComplete++;
    if (level34>=1) levelsComplete++;
    if (level35>=1) levelsComplete++;
    if (level36>=1) levelsComplete++; 

    
    levelsPoints = level1+level2+level3+level4+level5+
    level6+ level7+level8+level9+level10+
    level11+level12+level13+level14+level15+
    level16+ level17+level18+level19+level20+
    level21+level22+level23+level24    +level25+
    level26+level27+level28+level29+ level30+
    level31+level32+level33+level34+level35+level36 - levelsComplete;
    
    hclevelsComplete = 0;
    if (hclevel1>=1) hclevelsComplete++;
    if (hclevel2>=1) hclevelsComplete++;
    if (hclevel3>=1) hclevelsComplete++;
    if (hclevel4>=1) hclevelsComplete++;
    if (hclevel5>=1) hclevelsComplete++;
    if (hclevel6>=1) hclevelsComplete++;
    if (hclevel7>=1) hclevelsComplete++;
    if (hclevel8>=1) hclevelsComplete++;
    if (hclevel9>=1) hclevelsComplete++;
    if (hclevel10>=1) hclevelsComplete++;
    
    if (hclevel11>=1) hclevelsComplete++;
    if (hclevel12>=1) hclevelsComplete++;
    if (hclevel13>=1) hclevelsComplete++;
    if (hclevel14>=1) hclevelsComplete++;
    if (hclevel15>=1) hclevelsComplete++;
    if (hclevel16>=1) hclevelsComplete++;
    if (hclevel17>=1) hclevelsComplete++;
    if (hclevel18>=1) hclevelsComplete++;
    if (hclevel19>=1) hclevelsComplete++;
    if (hclevel20>=1) hclevelsComplete++;
    
    if (hclevel21>=1) hclevelsComplete++;
    if (hclevel22>=1) hclevelsComplete++;
    if (hclevel23>=1) hclevelsComplete++;
    if (hclevel24>=1) hclevelsComplete++;
    if (hclevel25>=1) hclevelsComplete++;
    if (hclevel26>=1) hclevelsComplete++;
    if (hclevel27>=1) hclevelsComplete++;
    if (hclevel28>=1) hclevelsComplete++;
    if (hclevel29>=1) hclevelsComplete++;
    if (hclevel30>=1) hclevelsComplete++;   
    if (hclevel31>=1) hclevelsComplete++;
    if (hclevel32>=1) hclevelsComplete++;
    if (hclevel33>=1) hclevelsComplete++;
    if (hclevel34>=1) hclevelsComplete++;
    if (hclevel35>=1) hclevelsComplete++;
    if (hclevel36>=1) hclevelsComplete++; 
    
    
    hclevelsPoints = hclevel1+hclevel2+hclevel3+hclevel4+hclevel5+
    hclevel6+ hclevel7+hclevel8+hclevel9+hclevel10+
    hclevel11+hclevel12+hclevel13+hclevel14+hclevel15+
    hclevel16+ hclevel17+hclevel18+hclevel19+hclevel20+
    hclevel21+hclevel22+hclevel23+hclevel24    +hclevel25+
    hclevel26+hclevel27+hclevel28+hclevel29+ hclevel30+
    hclevel31+hclevel32+hclevel33+hclevel34+hclevel35+hclevel36 - hclevelsComplete;
    
    //NSLog(@"%f%f%f%f", perc, hcperc, levelsPointsPerc, hclevelsPointsPerc);
    
    hc = [prefs integerForKey:@"HARDCORE_MODE"];
    
//    hardcoreStatus = [FlxText textWithWidth:FlxG.width
//                                       text:@""
//                                       font:@"SmallPixel"
//                                       size:16];
//	hardcoreStatus.color = 0xffb24714;
//	hardcoreStatus.alignment = @"left";
//	hardcoreStatus.x = 3;
//	hardcoreStatus.y = 190;
//	[self add:hardcoreStatus];
    
    totalCrates = [FlxText textWithWidth:FlxG.width
                            text:@"0"
                            font:@"SmallPixel"
                            size:16];
	totalCrates.color = 0xffb24714;
	totalCrates.alignment = @"left";
	totalCrates.x = 3;
	totalCrates.y = 110;
	[self add:totalCrates];
    NSString *tc;
    if (levelsPoints!=36){
        tc = [NSString stringWithFormat:@"Levels Unlocked: %d of 36.\nBottle Caps: %d of 36\n36 caps to unlock hardcore mode.", levelsComplete, levelsPoints];
    }
    else if (levelsPoints==36){
        tc = [NSString stringWithFormat:@"Levels Unlocked: %d of 36.\nBottle Caps: %d of 36\nHardcore Levels Unlocked: %d of 36.\nHardcore Caps: %d of 36 ", levelsComplete, levelsPoints, hclevelsComplete,hclevelsPoints];
//        if (FlxG.hardCoreMode==0){
//            hardcoreStatus.text = @"Hardcore mode is off.\nSwipe up or down to change.";
//        }
//        else if (FlxG.hardCoreMode==1){
//            hardcoreStatus.text = @"Hardcore mode is on.\nSwipe up or down to change.";
//        }
        
        
    }
    totalCrates.text = (@"%@", tc);
    


    float charY=55;
    float charTextYOffset=30;
    
        
    gb = [EnemyGeneric enemyGenericWithOrigin:CGPointMake(120,100) index:0  ];
    //[gb play:@"armyTalk"];
    gb.acceleration = CGPointMake(0, 0);
    gb.velocity = CGPointMake(0, 0);
    gb.dead = NO;
    gb.x = FlxG.width*0.2;
    gb.y = charY;
    gb.visible = YES;
    [self add:gb];
    
    gbt2 = [FlxText textWithWidth:FlxG.width
                            text:@"0"
                            font:@"SmallPixel"
                            size:16];    
    
   	gbt2.color = 0xffb24714;
	gbt2.alignment = @"left";
	gbt2.x = gb.x;
	gbt2.y = gb.y+charTextYOffset;
	[self add:gbt2];
    
    NSString *intString = [NSString stringWithFormat:@"%d", existingNumberOfArmyKilledBy];
    gbt2.text = (@"%@", intString); 
    
    gs = [EnemyGeneric enemyGenericWithOrigin:CGPointMake(120,300) index:1  ];
    //[gs play:@"chefTalk"];
    gs.acceleration = CGPointMake(0, 0);
    gs.velocity = CGPointMake(0, 0);
    gs.dead = NO;
    gs.x = FlxG.width*0.4;
    gs.y = charY;
    gs.visible = YES;
    [self add:gs];
    
    gst2 = [FlxText textWithWidth:FlxG.width
                            text:@"0"
                            font:@"SmallPixel"
                            size:16];
	gst2.color = 0xffb24714;
	gst2.alignment = @"left";
	gst2.x = gs.x;
	gst2.y = gs.y+charTextYOffset;
	[self add:gst2];
    
    NSString *nsgs = [NSString stringWithFormat:@"%d", existingNumberOfChefKilledBy];
    gst2.text = (@"%@", nsgs);
    
    rb = [EnemyGeneric enemyGenericWithOrigin:CGPointMake(120,300) index:2  ];
    //[rb play:@"inspectorListen"];
    rb.acceleration = CGPointMake(0, 0);
    rb.velocity = CGPointMake(0, 0);
    rb.dead = NO;
    rb.x = FlxG.width*0.6;
    rb.y = charY;
    rb.visible = YES;
    [self add:rb];
    
    rbt2 = [FlxText textWithWidth:FlxG.width
                            text:@"0"
                            font:@"SmallPixel"
                            size:16];
	rbt2.color = 0xffb24714;
	rbt2.alignment = @"left";
	rbt2.x = rb.x;
	rbt2.y = rb.y+charTextYOffset;
	[self add:rbt2];
    
    NSString *nsrb = [NSString stringWithFormat:@"%d", existingNumberOfInspectorKilledBy];
    rbt2.text = (@"%@", nsrb);
    
    rs = [EnemyGeneric enemyGenericWithOrigin:CGPointMake(120,300) index:3  ];
    //[rs play:@"workerTalk"];
    rs.acceleration = CGPointMake(0, 0);
    rs.velocity = CGPointMake(0, 0);
    rs.dead = NO;
    rs.x = FlxG.width*0.8;
    rs.y = charY;
    rs.visible = YES;
    [self add:rs];
    
    rst2 = [FlxText textWithWidth:FlxG.width
                            text:@"0"
                            font:@"SmallPixel"
                            size:16];
	rst2.color = 0xffb24714;
	rst2.alignment = @"left";
	rst2.x = rs.x;
	rst2.y = rs.y+charTextYOffset;
	[self add:rst2];
    
    NSString *nsrs = [NSString stringWithFormat:@"%d", existingNumberOfWorkerKilledBy];
    rst2.text = (@"%@", nsrs); 
    
    
    killedBy = [FlxText textWithWidth:FlxG.width
                                           text:@"Killed By"
                                           font:@"SmallPixel"
                                           size:16];
	killedBy.color = 0xffb24714;
	killedBy.alignment = @"left";
	killedBy.x = 3;
	killedBy.y = charY;
	[self add:killedBy];
    
    achText = [FlxText textWithWidth:FlxG.width
                                 text:@"View Stats\nView Credits\nUnlock All Warehouse Levels\nCollected Bottle on All warehouse levels\nUnlock all factory levels\nCollected Bottle on all Factory levels\nUnlock all Management levels\nCollected Bottle on all managements levels\nAll 36 Caps\nUnlock All Hardcore Warehouse Levels\nCollected Bottle on All Hardcore warehouse levels\nUnlock all Hardcore factory levels\nCollected Bottle on all Hardcore Factory levels\nUnlock all Hardcore Management levels\nCollected Bottle on all Hardcore managements levels\nAll 36 Hardcore Caps\nTalk to all employees\nTalk to Andre on all levels\nTalk to all employees on hardcore levels\nTalk to Andre on all hardcore levels\n   "
                                 font:@"SmallPixel"
                                 size:8];
	achText.color = 0xffb24714;
	achText.alignment = @"left";
	achText.x = 25;
	achText.y = charY-5;
    achText.visible=NO;
	[self add:achText];  
    
    //x marks
    
    float offset = 9.625;
    
    
    achx1 = [FlxText textWithWidth:FlxG.width
                                text:@""
                                font:@"SmallPixel"
                                size:8];
	achx1.color = 0xffb24714;
	achx1.alignment = @"left";
	achx1.x = 15;
	achx1.y = charY-5;
    achx1.visible=NO;
	[self add:achx1]; 
    
    achx2 = [FlxText textWithWidth:FlxG.width
                              text:@""
                              font:@"SmallPixel"
                              size:8];
	achx2.color = 0xffb24714;
	achx2.alignment = @"left";
	achx2.x = 15;
	achx2.y = charY-5 + ( offset * 1.0) ;
    achx2.visible=NO;
	[self add:achx2]; 
    
    achx3 = [FlxText textWithWidth:FlxG.width
                              text:@""
                              font:@"SmallPixel"
                              size:8];
	achx3.color = 0xffb24714;
	achx3.alignment = @"left";
	achx3.x = 15;
	achx3.y = charY-5 + ( offset * 2) ;
    achx3.visible=NO;
	[self add:achx3]; 
    
    achx4 = [FlxText textWithWidth:FlxG.width
                              text:@""
                              font:@"SmallPixel"
                              size:8];
	achx4.color = 0xffb24714;
	achx4.alignment = @"left";
	achx4.x = 15;
	achx4.y = charY-5 + ( offset * 3) ;
    achx4.visible=NO;
	[self add:achx4]; 
    
    achx5 = [FlxText textWithWidth:FlxG.width
                              text:@""
                              font:@"SmallPixel"
                              size:8];
	achx5.color = 0xffb24714;
	achx5.alignment = @"left";
	achx5.x = 15;
	achx5.y = charY-5 + ( offset * 4) ;
    achx5.visible=NO;
	[self add:achx5]; 
    
    achx6 = [FlxText textWithWidth:FlxG.width
                              text:@""
                              font:@"SmallPixel"
                              size:8];
	achx6.color = 0xffb24714;
	achx6.alignment = @"left";
	achx6.x = 15;
	achx6.y = charY-5 + ( offset * 5) ;
    achx6.visible=NO;
	[self add:achx6]; 
    
    achx7 = [FlxText textWithWidth:FlxG.width
                              text:@""
                              font:@"SmallPixel"
                              size:8];
	achx7.color = 0xffb24714;
	achx7.alignment = @"left";
	achx7.x = 15;
	achx7.y = charY-5 + ( offset * 6) ;
    achx7.visible=NO;
	[self add:achx7]; 
    
    achx8 = [FlxText textWithWidth:FlxG.width
                              text:@""
                              font:@"SmallPixel"
                              size:8];
	achx8.color = 0xffb24714;
	achx8.alignment = @"left";
	achx8.x = 15;
	achx8.y = charY-5 + ( offset * 7) ;
    achx8.visible=NO;
	[self add:achx8]; 
    
    achx9 = [FlxText textWithWidth:FlxG.width
                              text:@""
                              font:@"SmallPixel"
                              size:8];
	achx9.color = 0xffb24714;
	achx9.alignment = @"left";
	achx9.x = 15;
	achx9.y = charY-5 + ( offset * 8) ;
    achx9.visible=NO;
	[self add:achx9];     
    
    achx10 = [FlxText textWithWidth:FlxG.width
                              text:@""
                              font:@"SmallPixel"
                              size:8];
	achx10.color = 0xffb24714;
	achx10.alignment = @"left";
	achx10.x = 15;
	achx10.y = charY-5 + ( offset * 9) ;
    achx10.visible=NO;
	[self add:achx10]; 
    
    achx11 = [FlxText textWithWidth:FlxG.width
                               text:@""
                               font:@"SmallPixel"
                               size:8];
	achx11.color = 0xffb24714;
	achx11.alignment = @"left";
	achx11.x = 15;
	achx11.y = charY-5 + ( offset * 10) ;
    achx11.visible=NO;
	[self add:achx11];    
    
    achx12 = [FlxText textWithWidth:FlxG.width
                               text:@""
                               font:@"SmallPixel"
                               size:8];
	achx12.color = 0xffb24714;
	achx12.alignment = @"left";
	achx12.x = 15;
	achx12.y = charY-5 + ( offset * 11) ;
    achx12.visible=NO;
	[self add:achx12]; 
    
    achx13 = [FlxText textWithWidth:FlxG.width
                               text:@""
                               font:@"SmallPixel"
                               size:8];
	achx13.color = 0xffb24714;
	achx13.alignment = @"left";
	achx13.x = 15;
	achx13.y = charY-5 + ( offset * 12) ;
    achx13.visible=NO;
	[self add:achx13]; 
    
    achx14 = [FlxText textWithWidth:FlxG.width
                               text:@""
                               font:@"SmallPixel"
                               size:8];
	achx14.color = 0xffb24714;
	achx14.alignment = @"left";
	achx14.x = 15;
	achx14.y = charY-5 + ( offset * 13) ;
    achx14.visible=NO;
	[self add:achx14]; 
    
    achx15 = [FlxText textWithWidth:FlxG.width
                               text:@""
                               font:@"SmallPixel"
                               size:8];
	achx15.color = 0xffb24714;
	achx15.alignment = @"left";
	achx15.x = 15;
	achx15.y = charY-5 + ( offset * 14) ;
    achx15.visible=NO;
	[self add:achx15]; 
    
    achx16 = [FlxText textWithWidth:FlxG.width
                               text:@""
                               font:@"SmallPixel"
                               size:8];
	achx16.color = 0xffb24714;
	achx16.alignment = @"left";
	achx16.x = 15;
	achx16.y = charY-5 + ( offset * 15) ;
    achx16.visible=NO;
	[self add:achx16]; 
    
    achx17 = [FlxText textWithWidth:FlxG.width
                               text:@""
                               font:@"SmallPixel"
                               size:8];
	achx17.color = 0xffb24714;
	achx17.alignment = @"left";
	achx17.x = 15;
	achx17.y = charY-5 + ( offset * 16) ;
    achx17.visible=NO;
	[self add:achx17]; 
    
    achx18 = [FlxText textWithWidth:FlxG.width
                               text:@""
                               font:@"SmallPixel"
                               size:8];
	achx18.color = 0xffb24714;
	achx18.alignment = @"left";
	achx18.x = 15;
	achx18.y = charY-5 + ( offset * 17) ;
    achx18.visible=NO;
	[self add:achx18]; 
    
    achx19 = [FlxText textWithWidth:FlxG.width
                               text:@""
                               font:@"SmallPixel"
                               size:8];
	achx19.color = 0xffb24714;
	achx19.alignment = @"left";
	achx19.x = 15;
	achx19.y = charY-5 + ( offset * 18) ;
    achx19.visible=NO;
	[self add:achx19]; 
    
    achx20 = [FlxText textWithWidth:FlxG.width
                               text:@""
                               font:@"SmallPixel"
                               size:8];
	achx20.color = 0xffb24714;
	achx20.alignment = @"left";
	achx20.x = 15;
	achx20.y = charY-5 + ( offset * 19) ;
    achx20.visible=NO;
	[self add:achx20];     
    
    
    
    pageStatus = [FlxText textWithWidth:FlxG.width
                                 text:@">> Swipe Right For Achievements >>"
                                 font:@"SmallPixel"
                                 size:16];
	pageStatus.color = 0xffb24724;
	pageStatus.alignment = @"left";
	pageStatus.x = 3;
	pageStatus.y = FlxG.height-60;
	[self add:pageStatus];
    
    
    
    clear = [[[FlxButton alloc]      initWithX:FlxG.width-182-20
                                             y:FlxG.height-40
                                      callback:[FlashFunction functionWithTarget:self
                                                                          action:@selector(onClear)]] autorelease];
    [clear loadGraphicWithParam1:[FlxSprite spriteWithGraphic:@"emptyButtonM.png"] param2:[FlxSprite spriteWithGraphic:@"emptyButtonPressedM.png"]  param3:[FlxSprite spriteWithGraphic:@"emptyButtonPressedM.png"]];
    [clear loadTextWithParam1:[FlxText textWithWidth:182
                                                text:NSLocalizedString(@"clear progress", @"clear progress")
                                                font:@"SmallPixel"
                                                size:16.0] param2:[FlxText textWithWidth:182
                                                                                    text:NSLocalizedString(@"clear progress", @"clear progress")
                                                                                    font:@"SmallPixel"
                                                                                    size:16.0] withXOffset:0 withYOffset:back.height/4] ;	
    [self add:clear];
    
    clearSure = [[[FlxButton alloc]      initWithX:FlxG.width-182-20
                                                 y:FlxG.height-40
                                          callback:[FlashFunction functionWithTarget:self
                                                                              action:@selector(onClear)]] autorelease];
    [clearSure loadGraphicWithParam1:[FlxSprite spriteWithGraphic:@"emptyButtonM.png"] param2:[FlxSprite spriteWithGraphic:@"emptyButtonPressedM.png"] param3:[FlxSprite spriteWithGraphic:@"emptyButtonPressedM.png"]];
    [clearSure loadTextWithParam1:[FlxText textWithWidth:182
                                                    text:NSLocalizedString(@"ARE YOU SURE?", @"ARE YOU SURE?")
                                                    font:@"SmallPixel"
                                                    size:16.0] param2:[FlxText textWithWidth:182
                                                                                        text:NSLocalizedString(@"ARE YOU SURE?", @"ARE YOU SURE?")
                                                                                        font:@"SmallPixel"
                                                                                        size:16.0] withXOffset:0 withYOffset:back.height/4] ;	
    clearSure.visible=NO;
    [self add:clearSure];
    
    clearDone = [[[FlxButton alloc]      initWithX:FlxG.width-182-20
                                                 y:FlxG.height-40
                                          callback:[FlashFunction functionWithTarget:self
                                                                              action:@selector(onClear)]] autorelease];
    [clearDone loadGraphicWithParam1:[FlxSprite spriteWithGraphic:@"emptyButtonM.png"] param2:[FlxSprite spriteWithGraphic:@"emptyButtonPressedM.png"] param3:[FlxSprite spriteWithGraphic:@"emptyButtonPressedM.png"]];
    [clearDone loadTextWithParam1:[FlxText textWithWidth:182
                                                    text:NSLocalizedString(@"CLEARED", @"CLEARED")
                                                    font:@"SmallPixel"
                                                    size:16.0] param2:[FlxText textWithWidth:182
                                                                                        text:NSLocalizedString(@"IT IS GONE", @"IT IS GONE")
                                                                                        font:@"SmallPixel"
                                                                                        size:16.0] withXOffset:0 withYOffset:back.height/4] ;	
    clearDone.visible=NO;
    [self add:clearDone];
    
    clear._selected=NO;
    clearSure._selected=NO;
    clearDone._selected=NO;
    
    if (FlxG.debugMode) {
        FlxSprite * debugbutton = [FlxSprite spriteWithX:0 y:200 graphic:@"debug.png"];
        debugbutton.scrollFactor = CGPointMake(0, 0);
        [self add:debugbutton];
        debugbutton = [FlxSprite spriteWithX:20 y:200 graphic:@"debug.png"];
        debugbutton.scrollFactor = CGPointMake(0, 0);
        [self add:debugbutton];        
        debugbutton = [FlxSprite spriteWithX:40 y:200 graphic:@"debug.png"];
        debugbutton.scrollFactor = CGPointMake(0, 0);
        [self add:debugbutton];
        
        debugbutton = [FlxSprite spriteWithX:60 y:200 graphic:@"debug.png"];
        debugbutton.scrollFactor = CGPointMake(0, 0);
        [self add:debugbutton];  
        debugbutton = [FlxSprite spriteWithX:80 y:200 graphic:@"debug.png"];
        debugbutton.scrollFactor = CGPointMake(0, 0);
        [self add:debugbutton];
        
    }
    
    
    int b  = [ FlxG talkToAndreProgress];
    int c = [ FlxG talkToEnemyProgress];
    int d  = [ FlxG hctalkToAndreProgress];
    int e = [ FlxG hctalkToEnemyProgress];	
    
    if (FlxG.gamePad==0) {
        back._selected=NO;
    } 
    else {
        back._selected=YES;
    }
}

- (void) dealloc
{
	[super dealloc];
}


- (void) update
{
    
    
    if (FlxG.touches.iCadeBBegan) {
        [self onBack];
        return;
    }
    
    if (FlxG.touches.iCadeABegan && back._selected) {
        [self onBack];
        return;
    }
    
    if (FlxG.touches.iCadeABegan && clear._selected) {
        [FlxG showUIAlertWithTitle:@"Use touch screen" message:@"Use touch screen to avoid accidently erasing game"];
    }
    if ((FlxG.touches.iCadeRightBegan || FlxG.touches.iCadeLeftBegan) && !upperPart) {
        if (back._selected) {
            back._selected=NO;
            clear._selected=YES;
            clearSure._selected=YES;
            clearDone._selected=YES;
            [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];
        }
        else if (clear._selected) {
            back._selected=YES;
            clear._selected=NO;
            clearSure._selected=NO;
            clearDone._selected=NO;
            [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];

        }
    }
    if (FlxG.touches.iCadeUpBegan) {
        upperPart=YES;
        [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];
        back._selected=NO;
        clear._selected=NO;
        clearSure._selected=NO;
        clearDone._selected=NO;

    }
    if (FlxG.touches.iCadeDownBegan) {
        upperPart=NO;
        [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];
        back._selected=YES;
        clear._selected=NO;
        clearSure._selected=NO;
        clearDone._selected=NO;
    }    
    
    
    
    
//    if (levelsPoints==36) {
//        if (FlxG.touches.swipedRight) {
//            [FlxG playWithParam1:@"ping2" param2:PING2_VOL param3:NO];
//
//            FlxG.hardCoreMode=1;
//            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//            [prefs setInteger:1 forKey:@"HARDCORE_MODE"];
//            [FlxG play:@"tagtone2"];
//
//            [FlxG pauseMusic];
//            hardcoreStatus.text = @"Hardcore mode is on.\nSwipe up or down to change.";
//
//        }
//        
//        
//        if (FlxG.touches.swipedLeft) {
//            [FlxG play:@"error"];
//
//            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//            [prefs setInteger:0 forKey:@"HARDCORE_MODE"];
//            FlxG.hardCoreMode=0;
//            [FlxG unpauseMusic];
//            hardcoreStatus.text = @"Hardcore mode is off.\nSwipe up or down to change.";
//
//            
//        }   
//    }
    
    //achievements
    if ( FlxG.touches.swipedRight || (FlxG.touches.iCadeRightBegan && upperPart)) {
        
        [FlxG playWithParam1:SndSwipe param2:0.14 param3:NO];
        
        totalCrates.visible=NO;
        //hardcoreStatus.visible=NO;
        gb.visible=NO;
        gs.visible=NO;
        rb.visible=NO;
        rs.visible=NO;
        gbt2.visible=NO;
        gst2.visible=NO;
        rbt2.visible=NO;
        rst2.visible=NO;
        killedBy.visible=NO;
        
        achText.visible=YES;
        achx1.visible=YES;
        achx2.visible=YES;
        achx3.visible=YES;
        achx4.visible=YES;
        achx5.visible=YES;
        achx6.visible=YES;
        achx7.visible=YES;
        achx8.visible=YES;
        achx9.visible=YES;
        
        achx10.visible=YES;
        achx11.visible=YES;
        achx12.visible=YES;
        achx13.visible=YES;
        achx14.visible=YES;
        achx15.visible=YES;
        achx16.visible=YES;
        
        achx17.visible=YES;
        achx18.visible=YES;

        achx19.visible=YES;
        achx20.visible=YES;        
        
        headingText.text=@"ACHIEVEMENTS";
        pageStatus.text=@"<< Swipe Left For Statistics <<";
        
        NSMutableDictionary * achs = [FlxG returnCompleteAchievements];
        
        //NSLog(@"%@", achs);
        
//        if (!achs==NULL) {
        
        //for (GKAchievement* score in achs) {
        if ([achs objectForKey:kViewStats])                 
            achx1.text=@"x";
        else
            achx1.text=@"";

        if ([achs objectForKey:kViewCredits])               
            achx2.text=@"x";
        else
            achx2.text=@"";
        
        if ([achs objectForKey:kUnlockAllWarehouseLevels])  
            achx3.text=@"x";
        else
            achx3.text=@"";
        
        if ([achs objectForKey:k3CapWarehouse])             
            achx4.text=@"x";
        else
            achx4.text=@"";
        
        if ([achs objectForKey:kUnlockAllFactoryLevels])    
            achx5.text=@"x";
        else
            achx5.text=@"";
        
        if ([achs objectForKey:k3CapFactory])               
            achx6.text=@"x";
        else
            achx6.text=@"";
        
        if ([achs objectForKey:kUnlockAllManagementLevels]) 
            achx7.text=@"x";
        else
            achx7.text=@"";
        
        if ([achs objectForKey:k3CapManagement])            
            achx8.text=@"x";    
        else
            achx8.text=@"";
        
        if ([achs objectForKey:k108Caps])                   
            achx9.text=@"x";
        else
            achx9.text=@"";
        
        if ([achs objectForKey:khcUnlockAllWarehouseLevels])  
            achx10.text=@"x";
        else
            achx10.text=@"";
        
        if ([achs objectForKey:khc3CapWarehouse])             
            achx11.text=@"x";
        else
            achx11.text=@"";
        
        if ([achs objectForKey:khcUnlockAllFactoryLevels])    
            achx12.text=@"x";
        else
            achx12.text=@"";
        
        if ([achs objectForKey:khc3CapFactory])               
            achx13.text=@"x";
        else
            achx13.text=@"";
        
        if ([achs objectForKey:khcUnlockAllManagementLevels]) 
            achx14.text=@"x";
        else
            achx14.text=@"";
        
        if ([achs objectForKey:khc3CapManagement])            
            achx15.text=@"x";    
        else
            achx15.text=@"";
        
        if ([achs objectForKey:khc108Caps])                   
            achx16.text=@"x";        
        else
            achx16.text=@"";
        
        if ([achs objectForKey:kTalkToAllEmployees])          
            achx17.text=@"x";        
        else
            achx17.text=@"";
        
        if ([achs objectForKey:kTalkToAndre])                 
            achx18.text=@"x";        
        else
            achx18.text=@"";
        
        if ([achs objectForKey:kTalkToAllEmployeesHardcore])          
            achx19.text=@"x";        
        else
            achx19.text=@"";
        
        if ([achs objectForKey:kTalkToAndreHardcore])                 
            achx20.text=@"x";
        else
            achx20.text=@"";
        
//        }
        if (achs==NULL) {
//            [FlxG showAlertWithTitle:@"Warning" message:@"Achievements not loaded. You may not see your completed achievements"];
            achx1.text=@"?";
            achx2.text=@"?";
            achx3.text=@"?";
            achx4.text=@"?";
            achx5.text=@"?";
            achx6.text=@"?";
            achx7.text=@"?";
            achx8.text=@"?";
            achx9.text=@"?";
            
            achx10.text=@"?";
            achx11.text=@"?";
            achx12.text=@"?";
            achx13.text=@"?";
            achx14.text=@"?";
            achx15.text=@"?";
            achx16.text=@"?";
            
            achx17.text=@"?";
            achx18.text=@"?";
            achx19.text=@"?";
            achx20.text=@"?";
            
            headingText.text=@"ACHIEVEMENTS - NOT LOADED";
            
        }
        else {
            headingText.text=@"ACHIEVEMENTS";

            
        }

        
        
        
        

        //}
        
        

        
        
        
    }
    
    //stats
    if ( FlxG.touches.swipedLeft  || (FlxG.touches.iCadeLeftBegan && upperPart) ) {
        [FlxG playWithParam1:SndSwipe param2:0.14 param3:NO];

        totalCrates.visible=YES;
        //hardcoreStatus.visible=YES;
        gb.visible=YES;
        gs.visible=YES;
        rb.visible=YES;
        rs.visible=YES;
        gbt2.visible=YES;
        gst2.visible=YES;
        rbt2.visible=YES;
        rst2.visible=YES;
        killedBy.visible=YES;
        
        achText.visible=NO;
        
        achx1.visible=NO;
        achx2.visible=NO;
        achx3.visible=NO;
        achx4.visible=NO;
        achx5.visible=NO;
        achx6.visible=NO;
        achx7.visible=NO;
        achx8.visible=NO;
        achx9.visible=NO;
        achx10.visible=NO;

        achx11.visible=NO;
        achx12.visible=NO;
        achx13.visible=NO;
        achx14.visible=NO;
        achx15.visible=NO;
        achx16.visible=NO;
        achx17.visible=NO;
        achx18.visible=NO;
        achx19.visible=NO;
        achx20.visible=NO;

        headingText.text=@"STATISTICS";
        pageStatus.text=@">> Swipe Right For Achievements >>";


    }
    
    if (FlxG.debugMode && FlxG.touches.debugButton1 && FlxG.touches.touchesBegan) {
        [FlxG playWithParam1:@"ping2.caf" param2:PING2_VOL param3:NO];
        
        [FlxG showAlertWithTitle:@"Regular levels." message:@"Unlocked"];

        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setInteger:2 forKey:@"level1"];
        [prefs setInteger:2 forKey:@"level2"];
        [prefs setInteger:2 forKey:@"level3"];
        [prefs setInteger:2 forKey:@"level4"];
        [prefs setInteger:2 forKey:@"level5"];
        [prefs setInteger:2 forKey:@"level6"];
        [prefs setInteger:2 forKey:@"level7"];
        [prefs setInteger:2 forKey:@"level8"];
        [prefs setInteger:2 forKey:@"level9"];
        [prefs setInteger:2 forKey:@"level10"];
        [prefs setInteger:2 forKey:@"level11"];
        [prefs setInteger:2 forKey:@"level12"];
        [prefs setInteger:2 forKey:@"level13"];
        [prefs setInteger:2 forKey:@"level14"];
        [prefs setInteger:2 forKey:@"level15"];
        [prefs setInteger:2 forKey:@"level16"];
        [prefs setInteger:2 forKey:@"level17"];
        [prefs setInteger:2 forKey:@"level18"];
        [prefs setInteger:2 forKey:@"level19"];
        [prefs setInteger:2 forKey:@"level20"];
        [prefs setInteger:2 forKey:@"level21"];
        [prefs setInteger:2 forKey:@"level22"];
        [prefs setInteger:2 forKey:@"level23"];
        [prefs setInteger:2 forKey:@"level24"];
        [prefs setInteger:2 forKey:@"level25"];
        [prefs setInteger:2 forKey:@"level26"];
        [prefs setInteger:2 forKey:@"level27"];
        [prefs setInteger:2 forKey:@"level28"];
        [prefs setInteger:2 forKey:@"level29"];
        [prefs setInteger:2 forKey:@"level30"];
        [prefs setInteger:2 forKey:@"level31"];
        [prefs setInteger:2 forKey:@"level32"];
        [prefs setInteger:2 forKey:@"level33"];
        [prefs setInteger:2 forKey:@"level34"];
        [prefs setInteger:2 forKey:@"level35"];
        //[prefs setInteger:2 forKey:@"level36"];

        
        
        [prefs synchronize];
        
        [FlxG hclevelProgress];
        [FlxG hclevelProgressFactory];
        [FlxG hclevelProgressManagement];
        [FlxG hclevelProgressWarehouse];       
        

    }
    
    if (FlxG.debugMode && FlxG.touches.debugButton2  && FlxG.touches.touchesBegan) {
        
        NSLog(@"OK hit debug 2");

        [FlxG playWithParam1:@"ping2.caf" param2:PING2_VOL param3:NO];
        
        [FlxG showAlertWithTitle:@"Hardcore levels." message:@"Unlocked"];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        

        [prefs setInteger:2 forKey:@"hclevel1"];
        [prefs setInteger:2 forKey:@"hclevel2"];
        [prefs setInteger:2 forKey:@"hclevel3"];
        [prefs setInteger:2 forKey:@"hclevel4"];
        [prefs setInteger:2 forKey:@"hclevel5"];
        [prefs setInteger:2 forKey:@"hclevel6"];
        [prefs setInteger:2 forKey:@"hclevel7"];
        [prefs setInteger:2 forKey:@"hclevel8"];
        [prefs setInteger:2 forKey:@"hclevel9"];
        [prefs setInteger:2 forKey:@"hclevel10"];
        [prefs setInteger:2 forKey:@"hclevel11"];
        [prefs setInteger:2 forKey:@"hclevel12"];
        [prefs setInteger:2 forKey:@"hclevel13"];
        [prefs setInteger:2 forKey:@"hclevel14"];
        [prefs setInteger:2 forKey:@"hclevel15"];
        [prefs setInteger:2 forKey:@"hclevel16"];
        [prefs setInteger:2 forKey:@"hclevel17"];
        [prefs setInteger:2 forKey:@"hclevel18"];
        [prefs setInteger:2 forKey:@"hclevel19"];
        [prefs setInteger:2 forKey:@"hclevel20"];
        [prefs setInteger:2 forKey:@"hclevel21"];
        [prefs setInteger:2 forKey:@"hclevel22"];
        [prefs setInteger:2 forKey:@"hclevel23"];
        [prefs setInteger:2 forKey:@"hclevel24"];
        [prefs setInteger:2 forKey:@"hclevel25"];
        [prefs setInteger:2 forKey:@"hclevel26"];
        [prefs setInteger:2 forKey:@"hclevel27"];
        [prefs setInteger:2 forKey:@"hclevel28"];
        [prefs setInteger:2 forKey:@"hclevel29"];
        [prefs setInteger:2 forKey:@"hclevel30"];
        [prefs setInteger:2 forKey:@"hclevel31"];
        [prefs setInteger:2 forKey:@"hclevel32"];
        [prefs setInteger:2 forKey:@"hclevel33"];
        [prefs setInteger:2 forKey:@"hclevel34"];
        [prefs setInteger:2 forKey:@"hclevel35"];
        [prefs setInteger:2 forKey:@"hclevel36"];
        
        
        [prefs synchronize];
        
        [FlxG hclevelProgress];
        [FlxG hclevelProgressFactory];
        [FlxG hclevelProgressManagement];
        [FlxG hclevelProgressWarehouse];       


    }
    
    
    //talked to everyone
    
    if (FlxG.debugMode && FlxG.touches.debugButton3  && FlxG.touches.touchesBegan) {
        [FlxG playWithParam1:@"ping2.caf" param2:PING2_VOL param3:NO];
        
        [FlxG showAlertWithTitle:@"Talking badges" message:@"Unlocked"];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY1"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY2"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY3"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY4"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY5"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY6"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY7"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY8"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY9"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY10"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY11"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY12"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY13"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY14"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY15"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY16"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY17"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY18"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY19"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY20"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY21"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY22"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY23"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY24"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY25"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY26"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY27"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY28"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY29"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY30"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY31"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY32"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY33"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY34"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY35"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMY36"];
        
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF1"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF2"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF3"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF4"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF5"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF6"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF7"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF8"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF9"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF10"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF11"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF12"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF13"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF14"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF15"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF16"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF17"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF18"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF19"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF20"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF21"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF22"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF23"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF24"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF25"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF26"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF27"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF28"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF29"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF30"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF31"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF32"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF33"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF34"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF35"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEF36"];
        
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR1"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR2"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR3"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR4"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR5"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR6"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR7"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR8"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR9"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR10"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR11"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR12"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR13"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR14"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR15"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR16"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR17"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR18"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR19"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR20"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR21"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR22"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR23"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR24"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR25"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR26"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR27"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR28"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR29"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR30"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR31"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR32"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR33"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR34"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR35"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTOR36"];
        
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER1"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER2"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER3"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER4"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER5"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER6"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER7"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER8"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER9"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER10"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER11"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER12"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER13"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER14"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER15"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER16"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER17"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER18"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER19"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER20"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER21"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER22"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER23"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER24"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER25"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER26"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER27"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER28"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER29"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER30"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER31"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER32"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER33"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER34"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER35"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKER36"];
        
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE1"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE2"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE3"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE4"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE5"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE6"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE7"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE8"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE9"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE10"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE11"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE12"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE13"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE14"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE15"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE16"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE17"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE18"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE19"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE20"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE21"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE22"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE23"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE24"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE25"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE26"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE27"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE28"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE29"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE30"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE31"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE32"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE33"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE34"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE35"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDRE36"];
        
        
        //keep level 1 clean
//        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY1"];
//        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF1"];
//        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR1"];
//        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER1"];
//        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE1"];
//
//        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY3"];
//        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF3"];
//        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR3"];
//        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER3"];
//        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE8"];
        
        
        [prefs synchronize];
        
        [FlxG talkToAndreProgress];
        [FlxG talkToEnemyProgress];        
        
    }
    //talked to everyone
    
    if (FlxG.debugMode && FlxG.touches.debugButton4  && FlxG.touches.touchesBegan) {
        [FlxG playWithParam1:@"ping2.caf" param2:PING2_VOL param3:NO];
        
        [FlxG showAlertWithTitle:@"Hardcore Talking badges" message:@"Unlocked"];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC1"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC2"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC3"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC4"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC5"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC6"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC7"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC8"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC9"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC10"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC11"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC12"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC13"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC14"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC15"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC16"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC17"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC18"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC19"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC20"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC21"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC22"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC23"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC24"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC25"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC26"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC27"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC28"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC29"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC30"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC31"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC32"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC33"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC34"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC35"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ARMYHC36"];
        
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC1"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC2"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC3"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC4"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC5"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC6"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC7"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC8"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC9"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC10"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC11"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC12"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC13"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC14"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC15"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC16"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC17"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC18"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC19"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC20"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC21"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC22"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC23"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC24"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC25"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC26"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC27"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC28"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC29"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC30"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC31"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC32"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC33"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC34"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC35"];
        [prefs setInteger:1 forKey:@"TALKED_TO_CHEFHC36"];
        
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC1"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC2"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC3"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC4"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC5"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC6"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC7"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC8"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC9"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC10"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC11"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC12"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC13"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC14"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC15"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC16"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC17"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC18"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC19"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC20"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC21"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC22"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC23"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC24"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC25"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC26"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC27"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC28"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC29"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC30"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC31"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC32"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC33"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC34"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC35"];
        [prefs setInteger:1 forKey:@"TALKED_TO_INSPECTORHC36"];
        
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC1"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC2"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC3"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC4"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC5"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC6"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC7"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC8"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC9"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC10"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC11"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC12"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC13"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC14"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC15"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC16"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC17"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC18"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC19"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC20"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC21"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC22"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC23"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC24"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC25"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC26"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC27"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC28"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC29"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC30"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC31"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC32"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC33"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC34"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC35"];
        [prefs setInteger:1 forKey:@"TALKED_TO_WORKERHC36"];
        
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC1"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC2"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC3"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC4"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC5"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC6"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC7"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC8"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC9"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC10"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC11"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC12"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC13"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC14"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC15"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC16"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC17"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC18"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC19"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC20"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC21"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC22"];    
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC23"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC24"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC25"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC26"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC27"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC28"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC29"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC30"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC31"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC32"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC33"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC34"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC35"];
        [prefs setInteger:1 forKey:@"TALKED_TO_ANDREHC36"];
        
        
        //keep level 1 clean
//        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC1"];
//        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC1"];
//        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC1"];
//        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC1"];
//        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC1"];
        
        
        
        [prefs synchronize];
        
        [FlxG hctalkToAndreProgress];
        [FlxG hctalkToEnemyProgress];        
        
    }

    
    
    
	[super update];
	
	
	
}

- (void) onBack
{
    [FlxG play:SndBack withVolume:PING2_VOL];

	FlxG.state = [[[MenuState alloc] init] autorelease];
    return;
}

- (void) loadLevelBlocksFromImage {
    static NSString * ImgTiles = @"level3_tiles.png";
    static NSString * ImgSpecialSquareBlock = @"level3_specialBlock.png";
    static NSString * ImgSpecialPlatform = @"level3_specialPlatform.png";
    NSData* pixelData;
    
    pixelData = [FlxImageInfo readImage:@"credits_map.png"];
    
    
    int levelWidth = 48;
    int levelHeight = 32;
    
    //    static NSString * ImgTiles = @"level1_tiles.png";
    //    NSData* pixelData = [FlxImageInfo readImage:@"level1_map.png"];
    
    unsigned char* pixelBytes = (unsigned char *)[pixelData bytes];
    
    int j = 0;
    
    //look at each pixel
    //black = 20x20 block
    //red = HORIZONTAL length
    //green = VERTICAL length
    //blue = Arbitrary ID
    
    int arbID=0;
    
    for(int i = 0; i < [pixelData length]; i += 4) {
        
        int red1 = pixelBytes[i];
        int green1 = pixelBytes[i+1];
        int blue1 = pixelBytes[i+2];
        int alpha1 = pixelBytes[i+3];
        
        
        //if pixel has some red and some green
        if (pixelBytes[i]>0 && pixelBytes[i+1]>0 && pixelBytes[i+2]<100 && pixelBytes[i+3]==255) {
            //NSLog(@"Found a red+blue Pixel");
            int w = pixelBytes[i]*10;
            int h = pixelBytes[i+1]*10;
            FlxTileblock * bl = [FlxTileblock tileblockWithX:( (j)%levelWidth)*10 y:((j) / levelWidth) * 10 width:w height:h];  
            [bl loadGraphic:ImgTiles 
                    empties:0 
                   autoTile:YES 
             isSpeechBubble:0 
                 isGradient:0 
                arbitraryID:blue1
                      index:arbID] ;
            
            [self add:bl]; 
            
            arbID++;
        }
        
        //if pixel has an a blue pixel of 100
        else if (pixelBytes[i]>0 && pixelBytes[i+1]>0 && pixelBytes[i+2]==100 && pixelBytes[i+3]==255) {
            //NSLog(@"Found a red+blue Pixel");
            int w = pixelBytes[i]*10;
            int h = pixelBytes[i+1]*10;
            FlxTileblock * bl = [FlxTileblock tileblockWithX:( (j)%levelWidth)*10 y:((j) / levelWidth) * 10 width:w height:h];  
            [bl loadGraphic:ImgSpecialSquareBlock 
                    empties:0 
                   autoTile:NO 
             isSpeechBubble:0 
                 isGradient:0 
                arbitraryID:blue1
                      index:arbID] ;
            
            
            [self add:bl]; 
            
            arbID++;
        }    
        
        //if pixel has an a blue pixel of 101 - specialPlatform
        else if (pixelBytes[i]>0 && pixelBytes[i+1]>0 && pixelBytes[i+2]==101 && pixelBytes[i+3]==255) {
            //NSLog(@"Found a red+blue Pixel");
            int w = pixelBytes[i]*10;
            int h = pixelBytes[i+1]*10;
            //            bl = [FlxTileblock tileblockWithX:( (j)%levelWidth)*10 y:((j) / levelWidth) * 10 width:w height:h];  
            //            [bl loadGraphic:ImgSpecialPlatform
            //                    empties:0 
            //                   autoTile:NO 
            //             isSpeechBubble:0 
            //                 isGradient:0 
            //                arbitraryID:blue1
            //                      index:arbID] ;
            
            FlxSprite * specialBlock = [FlxSprite spriteWithX:( (j)%levelWidth)*10 y:((j) / levelWidth) * 10 graphic:ImgSpecialPlatform];
            specialBlock.width = w;
            specialBlock.height = h;
            specialBlock.fixed = YES;
            
            [self add:specialBlock]; 
            
            arbID++;
        } 
        
        
        
        
        
        
        //NSLog(@"PIXEL DATA %d %hhu %hhu %hhu %hhu %d %d", i, pixelBytes[i], pixelBytes[i+1], pixelBytes[i+2], pixelBytes[i+3], (j%48)*10, (j / 48) * 10 );
        j++;
    }
    
}
- (void) onClear
{
    if (areYouSure==YES){
        [FlxG play:@"deathSFX.caf"];
        
        [FlxG resetAchievements];

        clearDone.visible=YES;
        clear.visible=NO;
        clearSure.visible=NO;
        
        gst2.text = @"0";
        rbt2.text = @"0";
        gbt2.text = @"0";
        rst2.text = @"0";
        
        achx1.text=@"";
        achx2.text=@"";
        achx3.text=@"";
        achx4.text=@"";
        achx5.text=@"";
        achx6.text=@"";
        achx7.text=@"";
        achx8.text=@"";
        achx9.text=@"";
        
        achx10.text=@"";
        achx11.text=@"";
        achx12.text=@"";
        achx13.text=@"";
        achx14.text=@"";
        achx15.text=@"";
        achx16.text=@"";
        
        achx17.text=@"";
        achx18.text=@"";
        achx19.text=@"";
        achx20.text=@"";
        
        FlxG.hardCoreMode=0;
        
        
        //hardcoreStatus.text = @"";
        totalCrates.text = @"Levels Unlocked: 3 of 36.\nBottle Caps: 0 of 36\n36 caps to unlock hardcore mode.";
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setInteger:0 forKey:@"KILLED_BY_ARMY"];
        [prefs setInteger:0 forKey:@"KILLED_BY_CHEF"];
        [prefs setInteger:0 forKey:@"KILLED_BY_INSPECTOR"];
        [prefs setInteger:0 forKey:@"KILLED_BY_WORKER"];
        
        [prefs setInteger:1 forKey:@"level1"];
        [prefs setInteger:0 forKey:@"level2"];
        [prefs setInteger:0 forKey:@"level3"];
        [prefs setInteger:0 forKey:@"level4"];
        [prefs setInteger:0 forKey:@"level5"];
        [prefs setInteger:0 forKey:@"level6"];
        [prefs setInteger:0 forKey:@"level7"];
        [prefs setInteger:0 forKey:@"level8"];
        [prefs setInteger:0 forKey:@"level9"];
        [prefs setInteger:0 forKey:@"level10"];
        [prefs setInteger:0 forKey:@"level11"];
        [prefs setInteger:0 forKey:@"level12"];
        [prefs setInteger:1 forKey:@"level13"];
        [prefs setInteger:0 forKey:@"level14"];
        [prefs setInteger:0 forKey:@"level15"];
        [prefs setInteger:0 forKey:@"level16"];
        [prefs setInteger:0 forKey:@"level17"];
        [prefs setInteger:0 forKey:@"level18"];
        [prefs setInteger:0 forKey:@"level19"];
        [prefs setInteger:0 forKey:@"level20"];
        [prefs setInteger:0 forKey:@"level21"];
        [prefs setInteger:0 forKey:@"level22"];
        [prefs setInteger:0 forKey:@"level23"];
        [prefs setInteger:0 forKey:@"level24"];
        [prefs setInteger:1 forKey:@"level25"];
        [prefs setInteger:0 forKey:@"level26"];
        [prefs setInteger:0 forKey:@"level27"];
        [prefs setInteger:0 forKey:@"level28"];
        [prefs setInteger:0 forKey:@"level29"];
        [prefs setInteger:0 forKey:@"level30"];
        [prefs setInteger:0 forKey:@"level31"];
        [prefs setInteger:0 forKey:@"level32"];
        [prefs setInteger:0 forKey:@"level33"];
        [prefs setInteger:0 forKey:@"level34"];
        [prefs setInteger:0 forKey:@"level35"];
        [prefs setInteger:0 forKey:@"level36"];
        
        [prefs setInteger:1 forKey:@"hclevel1"];
        [prefs setInteger:0 forKey:@"hclevel2"];
        [prefs setInteger:0 forKey:@"hclevel3"];
        [prefs setInteger:0 forKey:@"hclevel4"];
        [prefs setInteger:0 forKey:@"hclevel5"];
        [prefs setInteger:0 forKey:@"hclevel6"];
        [prefs setInteger:0 forKey:@"hclevel7"];
        [prefs setInteger:0 forKey:@"hclevel8"];
        [prefs setInteger:0 forKey:@"hclevel9"];
        [prefs setInteger:0 forKey:@"hclevel10"];
        [prefs setInteger:0 forKey:@"hclevel11"];
        [prefs setInteger:0 forKey:@"hclevel12"];
        [prefs setInteger:1 forKey:@"hclevel13"];
        [prefs setInteger:0 forKey:@"hclevel14"];
        [prefs setInteger:0 forKey:@"hclevel15"];
        [prefs setInteger:0 forKey:@"hclevel16"];
        [prefs setInteger:0 forKey:@"hclevel17"];
        [prefs setInteger:0 forKey:@"hclevel18"];
        [prefs setInteger:0 forKey:@"hclevel19"];
        [prefs setInteger:0 forKey:@"hclevel20"];
        [prefs setInteger:0 forKey:@"hclevel21"];
        [prefs setInteger:0 forKey:@"hclevel22"];
        [prefs setInteger:0 forKey:@"hclevel23"];
        [prefs setInteger:0 forKey:@"hclevel24"];
        [prefs setInteger:1 forKey:@"hclevel25"];
        [prefs setInteger:0 forKey:@"hclevel26"];
        [prefs setInteger:0 forKey:@"hclevel27"];
        [prefs setInteger:0 forKey:@"hclevel28"];
        [prefs setInteger:0 forKey:@"hclevel29"];
        [prefs setInteger:0 forKey:@"hclevel30"];
        [prefs setInteger:0 forKey:@"hclevel31"];
        [prefs setInteger:0 forKey:@"hclevel32"];
        [prefs setInteger:0 forKey:@"hclevel33"];
        [prefs setInteger:0 forKey:@"hclevel34"];
        [prefs setInteger:0 forKey:@"hclevel35"];
        [prefs setInteger:0 forKey:@"hclevel36"];
        
        
        [prefs setInteger:0 forKey:@"HARDCORE_MODE"];
        
        
        //talked to no one
        
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY1"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY2"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY3"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY4"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY5"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY6"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY7"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY8"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY9"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY10"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY11"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY12"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY13"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY14"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY15"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY16"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY17"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY18"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY19"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY20"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY21"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY22"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY23"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY24"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY25"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY26"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY27"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY28"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY29"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY30"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY31"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY32"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY33"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY34"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY35"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMY36"];
        
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF1"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF2"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF3"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF4"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF5"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF6"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF7"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF8"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF9"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF10"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF11"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF12"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF13"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF14"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF15"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF16"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF17"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF18"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF19"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF20"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF21"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF22"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF23"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF24"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF25"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF26"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF27"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF28"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF29"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF30"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF31"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF32"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF33"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF34"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF35"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEF36"];
        
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR1"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR2"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR3"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR4"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR5"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR6"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR7"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR8"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR9"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR10"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR11"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR12"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR13"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR14"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR15"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR16"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR17"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR18"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR19"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR20"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR21"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR22"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR23"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR24"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR25"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR26"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR27"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR28"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR29"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR30"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR31"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR32"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR33"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR34"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR35"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTOR36"];
        
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER1"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER2"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER3"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER4"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER5"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER6"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER7"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER8"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER9"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER10"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER11"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER12"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER13"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER14"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER15"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER16"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER17"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER18"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER19"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER20"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER21"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER22"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER23"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER24"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER25"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER26"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER27"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER28"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER29"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER30"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER31"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER32"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER33"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER34"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER35"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKER36"];
        
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE1"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE2"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE3"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE4"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE5"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE6"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE7"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE8"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE9"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE10"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE11"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE12"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE13"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE14"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE15"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE16"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE17"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE18"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE19"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE20"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE21"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE22"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE23"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE24"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE25"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE26"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE27"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE28"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE29"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE30"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE31"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE32"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE33"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE34"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE35"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDRE36"];
        
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC1"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC2"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC3"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC4"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC5"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC6"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC7"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC8"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC9"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC10"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC11"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC12"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC13"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC14"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC15"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC16"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC17"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC18"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC19"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC20"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC21"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC22"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC23"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC24"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC25"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC26"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC27"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC28"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC29"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC30"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC31"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC32"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC33"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC34"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC35"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ARMYHC36"];
        
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC1"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC2"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC3"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC4"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC5"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC6"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC7"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC8"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC9"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC10"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC11"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC12"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC13"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC14"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC15"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC16"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC17"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC18"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC19"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC20"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC21"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC22"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC23"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC24"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC25"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC26"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC27"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC28"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC29"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC30"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC31"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC32"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC33"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC34"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC35"];
        [prefs setInteger:0 forKey:@"TALKED_TO_CHEFHC36"];
        
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC1"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC2"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC3"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC4"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC5"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC6"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC7"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC8"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC9"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC10"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC11"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC12"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC13"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC14"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC15"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC16"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC17"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC18"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC19"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC20"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC21"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC22"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC23"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC24"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC25"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC26"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC27"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC28"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC29"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC30"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC31"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC32"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC33"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC34"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC35"];
        [prefs setInteger:0 forKey:@"TALKED_TO_INSPECTORHC36"];
        
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC1"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC2"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC3"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC4"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC5"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC6"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC7"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC8"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC9"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC10"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC11"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC12"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC13"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC14"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC15"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC16"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC17"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC18"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC19"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC20"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC21"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC22"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC23"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC24"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC25"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC26"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC27"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC28"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC29"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC30"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC31"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC32"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC33"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC34"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC35"];
        [prefs setInteger:0 forKey:@"TALKED_TO_WORKERHC36"];
        
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC1"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC2"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC3"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC4"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC5"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC6"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC7"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC8"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC9"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC10"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC11"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC12"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC13"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC14"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC15"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC16"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC17"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC18"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC19"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC20"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC21"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC22"];    
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC23"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC24"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC25"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC26"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC27"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC28"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC29"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC30"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC31"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC32"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC33"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC34"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC35"];
        [prefs setInteger:0 forKey:@"TALKED_TO_ANDREHC36"];
        
        [prefs setInteger:0 forKey:@"HAS_RATED"];

        
        [prefs synchronize];
        
        
    }
    else {
        [FlxG play:@"deathSFX.caf"];

        areYouSure=YES;
        clearDone.visible=NO;
        clear.visible=NO;
        clearSure.visible=YES;
    }
    
}

@end

