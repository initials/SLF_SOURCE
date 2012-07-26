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

#import "FlxImageInfo.h"

#import "OgmoLevelState.h"
#import "WinniOgmoLevelState.h"

#import "LevelMenuState.h"
#import "WorldSelectState.h"
#import "GameCompleteState.h"

#import "MenuState.h"
#import "Liselot.h"

#import "Player.h"
#import "Enemy.h"
#import "EnemyArmy.h"
#import "EnemyChef.h"
#import "EnemyInspector.h"
#import "EnemyWorker.h"
#import "EnemyGeneric.h"

#import "HelpBox.h"
#import "HelpLabel.h"

#import "Hud.h"         

#import "Bottle.h"
#import "SugarBag.h"
#import "Crate.h"
#import "LargeCrate.h"
#import "Gun.h"
#import "Cloud.h"
#import "Exit.h"
#import "LevelComplete.h"

#import "NavArrow.h"

#import "OldSchoolCompleteState.h"

//#import "ScoreCaps.h"
#import "CheckPoint.h"

#define debugGround 0

//#define BUTTON_START_ALPHA 0 //.3
//#define BUTTON_PRESSED_ALPHA 0 //.7

#define DIVISOR_FOR_STORY_UNLOCK 3
#define SPEED_FOR_SUGAR_HIGH_REDUCTION 0.00500000
#define PERCENTAGE_SUGAR_BAG_ADDS 1 //0.2
#define SHRAPNEL_IN_GRENADE 10
#define VERTICAL_OVERSHOOT_OF_LEVEL 0

#define SCROLLFACTOR_FOR_LAYER1 0.2
#define SCROLLFACTOR_FOR_LAYER2 0.6
#define SCROLLFACTOR_FOR_LAYER3 1
#define SCROLLFACTOR_FOR_FG1 1.5
#define CHAR_Y_OFFSET -4


#define HELP_BOX_ALPHA 0

CGFloat swiperotation;
CGFloat hypotenuse;
CGFloat bulletDamage;
CGFloat gunOffsetToPlayer;
int previousWeapon;

//virtual control pad vars
int previousNumberOfTouches;
BOOL newTouch;

static FlxEmitter * puffEmitter = nil;
static FlxEmitter * steamEmitter = nil;
static FlxEmitter * crateShardEmitter = nil;

FlxButton * nextLevel;

//used to be flxsprite
FlxButton * levelSelect;

FlxSprite * levelComplete;

static NSString * ImgSteam = @"steam.png";
static NSString * ImgBubble = @"bubble.png";

//static NSString * MusicMegaCannon = @"megacannon.mp3";
//static NSString * MusicIceFishing = @"icefishing.mp3";
//static NSString * MusicPirate = @"pirate.mp3";

static NSString * SndFizz = @"openDrinkFizz_bfxr.caf";
static NSString * SndError = @"deathSFX.caf";
static NSString * SndCheckPoint = @"scoreCap3.caf";

static NSString * ImgSmallButtonPressed = @"emptySmallButtonPressed.png";
static NSString * ImgSmallButton = @"emptySmallButton.png";





static float timerForFollowObject=1000000.0;
CGPoint tempPointForFollowObject;


static NSString * ImgLevelTiles = @"level1_tiles.png";

NSString * tempString = @"";

int killedArmy;
int killedChef;
int killedWorker;
int killedInspector;
int collectedBottles;

BOOL hasCheckedGameOverScreen;

NSInteger curHighScore;

int currentSpeechText;

NSString * currentXMLLayer = @"";
NSString * lastXMLLayer = @"";
NSNumber * _scrollfactor;


static float buttonStartAlpha;
static float buttonPressedAlpha;
static BOOL displayInGameHelp;
static BOOL switchCharactersOnDeath;

static float smoothCameraMoveDuration;


static float lh, lw;
static float currentFollowHeight, currentFollowWidth;



@implementation OgmoLevelState

- (id) init
{
	if ((self = [super init])) {
		self.bgColor = 0xff35353d;
        playerPlatforms = [[FlxGroup alloc] init];
        enemyPlatforms = [[FlxGroup alloc] init];
        helpBoxes = [[FlxGroup alloc] init];
        
        
        characters = [[FlxGroup alloc] init];
        talkCharacters = [[FlxGroup alloc] init];
        
        charactersArmy= [[FlxGroup alloc] init];
        charactersChef= [[FlxGroup alloc] init];
        charactersInspector= [[FlxGroup alloc] init];
        charactersWorker= [[FlxGroup alloc] init];
        hazards = [[FlxGroup alloc] init];
        crates = [[FlxGroup alloc] init];
        
        
        currentXMLLayer = @"";
        
        levelArray = [[NSMutableArray alloc] initWithCapacity:1];
        levelArrayFake = [[NSMutableArray alloc] initWithCapacity:1];
        
        movingPlatformsArray = [[NSMutableArray alloc] initWithCapacity:1];
        movingPlatformsLimitsArray = [[NSMutableArray alloc] initWithCapacity:1];
        
        bottleArray = [[NSMutableArray alloc] initWithCapacity:1];
        BGArray1 = [[NSMutableArray alloc] initWithCapacity:1];
        BGArray2 = [[NSMutableArray alloc] initWithCapacity:1];
        BGArray3 = [[NSMutableArray alloc] initWithCapacity:1];
        FGArray1 = [[NSMutableArray alloc] initWithCapacity:1];
        
        hazardArray = [[NSMutableArray alloc] initWithCapacity:1];
        
        characterArray  = [[NSMutableArray alloc] initWithCapacity:1];
        characterNodeArray  = [[NSMutableArray alloc] initWithCapacity:1];
        
        NSString * levelFile = @"level";
        if (FlxG.hardCoreMode) {
            levelFile = @"hclevel";
        }
        
        if (FlxG.winnitron) {
            levelFile= @"w_level";
        }
        int levelNumber = FlxG.level;
        levelFile = [levelFile stringByAppendingFormat:@"%d", levelNumber];
        levelFile = [levelFile stringByAppendingString:@".oel"];
        
        NSString * levelInfo=@" Loading this level file: ";
        levelInfo = [levelInfo stringByAppendingString:levelFile];
        //        NSLog(@" *** ---  %@ ", levelInfo);
        
        NSString *paths = [[NSBundle mainBundle] resourcePath];
        NSString *xmlFile = [paths stringByAppendingPathComponent:levelFile]; //@"level1.oel"
        NSURL *xmlURL = [NSURL fileURLWithPath:xmlFile isDirectory:NO];
        
        NSXMLParser *firstParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
        [firstParser setDelegate:self];
        [firstParser parse];
        
        
	}
	return self;
}

#pragma mark XML LOADING

-(void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string
{
    //    tempString=string;
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    
    //    if ([parentNode count] < 3) {
    //        [parentNode push:elementName];
    //    }
    
    
    
    if ([elementName compare:@"solids"] == NSOrderedSame     ) {		
		//NSLog(@"current type is solids"); 
        currentXMLLayer=@"solids";
	}      
    else if ([elementName compare:@"fakesolids"] == NSOrderedSame     ) {		
		//NSLog(@"current type is fakesolids"); 
        currentXMLLayer=@"fakesolids";
	}
    else if ([elementName compare:@"extraPlatforms"] == NSOrderedSame     ) {		
		//NSLog(@"current type is solids"); 
        currentXMLLayer=@"extraPlatforms";
	} 
    else if ([elementName compare:@"tiles"] == NSOrderedSame     ) {		
		//NSLog(@"current type is tiles");  
        currentXMLLayer=@"tiles";
	} 
    else if ([elementName compare:@"BGLayer1"] == NSOrderedSame     ) {		
		//NSLog(@"current type is BGLayer1");
        currentXMLLayer=@"BGLayer1";
        _scrollfactor = [NSNumber numberWithFloat:SCROLLFACTOR_FOR_LAYER1];
	}   
    else if ([elementName compare:@"BGLayer2"] == NSOrderedSame     ) {		
		//NSLog(@"current type is BGLayer2");
        currentXMLLayer=@"BGLayer2";
        _scrollfactor = [NSNumber numberWithFloat:SCROLLFACTOR_FOR_LAYER2];
        
	}  
    else if ([elementName compare:@"BGLayer3"] == NSOrderedSame     ) {		
		//NSLog(@"current type is BGLayer3");    
        currentXMLLayer=@"BGLayer3";
        _scrollfactor = [NSNumber numberWithFloat:SCROLLFACTOR_FOR_LAYER3];
        
	}  
    else if ([elementName compare:@"objects"] == NSOrderedSame     ) {		
		//NSLog(@"current type is objects");   
        currentXMLLayer=@"objects";
        
	}     
    else if ([elementName compare:@"characters"] == NSOrderedSame     ) {		
		//NSLog(@"current type is characters");     
        currentXMLLayer=@"characters";
        
	} else if ([elementName compare:@"movingPlatforms"] == NSOrderedSame     ) {		
        currentXMLLayer=@"movingPlatforms";
        
	}  else if ([elementName compare:@"FGLayer1"] == NSOrderedSame     ) {		
        currentXMLLayer=@"FGLayer1";
        _scrollfactor = [NSNumber numberWithFloat:SCROLLFACTOR_FOR_FG1];
        
        
	}        
    
    //rects are stored in the level array
    if ([currentXMLLayer isEqual:@"solids"] ) {
        if ([elementName compare:@"rect"] == NSOrderedSame     ) {		
            [levelArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                   elementName,@"type",
                                   [attributeDict objectForKey:@"x"],@"x",
                                   [attributeDict objectForKey:@"y"],@"y",
                                   [attributeDict objectForKey:@"w"],@"w",
                                   [attributeDict objectForKey:@"h"],@"h",
                                   nil]];        
        }
    }
    
    if ([currentXMLLayer isEqual:@"fakesolids"] ) {
        if ([elementName compare:@"rect"] == NSOrderedSame     ) {		
            [levelArrayFake addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                       elementName,@"type",
                                       [attributeDict objectForKey:@"x"],@"x",
                                       [attributeDict objectForKey:@"y"],@"y",
                                       [attributeDict objectForKey:@"w"],@"w",
                                       [attributeDict objectForKey:@"h"],@"h",
                                       nil]];        
        }
    }    
    
    //moving platforms
    
    if ([currentXMLLayer isEqual:@"movingPlatforms"] ) {
        if ([elementName compare:@"level1_specialBlock"] == NSOrderedSame    ||
            [elementName compare:@"level1_specialPlatform"] == NSOrderedSame ||
            [elementName compare:@"level2_specialBlock"] == NSOrderedSame    ||
            [elementName compare:@"level2_specialPlatform"] == NSOrderedSame ||
            [elementName compare:@"level1_specialPlatformSmall"] == NSOrderedSame || 
            [elementName compare:@"level2_specialPlatformSmall"] == NSOrderedSame || 
            [elementName compare:@"level3_specialPlatformSmall"] == NSOrderedSame ||            
            
            [elementName compare:@"level3_specialBlock"] == NSOrderedSame    ||
            [elementName compare:@"level3_specialPlatform"] == NSOrderedSame   ) {	
            [movingPlatformsArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                             elementName,@"type",
                                             [attributeDict objectForKey:@"x"],@"x",
                                             [attributeDict objectForKey:@"y"],@"y",
                                             [attributeDict objectForKey:@"speed"],@"speed",
                                             [attributeDict objectForKey:@"movementType"],@"movementType",
                                             [attributeDict objectForKey:@"animated"],@"animated",     
                                             nil]]; 
        }
        else if ([elementName compare:@"node"] == NSOrderedSame) {
            [movingPlatformsLimitsArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:[attributeDict objectForKey:@"x"], @"limitX",
                                                   [attributeDict objectForKey:@"y"], @"limitY",
                                                   nil]];
        }
        
        
        
    }
    
    // extra platforms.
    
    if ([currentXMLLayer isEqual:@"extraPlatforms"] ) {
        if ([elementName compare:@"LargeCrate"] == NSOrderedSame   ||
            [elementName compare:@"level1_specialBlock"] == NSOrderedSame   ||
            [elementName compare:@"level1_specialPlatform"] == NSOrderedSame ||
            [elementName compare:@"level2_specialBlock"] == NSOrderedSame   ||
            [elementName compare:@"level2_specialPlatform"] == NSOrderedSame ||
            [elementName compare:@"level3_specialBlock"] == NSOrderedSame   ||
            [elementName compare:@"level3_specialPlatform"] == NSOrderedSame   ) {	
            [levelArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                   elementName,@"type",
                                   [attributeDict objectForKey:@"x"],@"x",
                                   [attributeDict objectForKey:@"y"],@"y",
                                   [attributeDict objectForKey:@"w"],@"w",
                                   [attributeDict objectForKey:@"h"],@"h",
                                   [attributeDict objectForKey:@"speed"],@"speed",
                                   nil]]; 
        } 
        
        
    }
    
    if ([currentXMLLayer isEqual:@"extraPlatforms"] ) {
        if ([elementName compare:@"helpBox"] == NSOrderedSame     ) {	
            [bottleArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                    elementName,@"type",
                                    [attributeDict objectForKey:@"x"],@"x",
                                    [attributeDict objectForKey:@"y"],@"y",
                                    [attributeDict objectForKey:@"type"],@"type",
                                    [attributeDict objectForKey:@"helpString"],@"helpString",
                                    
                                    nil]]; 
        } 
        
        
    }
    
    //add hazards to the hazard array
    
    if ([currentXMLLayer isEqual:@"extraPlatforms"] ) {
        if ([elementName compare:@"spike0"] == NSOrderedSame  ||
            [elementName compare:@"spike1"] == NSOrderedSame  ||
            [elementName compare:@"spike2"] == NSOrderedSame  ||
            [elementName compare:@"spike3"] == NSOrderedSame   ||
            [elementName compare:@"level2_spike0"] == NSOrderedSame  ||
            [elementName compare:@"level2_spike1"] == NSOrderedSame  ||
            [elementName compare:@"level2_spike2"] == NSOrderedSame  ||
            [elementName compare:@"level2_spike3"] == NSOrderedSame  ||
            [elementName compare:@"level3_spike0"] == NSOrderedSame  ||
            [elementName compare:@"level3_spike1"] == NSOrderedSame  ||
            [elementName compare:@"level3_spike2"] == NSOrderedSame  ||
            [elementName compare:@"level3_spike3"] == NSOrderedSame 
            
            
            
            ) {	
            [hazardArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                    elementName,@"type",
                                    [attributeDict objectForKey:@"x"],@"x",
                                    [attributeDict objectForKey:@"y"],@"y",
                                    [attributeDict objectForKey:@"width"],@"width",
                                    [attributeDict objectForKey:@"height"],@"height",
                                    nil]]; 
        } 
    }
    
    
    //bottles
    if ([currentXMLLayer isEqual:@"objects"] ) {
        
        if ([elementName compare:@"Bottle"] == NSOrderedSame     ) {		
            [bottleArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                    elementName,@"type",  
                                    [attributeDict objectForKey:@"x"],@"x",
                                    [attributeDict objectForKey:@"y"],@"y",
                                    nil]]; 
        }  
        if ([elementName compare:@"smallSugarBag"] == NSOrderedSame     ) {		
            [bottleArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                    elementName,@"type",  
                                    [attributeDict objectForKey:@"x"],@"x",
                                    [attributeDict objectForKey:@"y"],@"y",
                                    nil]]; 
        } 
        if ([elementName compare:@"L1_SmallCrate"] == NSOrderedSame     ) {		
            [bottleArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                    elementName,@"type",  
                                    [attributeDict objectForKey:@"x"],@"x",
                                    [attributeDict objectForKey:@"y"],@"y",
                                    nil]]; 
        } 
        if ([elementName compare:@"LargeCrate"] == NSOrderedSame     ) {		
            [bottleArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                    elementName,@"type",  
                                    [attributeDict objectForKey:@"x"],@"x",
                                    [attributeDict objectForKey:@"y"],@"y",
                                    nil]]; 
        }  
        if ([elementName compare:@"exit"] == NSOrderedSame     ) {		
            [bottleArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                    elementName,@"type",  
                                    [attributeDict objectForKey:@"x"],@"x",
                                    [attributeDict objectForKey:@"y"],@"y",
                                    [attributeDict objectForKey:@"nextLevel"],@"nextLevel",
                                    nil]]; 
        }
        if ([elementName compare:@"andreCheckPoint"] == NSOrderedSame     ) {		
            [bottleArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                    elementName,@"type",  
                                    [attributeDict objectForKey:@"x"],@"x",
                                    [attributeDict objectForKey:@"y"],@"y",
                                    nil]]; 
        }
        if ([elementName compare:@"liselotCheckPoint"] == NSOrderedSame     ) {		
            [bottleArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                    elementName,@"type",  
                                    [attributeDict objectForKey:@"x"],@"x",
                                    [attributeDict objectForKey:@"y"],@"y",
                                    nil]]; 
        }
    }    
    
    //characters
    if ( [elementName compare:@"player"] == NSOrderedSame ) {	
        
		[characterArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                   elementName,@"character",  
                                   [attributeDict objectForKey:@"x"],@"x",
                                   [attributeDict objectForKey:@"y"],@"y",
                                   [attributeDict objectForKey:@"speed"],@"speed",
                                   [attributeDict objectForKey:@"movementType"],@"movementType",
                                   [attributeDict objectForKey:@"levelName"],@"levelName",
                                   [attributeDict objectForKey:@"startsFirst"],@"startsFirst",
                                   [attributeDict objectForKey:@"andreInitialFlip"],@"andreInitialFlip",
                                   [attributeDict objectForKey:@"liselotInitialFlip"],@"liselotInitialFlip",
                                   [attributeDict objectForKey:@"followWidth"],@"followWidth",
                                   [attributeDict objectForKey:@"followHeight"],@"followHeight",
                                   nil]];
        
	}    
    //characters
    if ([elementName compare:@"worker"] == NSOrderedSame || 
        [elementName compare:@"liselot"] == NSOrderedSame || 
        [elementName compare:@"inspector"] == NSOrderedSame || 
        [elementName compare:@"army"] == NSOrderedSame || 
        [elementName compare:@"chef"] == NSOrderedSame ) {	
        
		[characterArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                   elementName,@"character",  
                                   [attributeDict objectForKey:@"x"],@"x",
                                   [attributeDict objectForKey:@"y"],@"y",
                                   [attributeDict objectForKey:@"speed"],@"speed",
                                   [attributeDict objectForKey:@"movementType"],@"movementType",
                                   
                                   nil]]; 
        
	} 
    
    if ([elementName compare:@"node"] == NSOrderedSame && [currentXMLLayer isEqual:@"characters"] ) {
		[characterNodeArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                       [attributeDict objectForKey:@"x"],@"limitX",
                                       [attributeDict objectForKey:@"y"],@"limitY",
                                       nil]]; 
        
    }
    
    
    //BG Elements
    if ([elementName compare:@"LargeCrate"] == NSOrderedSame || 
        [elementName compare:@"smallSugarBag"] == NSOrderedSame ||   
        [elementName compare:@"cratesBox"] == NSOrderedSame || 
        [elementName compare:@"level1_windows"] == NSOrderedSame || 
        [elementName compare:@"palettes"] == NSOrderedSame  ||    
        [elementName compare:@"L1_Shelf"] == NSOrderedSame ||  
        [elementName compare:@"level1_shelfTile"] == NSOrderedSame ||   
        
        [elementName compare:@"sodaPack"] == NSOrderedSame || 
        [elementName compare:@"sugarBags"] == NSOrderedSame || 
        [elementName compare:@"sugarBagsAndCrates"] == NSOrderedSame || 
        
        [elementName compare:@"level2_window"] == NSOrderedSame || 
        [elementName compare:@"level2_chainTile"] == NSOrderedSame ||   
        [elementName compare:@"level2_FMG3"] == NSOrderedSame || 
        [elementName compare:@"level2_MG2"] == NSOrderedSame || 
        
        [elementName compare:@"level2_greenPipe"] == NSOrderedSame || 
        [elementName compare:@"level2_metalPipe"] == NSOrderedSame ||   
        [elementName compare:@"level2_tank"] == NSOrderedSame || 
        [elementName compare:@"level2_pipe1"] == NSOrderedSame ||
        [elementName compare:@"level2_braceLeft"] == NSOrderedSame ||
        [elementName compare:@"level2_braceRight"] == NSOrderedSame ||
        
        [elementName compare:@"level3_cloud"] == NSOrderedSame || 
        [elementName compare:@"level3_MG"] == NSOrderedSame || 
        [elementName compare:@"level3_MG_pylon"] == NSOrderedSame || 
        [elementName compare:@"level3_window"] == NSOrderedSame || 
        
        [elementName compare:@"level3_desk1"] == NSOrderedSame || 
        [elementName compare:@"level3_desk2"] == NSOrderedSame || 
        [elementName compare:@"level3_desk3"] == NSOrderedSame || 
        [elementName compare:@"level3_painting1"] == NSOrderedSame || 
        [elementName compare:@"level3_painting2"] == NSOrderedSame || 
        [elementName compare:@"level3_painting3"] == NSOrderedSame || 
        [elementName compare:@"level3_salesChart"] == NSOrderedSame ||
        
        [elementName compare:@"plant1"] == NSOrderedSame ||
        [elementName compare:@"plant2"] == NSOrderedSame ||
        [elementName compare:@"bookCase"] == NSOrderedSame ||
        [elementName compare:@"filingCab1"] == NSOrderedSame ||
        [elementName compare:@"filingCab2"] == NSOrderedSame ||
        [elementName compare:@"noticeBoard"] == NSOrderedSame 
        
        
        
        ) {	
        
        if ([currentXMLLayer isEqualToString:@"BGLayer1"]) {
            
            [BGArray1 addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                 elementName,@"BGElement",  
                                 [attributeDict objectForKey:@"x"],@"x",
                                 [attributeDict objectForKey:@"y"],@"y",
                                 [attributeDict objectForKey:@"scrollFactor"], @"scrollfactor",
                                 [attributeDict objectForKey:@"width"],@"width",
                                 [attributeDict objectForKey:@"height"],@"height",
                                 nil]]; 
            
        }
        else if ([currentXMLLayer isEqualToString:@"BGLayer2"]) {
            
            [BGArray2 addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                 elementName,@"BGElement",  
                                 [attributeDict objectForKey:@"x"],@"x",
                                 [attributeDict objectForKey:@"y"],@"y",
                                 [attributeDict objectForKey:@"scrollFactor"], @"scrollfactor",
                                 [attributeDict objectForKey:@"width"],@"width",
                                 [attributeDict objectForKey:@"height"],@"height",
                                 nil]]; 
        }
        else if ([currentXMLLayer isEqualToString:@"BGLayer3"]) {
            
            [BGArray3 addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                 elementName,@"BGElement",  
                                 [attributeDict objectForKey:@"x"],@"x",
                                 [attributeDict objectForKey:@"y"],@"y",
                                 _scrollfactor, @"scrollfactor",
                                 [attributeDict objectForKey:@"width"],@"width",
                                 [attributeDict objectForKey:@"height"],@"height",
                                 nil]]; 
        }
        else if ([currentXMLLayer isEqualToString:@"FGLayer1"]) {
            [FGArray1 addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                 elementName,@"BGElement",  
                                 [attributeDict objectForKey:@"x"],@"x",
                                 [attributeDict objectForKey:@"y"],@"y",
                                 [attributeDict objectForKey:@"scrollFactor"], @"scrollfactor",
                                 [attributeDict objectForKey:@"width"],@"width",
                                 [attributeDict objectForKey:@"height"],@"height",
                                 nil]]; 
        }
	}    
    
    
    
    
    lastXMLLayer = elementName;
    
}

//- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
//{
//    
//    //    @try {
//    //        if ([elementName compare:@"width"] == NSOrderedSame     ) {	
//    //            lw = [tempString floatValue];
//    //        }
//    //        if ([elementName compare:@"height"] == NSOrderedSame     ) {	
//    //            lh = [tempString floatValue];
//    //        }
//    //        tempString = @""; 
//    //	} 
//    //	@catch (id theException) {
//    //        FlxG.levelWidth = 2000;
//    //        FlxG.levelHeight = 2000;
//    //
//    //	} 
//    //	@finally {
//    //
//    //	}
//    
//}

//- (void)parserDidEndDocument:(NSXMLParser *)parser {
//	
//	//[parser release];
//	
//}

- (void) loadImageFromXMLNode:(NSDictionary *)XMLNode toGroup:(FlxGroup *)group //withImage:(NSString *)Image
{
    static NSString * Image = @"";
    Image = [XMLNode objectForKey:@"type"] ;
    Image = [Image stringByAppendingString:@".png"];  
    
    if ([XMLNode objectForKey:@"width"]) {
        FlxTileblock * BGElement = [FlxTileblock tileblockWithX:[[XMLNode objectForKey:@"x"] floatValue] y:[[XMLNode objectForKey:@"y"] floatValue] width:[[XMLNode objectForKey:@"width"] floatValue] height:[[XMLNode objectForKey:@"height"] floatValue]];
        [BGElement loadGraphic:Image];
        
        if (group==nil) {
            [self add:BGElement];
        }
        else {
            [group add:BGElement];
            
        }
    }
    
    //otherwise it's just a sprite.
    
    else {
        
        FlxSprite * BGElement = [FlxSprite spriteWithX:[[XMLNode objectForKey:@"x"] floatValue] y:[[XMLNode objectForKey:@"y"] floatValue] graphic:Image];
        if (group==nil) {
            [self add:BGElement];
        }
        else {
            [group add:BGElement];
            
        }    
    }
}

- (void) loadLevelFromXML{
    
    int i;
    
    //BG Array
    static NSString * Image = @"";
    
    for (i = 0; i < [BGArray1 count]; i++) {
        NSDictionary * j = [BGArray1 objectAtIndex:i];
        Image = [j objectForKey:@"BGElement"] ;
        Image = [Image stringByAppendingString:@".png"]; 
        
        //if the object has a width parameter, make it a flxTileblock and tile it out.
        
        if ([j objectForKey:@"width"]) {
            
            
            FlxTileblock * BGElement = [FlxTileblock tileblockWithX:[[j objectForKey:@"x"] floatValue]
                                                                  y:[[j objectForKey:@"y"] floatValue]
                                                              width:[[j objectForKey:@"width"] floatValue] 
                                                             height:[[j objectForKey:@"height"] floatValue]];
            
            [BGElement loadGraphic:Image];
            BGElement.scrollFactor = CGPointMake([[j objectForKey:@"scrollfactor"] floatValue], 1);
            [self add:BGElement];
            
            //NSLog(@" %f %f ", BGElement.x, BGElement.y);
            
            
        }
        
        //otherwise it's just a sprite.
        
        else {
            
            FlxSprite * BGElement = [FlxSprite spriteWithX:[[j objectForKey:@"x"] floatValue]  
                                                         y:[[j objectForKey:@"y"] floatValue] 
                                                   graphic:Image];
            BGElement.scrollFactor = CGPointMake([[j objectForKey:@"scrollfactor"] floatValue], 1);
            [self add:BGElement]; 
            
        }
        
        
        
    }    
    for (i = 0; i < [BGArray2 count]; i++) {
        NSDictionary * j = [BGArray2 objectAtIndex:i];
        Image = [j objectForKey:@"BGElement"] ;
        Image = [Image stringByAppendingString:@".png"];        
        //if the object has a width parameter, make it a flxTileblock and tile it out.
        
        if ([j objectForKey:@"width"]) {
            
            FlxTileblock * BGElement = [FlxTileblock tileblockWithX:[[j objectForKey:@"x"] floatValue] y:[[j objectForKey:@"y"] floatValue] width:[[j objectForKey:@"width"] floatValue] height:[[j objectForKey:@"height"] floatValue]];
            [BGElement loadGraphic:Image];
            BGElement.scrollFactor = CGPointMake([[j objectForKey:@"scrollfactor"] floatValue], 1);
            [self add:BGElement];
            
        }
        
        //otherwise it's just a sprite.
        
        else {
            
            FlxSprite * BGElement = [FlxSprite spriteWithX:[[j objectForKey:@"x"] floatValue] y:[[j objectForKey:@"y"] floatValue] graphic:Image];
            BGElement.scrollFactor = CGPointMake([[j objectForKey:@"scrollfactor"] floatValue], 1);
            [self add:BGElement]; 
            
        }
    } 
    
    
    //hazards
    
    for (i = 0; i < [hazardArray count]; i++) {
        NSDictionary * j = [hazardArray objectAtIndex:i];
        Image = [j objectForKey:@"BGElement"] ;
        Image = [Image stringByAppendingString:@".png"];        
        [self loadImageFromXMLNode:j toGroup:hazards ];
        
        
    } 
    
    for (i = 0; i < [bottleArray count]; i++) {
        NSDictionary * j = [bottleArray objectAtIndex:i];
        
        if ( [[j objectForKey:@"type"] isEqual:@"Bottle"] ) { 
            NSDictionary * j = [bottleArray objectAtIndex:i];
            bottle = [Bottle bottleWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue]  ,[[j objectForKey:@"y"] floatValue])] ;
            [self add:bottle]; 
        }
        else if ( [[j objectForKey:@"type"] isEqual:@"L1_SmallCrate"] ) { 
            crate = [Crate crateWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue]  ,[[j objectForKey:@"y"] floatValue])] ;
            //crate.fixed=YES;
            //crate.solid=YES;
            [crates add:crate];
        }   
        else if ( [[j objectForKey:@"type"] isEqual:@"smallSugarBag"] ) { 
            sugarBag = [SugarBag sugarBagWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue]  ,[[j objectForKey:@"y"] floatValue])] ;
            [self add:sugarBag];
        } 
        else if ( [[j objectForKey:@"type"] isEqual:@"exit"] ) { 
            Image = [j objectForKey:@"type"] ;
            Image = [Image stringByAppendingString:@".png"];  
            //exit = [Exit exit:[[j objectForKey:@"x"] floatValue]  y:[[j objectForKey:@"y"] floatValue] graphic:Image] ;
            exit = [Exit exitWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue],[[j objectForKey:@"y"] floatValue])];
            
            exit.nextLevel = [[j objectForKey:@"x"] intValue];
            
            [self add:exit];
        } 
        else if ( [[j objectForKey:@"type"] isEqual:@"LargeCrate"] ) { 
            LargeCrate * lc = [LargeCrate largeCrateWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue]  ,[[j objectForKey:@"y"] floatValue]) withPlayer:player withLiselot:liselot] ;
            [playerPlatforms add:lc];
            [enemyPlatforms add:lc];          
        } 
        
        //special case HelpBox
        
        else if ( [[j objectForKey:@"type"] isEqual:@"helpBox"] ) { 
            HelpBox * hb = [HelpBox helpBoxWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue]  ,[[j objectForKey:@"y"] floatValue]) ] ;
            hb.helpString=[j objectForKey:@"helpString"];
            hb.type=[[j objectForKey:@"type"] floatValue];
            //hb.alpha=HELP_BOX_ALPHA;
            
            //NSLog(@"%@", [j objectForKey:@"helpString"]);
            
            [self add:hb];
            
            [helpBoxes add:hb];
            //[enemyPlatforms add:lc];          
        }
        
        //special case --- CHECK POINTS ---
        
        else if ( [[j objectForKey:@"type"] isEqual:@"andreCheckPoint"]    ) { 
            CheckPoint * hb = [CheckPoint andreCheckPointWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue]  , [[j objectForKey:@"y"] floatValue]) ] ;
            hb.type=1;
            [self add:hb];
            [helpBoxes add:hb];
        }
        else if ( [[j objectForKey:@"type"] isEqual:@"liselotCheckPoint"]    ) { 
            CheckPoint * hb = [CheckPoint liselotCheckPointWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue]  , [[j objectForKey:@"y"] floatValue]) ] ;
            hb.type=2;
            [self add:hb];
            [helpBoxes add:hb];
        }        
        
        
        
    }
    
    //character array
    
    for (i = 0; i < [characterArray count]; i++) {
        
        NSDictionary * j = [characterArray objectAtIndex:i];
        NSDictionary * limits = [characterNodeArray objectAtIndex:i];
        
        //player 
        if ( [[j objectForKey:@"character"] isEqual:@"player"] ) {        	
            player = [Player playerWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue],[[j objectForKey:@"y"] floatValue]-CHAR_Y_OFFSET)];
            [self add:player];
            player.startsFirst=[[j objectForKey:@"startsFirst"] intValue];
            player.levelName=[j objectForKey:@"levelName"];
            player.andreInitialFlip=[[j objectForKey:@"andreInitialFlip"] intValue];
            player.liselotInitialFlip=[[j objectForKey:@"liselotInitialFlip"] intValue];
            
            player.followHeight=[[j objectForKey:@"followHeight"] intValue];
            player.followWidth=[[j objectForKey:@"followWidth"] intValue];
            
        }  
        
        //liselot
        
        if ( [[j objectForKey:@"character"] isEqual:@"liselot"] ) {        	
            liselot = [Liselot liselotWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue],[[j objectForKey:@"y"] floatValue]-CHAR_Y_OFFSET)];
            [self add:liselot];
            liselot.isPlayerControlled=NO;
            [talkCharacters add:liselot];
            
            
        }
        
        //worker 
        if ( [[j objectForKey:@"character"] isEqual:@"worker"] ) {   
            enemyWorker = [EnemyWorker enemyWorkerWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue],[[j objectForKey:@"y"] floatValue]-CHAR_Y_OFFSET) index:0  ];
            enemyWorker.limitX = [[limits objectForKey:@"limitX"] floatValue];
            enemyWorker.limitY = [[limits objectForKey:@"limitY"] floatValue];
            enemyWorker.velocity = CGPointMake([[j objectForKey:@"speed"] floatValue], 0);
            enemyWorker.originalVelocity=[[j objectForKey:@"speed"] floatValue];
            [self add:enemyWorker];
            [characters add:enemyWorker];
            [charactersWorker add:enemyWorker];
            [talkCharacters add:enemyWorker];
        }
        
        //army 
        if ( [[j objectForKey:@"character"] isEqual:@"army"] ) {   
            enemyArmy = [EnemyArmy enemyArmyWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue],[[j objectForKey:@"y"] floatValue]-CHAR_Y_OFFSET) index:i  ];
            enemyArmy.limitX = [[limits objectForKey:@"limitX"] floatValue];
            enemyArmy.limitY = [[limits objectForKey:@"limitY"] floatValue];
            enemyArmy.velocity = CGPointMake([[j objectForKey:@"speed"] floatValue], 0);
            enemyArmy.originalVelocity=[[j objectForKey:@"speed"] floatValue];
            [self add:enemyArmy];
            [characters add:enemyArmy];
            [charactersArmy add:enemyArmy];
            [talkCharacters add:enemyArmy];
            
        }
        //chef 
        if ( [[j objectForKey:@"character"] isEqual:@"chef"] ) {   
            enemyChef = [EnemyChef enemyChefWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue],[[j objectForKey:@"y"] floatValue]-CHAR_Y_OFFSET) index:i  ];
            enemyChef.velocity = CGPointMake([[j objectForKey:@"speed"] floatValue], 0);
            enemyChef.limitX = [[limits objectForKey:@"limitX"] floatValue];
            enemyChef.limitY = [[limits objectForKey:@"limitY"] floatValue];
            enemyChef.originalVelocity=[[j objectForKey:@"speed"] floatValue];
            
            [self add:enemyChef];
            [characters add:enemyChef];
            [charactersChef add:enemyChef];
            [talkCharacters add:enemyChef];
            
        }        
        //inspector 
        if ( [[j objectForKey:@"character"] isEqual:@"inspector"] ) {   
            enemyInspector = [EnemyInspector enemyInspectorWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue],[[j objectForKey:@"y"] floatValue]-CHAR_Y_OFFSET) index:i  ];
            enemyInspector.velocity = CGPointMake([[j objectForKey:@"speed"] floatValue], 0);
            enemyInspector.limitX = [[limits objectForKey:@"limitX"] floatValue];
            enemyInspector.limitY = [[limits objectForKey:@"limitY"] floatValue];
            enemyInspector.originalVelocity=[[j objectForKey:@"speed"] floatValue];
            
            [self add:enemyInspector];
            [characters add:enemyInspector];
            [charactersInspector add:enemyInspector];
            [talkCharacters add:enemyInspector];
        }    
    }    
    
    // Load all moving platforms
    for (int ii = 0; ii < [movingPlatformsArray count]; ii++) {
        NSDictionary * j = [movingPlatformsArray objectAtIndex:ii];
        NSDictionary * limit = [movingPlatformsLimitsArray objectAtIndex:ii];
        Image = [j objectForKey:@"type"] ;
        Image = [Image stringByAppendingString:@".png"];        
        
        FlxSpriteOnPath * bb = [FlxSpriteOnPath flxSpriteOnPathWithOrigin:CGPointMake([[ j objectForKey:@"x"] floatValue], [[ j objectForKey:@"y"] floatValue]) withSpeed:[[ j objectForKey:@"speed"] floatValue] withLimits:CGPointMake([[limit objectForKey:@"limitX"] floatValue], [[limit objectForKey:@"limitY"] floatValue]) withMovementType:[[j objectForKey:@"movementType"] intValue] isAnimated:[[j objectForKey:@"animated"] boolValue]  ];
        if (![[j objectForKey:@"animated"] boolValue]){
            [bb loadGraphic:Image];
        }
        else {
            [bb loadGraphic:Image animated:YES reverse:NO width:40 height:20];
        }
        
        bb.fixed=YES;
        [playerPlatforms add:bb];
        [enemyPlatforms add:bb];                  
    }	
    
    
    
    
    // LEVEL ARRAY
    
    // Load all rects as tileblocks
    for (int ii = 0; ii < [levelArray count]; ii++) {
        NSDictionary * j = [levelArray objectAtIndex:ii];
        
        // if it's a rect, AUTOTILE a rectangle.
        
        if ( [[j objectForKey:@"type"] isEqual:@"rect"] ) { 
            FlxTileblock * bb = [FlxTileblock tileblockWithX:[[j objectForKey:@"x"] floatValue] y:[[j objectForKey:@"y"] floatValue] width:[[j objectForKey:@"w"] floatValue] height:[[j objectForKey:@"h"] floatValue]];
            [bb loadGraphic:ImgLevelTiles empties:0 autoTile:YES];
            [playerPlatforms add:bb];
            [enemyPlatforms add:bb];
        }
        
        //otherwise it's a platform, load it using the type as the image.
        
        else {
            Image = [j objectForKey:@"type"] ;
            Image = [Image stringByAppendingString:@".png"];        
            //if the object has a width parameter, make it a flxTileblock and tile it out.
            
            if ([j objectForKey:@"width"]) {
                
                FlxTileblock * bb = [FlxTileblock tileblockWithX:[[j objectForKey:@"x"] floatValue] y:[[j objectForKey:@"y"] floatValue] width:[[j objectForKey:@"width"] floatValue] height:[[j objectForKey:@"height"] floatValue]];
                [bb loadGraphic:Image];
                [playerPlatforms add:bb];
                [enemyPlatforms add:bb];                
            }
            
            //special case LargeCrate
            
            else if ( [[j objectForKey:@"type"] isEqual:@"LargeCrate"] ) { 
                LargeCrate * lc = [LargeCrate largeCrateWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue]  ,[[j objectForKey:@"y"] floatValue]) withPlayer:player withLiselot:liselot] ;
                [playerPlatforms add:lc];
                [enemyPlatforms add:lc];          
            }
            
            
            
            
            //otherwise it's just a sprite.
            
            else {
                
                FlxManagedSprite * bb = [FlxManagedSprite spriteWithX:[[j objectForKey:@"x"] floatValue] y:[[j objectForKey:@"y"] floatValue] graphic:Image];
                bb.fixed=YES;
                [playerPlatforms add:bb];
                [enemyPlatforms add:bb];                  
            }
        }
        
        
    }	
    
    
    [self add:playerPlatforms];
    
    [self add:hazards];
    
    [self add:crates];
    
    for (int ii = 0; ii < [levelArrayFake count]; ii++) {
        NSDictionary * j = [levelArrayFake objectAtIndex:ii];
        
        // if it's a rect, AUTOTILE a rectangle.
        
        if ( [[j objectForKey:@"type"] isEqual:@"rect"] ) { 
            FlxTileblock * bb = [FlxTileblock tileblockWithX:[[j objectForKey:@"x"] floatValue] y:[[j objectForKey:@"y"] floatValue] width:[[j objectForKey:@"w"] floatValue] height:[[j objectForKey:@"h"] floatValue]];
            [bb loadGraphic:ImgLevelTiles empties:0 autoTile:YES];
            [self add:bb];
        }
    }
    
    //BG Array 3 - scroll factor of 1. in front of characters.
    
    for (i = 0; i < [BGArray3 count]; i++) {
        NSDictionary * j = [BGArray3 objectAtIndex:i];
        Image = [j objectForKey:@"BGElement"] ;
        Image = [Image stringByAppendingString:@".png"];        
        //if the object has a width parameter, make it a flxTileblock and tile it out.
        if ([j objectForKey:@"width"]) {
            
            FlxTileblock * BGElement = [FlxTileblock tileblockWithX:[[j objectForKey:@"x"] floatValue] y:[[j objectForKey:@"y"] floatValue] width:[[j objectForKey:@"width"] floatValue] height:[[j objectForKey:@"height"] floatValue]];
            [BGElement loadGraphic:Image];
            BGElement.scrollFactor = CGPointMake([[j objectForKey:@"scrollfactor"] floatValue], [[j objectForKey:@"scrollfactor"] floatValue]);
            [self add:BGElement];
            
        }
        
        //otherwise it's just a sprite.
        
        else {
            
            FlxSprite * BGElement = [FlxSprite spriteWithX:[[j objectForKey:@"x"] floatValue] y:[[j objectForKey:@"y"] floatValue] graphic:Image];
            BGElement.scrollFactor = CGPointMake([[j objectForKey:@"scrollfactor"] floatValue], [[j objectForKey:@"scrollfactor"] floatValue]);
            [self add:BGElement]; 
            
        }
    }
    
    
    for (i = 0; i < [FGArray1 count]; i++) {
        NSDictionary * j = [FGArray1 objectAtIndex:i];
        Image = [j objectForKey:@"BGElement"] ;
        Image = [Image stringByAppendingString:@".png"];        
        //if the object has a width parameter, make it a flxTileblock and tile it out.
        
        if ([j objectForKey:@"width"]) {
            
            FlxTileblock * BGElement = [FlxTileblock tileblockWithX:[[j objectForKey:@"x"] floatValue] y:[[j objectForKey:@"y"] floatValue] width:[[j objectForKey:@"width"] floatValue] height:[[j objectForKey:@"height"] floatValue]];
            [BGElement loadGraphic:Image];
            BGElement.scrollFactor = CGPointMake([[j objectForKey:@"scrollfactor"] floatValue], 1);
            [self add:BGElement];
            
        }
        
        //otherwise it's just a sprite.
        
        else {
            
            FlxSprite * BGElement = [FlxSprite spriteWithX:[[j objectForKey:@"x"] floatValue] y:[[j objectForKey:@"y"] floatValue] graphic:Image];
            BGElement.scrollFactor = CGPointMake([[j objectForKey:@"scrollfactor"] floatValue], 1);
            [self add:BGElement]; 
            
        }
    } 
    
    
    
    
}


#pragma mark Initializers

- (void) loadLevelStandards
{
    
    if (FlxG.winnitron) {
        // World 1 - Levels 1 - 12;
        
        if (FlxG.level==1 || FlxG.level==4 || FlxG.level==6) {
            
//            if (FlxG.restartMusic==YES)
//                [FlxG playMusicWithParam1:MusicMegaCannon param2:0.5];
//            else
//                [FlxG unpauseMusic];
            
            ImgLevelTiles=@"level1_tiles.png";
            
            FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:FlxG.height];  
            [grad loadGraphic:@"level1_bgSmoothGrad_new.png" empties:0];
            grad.scrollFactor = CGPointMake(0, 0);
            [self add:grad]; 
            
            
        }
        
        // World 2 - Levels 13 - 24
        else if (FlxG.level==2 || FlxG.level==5) {
            
//            if (FlxG.restartMusic==YES)
//                [FlxG playMusicWithParam1:MusicIceFishing param2:0.5];
//            else
//                [FlxG unpauseMusic];
            
            ImgLevelTiles=@"level2_tiles.png";
            
            static NSString * ImgBG = @"level2_BG.png";
            backG = [FlxSprite spriteWithX:480 y:320 graphic:ImgBG];
            backG.x = 0;
            backG.y = 0;
            backG.scrollFactor = CGPointMake(0, 0);
            [self add:backG];
            
            
        }
        
        //World 3 - Levels 25 - 36h - Management
        
        else if (FlxG.level==3 ) {
            
//            if (FlxG.restartMusic==YES) {
//                [FlxG playMusicWithParam1:MusicPirate param2:0.5];
//            else
//                [FlxG unpauseMusic];
            
            ImgLevelTiles=@"level3_tiles.png";
            
            static NSString * ImgGradient = @"level3_gradient.png";
            FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:FlxG.height];
            grad.scrollFactor = CGPointMake(0, 0);
            [grad loadGraphic:ImgGradient];
            [self add:grad];
            
            
        }
    }
    
    
    else {
        // World 1 - Levels 1 - 12;
        
        if (FlxG.level <= LEVELS_IN_WORLD || FlxG.level==101 || FlxG.level==1001 || FlxG.level==49997 || FlxG.level==59997) {
            
//            if (FlxG.restartMusic==YES)
//                [FlxG playMusicWithParam1:MusicMegaCannon param2:0.5];
//            else
//                [FlxG unpauseMusic];
            
            ImgLevelTiles=@"level1_tiles.png";
            
            FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:FlxG.height];  
            [grad loadGraphic:@"level1_bgSmoothGrad_new.png" empties:0];
            grad.scrollFactor = CGPointMake(0, 0);
            [self add:grad]; 
            
            
        }
        
        // World 2 - Levels 13 - 24
        else if (FlxG.level <= LEVELS_IN_WORLD*2 || FlxG.level==113|| FlxG.level==49998 || FlxG.level==59998) {
            
//            if (FlxG.restartMusic==YES)
//                [FlxG playMusicWithParam1:MusicIceFishing param2:0.5];
//            else
//                [FlxG unpauseMusic];
            
            ImgLevelTiles=@"level2_tiles.png";
            
            static NSString * ImgBG = @"level2_BG.png";
            backG = [FlxSprite spriteWithX:480 y:320 graphic:ImgBG];
            backG.x = 0;
            backG.y = 0;
            backG.scrollFactor = CGPointMake(0, 0);
            [self add:backG];
            
            
        }
        
        //World 3 - Levels 25 - 36h - Management
        
        else if (FlxG.level <= LEVELS_IN_WORLD*3 || FlxG.level==125|| FlxG.level==49999 || FlxG.level==59999) {
            
//            if (FlxG.restartMusic==YES)
//                [FlxG playMusicWithParam1:MusicPirate param2:0.5];
//            else
//                [FlxG unpauseMusic];
            
            ImgLevelTiles=@"level3_tiles.png";
            
            static NSString * ImgGradient = @"level3_gradient.png";
            FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:FlxG.height];
            grad.scrollFactor = CGPointMake(0, 0);
            [grad loadGraphic:ImgGradient];
            [self add:grad];
            
            
        }
    }
    FlxG.restartMusic=NO;

    
    
}


- (void) loadCharacters
{
    int i;
    
    //gibs
    
    
    int gibCount = 25;
    
    ge = [[FlxEmitter alloc] init];
    
    ge.delay = 0.02;
    
    ge.minParticleSpeed = CGPointMake(-40,
                                      -40);
    ge.maxParticleSpeed = CGPointMake(40,
                                      40);
    ge.minRotation = 0;
    ge.maxRotation = 0;
    ge.gravity = -120;
    ge.particleDrag = CGPointMake(10, 10);
    
    
    
    puffEmitter = [ge retain];
    
    
    [self add:puffEmitter];
    
    
    
    [ge createSprites:ImgBubble quantity:gibCount bakedRotations:NO
             multiple:YES collide:0.0 modelScale:1.0];
    
    
    if (FlxG.level>=13 && FlxG.level<=24 ) {
        
        //STEAM 
        sEmit = [[FlxEmitter alloc] init];
        sEmit.delay = 0.02;
        sEmit.minParticleSpeed = CGPointMake(-40,
                                             0);
        sEmit.maxParticleSpeed = CGPointMake(40,
                                             0);
        sEmit.minRotation = -5;
        sEmit.maxRotation = 5;
        sEmit.gravity = 0;
        sEmit.particleDrag = CGPointMake(0, 0);
        
        sEmit.x = 0;
        sEmit.y = 0;
        sEmit.width = FlxG.levelWidth;
        sEmit.height = FlxG.levelHeight;
        
        steamEmitter = [sEmit retain];
        
        
        [self add:steamEmitter];
        [sEmit createSprites:ImgSteam quantity:20 bakedRotations:NO
                    multiple:YES collide:0.0 modelScale:1.0]; 
        [sEmit startWithParam1:YES param2:140 param3:20 ];  
        
    }
    
    //gibs
    cEmit = [[FlxEmitter alloc] init];
    cEmit.delay = 0.02;
    cEmit.minParticleSpeed = CGPointMake(-140,
                                         -140);
    cEmit.maxParticleSpeed = CGPointMake(140,
                                         140);
    cEmit.minRotation = 0;
    cEmit.maxRotation = 720;
    cEmit.gravity = 450;
    cEmit.particleDrag = CGPointMake(10, 10);
    
    cEmit.x = 0;
    cEmit.y = FlxG.levelHeight-100;
    cEmit.width = FlxG.levelWidth;
    cEmit.height = 2;
    
    crateShardEmitter = [cEmit retain];
    
    
    [self add:crateShardEmitter];
    [cEmit createSprites:@"crateShards.png" quantity:100 bakedRotations:NO
                multiple:YES collide:0.0 modelScale:1.0]; 
    
}

- (void)loadUnknownXML {
    // Load and parse the books.xml file
    
    NSString * levelFile = @"level";
    if (FlxG.hardCoreMode) {
        levelFile = @"hclevel";
    }
    
    if (FlxG.winnitron) {
        levelFile= @"w_level";
    }
    
    int levelNumber = FlxG.level;
    levelFile = [levelFile stringByAppendingFormat:@"%d", levelNumber];
    levelFile = [levelFile stringByAppendingString:@".oel"];
    
    tbxml = [[TBXML tbxmlWithXMLFile:levelFile] retain];
    
    // If TBXML found a root node, process element and iterate all children
    if (tbxml.rootXMLElement)
        [self traverseElement:tbxml.rootXMLElement];
    
    // release resources
    [tbxml release];
}

- (void) traverseElement:(TBXMLElement *)element {
    
    do {
        
        if ([[TBXML elementName:element] isEqualToString:@"width"]) {
            
            //NSLog(@"element %@ text for element %@",[TBXML elementName:element], [TBXML textForElement:element]);
            float width = [[TBXML textForElement:element] floatValue];
            lw=width;
            //NSLog(@"WIDTH!!!%f", width);
        }
        
        if ([[TBXML elementName:element] isEqualToString:@"height"]) {
            //NSLog(@"height!!!");
            //NSLog(@"element %@ text for element %@",[TBXML elementName:element], [TBXML textForElement:element]);
            float height = [[TBXML textForElement:element] floatValue];
            lh=height;
        }
        // Obtain first attribute from element
        TBXMLAttribute * attribute = element->firstAttribute;
        
        // if attribute is valid
        while (attribute) {
            // Display name and value of attribute to the log window
            //            NSLog(@"element %@ attr %@ == %@ ",
            //                  [TBXML elementName:element],
            //                  [TBXML attributeName:attribute],
            //                  [TBXML attributeValue:attribute]);
            
            // Obtain the next attribute
            attribute = attribute->next;
        }
        
        // if the element has child elements, process them
        if (element->firstChild) {
            [self traverseElement:element->firstChild];
        }
        
        // Obtain next sibling element
    } while ((element = element->nextSibling));  
}


#pragma mark Create


- (void) create
{        
    [FlxG setMaxElapsed:0.033];
    timerForGameComplete=0;
    isGameCompleteState=NO;
    
    
    //    FlxG.levelWidth=[lw floatValue];
    //    FlxG.levelHeight=[lh floatValue];
    
    tempPointForFollowObject = CGPointMake(0, 0);
    
    [self loadUnknownXML];
    
    FlxG.levelWidth=lw;
    FlxG.levelHeight=lh;
    
    _levelFinished=NO;
    
    //FlxG.level = 1;
    
    //NSLog(@" hc %d", FlxG.hardCoreMode);
    
    paused=NO;
    
    _levelFinished=NO;
    speechTextCycler=1;
    
    if (!FlxG.hardCoreMode) {
    
        
        speechTexts = [[NSArray alloc] initWithObjects:
                       
                       //army
                       
                       [NSMutableArray arrayWithObjects:
                        @"", //0
                        @"", //1 
                        @"You've got to remember, we are here as peace keepers. The guerrillas are the enemy.", //2
                        @"We're looking to use your soft drinks to pad out our rations to our soliders.", //3
                        @"If you agree to supply us with soft drinks, you'll need to sign a contract.", @"   ", //4,5                    
                        @"If you agree to supply us with soft drinks, you'll need to sign a contract.", //6
                        @"",@"", //7,8
                        @"Our contract would require 30 crates per week. Failure to deliver will result in penalties.", //9
                        @"", //10
                        @"We can't force you to supply us with soft drinks. Answering no will make things very difficult for you and your family.", //11
                        @"",//12
                        @"",//13
                        @"",//14
                        @"A French navy ship docked at the harbor. They are having a judo contest with locals later today.",//15
                        @"",//16
                        @"",//17
                        @"",//18
                        @"Unlike your usual customers the military will not be bringing back the empty bottles, and we will not pay extra because of it.", //19
                        @"", //20
                        @"",
                        @"",
                        @"An active military base gives back to the economy.",//23
                        @"",
                        @"",
                        @"We buy the soft drinks and therefore we own the bottles. It's that simple.",//26
                        @"I have the contracts drawn up for you to supply us. I would you remind you that saying no will not be beneficial for anyone.", //27
                        @"Some of the worst crimes in the history of humanity have been carried out by people who were just following orders. And yet I expect my orders to be followed to the letter.",//28
                        @"Your desk is here. Your pens are here. The contract is here. Sign it or there will be trouble!", //29
                        @"", //30
                        @"", //31
                        @"", //32
                        @"", //33
                        @"", //34
                        @"Join the army reserve.", //35
                        @"In a decisive moment man must control himself. When placed under pressure a man reveals his true self.",//36
                        @"Just when you think you know the answers, I change the questions.  ",//37 spare
                        nil],
                       
                       //chef
                       
                       [NSMutableArray arrayWithObjects:
                        @"",
                        @"",//1
                        @"We keep it clean here. That food inspector is such a idiot! We keep it clean, he should leave us alone.", //2
                        @"The secret ingredient is love. And then sugar. Lots and lots of sugar.", //3
                        @"", //4
                        @"", //5;
                        @"We keep it clean here. That food inspector is such a idiot! We keep it clean, he should leave us alone.", //6
                        @"",@"",@"",@"",@"",//7-11
                        @"The secret ingredient is love. And then sugar. Lots and lots of sugar.",//12
                        @"",//13
                        @"The sugar we buy is harvested in the local area. We buy local, keep the profits in our neighborhood.",//14
                        @"",@"",@"",
                        @"We bought our initial empty bottles from Holland from a well known beer company.", //18
                        @"Caffeine citrate and citric acid. Every time we get a delivery the army is here checking that we're not making bombs! ",//19
                        @"Our ingredients are not secret. Our recipe is open to anyone who may want it. Our policy has always been to show the world what we've got and that we do it the best.",//20
                        @"Crushed ice is one of the other products we sell here. I'm not sure how they crush it. Better ask the workers here.",//21
                        @"",@"",@"", //22,23,24
                        @"The product referred to as lemonade is different for each region we ship to. Cloudy lemonade, fizzy lemonade, citronade... The list goes on.",//25
                        @"",
                        @"Pink lemonade is gaining popularity. I am going to spend some time in the lab tightening up the recipe.",//27
                        @"Our rivals tried to steal our recipe. So we published it in the daily newspaper and told them give it their best shot.",//28
                        @"",//29
                        @"",
                        @"",
                        @"To answer your question about what exactly are bitters, we use orange peel and quinine.",//32
                        @"",//33
                        @"Having these glass bottles made is very expensive.",//34
                        @"",
                        @"At the end of the day. At the end of the year. At the end of your life. It's just a recipe.", //36
                        nil],  
                       
                       //inspector
                       
                       [NSMutableArray arrayWithObjects:
                        @"", //0
                        @"Utilitarianism promises the greatest \"good\" for the greatest number... If someone else falls between the cracks, it's not your problem.", //1
                        @"", //2
                        @"Trust, faith and common good. All of them are masks painted to hide corruption.", //3
                        @"", //4
                        @"", //5
                        @"", //6
                        @"", //7
                        @"Utilitarianism promises the greatest \"good\" for the greatest number... If someone else falls between the cracks, it's not your problem.",//8
                        @"",//9
                        @"",//10
                        @"",//11
                        @"",//12
                        @"",//13
                        @"If I am using my wealth to exceed greater odds for my family’s happiness, I don’t see that as any more amoral as buying insurance.",//14
                        @"",//15
                        @"",//16
                        @"",//17
                        @"",//18
                        @"",//19
                        @"Trust, faith and common good. All of them are masks painted to hide corruption.",//20*
                        @"I will turn over every corner of this so called Super Lemonade Factory until I find some dirt.",//21
                        @"You are what you eat, and I will never be dirty.",//22 !
                        @"",//23
                        @"",//24
                        @"Today's inspection has turned up no problems. You should not be congratulated on this, but you will be punished severely if I do find any dirt at a later date.",//25
                        @"I do believe everything is in order today. See to it that you keep it this way.",//26
                        @"I have come here to chew bubblegum and inspect the cleanliness of this factory... and I'm all out of bubblegum.",//27
                        
                        @"Filing TPS reports before 9am. What a great feeling.",//28
                        @"",//29
                        @"",//30
                        @"The recycling of glass bottles has to happen. It's economically viable, and ecologically friendly. Just clean them properly!", //31
                        @"", //32
                        @"", //33
                        @"", //34
                        @"", //35
                        @"Goodness me. I do believe it's 3:30pm. Time to go home. Tax payers will fill in the rest.",//36 - spare
                        @"", //37 spare
                        nil],     
                       
                       //worker
                       
                       [NSMutableArray arrayWithObjects:
                        @"",
                        @"The efforts of industry are not without casualties. And yet we work, and we work hard. Are we not entitled to that which we produce.", //1
                        @"The government is blaming The Super Lemonade Factory for all the broken glass on the road. Can't anyone take some responsibility for themselves.",//2
                        @"7 to 4, 9 to 5, 10 to 6, the hours long, and the work hard on the body.      \n",//3
                        @"7 to 4, 9 to 5, 10 to 6, the hours long, and the work hard on the body.      \n",//4
                        @"This factory started out in Andre's father's garage. He was content to keep circulation small. Andre has big plans to widen the reach of his product.",//5
                        @"",//6
                        @"Your heart is a muscle the size of your fist. Keep loving. Keep fighting.",//7*
                        @"",//8
                        @"",//9
                        @"I want this Super Lemonade Factory to be a non-hierarchical, non-bureaucratic business without private property in the means of production.",//10
                        @"",//11
                        @"",//12
                        @"Sometimes choosing between two bad alternatives does make a difference.     \n  ",//13
                        @"I could ramp up the production. I could increase the bottles per hour. I could do it all. It would go unnoticed and my pay remain the same.",//14
                        @"",
                        @"When I succeed, no one remembers. When I fail, they won't let me forget.",//16*
                        @"I oppose your your private ownership of this company and feel that you engage in wage slavery.",//17
                        @"",//18
                        @"",//19
                        @"",//20
                        @"",//21
                        @"This place is a testament to capitalism and the free market, but who in here can truly call themselves satisfied?",//22
                        @"",//23
                        @"Small business is an important part of the modern day capitalist society. You won't break us. We won't fade away.",//24
                        @"We've got a fairly flat business structure here. By that I mean horizontal organization. Andre and Liselot work along side us just as hard as everyone else.",//25
                        @"",@"",
                        @"I don't know whether I support us providing product to the military. On one hand my job is secure. On the other, I am sympathize with the guerrilla factions.", //28
                        @"", //29
                        @"The inspector is always busting my chops. I let it slide. I won't solve my problems with violence.", //30
                        @"", //31
                        @"I don't trust the new punch card machine. I keep track of my hours in my notebook.", //32
                        @"I'll be out of here at 5pm. Go home, feed my family, and read the newspaper. Ahh the good life.", //33
                        @"", //34
                        @"", //35
                        @"", //36
                        @"",//37
                        nil], 
                       
                       //player
                       
                       
                       
                       [NSMutableArray arrayWithObjects:
                        @"",
                        @"Every month the same old news. Since WWII ended, every month more scare tactics. I run a business, my interest lies with sustaining my business and feeding my family, not war.", //1
                        @"Liselot, my sweet emerald. I give you  my heart, my word and my life. I will work for our family so that they can have a good life.", //2
                        @"Family is all.",//3
                        @"We run a tight ship. I learned that from my time in the Customs Office. Without solid rules, everything runs foul. My workers respect this. They follow my rules.",//4
                        @"I just heard Don't Fence Me In on the wireless. Fantastic song!",//5
                        @"Our sons will run this factory one day. And their sons. And their son's sons.",//6*
                        @"During the World War II, I tried to explain to my younger sisters what chocolate is. Can you imagine, trying to describe chocolate to someone that has never tasted it?",//7
                        @"A military contract to supply soda to the military landed on my desk today. Choosing sides in the turbulent time is risky, but the rewards are great.",
                        @"Before signing anything I need to read it, but I need to be aware of the consequences that aren't written in black and white.",//8
                        @"Signing on with the military would give us a steady cash flow, but it would make us official army contractors. Say the guerrilla factions go after everyone involved with the military. Will our necks be on the chopping block?",//9
                        @"I am off to my meeting with the Governor General.",//10
                        @"Sometimes I feel the information I hand over to the army is more valuable than they give credit for. I am responsible for airing the community's thoughts and grievances. Do they care?",//11
                        @"There's always money in the Lemonade Factory.",//12
                        
                        @"This is the factory. The vats are all made of high quality metal shipped from the United States.", //13
                        @"A man with nothing to lose is a dangerous man.",
                        @"The guerillas are becoming more and more brazen. Our copper pots are the target of theft.",
                        @"Our main ingredients are water and sugar. Both of which were quite rare during the war, but now we have established great relationships with suppliers.",
                        @"My father owned a bicycle factory in the city of Malang.",
                        @"While the coconut oil heats over a fire, we roll the dough into small balls and put a bit of brown sugar in the centre of each ball, and then deep fried it to a golden brown.",
                        @"On one occasion during WWII, I traded two eggs for one handkerchief.      \n  ",
                        @"The Red Cross planes flew very low, dropping rations of food and clothing to us. How we appreciated all the luxuries that were handed out.",
                        @"I decided it was safer to wait until the hysteria abated, so I stayed at the Red Cross compound in Malang.  I slept on the floor but at least they provided me with blankets and food.",
                        @"Our telephone number is 48 if you need to get in touch. Yes, 4 then 8. No other numbers necessary.",
                        @"Years ago I was in Batavia and met a group of seven other men trying to get work on the Steamship Plancius.",
                        @"After two months on the training ship, most of us were transferred to the Abel Tasman, a 5,500 tonne hospital ship.", //24
                        @"Our honeymoon week passed by very quickly. We enjoyed staying at home and going on bicycle trips around the perimeter where it was safe to ride.", //25
                        @"Working at the customs office I received payments of a thousand guilders for detecting and apprehending smugglers.",
                        @"From Batavia we heard the news that extremists were kidnapping people, even throwing them alive into deep wells. ",
                        @"A message from the bank was broadcast over the radio that the currency was devalued by fifty percent! Gone with the wind, our savings were halved, just like that. ",
                        @"I became a permanent public servant in the Dutch Department of Finance, but most of my colleagues left the customs and got positions in the private business sector.",
                        @"We left for Dutch New Guinea with the SS van Riemselijk, a ship from the KPM fleet.",
                        @"One day, we organized an air rifle sharp-shooting contest. We placed six lit candles in a row and the one who could shoot the candles out from a distance of six meters would be the winner.",
                        @"Although the political scene has improved, there is a vast disconnect between those in offices and those in the city.",
                        @"When I was younger we saved very hard for our trip and I had already secured a job with the Schiphol Airport in Amsterdam.",
                        @"My future mother-in-law wanted us to live with the family after we were married.",
                        @"I raced to the bus stop where I usually met Liselot to catch the bus together. When she saw my big smile, she knew.",
                        @"Three and a half years spent in a camp. I was only a young man, I was eighteen years old when I was interned. I saw things unimaginable.", //36
                        
                        
                        
                        
                        nil], 
                       
                       nil];
    }
    
    //HARDCORE 
    
    else if (FlxG.hardCoreMode) {
        speechTexts = [[NSArray alloc] initWithObjects:
                       
                       //HARDCORE army
                       
                       [NSMutableArray arrayWithObjects:
                        @"", //0
                        @"", //1 
                        @"The civil unrest is of some concern, but it's nothing my men can't handle.", //2
                        @"With the streets signs disappearing, we raided the factory that makes them.", //3
                        @"   ", @"   ", //4,5                    
                        @"We found the culprits were stealing street signs at night and selling the exact same signs back to us.", //6
                        @"",@"", //7,8
                        @"A broken arm is painful, but a rifle butt the head will never heal.", //9
                        @"", //10
                        @"A machete is needed for the long grass in the areas outside of the city. Don't ever mess with a man with a machete.", //11
                        @"",//12
                        @"",//13
                        @"",//14
                        @"The judo tournament was a success. We now have a team of black belts in the region.",//15
                        @"",//16
                        @"",//17
                        @"",//18
                        @"A dead man is a quiet man.", //19
                        @"", //20
                        @"",
                        @"",
                        @"An active military base gives back to the community.",//23
                        @"",
                        @"",
                        @"My medic kit is empty. Can we have the name of some local importers that you trust.",//26
                        @"I am a man apart, my work and social life are at polar opposites.", //27
                        @"The war crimes tribunal in this region is neither harsh nor fair. I will fix this if it's the last thing I do.",//28
                        @"Now that we are in business together, let's say we toast to mutual interests.", //29
                        @"", //30
                        @"", //31
                        @"", //32
                        @"", //33
                        @"", //34
                        @"I'll let you finish but I think an American soft drink company has some of the best soda water of all time.", //35
                        @"Friday doesn't mean the same to a military man as it does to a civilian.",//36
                        @"  ",//37 spare
                        nil],
                       
                       //HARDCORE chef
                       
                       [NSMutableArray arrayWithObjects:
                        @"",@"",@"",@"",@"",@"", //0-5;
                        @"The durian flavor I am trying to bring to the wall is being slammed by local critics.", //6
                        @"",@"",@"",@"",@"",//7-11
                        @"Apparently there are local food and drink critics who take soft drink seriously.",//12
                        @"",//13
                        @"Hard work beats talent when talent refuses to work hard.",//14
                        @"",@"",@"",
                        @"The local beach is called Base G.", //18
                        @"Caffeine citrate and citric acid deliveries are always followed by army personnel.",//19
                        @"Show the world what we've got and that we do it the best. If you can beat our flavor, the you have earned your market share.",//20
                        @"We pranked an apprentice by asking him to find skyhooks and ice solution.",//21
                        @"",@"",@"", //22,23,24
                        @"Cloudy lemonade, fizzy lemonade, citronade... Every country has a different idea of lemonade.",//25
                        @"",
                        @"Pink lemonade uses local berries to gain it's hue.",//27
                        @"It's always darkest before the dawn, but pink lemonade tastes better at dusk.",//28
                        @"",//29
                        @"",
                        @"",
                        @"Orange peel and quinine and sometimes lemon rind makes our bitters.",//32
                        @"",//33
                        @"Our telephone number is 48. The post office is 15. Or just dial the operator.",//34
                        @"",
                        @"I see each recipe as a love letter to the senses.", //36
                        nil],  
                       
                       //HARDCORE inspector
                       
                       [NSMutableArray arrayWithObjects:
                        @"", //0
                        @"", //1
                        @"", //2
                        @"", //3
                        @"", //4
                        @"", //5
                        @"", //6
                        @"", //7
                        @"Clean all the things!",//8
                        @"",//9
                        @"",//10
                        @"",//11
                        @"",//12
                        @"",//13
                        @"Dirt, dust and scum. I don't envy the people doing the cleaning, but it has to be done.",//14
                        @"",//15
                        @"",//16
                        @"",//17
                        @"",//18
                        @"",//19
                        @"There's this local fellow that is rather large, so we call him Biggest. He told me it was all a dream.",//20*
                        @"At the inception of a food or drink business, I must enter the premises.",//21
                        @"Not sure how magnets work, but they may help sterilize food.",//22 !
                        @"",//23
                        @"",//24
                        @"No need for an inspection today. You're with us now.",//25
                        @"I do believe we'll be able to reach an agreement.",//26
                        @"I have come here to chew bubblegum and inspect the cleanliness of this factory... and I'm all out of bubblegum.",//27
                        
                        @"False walls and hidden rooms violate many many laws.  ",//28
                        @"",//29
                        @"",//30
                        @"The recycling of glass bottles has to happen. It's economically viable, and ecologically friendly. Just clean them properly!", //31
                        @"", //32
                        @"", //33
                        @"", //34
                        @"", //35
                        @"I've been trying to find sodium based cleaning agents, but ever since the war supplies have been short.",//36 - spare
                        @"", //37 spare
                        nil],     
                       
                       //HARDCORE worker
                       
                       [NSMutableArray arrayWithObjects:
                        @"",
                        @"I would work thanklessly to end human misery, but that doesn't make any money.", //1
                        @"You work like a dog, and what do you get?",//2
                        @"",//3
                        @"I'm good at fixing things. From the pipes to a desk, I'll fix it.",//4
                        @"How can you even begin to know of my own personal struggles?",//5
                        @"",//6
                        @"I trust that people are beings with good intentions, but you can’t expect to harvest a crop in a sewer.",//7*
                        @"",//8
                        @"",//9
                        @"The tragedy is not in the recognition of your fate, but the weight that rests on your shoulders when no one is there to help you.",//10
                        @"",//11
                        @"",//12
                        @"I'd hit the road but I've got a family. I'm tied down. The wife, the house, the kids. ",//13
                        @"I wrote her a love letter, but she doesn't know how to read.",//14
                        @"",
                        @"I hope I'm alive to see a day where the banks go under.",//16*
                        @"The working underclass is a prison cell.",//17
                        @"We could use new tools. The tools would be available for everyone to use.",//18
                        @"",//19
                        @"",//20
                        @"",//21
                        @"I always root for the underdog.",//22
                        @"",//23
                        @"Small business is the life-blood of a community.",//24
                        @"These new imported spanners are just a dream to work with.",//25
                        @"",@"",
                        @"The fake walls? Well, no, of course I do not speak of them to outsiders.", //28
                        @"", //29
                        @"For anything to change I need complete worker solidarity and I need it to reach all the way to the top, which is you.", //30
                        @"", //31
                        @"The new punch card machine just ate my card. I telephoned support and they told me to turn it off and on again.", //32
                        @"Everything I earn goes to my family.", //33
                        @"", //34
                        @"", //35
                        @"", //36
                        @"",//37
                        nil], 
                       
                       //HARDCORE player
                       
                       
                       [NSMutableArray arrayWithObjects:
                        @"",
                        @"The bicycle store and repair shop we owned in Malang was wonderful.      \n  ", //1
                        @"It's hard to imagine now, but in 1930's and 1940's bicycles were the main mode of transport. If you saw a car it was usually a government head of department.", //2
                        @"And so the bicycle repair business cemented us as pillars of the community.",//3
                        @"Our bicycle parts were shipped mainly from Holland, but also from the United States.",//4
                        @"As a result of our trade partners in Holland, we also were able to import Flying Dutchmen style billy carts.",//5
                        @"I know you don't like to talk about it Liselot, but the world must know the horrors of war.",//6
                        @"Liselot was riding her bike during the war, and was hit in the jaw with the butt of a rifle.",//7
                        @"One does not simply walk into a Lemonade Factory.",//8
                        @"The steady cash flow from the military contract has enabled us to pay all of workers on time.",//9
                        @"The Governor General has once again proclaimed this territory to be a thriving business district, and given us tax breaks.",//10
                        @"That army general is always asking for inside information on the workers here. I tell him what I can, not what I know.",//11
                        @"There's always money in the Lemonade Factory, except when there is lemons.",//12
                        
                        @"The junk yards don't ask questions when receiving scrap metal. Some of our copper tubing has gone missing.", //13
                        @"A man with nothing to lose is a dangerous man. The bottom of the barrel is a often more dangerous for those around someone who is residing there.",
                        @"The guerillas have been spotted closer to the city.",
                        @"Our suppliers of citrus fruits are so shady.",
                        @"When night fell and Pa still had not returned home, my mother became extremely concerned as this was out of character for him.",
                        @"My older brother Jan, who has joined the Dutch army, is in Burma.",
                        @"We asked what had happened to the bicycle factory and shop.  Ma started to cry and said that everything was confiscated.",
                        @"I will never forget that ill-fated morning when I rode the bus to Malang.",
                        @"The new punch card machine is working well. Clock in, clock out.",
                        @"We might need to think about an exchange incentive to have people return their empty bottles.",
                        @"This guy on the street comes up to me and says hey buddy. I didn't know who he was.",
                        @"Keeping those pipes clean is important. ", //24
                        
                        @"I still know people at the customs office and get first class treatment when I order things from Holland.", //25
                        @"Working at the customs office I have now seen the difference between government and private enterprise.",
                        @"A broken bike is nothing to worry about. I've fixed hundreds of them.",
                        @"He told me a joke about running really fast and being able to get down the stairs... I didn't quite follow it.",
                        @"No client is too big or too small. We'll sell to the military, we'll sell to the local street vendors.",
                        @"Our first big contract was with Dutch import and export company.",
                        @"When we signed on the dotted line with the Dutch import and export company, they invited us to a grand party.",
                        @"We made sure everyone got a taste of our product at the party.",
                        @"The airline office is just down the road. I suggest we sell them refreshments.",
                        @"I never let my business get in the way of my family.",
                        @"This is very strictly a family business.",
                        @"Family is all.", //36
                        nil], 
                       nil];
    }
    
    
    hasCheckedGameOverScreen=NO;
    
    killedArmy = 0;
    killedChef = 0;
    killedInspector = 0;
    killedWorker = 0;
    collectedBottles = 0;
    
    FlxG.score = 0;
    bulletDamage = 1.0;
    
    [self loadLevelStandards];
    
    [self loadLevelFromXML];
    
    [self loadCharacters];
    
    
    
    int fw=player.followWidth;
    int fh=player.followHeight;
    if (player.followWidth==0) {
        fw=lw;
    }
    if (player.followHeight==0) {
        fh=lh;
    }
    [FlxG followBoundsWithParam1:0 param2:0 param3:fw param4:fh param5:YES];
    
    currentFollowHeight=fh;
    currentFollowWidth=fw;
    
    // Virtual Control Pad - VCP
    
    buttonStartAlpha = [[[NSUserDefaults standardUserDefaults] objectForKey:@"buttonStartAlpha"] floatValue];
    buttonPressedAlpha = [[[NSUserDefaults standardUserDefaults] objectForKey:@"buttonPressedAlpha"] floatValue];
    
    //if using external controller, turn these off
    
    if (FlxG.gamePad!=0) {
        buttonStartAlpha=0;
        buttonPressedAlpha=0;
    }
    
    //    NSLog(@"%d", [[[NSUserDefaults standardUserDefaults] objectForKey:@"InGameHelp"] boolValue]);
    
    displayInGameHelp = [[[NSUserDefaults standardUserDefaults] objectForKey:@"InGameHelp"] boolValue];
    switchCharactersOnDeath = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SwitchOnPlayerDeath"] boolValue];
    smoothCameraMoveDuration = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SmoothCameraMoveDuration"] floatValue];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    NSInteger LAX, LAY, RAX, RAY, B1X, B1Y, B2X, B2Y;
    
//    if (FlxG.iPad) {
//        LAX = [prefs integerForKey:@"LEFT_ARROW_POSITION_X_IPAD"];
//        LAY = [prefs integerForKey:@"LEFT_ARROW_POSITION_Y_IPAD"];
//        RAX = [prefs integerForKey:@"RIGHT_ARROW_POSITION_X_IPAD"];
//        RAY = [prefs integerForKey:@"RIGHT_ARROW_POSITION_Y_IPAD"];
//        
//        B1X = [prefs integerForKey:@"BUTTON_1_POSITION_X_IPAD"];
//        B1Y = [prefs integerForKey:@"BUTTON_1_POSITION_Y_IPAD"];
//        B2X = [prefs integerForKey:@"BUTTON_2_POSITION_X_IPAD"];
//        B2Y = [prefs integerForKey:@"BUTTON_2_POSITION_Y_IPAD"];
//    }
//    
//    else {
        LAX = [prefs integerForKey:@"LEFT_ARROW_POSITION_X"];
        LAY = [prefs integerForKey:@"LEFT_ARROW_POSITION_Y"];
        RAX = [prefs integerForKey:@"RIGHT_ARROW_POSITION_X"];
        RAY = [prefs integerForKey:@"RIGHT_ARROW_POSITION_Y"];
        
        B1X = [prefs integerForKey:@"BUTTON_1_POSITION_X"];
        B1Y = [prefs integerForKey:@"BUTTON_1_POSITION_Y"];
        B2X = [prefs integerForKey:@"BUTTON_2_POSITION_X"];
        B2Y = [prefs integerForKey:@"BUTTON_2_POSITION_Y"];

    
    
    buttonLeft  = [FlxSprite spriteWithX:80 y:80 graphic:@"buttonArrow.png"];
    buttonLeft.x = LAX;
    buttonLeft.y = LAY;
    buttonLeft.alpha=buttonStartAlpha;
    buttonLeft.scrollFactor = CGPointMake(0, 0);
	[self add:buttonLeft];
    
    buttonRight  = [FlxSprite spriteWithX:80 y:80 graphic:@"buttonArrow.png"];
    buttonRight.x = RAX;
    buttonRight.y = RAY;
    buttonRight.angle = 180;
    buttonRight.alpha=buttonStartAlpha;
    buttonRight.scrollFactor = CGPointMake(0, 0);
	[self add:buttonRight];  
    
    buttonA  = [FlxSprite spriteWithX:80 y:80 graphic:@"buttonA.png"];
    buttonA.x = B1X;
    buttonA.y = B1Y;
    buttonA.alpha=buttonStartAlpha;
    buttonA.scrollFactor = CGPointMake(0, 0);
	[self add:buttonA];
    
    buttonB  = [FlxSprite spriteWithX:80 y:80 graphic:@"buttonB.png"];
    buttonB.x = B2X;
    buttonB.y = B2Y;
    buttonB.alpha=buttonStartAlpha;
    buttonB.scrollFactor = CGPointMake(0, 0);
	[self add:buttonB]; 
    
    
    
    
//    if (FlxG.iPad) {
//        buttonLeft.x -=32;
//        buttonRight.x -=32;
//        buttonA.x +=32;
//        buttonB.x +=32;
//        
//    }
    
    
    hud = [Hud hudWithOrigin:CGPointMake(4, 4)];
    hud.scrollFactor = CGPointZero;
    [self add:hud];
    
    speechBubble = [FlxTileblock tileblockWithX:40 y:180 width:180 height:80];  
    [speechBubble loadGraphic:@"speechBubbleTiles.png" empties:0 autoTile:NO isSpeechBubble:4];
    speechBubble.visible=NO;
    speechBubble.scrollFactor  = CGPointMake(1, 1);
    [self add:speechBubble];
    
    speechBubbleText = [FlxText textWithWidth:180
                                         text:@" "
                                         font:@"Flixel"
                                         size:8.0];
    speechBubbleText.color = 0x00000000;
	speechBubbleText.alignment = @"center";
	speechBubbleText.x = speechBubble.x;
	speechBubbleText.y = speechBubble.y;
    speechBubbleText.shadow = 0x00000000;
    speechBubbleText.visible = NO;
    speechBubbleText.scrollFactor = CGPointMake(1, 1);
	[self add:speechBubbleText];
    
    gameOverScreenDarken  = [FlxSprite spriteWithX:0 y:0 graphic:nil];
	[gameOverScreenDarken createGraphicWithParam1:FlxG.width param2:FlxG.height param3:0xff000000];
	gameOverScreenDarken.visible = NO;
    gameOverScreenDarken.alpha = 0.6;
    gameOverScreenDarken.x = 0;
    gameOverScreenDarken.y = 0;
    gameOverScreenDarken.scrollFactor = CGPointZero;
    gameOverScreenDarken.drag = CGPointMake(500, 500);
	[self add:gameOverScreenDarken];
    
    fadeInOut  = [FlxSprite spriteWithX:0 y:0 graphic:nil];
	[fadeInOut createGraphicWithParam1:FlxG.width param2:FlxG.height param3:0xff000000];
	fadeInOut.visible = YES;
    fadeInOut.alpha = 1;
    fadeInOut.x = 0;
    fadeInOut.y = 0;
    fadeInOut.scrollFactor = CGPointZero;
    fadeInOut.drag = CGPointMake(500, 500);
	[self add:fadeInOut];
    
    pauseGraphic  = [FlxSprite spriteWithX:0 y:0 graphic:@"pause.png"];
    pauseGraphic.x = FlxG.width-40;
    pauseGraphic.y = 10;
    pauseGraphic.scrollFactor = CGPointZero;
    pauseGraphic.drag = CGPointMake(500, 500);
	[self add:pauseGraphic];
    
    resumeGraphic  = [FlxSprite spriteWithX:0 y:0 graphic:@"resume.png"];
    resumeGraphic.x = FlxG.width-40;
    resumeGraphic.y = 10;
    resumeGraphic.visible=NO;
    resumeGraphic.scrollFactor = CGPointZero;
    resumeGraphic.drag = CGPointMake(500, 500);
    
	[self add:resumeGraphic];
    
    
    
    
    buttonRestart  = [FlxSprite spriteWithX:0 y:0 graphic:nil];
    
    [buttonRestart loadGraphicWithParam1:@"restart.png" param2:YES param3:NO param4:130 param5:180];
    [buttonRestart addAnimationWithParam1:@"0" param2:[NSMutableArray intArrayWithSize:1 ints:0] param3:0 param4:YES]; 
    [buttonRestart addAnimationWithParam1:@"1" param2:[NSMutableArray intArrayWithSize:1 ints:1] param3:0 param4:YES]; 
    [buttonRestart addAnimationWithParam1:@"2" param2:[NSMutableArray intArrayWithSize:1 ints:2] param3:0 param4:YES]; 

    
    buttonRestart.x = 0;
    buttonRestart.y = 10;
    buttonRestart.scrollFactor = CGPointZero;
    buttonRestart.visible=NO;
    buttonRestart.drag = CGPointMake(500, 500);
	[self add:buttonRestart];
    [buttonRestart play:@"0"];
    
    
    
    
    
    
    //helpTextBubble = [HelpLabel tileblockWithX:40 y:8 width:FlxG.width-90 height:50];  
    helpTextBubble = [HelpLabel helpLabelWithOrigin:CGPointMake(40, 8)];
    helpTextBubble.x=40;
    helpTextBubble.y=8;
    
    //[helpTextBubble loadGraphic:@"speechBubbleTiles.png" empties:0 autoTile:NO isSpeechBubble:-1];
    helpTextBubble.visible=NO;
    helpTextBubble.scrollFactor  = CGPointMake(0, 0);
    [self add:helpTextBubble];
    
    helpText = [FlxText textWithWidth:380 //FlxG.width-100
                                 text:@"Nothing"
                                 font:@"SmallPixel"
                                 size:16.0];
    helpText.color = 0x00ffffff;
	helpText.alignment = @"center";
	helpText.x = 50;
	helpText.y = 10;
    helpText.visible = NO;
    helpText.scrollFactor = CGPointMake(0, 0);
	[self add:helpText];
    
//    buttonPlay  = [FlxSprite spriteWithX:FlxG.width/5 y:20 graphic:@"play.png"];
//    buttonPlay.alpha=1;
//    buttonPlay.visible = NO;
//    buttonPlay.scale = CGPointMake(2, 2);
//    buttonPlay.scrollFactor = CGPointMake(0, 0);
//    buttonPlay.drag = CGPointMake(500, 500);
//	[self add:buttonPlay]; 
    
    buttonPlay = [[[FlxButton alloc]   initWithX:FlxG.width*0.25 - 59
                                              y:-20
                                       callback:[FlashFunction functionWithTarget:self
                                                                           action:@selector(onPlay)]] autorelease];
    buttonPlay.scrollFactor=CGPointMake(0, 0);
    buttonPlay.drag = CGPointMake(500, 500);
    buttonPlay.visible = NO;
    
    
    [buttonPlay loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
    [buttonPlay loadTextWithParam1:[FlxText textWithWidth:buttonPlay.width
                                                    text:NSLocalizedString(@"play", @"play")
                                                    font:@"SmallPixel"
                                                    size:16.0] param2:[FlxText textWithWidth:buttonPlay.width
                                                                                        text:NSLocalizedString(@"play...", @"play...")
                                                                                        font:@"SmallPixel"
                                                                                        size:16.0] withXOffset:0 withYOffset:buttonPlay.height/4];
    [self add:buttonPlay];
    
    
    
    
//    nextLevel  = [FlxSprite spriteWithX:FlxG.width/5-10 y:20 graphic:@"nextLevel.png"];
//    nextLevel.alpha=1;
//    nextLevel.visible = NO;
//    nextLevel.scale = CGPointMake(2, 2);
//    nextLevel.scrollFactor = CGPointMake(0, 0);
//    nextLevel.drag = CGPointMake(500, 500);
//	[self add:nextLevel]; 
    
    
    
    nextLevel = [[[FlxButton alloc]   initWithX:FlxG.width*0.25 - 59
                                               y:-20
                                        callback:[FlashFunction functionWithTarget:self
                                                                            action:@selector(onNextLevel)]] autorelease];
    nextLevel.scrollFactor=CGPointMake(0, 0);
    nextLevel.drag = CGPointMake(500, 500);
    nextLevel.visible = NO;
    
    
    [nextLevel loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
    [nextLevel loadTextWithParam1:[FlxText textWithWidth:buttonPlay.width
                                                     text:NSLocalizedString(@"next", @"next")
                                                     font:@"SmallPixel"
                                                     size:16.0] param2:[FlxText textWithWidth:buttonPlay.width
                                                                                         text:NSLocalizedString(@"next...", @"next...")
                                                                                         font:@"SmallPixel"
                                                                                         size:16.0] withXOffset:0 withYOffset:buttonPlay.height/4];
    [self add:nextLevel];
    
    
    
    
    
    
//    buttonMenu  = [FlxSprite spriteWithX:FlxG.width/5 + FlxG.width/2 y:20 graphic:@"menu.png"];
//    buttonMenu.alpha=1;
//    buttonMenu.visible = NO;
//    buttonMenu.scale = CGPointMake(2, 2);
//    buttonMenu.scrollFactor = CGPointMake(0, 0);
//    buttonMenu.drag = CGPointMake(500, 500);
//	[self add:buttonMenu];  
    
    
    buttonMenu = [[[FlxButton alloc]   initWithX:FlxG.width*0.75 - 59
                                             y:-20
                                      callback:[FlashFunction functionWithTarget:self
                                                                          action:@selector(onMenu)]] autorelease];
    buttonMenu.scrollFactor=CGPointMake(0, 0);
    buttonMenu.drag = CGPointMake(500, 500);
    buttonMenu.visible = NO;
    
    
    [buttonMenu loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
    [buttonMenu loadTextWithParam1:[FlxText textWithWidth:buttonPlay.width
                                                   text:NSLocalizedString(@"menu", @"menu")
                                                   font:@"SmallPixel"
                                                   size:16.0] param2:[FlxText textWithWidth:buttonPlay.width
                                                                                       text:NSLocalizedString(@"MENU...", @"MENU...")
                                                                                       font:@"SmallPixel"
                                                                                       size:16.0] withXOffset:0 withYOffset:buttonPlay.height/4];
    [self add:buttonMenu];
    
    
    
    
    
//    levelSelect  = [FlxSprite spriteWithX:FlxG.width/5 + FlxG.width/2-10 y:20 graphic:@"levelSelect.png"];
//    levelSelect.alpha=1;
//    levelSelect.visible = NO;
//    levelSelect.scale = CGPointMake(2, 2);
//    levelSelect.scrollFactor = CGPointMake(0, 0);
//    levelSelect.drag = CGPointMake(500, 500);
//	[self add:levelSelect]; 
    
    
    levelSelect = [[[FlxButton alloc]   initWithX:FlxG.width*0.75 - 59
                                               y:-20
                                        callback:[FlashFunction functionWithTarget:self
                                                                            action:@selector(onLevelSelect)]] autorelease];
    levelSelect.scrollFactor=CGPointMake(0, 0);
    levelSelect.drag = CGPointMake(500, 500);
    levelSelect.visible = NO;
    
    
    [levelSelect loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
    [levelSelect loadTextWithParam1:[FlxText textWithWidth:buttonPlay.width
                                                     text:NSLocalizedString(@"menu", @"menu")
                                                     font:@"SmallPixel"
                                                     size:16.0] param2:[FlxText textWithWidth:buttonPlay.width
                                                                                         text:NSLocalizedString(@"menu...", @"menu...")
                                                                                         font:@"SmallPixel"
                                                                                         size:16.0] withXOffset:0 withYOffset:buttonPlay.height/4];
    [self add:levelSelect];
    
    
    
    
    
    levelComplete  = [LevelComplete levelCompleteWithOrigin:CGPointMake(FlxG.width/2-284/2,FlxG.height/2-181/2) ];
    levelComplete.visible = NO;
    levelComplete.scrollFactor = CGPointMake(0, 0);
    levelComplete.angularDrag=2500;
	[self add:levelComplete]; 
    
    
    
    
    //    capLevel  = [ScoreCaps scoreCapsWithOrigin:CGPointMake(FlxG.width/2-48,FlxG.height/2+120) ];
    //    capLevel.visible = NO;
    //    capLevel.scrollFactor = CGPointMake(0, 0);
    //    capLevel.angularDrag=2500;
    //	[self add:capLevel];
    //    if (FlxG.hardCoreMode) {
    //        [capLevel play:@"hardcore"];
    //    }
    //    else {
    //        [capLevel play:@"regular"];
    //    }
    //    
    //    capAndre  = [ScoreCaps scoreCapsWithOrigin:CGPointMake(FlxG.width/2-8,FlxG.height/2+120) ];
    //    capAndre.visible = NO;
    //    capAndre.scrollFactor = CGPointMake(0, 0);
    //    capAndre.angularDrag=2500;
    //    capAndre.scaleRate=0.06;
    //    capAndre.sound=@"scoreCap2";
    //	[self add:capAndre];
    //    
    //    capLiselot  = [ScoreCaps scoreCapsWithOrigin:CGPointMake(FlxG.width/2+32,FlxG.height/2+120) ];
    //    capLiselot.visible = NO;
    //    capLiselot.scrollFactor = CGPointMake(0, 0);
    //    capLiselot.angularDrag=2500;
    //    capLiselot.scaleRate=0.045;
    //    capLiselot.sound=@"scoreCap3";
    //
    //	[self add:capLiselot];
    
    liselotIcon  = [FlxSprite  spriteWithX:FlxG.width/2+28 y:FlxG.height/2+90 graphic:@"liselotIcon.png"];
    liselotIcon.visible = NO;
    liselotIcon.scrollFactor = CGPointMake(0, 0);
	[self add:liselotIcon];
    
    andreIcon  = [FlxSprite  spriteWithX:FlxG.width/2-12 y:FlxG.height/2+90 graphic:@"andreIcon.png"];
    andreIcon.visible = NO;
    andreIcon.scrollFactor = CGPointMake(0, 0);
	[self add:andreIcon]; 
    
    talkIcon  = [FlxSprite  spriteWithX:-100 y:-100 graphic:@"talkedToPlain.png"];
    //    talkIcon.scrollFactor = CGPointMake(0, 0);
	[self add:talkIcon]; 
    talkIcon.visible=NO;
    
    followObject  = [FlxSprite  spriteWithX:player.x y:player.y graphic:@"andreIcon.png"];
    followObject.visible = NO;
	[self add:followObject];
    
    //    if (FlxG.debugMode) {
    //        followObject.visible = YES;
    //    }
    
    [FlxG followWithParam1:followObject param2:15];
//    [FlxG followAdjustWithParam1:1.5 param2:0];

    
    //[FlxG followBoundsWithParam1:0 param2:0 param3:FlxG.levelWidth param4:FlxG.levelHeight+VERTICAL_OVERSHOOT_OF_LEVEL param5:YES];
    
    
    
    levelNameInfo = [FlxText textWithWidth:FlxG.width
                                      text:@""
                                      font:@"SmallPixel"
                                      size:16.0];
    levelNameInfo.color = 0x00ffffff;
	levelNameInfo.alignment = @"center";
	levelNameInfo.x = 0;
	levelNameInfo.y = FlxG.height-30;
    levelNameInfo.visible = NO;
    levelNameInfo.scrollFactor = CGPointMake(0, 0);
	[self add:levelNameInfo];
    
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
    
    //make sure vcp is on.
    
    FlxG.touches.humanControlled=YES;
    
    // last minute checks before level starts.
    
    player.isPiggyBacking=NO;
    liselot.isPiggyBacking=NO;
    
    // see if either character needs to be flipped.
    
    if (player.andreInitialFlip==1) {
        player.scale=CGPointMake(-1, 1);
    }
    if (player.liselotInitialFlip==1) {
        liselot.scale=CGPointMake(-1, 1);
    }    
    
    //see which character starts first.
    
    if (player.startsFirst == 0) {
        followObject.x=liselot.x;
        followObject.y=liselot.y;
        [self switchCharacters:NO flicker:0.0001 withSound:NO followReset:NO];
        
    }
    
    
    //make bottle ORANGE if already collected.
    
    NSString * levelFile = @"level";
    if (FlxG.hardCoreMode) {
        levelFile = @"hclevel";
    }
    int levelNumber = FlxG.level;
    levelFile = [levelFile stringByAppendingFormat:@"%d", levelNumber];
    
    NSInteger levelProgress = [prefs integerForKey:levelFile];
    
    if (levelProgress >= 2) {
        [bottle play:@"orange"];
//        bottle.x=-100;
//        bottle.y=-100;
//        bottle.dead=YES;
    }
    
    NSString * levelTemp = @"Now Playing: ";
    
    levelNameInfo.text = [levelTemp stringByAppendingString:player.levelName];
    
    
    navArrow = [NavArrow navArrowWithOrigin:CGPointMake(0, 0)];
    [self add:navArrow]; 
    
    navArrow.currentValue=1;
    navArrow.maxValue=3;
    
    navArrow.loc1=CGPointMake(5, 30);
    navArrow.loc2=CGPointMake(5, 150);
    navArrow.loc3=CGPointMake(FlxG.width-55, 2);
    navArrow.loc4=CGPointMake(-100, -100);

    
    navArrow.scrollFactor=CGPointMake(0, 0);
    
    //navArrow.visible=NO;
    
    
    
    
    //Notifications for levels
    
    //    if (FlxG.level <= LEVELS_IN_WORLD  ) {
    //        if (!FlxG.hardCoreMode) {
    //            [FlxG showAlertWithTitle:@"Now playing level:" message:player.levelName image:[UIImage imageNamed:@"iconWarehouse.png"]];
    //        }
    //        else if (FlxG.hardCoreMode) {
    //            [FlxG showAlertWithTitle:@"Now playing hardcore level:" message:player.levelName image:[UIImage imageNamed:@"iconWarehouse.png"]];
    //        }
    //    }
    //    
    //    // World 2 - Levels 13 - 24
    //    else if (FlxG.level <= LEVELS_IN_WORLD*2 ) {
    //        if (!FlxG.hardCoreMode) {
    //            [FlxG showAlertWithTitle:@"Now playing level:" message:player.levelName image:[UIImage imageNamed:@"iconFactory.png"]];
    //        }
    //        else if (FlxG.hardCoreMode) {
    //            [FlxG showAlertWithTitle:@"Now playing hardcore level:" message:player.levelName image:[UIImage imageNamed:@"iconFactory.png"]];
    //        }
    //    }
    //    
    //    //World 3 - Levels 25 - 36h - Management
    //    
    //    else if (FlxG.level <= LEVELS_IN_WORLD*3 ) {
    //        if (!FlxG.hardCoreMode) {
    //            [FlxG showAlertWithTitle:@"Now playing level:" message:player.levelName image:[UIImage imageNamed:@"iconMgmt.png"]];
    //        }
    //        else if (FlxG.hardCoreMode) {
    //            [FlxG showAlertWithTitle:@"Now playing hardcore level:" message:player.levelName image:[UIImage imageNamed:@"iconMgmt.png"]];
    //        }
    //    }
}

#pragma mark Dealloc


- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [levelArray release];
    [levelArrayFake release];
    
    [movingPlatformsArray release];
    [movingPlatformsLimitsArray release];
    
    [bottleArray release];
    [characterArray release];
    [BGArray1 release];
    [BGArray2 release];
    [BGArray3 release];
    [FGArray1 release];
    [hazardArray release];
    [crates release];
    
    
    [playerPlatforms.members removeAllObjects];
    [enemyPlatforms.members removeAllObjects];
    [helpBoxes.members removeAllObjects];
    
    [characters.members removeAllObjects];
    [talkCharacters.members removeAllObjects];
    
    [charactersArmy.members removeAllObjects];
    [charactersChef.members removeAllObjects];
    [charactersInspector.members removeAllObjects];
    [charactersWorker.members removeAllObjects];
    [hazards.members removeAllObjects];
    
	[speechTexts release];
    [playerPlatforms release];
    [helpBoxes release];
    
    [enemyPlatforms release];
    [characters release];
    [talkCharacters release];
    [charactersArmy release];
    [charactersChef release];
    [charactersInspector release];
    [charactersWorker release];
    [hazards release];
        
	[super dealloc];
}

#pragma mark Game Logic


- (void) virtualControlPad 
{    

    buttonRight.alpha = buttonStartAlpha;
    buttonLeft.alpha = buttonStartAlpha;
    buttonA.alpha =  buttonStartAlpha ;
    buttonB.alpha =  buttonStartAlpha;
    
    if (FlxG.touches.vcpLeftArrow) {
        buttonLeft.alpha = buttonPressedAlpha ;
    } 
    if (FlxG.touches.vcpRightArrow) {
        buttonRight.alpha = buttonPressedAlpha;
    } 
    if (FlxG.touches.vcpButton2  ) { //&& player.onFloor
        buttonB.alpha = buttonPressedAlpha ;      
    } 
    if (FlxG.touches.vcpButton1  ) {
        buttonA.alpha = buttonPressedAlpha ;
    }
    
}

- (void) liselotDies 
{
    if (liselot.dying==NO) {
        [FlxG play:SndError]; 
        
        player.isPiggyBacking=NO;
        player.visible=YES;
        
        liselot.isPiggyBacking=NO;
        liselot.visible=YES;
        
    }
    liselot.dying=YES;
    
    if (liselot.readyToSwitchCharacters ) {
        if (!player.isMale ) { 
            if (hud.mLives<1) {
                liselot.dead = YES;
                //player.dead = YES;
                liselot.velocity = CGPointMake(player.velocity.x, -250);
            }
            else {
                [hud subtractLifeFrom:@"male"];
                liselot.x = player.originalXPos;
                liselot.y = player.originalYPos;
                
            }
        }
        else if (player.isMale) {
            if (hud.fLives<1) {
                liselot.dead = YES;
                //player.dead = YES;
                
                liselot.velocity = CGPointMake(player.velocity.x, -250);
            }
            else {
                [hud subtractLifeFrom:@"female"];
                liselot.x = liselot.originalXPos;
                liselot.y = liselot.originalYPos;
            }
        }
        liselot.readyToSwitchCharacters=NO;
        liselot.dying=NO;        
    }
    
}


- (void) playerDies 
{
    
    if (player.dying==NO) {
        [FlxG play:SndError];
        
        player.isPiggyBacking=NO;
        player.visible=YES;
        
        liselot.isPiggyBacking=NO;
        liselot.visible=YES;
        
        tempPointForFollowObject = CGPointMake(player.x, player.y);
                
    }
    player.dying=YES;
    player.isPlayerControlled=NO;
    
    if (player.readyToSwitchCharacters ) {
        if (player.isMale ) {
            if (hud.mLives<1) {
                player.dead = YES;
                player.velocity = CGPointMake(player.velocity.x, -250);
            }
            else {
                [hud subtractLifeFrom:@"male"];
                player.x = player.originalXPos;
                player.y = player.originalYPos;
                
                //only switch characters if it says to in the user prefs.
                if (switchCharactersOnDeath)
                    [self switchCharacters];
                
            }
        }
        else if (!player.isMale) {
            if (hud.fLives<1) {
                player.dead = YES;
                player.velocity = CGPointMake(player.velocity.x, -250);
            }
            else {
                [hud subtractLifeFrom:@"female"];
                player.x = liselot.originalXPos;
                player.y = liselot.originalYPos;
                
                //only switch characters if it says to in the user prefs.
                if (switchCharactersOnDeath)
                    [self switchCharacters];
            }
        }
        player.readyToSwitchCharacters=NO;
        player.dying=NO;
        player.isPlayerControlled=YES;
        
    }
    
}


#pragma mark Update

- (void) showSpeechBubbleWithSound:(BOOL)playSound {
    
    //for random speech bubble
    int selectedSpeechText = [FlxU random]*[speechTexts length];
    
    speechBubbleText.text = [[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:0];
    speechBubble.visible = YES;
    
}

- (void) switchCharacters:(BOOL)withBubbles flicker:(float)flickerLength withSound:(BOOL)withSoundPlay followReset:(BOOL)withFollowReset
{
    
    if (withFollowReset) {
        timerForFollowObject=0.0;
    }
    
    player.isPiggyBacking=NO;
    liselot.isPiggyBacking=NO;
    player.visible=YES;
    liselot.visible=YES;
    
    if(withSoundPlay) {
        [FlxG playWithParam1:@"trick3.caf" param2:0.3];
    }
    
    [hud switchCharacters];
    
    [player stopDash];
    
    if (!player.dead) {
        
        //comment this out for no flickering on change for promo videos.
        
        //        NSLog(@"flicker Len:%f", flickerLength);
        
        if (flickerLength!=0.0) {
            //            NSLog(@"telling player to flicker:%f", flickerLength);
            
            
            //COMMENT BACK IN
            [player flicker:flickerLength];
            
            
            
        }
        
        if (player.isMale) {
            player.isMale=NO;
            liselot.isMale=YES;
            [player play:@"f_idle"];
            [liselot play:@"m_idle"];
        }
        else if (!player.isMale) {
            player.isMale=YES;
            liselot.isMale=NO;
            
            [player play:@"m_idle"];
            [liselot play:@"f_idle"];
        }
        
        
        //swap positions
        
        CGPoint temp = CGPointMake(player.x, player.y);
        player.x=liselot.x;
        player.y=liselot.y;
        liselot.x=temp.x;
        liselot.y=temp.y;
        
        //swap scales
        
        CGPoint tempscale = CGPointMake(player.scale.x, player.scale.y);
        player.scale= CGPointMake(liselot.scale.x, liselot.scale.y);
        liselot.scale= CGPointMake(tempscale.x, tempscale.y);
        
        
        //blow some bubbles;
        if (withBubbles) {
            puffEmitter.x = player.x-12;
            puffEmitter.y = player.y-12;
            puffEmitter.width = 24;
            puffEmitter.height = 24;
            [puffEmitter startWithParam1:YES param2:14 param3:7 ];
        }
    }
}

- (void) switchCharacters:(BOOL)withBubbles flicker:(float)flickerLength withSound:(BOOL)withSoundPlay
{
    [self switchCharacters:withBubbles flicker:flickerLength withSound:withSoundPlay followReset:YES];
    
}

- (void) switchCharacters:(BOOL)withBubbles flicker:(float)flickerLength
{
    [self switchCharacters:withBubbles flicker:flickerLength withSound:YES];
    
}

- (void) switchCharacters
{
    [self switchCharacters:YES flicker:1.5];
}

- (void) restartLevel
{
    player.originalXPos=player.levelStartX;
    player.originalYPos=player.levelStartY;
    
    liselot.originalXPos=liselot.levelStartX;
    liselot.originalYPos=liselot.levelStartY;
    
    for (HelpBox * hb in helpBoxes.members) {
        if ([hb isKindOfClass:[CheckPoint class]]) {
            [hb play:@"off"];
        }
    }
    
    currentFollowWidth=player.followWidth;
    currentFollowHeight= player.followHeight ;
    
    [FlxG followBoundsWithParam1:0 param2:0 param3:player.followWidth param4:player.followHeight param5:YES];
    
    
    followObject.x=player.x;
    followObject.y=player.y;
    tempPointForFollowObject=CGPointMake(player.x, player.y);
    
    
    fadeInOut.alpha=1;
    hasCheckedGameOverScreen=NO;
    gameOverScreenDarken.visible = NO;
    helpText.visible = NO;
    helpTextBubble.visible = NO;
    
    buttonPlay.visible = NO;
    buttonMenu.visible = NO;
    speechBubbleText.visible = NO;
    speechBubble.visible = NO;
    enemyGeneric.visible = NO;
    enemyListener.visible = NO;
    nextLevel.visible=NO;
    levelSelect.visible=NO;
    buttonRestart.visible=NO;
    pauseGraphic.visible=YES;
    resumeGraphic.visible=NO;
    levelComplete.visible=NO;
    levelNameInfo.visible=NO;
    navArrow.visible=NO;
    FlxG.score = 0;
    
    [FlxG unpauseMusic];
    
    player.dead = NO;
    player.visible = YES;
    player.x = player.originalXPos;
    player.y = player.originalYPos;
    player.velocity = CGPointMake(0, 0);
    player.isMale=YES;
    player.dying=NO;
    player.dead=NO;
    player.readyToSwitchCharacters=NO;
    player.isPlayerControlled=YES;
    
    
    liselot.x = liselot.originalXPos;
    liselot.y = liselot.originalYPos;
    liselot.isMale=NO;
    liselot.dying=NO;
    liselot.dead=NO;
    liselot.readyToSwitchCharacters=NO;
    [liselot play:@"f_idle"];
    
    //if (!FlxG.oldSchool)
    [hud resetLives];
    
    for (Enemy * s in characters.members) {
        s.dead = NO;
        s.x = s.originalXPos;
        s.y = s.originalYPos;
        [s talk:NO];
        
    }
    for (FlxObject * a in playerPlatforms.members) {
        if (a.originalXPos) {
            a.x = a.originalXPos;
            a.y = a.originalYPos;
        }
    }
    
    for (FlxObject * cx in crates.members) {
        if (cx.originalXPos) {
            cx.x = cx.originalXPos;
            cx.y = cx.originalYPos;
        }
    }
    paused=NO;
    //    capAndre.visible=NO;
    //    capLiselot.visible=NO;
    //    capLevel.visible=NO;
    //    
    //    capAndre.canScale=YES;
    //    capLiselot.canScale=YES;
    //    capLevel.canScale=YES; 
    
    andreIcon.visible=NO;
    liselotIcon.visible=NO;
    
    //make sure vcp is on.
    
    FlxG.touches.humanControlled=YES;
    
    // last minute checks before level starts.
    
    player.isPiggyBacking=NO;
    liselot.isPiggyBacking=NO;
    
    // see if either character needs to be flipped.
    
    if (player.andreInitialFlip==1) {
        player.scale=CGPointMake(-1, 1);
    }
    if (player.liselotInitialFlip==1) {
        liselot.scale=CGPointMake(-1, 1);
    }    
    
    //see which character starts first.
    
    if (player.startsFirst == 0) {
        [self switchCharacters:NO flicker:0.0001 withSound:NO followReset:YES];
    }
    
    bottle.x = bottle.originalXPos;
    bottle.y = bottle.originalYPos;
    

    
}

//- (void) startScoreCaps
//{    
//    if (levelComplete.visible && levelComplete.angularVelocity==0 && capLevel.visible==NO){
//        andreIcon.visible=YES;
//        liselotIcon.visible=YES;
//        
//        if (hud.mLives==1) {
//            capAndre.visible=YES;
//            capAndre.scale=CGPointMake(0, 0);
//
//        }
//        if (hud.fLives==1) {
//            capLiselot.visible=YES;
//            capLiselot.scale=CGPointMake(0, 0);
//
//        }
//            
//        capLevel.visible=YES;
//        capLevel.scale=CGPointMake(0, 0);
//    
//    }
//}

- (void) update
{            
//    if (FlxG.touches.swipedUp || FlxG.touches.swipedDown || FlxG.touches.swipedLeft || FlxG.touches.swipedRight) 
//        NSLog(@"u%d, d%d, l%d, r%d", FlxG.touches.swipedUp,FlxG.touches.swipedDown,FlxG.touches.swipedLeft,FlxG.touches.swipedRight);
    if (FlxG.level==4) {
        //NSLog(@"here we are! ! ! ! ! ");
    }
    if (paused && !isGameCompleteState) {
        
        if (FlxG.gamePad!=0) {
            if (navArrow.currentValue==1) {
                [buttonRestart play:@"1"];
            }
            else if (navArrow.currentValue==2) {
                [buttonRestart play:@"2"];
            } 
            else if (navArrow.currentValue==3) {
                [buttonRestart play:@"0"];
            }         
        }
        else {
            [buttonRestart play:@"0"];
        }
        
        if (FlxG.gamePad!=0) {
            navArrow.visible=YES;
        }
        if (FlxG.touches.iCadeLeftBegan) {
            [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];

            if (navArrow.currentValue==3) {
                navArrow.currentValue=1;
            }
            else {
                navArrow.currentValue--;
                
            }
        }
        if (FlxG.touches.iCadeRightBegan) {
            [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];

            if (navArrow.currentValue==1) {
                navArrow.currentValue=3;
            }
            else {
                navArrow.currentValue++;
                
            }       
        } 
        if (FlxG.touches.iCadeUpBegan) {
            [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];

            if (navArrow.currentValue==1) {
                navArrow.currentValue=2;
            } else if (navArrow.currentValue==3) {
                navArrow.currentValue=1;
            }
            
            else {
                navArrow.currentValue--;
                
            }
        }
        if (FlxG.touches.iCadeDownBegan) {
            [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];

            if (navArrow.currentValue==2) {
                navArrow.currentValue=1;
            } else if (navArrow.currentValue==3) {
                navArrow.currentValue=2;
            }
            else {
                navArrow.currentValue++;
                
            }       
        } 
        
    } else if (hasCheckedGameOverScreen) {
        if (FlxG.gamePad!=0) {
            navArrow.visible=YES;
        }
        if (FlxG.touches.iCadeLeftBegan) {
            navArrow.currentValue--;
            [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];


        }
        if (FlxG.touches.iCadeRightBegan) {
            navArrow.currentValue++;
            [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];

      
        } 
        if (FlxG.touches.iCadeUpBegan) {
            navArrow.currentValue--;
            [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];


        }
        if (FlxG.touches.iCadeDownBegan) {
            navArrow.currentValue++;
            [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];

        }

        
        
    }
    
    
    if (player.x>player.followWidth || player.y>player.followHeight) {
        [FlxG followBoundsWithParam1:0 param2:0 param3:lw param4:lh param5:YES];
        currentFollowWidth =lw;
        currentFollowHeight=lh;
        
        
    }
    
    //smooth transfer for camera.
    
    if (timerForFollowObject<smoothCameraMoveDuration) {
        //        NSLog(@"%f %f", tempPointForFollowObject.x, tempPointForFollowObject.y);
        
        if (timerForFollowObject==0.0) {
            if (followObject.x < FlxG.width/2 || 
                followObject.x > FlxG.levelWidth-FlxG.width/2  ) {
                
                //                NSLog(@"%f %d %d", followObject.x, FlxG.levelWidth, FlxG.width);
                timerForFollowObject=0.125;
            }
        }
        //        float duration = .70;
        timerForFollowObject += FlxG.elapsed;
        float delta = timerForFollowObject/smoothCameraMoveDuration - sin(timerForFollowObject/smoothCameraMoveDuration*2*M_PI)/(2*M_PI);
        
        //NSLog(@"timer %f dur %f delta %f", timerForFollowObject, smoothCameraMoveDuration, delta);
        
        if (delta < 1.0) {
            followObject.x = delta * (player.x-tempPointForFollowObject.x) + tempPointForFollowObject.x;
            followObject.y = delta * (player.y-tempPointForFollowObject.y) + tempPointForFollowObject.y;
        } else {
            followObject.x = player.x;
            followObject.y = player.y;
            
        }
    } 
    else {
        followObject.x=player.x;
        followObject.y=player.y;
    }
    
    
    //    followObject.x=player.x;
    //    followObject.y=player.y;
    
    
    
//    NSLog(@"%f update.m start of update", FlxG.elapsed);
    
    fadeInOut.alpha -= 0.025;
    
    //    if (liselot.isPlayerControlled) {
    //        [hud play:@"both_selected"];
    //    }
    //    else {
    //        if (player.isMale) {
    //            [hud play:@"m_selected"];
    //        }
    //        else if (!player.isMale) {
    //            [hud play:@"f_selected"];
    //        }
    //    }
    
    //piggy backing
    
    if ((FlxG.touches.swipedDown || FlxG.touches.swipedUp || FlxG.touches.iCadeYBegan || FlxG.touches.iCadeLeftBumperBegan) && !paused && !hasCheckedGameOverScreen ){
        if ([player overlapsWithOffset:liselot withCustomXOffset:20 withCustomYOffset:0]  ) {
            if (!player.isPiggyBacking) {
                [FlxG playWithParam1:@"SndOnShoulders.caf" param2:0.4 param3:NO];
            }
            if (!player.isMale) {
                [self switchCharacters:YES flicker:1.5 withSound:NO];
            }
            
            liselot.isPiggyBacking=!liselot.isPiggyBacking;
            liselot.visible=!liselot.visible;
            player.isPiggyBacking=!player.isPiggyBacking;
            
            followObject.x=player.x;
            followObject.y=player.y;
            
            tempPointForFollowObject=CGPointMake(player.x, player.y);
            
            
        }
        
    }
    
    //keep liselot locked to andre while piggybacking, but keep invisible since sprite does the work for two
    
    if (liselot.isPiggyBacking) {
        liselot.x=player.x;
        liselot.y=player.y-30;
        liselot.scale=CGPointMake(player.scale.x, player.scale.y);
        liselot.velocity=CGPointMake(0, 0);
    }
    
    if ((FlxG.touches.iCadeStartBegan) || (FlxG.touches.iCadeSelectBegan) ){
        navArrow.currentValue=3;
    }

    
    
    //pausing 
    
    if (pauseGraphic.visible || buttonRestart.visible) {
        if ((FlxG.touches.touchesBegan && FlxG.touches.screenTouchPoint.y < 30  && FlxG.touches.screenTouchPoint.y > 1 && FlxG.touches.screenTouchPoint.x < FlxG.width && FlxG.touches.screenTouchPoint.x > FlxG.width-80) || (FlxG.touches.iCadeStartBegan) || (FlxG.touches.iCadeSelectBegan) || (FlxG.touches.iCadeABegan && navArrow.currentValue==3 && resumeGraphic.visible )  ) {
                                    
            //NSLog(@" %f %f", FlxG.touches.screenTouchPoint.x,FlxG.touches.screenTouchPoint.y);
            
            paused=!paused;
            //        gameOverScreenDarken.x= 518.445984;
            //        gameOverScreenDarken.velocity = CGPointMake(-720, 0);
            gameOverScreenDarken.x= 0;
            gameOverScreenDarken.y= 0;
            
            gameOverScreenDarken.alpha = 0;
            
            gameOverScreenDarken.visible = paused;
            
            
            buttonRestart.x=-160;
            buttonRestart.velocity = CGPointMake(400, 0);
            buttonRestart.visible=paused;
            
            pauseGraphic.visible=NO;
            resumeGraphic.visible=NO;
            
            if (paused ) {
                [FlxG playWithParam1:@"ping.caf" param2:PING_VOL param3:NO];
                
                [FlxG pauseMusic];
                resumeGraphic.visible=YES;
                
                helpText.visible=NO;
                helpTextBubble.visible=NO;
                
                levelNameInfo.visible=YES;
                
            }
            else {
                [FlxG play:@"ping2.caf"];
                
                [FlxG unpauseMusic];
                pauseGraphic.visible=YES;
                
                levelNameInfo.visible=NO;
                navArrow.visible=NO;
                player.dontDash=NO;

                
            } 
        }
    }    
    
    
    // back to main menu
    
    if (paused) {
        if ((FlxG.touches.touchesEnded && FlxG.touches.lastScreenTouchPoint.y < 100 && FlxG.touches.lastScreenTouchPoint.x < FlxG.width/2) || (FlxG.touches.iCadeABegan && navArrow.currentValue==1)){

            [FlxG playWithParam1:@"ping2.caf" param2:PING2_VOL param3:NO];
            
            [self addStats];
            [playerPlatforms.members removeAllObjects];
            [enemyPlatforms.members removeAllObjects];
            [helpBoxes.members removeAllObjects];
            
            [characters.members removeAllObjects];
            [charactersArmy.members removeAllObjects];
            [charactersChef.members removeAllObjects];
            [charactersInspector.members removeAllObjects];
            [charactersWorker.members removeAllObjects];
            if (FlxG.winnitron || FlxG.oldSchool)
                FlxG.state = [[[WorldSelectState alloc] init] autorelease];
            else
                FlxG.state = [[[LevelMenuState alloc] init] autorelease];            
            return; 
        }
        if ((FlxG.touches.touchesEnded && FlxG.touches.lastScreenTouchPoint.y < 190 && FlxG.touches.lastScreenTouchPoint.y > 120 && FlxG.touches.lastScreenTouchPoint.x < FlxG.width/2 ) || (FlxG.touches.iCadeABegan && navArrow.currentValue==2)) {
            [FlxG playWithParam1:@"ping.caf" param2:PING_VOL param3:NO];
            
            player.dontDash=NO;
            [self restartLevel];
            if (FlxG.winnitron) {
                FlxG.timeLeft= WINNITRON_TIME;
                FlxG.level=1;
                FlxG.state = [[[WinniOgmoLevelState alloc] init] autorelease];
            }
            if (FlxG.oldSchool) {
                FlxG.level=1;
                FlxG.mlives =3;
                FlxG.flives = 3;
                
                hud.mLives=3;
                hud.fLives=3;
                
                
                [hud syncLives];
                FlxG.state = [[[OgmoLevelState alloc] init] autorelease];
            }
            
            return;
            
        }
    }
    
    /*
     CGPoint p = CGPointMake(player.x, player.y);
     CGPoint b = CGPointMake(bottle.x, bottle.y);
     float aaa = [FlxU getAngleBetweenPointsWithParam1:p param2:b];
     NSLog(@" angle between player and bottle %f ", aaa);
     */
    
    
    //game over screen
    if ( player.dead || _levelFinished || liselot.dead) { 
        

        
        //all these run once only.
        if (!hasCheckedGameOverScreen) {
            
            //change nav arrow to game over/next level screen
            
            navArrow.loc1=CGPointMake(nextLevel.x-nextLevel.width/2, nextLevel.y);
            navArrow.loc2=CGPointMake(levelSelect.x-nextLevel.width/2, levelSelect.y);
            navArrow.loc3=CGPointMake(-100, -100);

            navArrow.maxValue=2;
            navArrow.currentValue=1;
            if (FlxG.gamePad!=0) {
                navArrow.visible=YES;
            }
            
            
            [self addStats];
            
            if (!FlxG.hardCoreMode) {
                if (FlxG.level <= LEVELS_IN_WORLD) {
                    [FlxG levelProgressWarehouse];
                }
                else if (FlxG.level <= LEVELS_IN_WORLD*2 ) {
                    [FlxG levelProgressFactory];
                }
                else if (FlxG.level <= LEVELS_IN_WORLD*3 ) {
                    [FlxG levelProgressManagement];
                }
                
                [FlxG levelProgress];
            }
            else if (FlxG.hardCoreMode) {
                if (FlxG.level <= LEVELS_IN_WORLD) {
                    [FlxG hclevelProgressWarehouse];
                }
                else if (FlxG.level <= LEVELS_IN_WORLD*2 ) {
                    [FlxG hclevelProgressFactory];
                }
                else if (FlxG.level <= LEVELS_IN_WORLD*3 ) {
                    [FlxG hclevelProgressManagement];
                }
                
                [FlxG hclevelProgress];
            }            
            
            //            int levelProgress = [FlxG levelProgress];
            //            NSLog(@"Level progress %d", levelProgress);
            //            if (levelProgress==36) {
            //                
            //            }
            
            
            if (player.dead || liselot.dead) {
                
                [FlxG play:@"tagtone1.caf"];
                
                buttonPlay.y = -20;
                buttonPlay.velocity = CGPointMake(0, 200);
                buttonPlay.visible = YES;
                if (FlxG.gamePad!=0)
                    buttonPlay._selected=YES;
                
                buttonMenu.y = -20;
                buttonMenu.velocity = CGPointMake(0, 200);                
                buttonMenu.visible = YES;
                
                pauseGraphic.visible=NO;
                
                
                
                
            }      
            else if (_levelFinished) {
                
                if (!FlxG.winnitron && !FlxG.oldSchool)
                    [FlxG play:@"tagtone4.caf"];
                
                
                if (FlxG.level%12!=0 ) {
                    nextLevel.y = -20;
                    nextLevel.velocity=CGPointMake(0, 200);
                    nextLevel.visible=YES;
                    
                    if (FlxG.gamePad!=0)
                        nextLevel._selected=YES;
                }
                
                if (FlxG.winnitron && FlxG.level==5)
                {
                    nextLevel.visible=NO;
                }
                else if (FlxG.winnitron) {
                    FlxG.level++;

                    FlxG.state = [[[WinniOgmoLevelState alloc] init] autorelease];
                    return; 
                }
                
                if ( FlxG.oldSchool ) {
                    FlxG.level++;
                    
                    if (FlxG.level >= 37 && !FlxG.hardCoreMode) {
                        FlxG.level = 1;
                        FlxG.hardCoreMode = YES;
                    }
                    else if (FlxG.level >= 37 && FlxG.hardCoreMode) { 
                        FlxG.state = [[[OldSchoolCompleteState alloc] init] autorelease];
                        return;                     
                    }
                    
                    FlxG.state = [[[OgmoLevelState alloc] init] autorelease];
                    return;                    
                }
                
                levelSelect.y = -20;
                levelSelect.velocity=CGPointMake(0, 200);
                levelSelect.visible=YES;
                
                levelComplete.visible=YES;
                levelComplete.angularVelocity=2000;
                levelComplete.angle=280;
                levelComplete.scale=CGPointMake(5, 5);
                pauseGraphic.visible=NO;
                
                
                NSString * levelInfo=@"Finished Level: ";
                levelInfo = [levelInfo stringByAppendingFormat:@"%d", FlxG.level ];

                
                
            }
            
            [FlxG pauseMusic];
            
            gameOverScreenDarken.visible = YES;
            gameOverScreenDarken.alpha = 0.6;
            
            buttonLeft.alpha = 0;
            buttonRight.alpha = 0;
            buttonA.alpha = 0;
            buttonB.alpha = 0;
            
        }
        
        if (FlxG.gamePad!=0) {
            if (navArrow.currentValue==1) {
                nextLevel._selected=YES;
                buttonPlay._selected=YES;
                buttonMenu._selected=NO;
                levelSelect._selected=NO;
            }
            else if (navArrow.currentValue==2) {
                buttonMenu._selected=YES;
                levelSelect._selected=YES;
                nextLevel._selected=NO;
                buttonPlay._selected=NO;
            }
        }
        
        
        //[self startScoreCaps];
        
        hasCheckedGameOverScreen=YES;
        
        //let's play again!
        if (((FlxG.touches.touchesEnded && FlxG.touches.lastScreenTouchPoint.y < 90 && FlxG.touches.lastScreenTouchPoint.x < FlxG.width/2)
             ||
             (FlxG.touches.iCadeABegan && navArrow.currentValue==1)) 
            && 
            (player.dead || liselot.dead)) {
            
            [FlxG stop:@"tagtone4.caf"];
                        
            [FlxG playWithParam1:@"ping.caf" param2:PING_VOL param3:NO];
            
            // REMEMBER TO ADD
            //play correct music for level
            [FlxG unpauseMusic];
            
            [self restartLevel];
            
            if (FlxG.winnitron ) {
                FlxG.timeLeft= WINNITRON_TIME;
                FlxG.level=1;
                FlxG.state = [[[WinniOgmoLevelState alloc] init] autorelease];
            }
            if (FlxG.oldSchool) {
                FlxG.level=1;
                
                FlxG.mlives =3;
                FlxG.flives = 3;
                
                hud.mLives=3;
                hud.fLives=3;
                
                
                [hud syncLives];
                
                FlxG.state = [[[OgmoLevelState alloc] init] autorelease];
            }
            
            return;
        } 
        else if (((FlxG.touches.touchesEnded && FlxG.touches.lastScreenTouchPoint.y < 90 && FlxG.touches.lastScreenTouchPoint.x < FlxG.width/2) || (FlxG.touches.iCadeABegan && navArrow.currentValue==1 ) ) && _levelFinished && nextLevel.visible) {
            
            [FlxG stop:@"tagtone4.caf"];
            
            [FlxG playWithParam1:@"ping.caf" param2:PING_VOL param3:NO];
                        
            FlxG.level++;
            FlxG.state = [[[OgmoLevelState alloc] init] autorelease];
            return; 
            
        }
        //back to menu
        else if ((FlxG.touches.touchesEnded && FlxG.touches.lastScreenTouchPoint.y < 90 && FlxG.touches.lastScreenTouchPoint.x > FlxG.width/2) || (FlxG.touches.iCadeABegan && navArrow.currentValue==2)) {
            
            [FlxG stop:@"tagtone4.caf"];
            
            //[FlxG playWithParam1:@"ping2.caf" param2:PING2_VOL param3:NO];
            
            [self addStats];
            
            [playerPlatforms.members removeAllObjects];
            [enemyPlatforms.members removeAllObjects];
            [helpBoxes.members removeAllObjects];
            
            [characters.members removeAllObjects];
            [charactersArmy.members removeAllObjects];
            [charactersChef.members removeAllObjects];
            [charactersInspector.members removeAllObjects];
            [charactersWorker.members removeAllObjects];
            
            if (player.dead || liselot.dead) {
                [FlxG playWithParam1:@"ping2.caf" param2:PING2_VOL param3:NO];
                
                if (FlxG.winnitron || FlxG.oldSchool)
                    FlxG.state = [[[WorldSelectState alloc] init] autorelease];
                else
                    FlxG.state = [[[LevelMenuState alloc] init] autorelease];                     
            }
            else if (_levelFinished) {
                [FlxG playWithParam1:@"ping2.caf" param2:PING2_VOL param3:NO];
                
                if (FlxG.winnitron || FlxG.oldSchool)
                    FlxG.state = [[[WorldSelectState alloc] init] autorelease];
                else
                    FlxG.state = [[[LevelMenuState alloc] init] autorelease];                     
            }
            return; 
        }
    }
    
    if (player.dying) {
        [self playerDies];
    } 
    if (liselot.dying) {
        [self liselotDies];
    }    
    
    if (!player.dead && !liselot.dead && !_levelFinished && !paused) 
    {
        [self virtualControlPad];
    } 
    
    //this is where [super update] was 
    
    
    
    
    
    //if (!player.dead) {
    
    //works well but player walks over spikes.
    //        if ([FlxU collideObject:player  withGroup:hazards]  && !player.flickering ) {
    //            [self playerDies];
    //        }
    //}
    
    for (FlxObject * hz in hazards.members) {
        if (!player.dead) { //!player.flickering && 
            if ([player overlapsWithOffset:hz]){
                [self playerDies];
            }
        }
    }
    
    for (LargeCrate * lc in playerPlatforms.members) {
        if ([lc isKindOfClass:[LargeCrate class]]) {
            if (lc.isAboutToExplode) {
                crateShardEmitter.x = lc.x;
                crateShardEmitter.y = lc.y;
                crateShardEmitter.width = 80;
                crateShardEmitter.height = 60;
                [crateShardEmitter startWithParam1:YES param2:14 param3:100 ];
                [lc moveOffScreen];
            }
        }
    }
    
    
    //switch characters
    
    if (!player.dead && !_levelFinished && !player.dying)  {
        if ((FlxG.touches.swipedLeft || FlxG.touches.swipedRight || FlxG.touches.iCadeXBegan || FlxG.touches.iCadeRightBumperBegan  ) && !paused) {
            if (FlxG.touches.lastScreenTouchPoint.y<280) {
                
                tempPointForFollowObject = CGPointMake(player.x, player.y);
                
                [self switchCharacters];
            }
        }
    }
    
    //super update.
    //is paused, just update the relevent items.
    
    if (!paused)
        [super update];
    else if (paused) {
        [buttonRestart update];
        [gameOverScreenDarken update];
        [navArrow update];
        if (gameOverScreenDarken.alpha < 0.80 ) {
            gameOverScreenDarken.alpha+=0.05;
        }
    }
    
    [FlxU collideObject:player withGroup:playerPlatforms];
    [FlxU collideObject:liselot withGroup:playerPlatforms];
    [FlxU collideObject:liselot withGroup:crates];
    
    
    //display in game help if it is set in prefs page.
    
    if ( !paused) {
        BOOL didoverlap=NO;
        for (HelpBox * hb in helpBoxes.members) {
            
            //checkpoints for liselot.
            
            if ( [hb overlapsWithOffset:liselot]  ) {
                if ([hb isKindOfClass:[CheckPoint class]]) {
                    if (hb.type==2 && player.isMale) {
                        //turn off all others
                        for (CheckPoint * hbx in helpBoxes.members) {
                            if ([hbx isKindOfClass:[CheckPoint class]]) {
                                if (hbx.type==2) {
                                    if (hbx!=hb) {
                                        [hbx play:@"off"];
                                        hbx.checked=NO;
                                    }
                                }
                            }
                        }
                        
                        [hb play:@"on"];
                        liselot.originalXPos=hb.x;
                        liselot.originalYPos=hb.y;
                        
                        CheckPoint* pNew = (CheckPoint*)hb;
                        
                        if (pNew.checked==NO) {
                            [FlxG play:SndCheckPoint];
                        }
                        pNew.checked=YES;                       
                    }
                }
            }
            
            
            // checkpoints for player.
            
            if ( [hb overlapsWithOffset:player] && (!player.dead && !liselot.dead) ) {
                if ([hb isKindOfClass:[HelpBox class]] && displayInGameHelp) {
                    if (helpTextBubble.visible==NO) {
                        helpTextBubble.scale = CGPointMake(0.2, 0.2);
                        [helpTextBubble play:@"reveal"];
                    }
                    helpText.visible=YES;
                    helpTextBubble.visible = YES;
                    
                    helpText.text=hb.helpString;
                    didoverlap=YES;
                    
                    //NSLog(@"%@", hb.helpString);
                }
                else if ([hb isKindOfClass:[CheckPoint class]]) {
                    if (hb.type==1 && player.isMale) {
                        //turn off all others
                        for (CheckPoint * hbx in helpBoxes.members) {
                            if ([hbx isKindOfClass:[CheckPoint class]]) {
                                if (hbx.type==1) {
                                    //NSLog(@"%@ %@ %d", hbx, hb, hbx==hb);
                                    
                                    if (hbx!=hb) {
                                        [hbx play:@"off"];
                                        hbx.checked=NO;
                                    }
                                }
                            }
                        }
                        
                        [hb play:@"on"];
                        
                        CheckPoint* pNew = (CheckPoint*)hb;
                        
                        if (pNew.checked==NO) {
                            [FlxG play:SndCheckPoint];
                        }
                        pNew.checked=YES;
                        
                        player.originalXPos=hb.x;
                        player.originalYPos=hb.y;
                    }
                    else if (hb.type==2 && !player.isMale) {
                        //turn off all others
                        for (CheckPoint * hbx in helpBoxes.members) {
                            if ([hbx isKindOfClass:[CheckPoint class]]) {
                                if (hbx.type==2) {
                                    if (hbx!=hb) {
                                        [hbx play:@"off"];
                                        hbx.checked=NO;
                                    }                                }
                            }
                        }
                        
                        CheckPoint* pNew = (CheckPoint*)hb;
                        
                        [hb play:@"on"];
                        
                        if (pNew.checked==NO) {
                            [FlxG play:SndCheckPoint];
                        }
                        pNew.checked=YES;
                        
                        
                        liselot.originalXPos=hb.x;
                        liselot.originalYPos=hb.y;
                    }
                    
                }
                
                
            }
        }
        if (!didoverlap) {
            helpText.visible=NO;
            helpTextBubble.visible = NO;
            [helpTextBubble play:@"static"];
            
        }
    }
    
    
    for (Crate * cr in crates.members) {
        if ( [FlxU alternateCollideWithParam1:cr param2:player] ) {
            if (  (FlxG.touches.vcpButton1 || FlxG.touches.iCadeBBegan)   && !player.isMale) {
                if (cr.canBePushedRight) {
                    cr.velocity = CGPointMake(1300, 0);
                    [FlxG playWithParam1:@"pushCrate.caf" param2:0.2 param3:NO];
                }
                else if (cr.canBePushedLeft) {
                    cr.velocity = CGPointMake(-1300, 0);
                    [FlxG playWithParam1:@"pushCrate.caf" param2:0.2 param3:NO];
                }
            }
        }
        
        
        //doesn't work. y u no overlap???
        //        [FlxU alternateCollideWithParam1:cr param2:player];
        //        if ( [cr overlapsWithOffset:player] ) {
        //            if (FlxG.touches.vcpButton1 && !player.isMale) {
        //                if (cr.canBePushedRight)
        //                    cr.velocity = CGPointMake(1000, 0);
        //                else if (cr.canBePushedLeft)
        //                    cr.velocity = CGPointMake(-1000, 0);
        //            }
        //        }
        
        //[FlxU collideObject:cr withGroup:crates];
        [FlxU collideObject:cr withGroup:characters];
        
        [FlxU collideObject:cr withGroup:playerPlatforms];
        
        //        for (Crate * cr2 in crates.members) {
        //            [FlxU alternateCollideWithParam1:cr param2:cr2];
        //        }
    }
    
    //talk
    BOOL playSnd = speechBubble.visible;
    BOOL foundPlaceForIcon = NO;
    
    for (FlxSprite * s in talkCharacters.members) {
        
        BOOL done=NO;
        float distance = sqrt((player.x-s.x)*(player.x-s.x) + (player.y-s.y)*(player.y-s.y));
        BOOL facing=NO;
        if (  (player.scale.x ==1 && s.scale.x==-1)  && (player.x < s.x)  ) facing = YES;
        if (  (player.scale.x == -1 && s.scale.x==1)  && (player.x > s.x)  ) facing = YES;
        
        if (!player.isMale && distance<90 && facing) {
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            if (!FlxG.hardCoreMode) {
                if ([s isKindOfClass:[EnemyArmy class]] && [prefs integerForKey:[NSString stringWithFormat:@"TALKED_TO_ARMY%d", FlxG.level ]]==0 ) {
                    talkIcon.visible=YES;
                    talkIcon.x=(s.x+s.width/2)-talkIcon.width/2;
                    talkIcon.y=(s.y-s.height)-talkIcon.height/2;
                    foundPlaceForIcon=YES;
                    //                    NSLog(@"1");
                }
                else if ([s isKindOfClass:[EnemyChef class]] && [prefs integerForKey:[NSString stringWithFormat:@"TALKED_TO_CHEF%d", FlxG.level ]]==0 ) {
                    talkIcon.visible=YES;
                    talkIcon.x=(s.x+s.width/2)-talkIcon.width/2;
                    talkIcon.y=(s.y-s.height)-talkIcon.height/2;
                    foundPlaceForIcon=YES;
                    //                    NSLog(@"2");
                    
                }
                else if ([s isKindOfClass:[EnemyInspector class]] && [prefs integerForKey:[NSString stringWithFormat:@"TALKED_TO_INSPECTOR%d", FlxG.level ]]==0 ) {
                    talkIcon.visible=YES;
                    talkIcon.x=(s.x+s.width/2)-talkIcon.width/2;
                    talkIcon.y=(s.y-s.height)-talkIcon.height/2;
                    foundPlaceForIcon=YES;
                    //                    NSLog(@"3");
                    
                }
                else if ([s isKindOfClass:[EnemyWorker class]] && [prefs integerForKey:[NSString stringWithFormat:@"TALKED_TO_WORKER%d", FlxG.level ]]==0 ) {
                    talkIcon.visible=YES;
                    talkIcon.x=(s.x+s.width/2)-talkIcon.width/2;
                    talkIcon.y=(s.y-s.height)-talkIcon.height/2;
                    foundPlaceForIcon=YES;
                    //                    NSLog(@"4");
                    
                }
            }
            
            else if (FlxG.hardCoreMode) {
                if ([s isKindOfClass:[EnemyArmy class]] && [prefs integerForKey:[NSString stringWithFormat:@"TALKED_TO_ARMYHC%d", FlxG.level ]]==0 ) {
                    talkIcon.visible=YES;
                    talkIcon.x=(s.x+s.width/2)-talkIcon.width/2;
                    talkIcon.y=(s.y-s.height)-talkIcon.height/2;
                    foundPlaceForIcon=YES;
                    //                    NSLog(@"5");
                    
                }
                else if ([s isKindOfClass:[EnemyChef class]] && [prefs integerForKey:[NSString stringWithFormat:@"TALKED_TO_CHEFHC%d", FlxG.level ]]==0 ) {
                    talkIcon.visible=YES;
                    talkIcon.x=(s.x+s.width/2)-talkIcon.width/2;
                    talkIcon.y=(s.y-s.height)-talkIcon.height/2;
                    foundPlaceForIcon=YES;
                    //                    NSLog(@"6");
                    
                }
                else if ([s isKindOfClass:[EnemyInspector class]] && [prefs integerForKey:[NSString stringWithFormat:@"TALKED_TO_INSPECTORHC%d", FlxG.level ]] ==0) {
                    talkIcon.visible=YES;
                    talkIcon.x=(s.x+s.width/2)-talkIcon.width/2;
                    talkIcon.y=(s.y-s.height)-talkIcon.height/2;
                    foundPlaceForIcon=YES;
                    //                    NSLog(@"7");
                    
                }
                else if ([s isKindOfClass:[EnemyWorker class]] && [prefs integerForKey:[NSString stringWithFormat:@"TALKED_TO_WORKERHC%d", FlxG.level ]]==0  ) {
                    talkIcon.visible=YES;
                    talkIcon.x=(s.x+s.width/2)-talkIcon.width/2;
                    talkIcon.y=(s.y-s.height)-talkIcon.height/2;
                    foundPlaceForIcon=YES;
                    //                    NSLog(@"8");
                    
                }
            }
        }
        
        //attempt to talk to enemies
        if (!player.isMale && ((FlxG.touches.vcpButton1 && FlxG.touches.newTouch ) || FlxG.touches.iCadeBBegan)  ) {
            
            //get distance between enemy
            [s talk:NO];
            
            speechBubble.visible=NO;
            speechBubbleText.visible=NO;
            
            //we are in talking distance, and the enemy is facing us, let's talk.
            
            if (distance<120 && facing && !done) {
                
                if (!playSnd) {
                    [FlxG playWithParam1:@"SndTalk.caf" param2:0.6 param3:NO];
                }
                
                talkIcon.visible=NO;
                
                
                [s talk:YES];
                
                int speechTextLength;
                
                int speechTextPerLevel;
                if (!FlxG.hardCoreMode) {
                    speechTextPerLevel=FlxG.level;
                }
                else if (FlxG.hardCoreMode) {
                    speechTextPerLevel=FlxG.level;
                }
                
                //NSLog(@"%d", speechTextPerLevel);
                //NSLog(@"cycler %d", speechTextCycler); //use this in place of FlxG.level to cycle through
                
                if ([s isKindOfClass:[EnemyArmy class]]) {
                    
                    //int selectedSpeechText = [FlxU random]*[[speechTexts objectAtIndex:0] length]; 
                    
                    //                    speechBubbleText.text = [[speechTexts objectAtIndex:0] objectAtIndex:FlxG.level ];
                    //                    speechTextLength = [[[speechTexts objectAtIndex:0] objectAtIndex:FlxG.level] length];
                    
                    speechBubbleText.text = [[speechTexts objectAtIndex:0] objectAtIndex:speechTextPerLevel ];
                    speechTextLength = [[[speechTexts objectAtIndex:0] objectAtIndex:speechTextPerLevel] length];
                    
                    //set that this enemy has been talked to
                    
                    if (!FlxG.hardCoreMode) {
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                        NSString * enemyTalking = [NSString stringWithFormat:@"TALKED_TO_ARMY%d", FlxG.level ];
                        [prefs setInteger:1 forKey:enemyTalking];
                        [prefs synchronize];
                    }
                    else if (FlxG.hardCoreMode) {
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                        NSString * enemyTalking = [NSString stringWithFormat:@"TALKED_TO_ARMYHC%d", FlxG.level ];
                        [prefs setInteger:1 forKey:enemyTalking];
                        [prefs synchronize];
                    }                    
                    
                    
                    
                    
                }
                else if ([s isKindOfClass:[EnemyChef class]]) {
                    //int selectedSpeechText = [FlxU random]*[[speechTexts objectAtIndex:1] length];  
                    
                    //                    speechBubbleText.text = [[speechTexts objectAtIndex:1] objectAtIndex:FlxG.level];
                    //                    speechTextLength = [[[speechTexts objectAtIndex:1] objectAtIndex:FlxG.level] length];
                    
                    speechBubbleText.text = [[speechTexts objectAtIndex:1] objectAtIndex:speechTextPerLevel ];
                    speechTextLength = [[[speechTexts objectAtIndex:1] objectAtIndex:speechTextPerLevel] length];
                    
                    if (!FlxG.hardCoreMode) {
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                        NSString * enemyTalking = [NSString stringWithFormat:@"TALKED_TO_CHEF%d", FlxG.level ];
                        [prefs setInteger:1 forKey:enemyTalking];
                        [prefs synchronize];
                    }
                    else if (FlxG.hardCoreMode) {
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                        NSString * enemyTalking = [NSString stringWithFormat:@"TALKED_TO_CHEFHC%d", FlxG.level ];
                        [prefs setInteger:1 forKey:enemyTalking];
                        [prefs synchronize];
                    }
                    
                    
                }
                
                else if ([s isKindOfClass:[EnemyInspector class]]) {
                    //int selectedSpeechText = [FlxU random]*[[speechTexts objectAtIndex:2] length]; 
                    
                    //                    speechBubbleText.text = [[speechTexts objectAtIndex:2] objectAtIndex:FlxG.level];
                    //                    speechTextLength = [[[speechTexts objectAtIndex:2] objectAtIndex:FlxG.level] length];
                    speechBubbleText.text = [[speechTexts objectAtIndex:2] objectAtIndex:speechTextPerLevel ];
                    speechTextLength = [[[speechTexts objectAtIndex:2] objectAtIndex:speechTextPerLevel] length];
                    
                    if (!FlxG.hardCoreMode) {
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                        NSString * enemyTalking = [NSString stringWithFormat:@"TALKED_TO_INSPECTOR%d", FlxG.level ];
                        [prefs setInteger:1 forKey:enemyTalking];
                        [prefs synchronize];
                    }
                    else if (FlxG.hardCoreMode) {
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                        NSString * enemyTalking = [NSString stringWithFormat:@"TALKED_TO_INSPECTORHC%d", FlxG.level ];
                        [prefs setInteger:1 forKey:enemyTalking];
                        [prefs synchronize];
                    }
                    
                    
                }
                
                else if ([s isKindOfClass:[EnemyWorker class]]) {
                    //int selectedSpeechText = [FlxU random]*[[speechTexts objectAtIndex:3] length];  
                    
                    //                    speechBubbleText.text = [[speechTexts objectAtIndex:3] objectAtIndex:FlxG.level];
                    //                    speechTextLength = [[[speechTexts objectAtIndex:3] objectAtIndex:FlxG.level] length];
                    speechBubbleText.text = [[speechTexts objectAtIndex:3] objectAtIndex:speechTextPerLevel ];
                    speechTextLength = [[[speechTexts objectAtIndex:3] objectAtIndex:speechTextPerLevel] length];
                    
                    if (!FlxG.hardCoreMode) {
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                        NSString * enemyTalking = [NSString stringWithFormat:@"TALKED_TO_WORKER%d", FlxG.level ];
                        [prefs setInteger:1 forKey:enemyTalking];
                        [prefs synchronize];
                    }
                    else if (FlxG.hardCoreMode) {
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                        NSString * enemyTalking = [NSString stringWithFormat:@"TALKED_TO_WORKERHC%d", FlxG.level ];
                        [prefs setInteger:1 forKey:enemyTalking];
                        [prefs synchronize];
                    }
                    
                    
                }
                
                else if ([s isKindOfClass:[Liselot class]]) {
                    //int selectedSpeechText = [FlxU random]*[[speechTexts objectAtIndex:4] length];  
                    
                    //                    speechBubbleText.text = [[speechTexts objectAtIndex:4] objectAtIndex:FlxG.level];
                    //                    speechTextLength = [[[speechTexts objectAtIndex:4] objectAtIndex:FlxG.level] length];
                    speechBubbleText.text = [[speechTexts objectAtIndex:4] objectAtIndex:speechTextPerLevel ];
                    speechTextLength = [[[speechTexts objectAtIndex:4] objectAtIndex:speechTextPerLevel] length];
                    
                    if (!FlxG.hardCoreMode) {
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                        NSString * enemyTalking = [NSString stringWithFormat:@"TALKED_TO_ANDRE%d", FlxG.level ];
                        [prefs setInteger:1 forKey:enemyTalking];
                        [prefs synchronize];
                    }
                    else if (FlxG.hardCoreMode) {
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                        NSString * enemyTalking = [NSString stringWithFormat:@"TALKED_TO_ANDREHC%d", FlxG.level ];
                        [prefs setInteger:1 forKey:enemyTalking];
                        [prefs synchronize];
                    }
                    
                    
                }      
                
                int b  = [ FlxG talkToAndreProgress];
                int c = [ FlxG talkToEnemyProgress];
                
                int d  = [ FlxG hctalkToAndreProgress];
                int e = [ FlxG hctalkToEnemyProgress];
                
                //NSLog(@"TALK %d ANDRE %d", c, b);
                
                float newHeight=(speechTextLength+10)/2;
                if (newHeight<=39) newHeight=40;
                
                //this was to keep the bubbles off the edge
                
                
                
                [speechBubble setHeight:newHeight];
                
                speechBubble.x = s.x-10;
                speechBubble.y = s.y-speechBubble.height-25;
                speechBubble.visible=YES;
                
                speechBubbleText.x = speechBubble.x;
                speechBubbleText.y = speechBubble.y;
                speechBubbleText.visible=YES;
                
                float diff = speechBubble.x-(currentFollowWidth-speechBubble.width);
                int intDiff = 4+(diff/13);
                
                
                if (speechBubble.x>currentFollowWidth-speechBubble.width) {
                    
                    [speechBubble loadGraphic:@"speechBubbleTiles.png" empties:0 autoTile:NO isSpeechBubble:intDiff];
                    speechBubble.x=currentFollowWidth-speechBubble.width;
                    
                    speechBubbleText.x = speechBubble.x;
                    speechBubbleText.y = speechBubble.y;
                    
                } else {
                    
                    
                    [speechBubble loadGraphic:@"speechBubbleTiles.png" empties:0 autoTile:NO isSpeechBubble:4];
                    
                }
                
                
                //                [speechBubble setHeight:newHeight];
                //                [speechBubble loadGraphic:@"speechBubbleTiles.png" empties:0 autoTile:NO isSpeechBubble:4];
                
                
                speechTextCycler++;
                if (speechTextCycler>=37) speechTextCycler=1;
                
                done=YES;
                break;
            }
            else {
                
            }
            
        }
        else if (!player.isMale && !facing && [s isTalking]) {
            speechBubble.visible=NO;
            speechBubbleText.visible=NO;
            [s talk:NO];
            
            talkIcon.visible=NO;
            
            
        }
        else if (player.isMale && !facing && [s isTalking]) {
            speechBubble.visible=NO;
            speechBubbleText.visible=NO;
            [s talk:NO];
            
            talkIcon.visible=NO;
            
            
        }
        
        //causing problems with crate collision.
        
        else if (player.isMale && distance<60 ) {
            speechBubble.visible=NO;
            speechBubbleText.visible=NO;
            [s talk:NO];
            talkIcon.visible=NO;
            
            
        }
    }
    if (foundPlaceForIcon==NO) {
        talkIcon.visible=NO;
    }
    if (speechBubble.visible==YES) {
        talkIcon.visible=NO;
    }
    
    //    NSLog(@"real x %f real y %f", speechBubble.x, speechBubble.y);
    
    
    
    //enemies collide with platforms and enemies touch player
    for (Enemy * s in characters.members) {
        //NSLog(@"!!! dist " );
        
        if (! s.dead ) {
            [FlxU collideObject:s withGroup:enemyPlatforms];
        }
        
        
        
        //used to kill non active player on hardcore mode
        //had problems with piggybacking.
        
        //		if ([s overlapsWithOffset:liselot] && (s.dead == NO) && (liselot.dead == NO) && FlxG.hardCoreMode ) {
        //            if (player.isMale ) {
        //                [self liselotDies];
        //                
        //            }
        //            else if (!player.isMale ) {
        //                [self liselotDies];
        //                
        //            }
        //
        //        }
        
        float distance = sqrt((player.x-s.x)*(player.x-s.x) + (player.y-s.y)*(player.y-s.y));
        BOOL facing=NO;
        
        // this will check that the players are facing EACH OTHER
        
        /*
         if (  (player.scale.x ==1 && s.scale.x==-1)  && (player.x < s.x)  ) facing = YES;
         if (  (player.scale.x == -1 && s.scale.x==1)  && (player.x > s.x)  ) facing = YES;
         */
        
        //this will check that the enemy is looking at the player, ignoring the way the player is looking.
        
        if (  (s.scale.x==-1)  && (player.x < s.x)  ) facing = YES;
        if (  (s.scale.x== 1)  && (player.x > s.x)  ) facing = YES;
        //NSLog(@"!!! dist %f, s.x %f s.scale.x %f, s.limitX %f, s.orig %f", distance, s.x, s.scale.x, s.limitX, s.originalXPos);
        
        
        if (distance<240 && [s isKindOfClass:[EnemyInspector class]] && facing && s.y-10<player.y+5 && s.y-10>player.y-5) {
            [s runAndJump];
        }
        if (distance<240 && [s isKindOfClass:[EnemyArmy class]] && facing && s.y-10<player.y+5 && s.y-10>player.y-5) {
            [s runAndJump:240];
        }
        
        if (distance<60 && [s isKindOfClass:[EnemyChef class]] && facing && s.y-10<player.y+5 && s.y-10>player.y-5) {
            
            if (s.scale.x==-1 && s.x<s.limitX-50) {
                [s runJumpAndTurn:240];
                
            }
            if (s.scale.x==1 && s.x>s.originalXPos+50) {
                [s runJumpAndTurn:240];
                
            }            
        }
        
		if ([s overlapsWithOffset:player] && (s.dead == NO) && (player.dead == NO) && (player.dying == NO) && (!player.flickering) && (!_levelFinished) ) {
            [self playerDies];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            if ([s isKindOfClass:[EnemyArmy class]]) {
                NSInteger existingNumberOfArmyKilled = [prefs integerForKey:@"KILLED_BY_ARMY"];
                existingNumberOfArmyKilled += 1;
                [prefs setInteger:existingNumberOfArmyKilled forKey:@"KILLED_BY_ARMY"];

            }
            else if ([s isKindOfClass:[EnemyChef class]]) {
                NSInteger existingNumberOfChefKilled = [prefs integerForKey:@"KILLED_BY_CHEF"];
                existingNumberOfChefKilled += 1;
                [prefs setInteger:existingNumberOfChefKilled forKey:@"KILLED_BY_CHEF"];

            }
            
            else if ([s isKindOfClass:[EnemyInspector class]]) {
                NSInteger existingNumberOfInspectorKilled = [prefs integerForKey:@"KILLED_BY_INSPECTOR"];
                existingNumberOfInspectorKilled += 1;
                [prefs setInteger:existingNumberOfInspectorKilled forKey:@"KILLED_BY_INSPECTOR"];

            }
            
            else if ([s isKindOfClass:[EnemyWorker class]]) {
                NSInteger existingNumberOfWorkerKilled = [prefs integerForKey:@"KILLED_BY_WORKER"];
                existingNumberOfWorkerKilled += 1;
                [prefs setInteger:existingNumberOfWorkerKilled forKey:@"KILLED_BY_WORKER"];

            }
			
		}
        
    }
    
    //overlaps sugar bag.
    if ([player overlapsWithOffset:sugarBag]) {
        if (FlxG.winnitron) {
            FlxG.timeLeft+=20;
        }
        
        if (FlxG.oldSchool) {
            hud.mLives++;
            hud.fLives++;            
        }
        else {
            hud.mLives=1;
            hud.fLives=1;           
        }

        
        
        
        [hud syncLives];
        [FlxG play:@"powerUp.caf" withVolume:0.6]; 
        
        sugarBag.dead = YES;
        sugarBag.x = -100;
        sugarBag.y = -100;
        

        
    }    
    
    if ([player overlapsWithOffset:exit] || [liselot overlapsWithOffset:exit]) {
        [exit play:@"open"];
    }
    else {
        [exit play:@"closed"];
    }
    
    //both players overlap the exit
    if ([player overlapsWithOffset:exit] && [liselot overlapsWithOffset:exit]) {
        
        _levelFinished=YES;
        
        // SAVE User defaults for what levels are done.
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        //how well did you complete the level.
        
        NSInteger levelComplete = 1;
        
        if (bottle.dead) {
            levelComplete++;
        }
        
        //levelComplete+=hud.mLives;
        //levelComplete+=hud.fLives;
        
        if (!FlxG.hardCoreMode && !FlxG.winnitron && !FlxG.oldSchool){
            //what level was it.
            NSString * levelName = [NSString stringWithFormat:@"level%d", FlxG.level ];
            NSString * nextLevel = [NSString stringWithFormat:@"level%d", FlxG.level+1 ];
            NSInteger nextLevelExisting = [prefs integerForKey:nextLevel];
            NSInteger levelExisting = [prefs integerForKey:levelName];
            
            if (levelComplete>levelExisting) {
                [prefs setInteger:levelComplete forKey:levelName];
            }
            if (FlxG.level % LEVELS_IN_WORLD != 0  && nextLevelExisting==0) {
                [prefs setInteger:1 forKey:nextLevel];
            }
        }
        else if (FlxG.hardCoreMode && !FlxG.winnitron && !FlxG.oldSchool) {
            //what level was it.
            NSString * levelName = [NSString stringWithFormat:@"hclevel%d", FlxG.level ];
            NSString * nextLevel = [NSString stringWithFormat:@"hclevel%d", FlxG.level+1 ];
            NSInteger nextLevelExisting = [prefs integerForKey:nextLevel];
            NSInteger levelExisting = [prefs integerForKey:levelName];
            
            if (levelComplete>levelExisting) {
                [prefs setInteger:levelComplete forKey:levelName];
            }
            if (FlxG.level % LEVELS_IN_WORLD != 0  && nextLevelExisting==0) {
                [prefs setInteger:1 forKey:nextLevel];
            }
        }
        
        [prefs synchronize];
        
        player.isPlayerControlled=NO;
        [player stopDash];
        
        //        FlxG.level++;
        //        FlxG.state = [[[OgmoLevelState alloc] init] autorelease];
        //        return;  
        
        //go to game complete state.
        
        timerForGameComplete++;
        if (!FlxG.oldSchool) {
            if (FlxG.level==12) {
                if (FlxG.iPad){
                    FlxG.level=59997;
                }
                else {
                    FlxG.level=49997;
                }
    //            if (timerForGameComplete>3)
                [FlxG hclevelProgressWarehouse];
                FlxG.state = [[[GameCompleteState alloc] init] autorelease];
                return;
            }
            if (FlxG.level==24) {
                if (FlxG.iPad){
                    FlxG.level=59998;
                }
                else {
                    FlxG.level=49998;
                }
    //            if (timerForGameComplete>3)
                [FlxG hclevelProgressFactory];
                FlxG.state = [[[GameCompleteState alloc] init] autorelease];
                return;
            }
        
            
            if (FlxG.level==36) {
                if (FlxG.iPad){
                    FlxG.level=59999;
                }
                else {
                    FlxG.level=49999;
                }  
    //            if (timerForGameComplete>3)
                [FlxG hclevelProgressManagement];
                FlxG.state = [[[GameCompleteState alloc] init] autorelease];
                return;
            }

        } 
    }
    
    
    if ([player overlapsWithOffset:bottle]) {
        
        //        if (player.isMale) {
        //            hud.mLives=1;
        //        }
        //        else if (!player.isMale) {
        //            hud.fLives=1;
        //        }
        //        
        //        [hud syncLives];
        
        
        if (FlxG.winnitron) {
            FlxG.timeLeft+=10;
        }
        
        [FlxG play:SndFizz];
        [FlxG play:@"powerUp.caf" withVolume:0.6]; 
        
        collectedBottles++;
        
        puffEmitter.x = bottle.x-12;
        puffEmitter.y = bottle.y-12;
        puffEmitter.width = 24;
        puffEmitter.height = 24;
        [puffEmitter startWithParam1:YES param2:14 param3:7 ];
        
        bottle.dead = YES;
        bottle.x = -100;
        bottle.y = -100;
        
        
    }
    
    //    if (FlxG.touches.debugButton1) {
    //      
    //    }    
    //    if (FlxG.touches.debugButton2) {
    //        player.jumpTimer+=0.05;
    //        NSLog(@"p.jumpTimer=%f", player.jumpTimer);
    //        
    //    }
    //    if (FlxG.touches.debugButton3) {
    //        player.jumpInitialMultiplier+=0.05;
    //        NSLog(@"p.jumpInitialMultiplier=%f", player.jumpInitialMultiplier);
    //        
    //    }
    //    if (FlxG.touches.debugButton4) {
    //        player.jumpSecondaryMultiplier+=0.05;
    //        NSLog(@"p.jumpSecondaryMultiplier=%f", player.jumpSecondaryMultiplier);
    //    }
    //    if (FlxG.touches.debugButton5) {
    //        player.jumpInitialTime+=0.05;
    //        NSLog(@"p.jumpInitialTime=%f", player.jumpInitialTime);
    //    }
    //    
    //    
    //    if (FlxG.touches.debugButton1 && FlxG.touches.debugButton2) {
    //        player.jumpTimer-=0.05;
    //        NSLog(@"p.jumpTimer=%f", player.jumpTimer);
    //    }
    //    if (FlxG.touches.debugButton1 && FlxG.touches.debugButton3) {
    //        player.jumpInitialMultiplier-=0.05;
    //        NSLog(@"p.jumpInitialMultiplier=%f", player.jumpInitialMultiplier);
    //    }
    //    if (FlxG.touches.debugButton1 && FlxG.touches.debugButton4) {
    //        player.jumpSecondaryMultiplier-=0.05;
    //        NSLog(@"p.jumpSecondaryMultiplier=%f", player.jumpSecondaryMultiplier);
    //    }
    //    if (FlxG.touches.debugButton1 && FlxG.touches.debugButton5) {
    //        player.jumpInitialTime-=0.05;
    //        NSLog(@"p.jumpInitialTime=%f", player.jumpInitialTime);
    //    }
    
    if (FlxG.touches.debugButton1 && FlxG.touches.touchesBegan) {
        if (FlxG.level>1) {
            FlxG.level--;
            FlxG.state = [[[OgmoLevelState alloc] init] autorelease];
            return;
        }
    }
    
    if (FlxG.touches.debugButton2 && FlxG.touches.touching) {

        bottle.dead=YES;
        
        if (!FlxG.hardCoreMode) {

            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString * a = [NSString stringWithFormat:@"TALKED_TO_ANDRE%d", FlxG.level ];
            NSString * b = [NSString stringWithFormat:@"TALKED_TO_ARMY%d", FlxG.level ];
            
            [prefs setInteger:1 forKey:a];
            [prefs setInteger:1 forKey:b];
            [prefs synchronize];
        }
        if (FlxG.hardCoreMode) {

            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString * a = [NSString stringWithFormat:@"TALKED_TO_ANDREHC%d", FlxG.level ];
            NSString * b = [NSString stringWithFormat:@"TALKED_TO_ARMYHC%d", FlxG.level ];

            [prefs setInteger:1 forKey:a];
            [prefs setInteger:1 forKey:b];
            [prefs synchronize];
        }        
        
        
        player.x=exit.x;
        player.y=exit.y;
        liselot.x=exit.x;
        liselot.y=exit.y;
        
    }
    
    if (FlxG.touches.debugButton3 && FlxG.touches.touchesBegan) {

        if (FlxG.level<36) {
            FlxG.level++;
            FlxG.state = [[[OgmoLevelState alloc] init] autorelease];
            return;
        }
    }
    
    
    if (FlxG.touches.debugButton4 && FlxG.touches.touchesBegan) {

        
    }
    
    if (FlxG.touches.debugButton5 && FlxG.touches.touchesBegan) {
        FlxG.level++;
        FlxG.state = [[[WinniOgmoLevelState alloc] init] autorelease];
        return;
        
    }
    //NSLog(@"%f update.m end of update", player.y);
    
//    //FIRST UNIT TESTING
//    if (UNIT_TESTING == 1) {
//        if ([FlxU random]<0.05) {
//            FlxG.level ++;
//            if (FlxG.level==37) {
//                FlxG.level=1;
//                FlxG.hardCoreMode=!FlxG.hardCoreMode;
//                FlxG.state = [[[LevelMenuState alloc] init] autorelease];
//            }
//
//            FlxG.state = [[[OgmoLevelState alloc] init] autorelease];
//
//            
//        }
//    }
    
    
}


#pragma mark Stats


-(void) addEnemyToTotal:(Enemy *)toAdd
{
    if ([toAdd isKindOfClass:[EnemyArmy class]]) {
        killedArmy++;
    }
    else if ([toAdd isKindOfClass:[EnemyChef class]]) {
        killedChef++;
    }if ([toAdd isKindOfClass:[EnemyInspector class]]) {
        killedInspector++;
    }if ([toAdd isKindOfClass:[EnemyWorker class]]) {
        killedWorker++;
    }
    
}

- (void) addStats {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSInteger
    NSInteger existingNumberOfArmyKilled = [prefs integerForKey:@"KILLED_ARMY"];
    existingNumberOfArmyKilled += killedArmy;
    [prefs setInteger:existingNumberOfArmyKilled forKey:@"KILLED_ARMY"];
    
    NSInteger existingNumberOfChefKilled = [prefs integerForKey:@"KILLED_CHEF"];
    existingNumberOfChefKilled += killedChef;
    [prefs setInteger:existingNumberOfChefKilled forKey:@"KILLED_CHEF"];
    
    NSInteger existingNumberOfInspectorKilled = [prefs integerForKey:@"KILLED_INSPECTOR"];
    existingNumberOfInspectorKilled += killedInspector;
    [prefs setInteger:existingNumberOfInspectorKilled forKey:@"KILLED_INSPECTOR"];
    
    NSInteger existingNumberOfWorkerKilled = [prefs integerForKey:@"KILLED_WORKER"];
    existingNumberOfWorkerKilled += killedWorker;
    [prefs setInteger:existingNumberOfWorkerKilled forKey:@"KILLED_WORKER"];
    
    NSInteger existingNumberOfBottles = [prefs integerForKey:@"COLLECTED_BOTTLES"];
    existingNumberOfBottles += collectedBottles;
    [prefs setInteger:existingNumberOfBottles forKey:@"COLLECTED_BOTTLES"];
    
	[prefs synchronize];
    
    killedArmy=0;
    killedChef=0;
    killedWorker=0;
    killedInspector=0;
    collectedBottles=0;
    
}


@end

