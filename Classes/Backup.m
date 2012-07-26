//
//  MenuState.m
//  Canabalt
//
//  Copyright Semi Secret Software 2009-2010. All rights reserved.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE. 
//

#import "FlxImageInfo.h"

#import "OgmoLevelState.h"
#import "MenuState.h"

#import "Player.h"
#import "Enemy.h"
#import "EnemyArmy.h"
#import "EnemyChef.h"
#import "EnemyInspector.h"
#import "EnemyWorker.h"
#import "EnemyGeneric.h"

#import "Bullet.h"
#import "Disc.h"
#import "Grenade.h"
#import "Explosion.h"
#import "Bottle.h"
#import "SugarBag.h"
#import "Crate.h"
#import "Gun.h"
#import "Cloud.h"

#import "SugarHigh.h"

#define debugGround 0
#define BULLETSINSHOTGUNBLAST 10
#define BUTTON_START_ALPHA 0.4
#define BUTTON_PRESSED_ALPHA 0.6
#define DIVISOR_FOR_STORY_UNLOCK 10
#define SPEED_FOR_SUGAR_HIGH_REDUCTION 0.00500000
#define PERCENTAGE_SUGAR_BAG_ADDS 1 //0.2
#define SHRAPNEL_IN_GRENADE 10
#define VERTICAL_OVERSHOOT_OF_LEVEL 50

#define SCROLLFACTOR_FOR_LAYER1 0.2
#define SCROLLFACTOR_FOR_LAYER2 0.4
#define SCROLLFACTOR_FOR_LAYER3 0.6
#define LEVELS_IN_WORLD 10


CGFloat timer;
CGFloat totalTimeElapsed;
CGFloat swiperotation;
CGFloat hypotenuse;
CGFloat bulletDamage;
CGFloat gunOffsetToPlayer;
int previousWeapon;

//virtual control pad vars
int previousNumberOfTouches;
BOOL newTouch;

static FlxEmitter * puffEmitter = nil;
static FlxEmitter * puffEmitter2 = nil;
static FlxEmitter * steamEmitter = nil;
SugarHigh * sh;
FlxSprite * sugarHighIndicator;

static NSString * ImgSteam = @"steam.png";
static NSString * ImgBubble = @"bubble.png";
static NSString * MusicMegaCannon = @"megacannon.mp3";
static NSString * MusicIceFishing = @"icefishing.mp3";
static NSString * MusicPirate = @"pirate.mp3";
static NSString * SndFizz = @"openDrinkFizz_bfxr.caf";
static NSString * SndShoot01 = @"shoot01.caf";

static NSString * SndError = @"error.caf";
static NSString * SndSugarHighWarning = @"sugarHighWarning.caf";
static NSString * SndSugarHighStart = @"sugarHighStart.caf";
NSString * tempString = @"";


int killedArmy;
int killedChef;
int killedWorker;
int killedInspector;
int collectedBottles;

static int levelWidth = 48;
static int levelHeight = 32;


BOOL hasCheckedGameOverScreen;

NSInteger curHighScore;

int currentSpeechText;

NSString * currentXMLLayer = @"";
NSString * lastXMLLayer = @"";

NSNumber * _scrollfactor;





@implementation OgmoLevelState

- (id) init
{
	if ((self = [super init])) {
		self.bgColor = 0xff35353d;
        playerPlatforms = [[FlxGroup alloc] init];
        enemyPlatforms = [[FlxGroup alloc] init];
        
        characters = [[FlxGroup alloc] init];
        
        charactersArmy= [[FlxGroup alloc] init];
        charactersChef= [[FlxGroup alloc] init];
        charactersInspector= [[FlxGroup alloc] init];
        charactersWorker= [[FlxGroup alloc] init];
        
        allBullets = [[FlxGroup alloc] init];
        bullets = [[FlxGroup alloc] init];
        discs = [[FlxGroup alloc] init];
        grenades = [[FlxGroup alloc] init];
        
        currentXMLLayer = @"";
        
        levelArray = [[NSMutableArray alloc] initWithCapacity:1];
        bottleArray = [[NSMutableArray alloc] initWithCapacity:1];
        BGArray = [[NSMutableArray alloc] initWithCapacity:1];
        characterArray  = [[NSMutableArray alloc] initWithCapacity:1];
        characterNodeArray  = [[NSMutableArray alloc] initWithCapacity:1];
        
        
        NSString *paths = [[NSBundle mainBundle] resourcePath];
        NSString *xmlFile = [paths stringByAppendingPathComponent:@"level3.oel"];
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
    tempString=string;
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    
    //    if ([parentNode count] < 3) {
    //        [parentNode push:elementName];
    //    }
    
    
    
    if ([elementName compare:@"solids"] == NSOrderedSame     ) {		
		//NSLog(@"current type is solids"); 
        currentXMLLayer=@"solids";
	}  
    if ([elementName compare:@"tiles"] == NSOrderedSame     ) {		
		//NSLog(@"current type is tiles");  
        currentXMLLayer=@"tiles";
	} 
    else if ([elementName compare:@"BGLayer1"] == NSOrderedSame     ) {		
		//NSLog(@"current type is BGLayer1");
        currentXMLLayer=@"BGLayer1";
        _scrollfactor = [NSNumber numberWithFloat:0.2];
	}   
    else if ([elementName compare:@"BGLayer2"] == NSOrderedSame     ) {		
		//NSLog(@"current type is BGLayer2");
        currentXMLLayer=@"BGLayer2";
        _scrollfactor = [NSNumber numberWithFloat:0.4];
        
	}  
    else if ([elementName compare:@"BGLayer3"] == NSOrderedSame     ) {		
		//NSLog(@"current type is BGLayer3");    
        currentXMLLayer=@"BGLayer3";
        _scrollfactor = [NSNumber numberWithFloat:0.6];
        
	}  
    else if ([elementName compare:@"objects"] == NSOrderedSame     ) {		
		//NSLog(@"current type is objects");   
        currentXMLLayer=@"objects";
        
	}     
    else if ([elementName compare:@"characters"] == NSOrderedSame     ) {		
		//NSLog(@"current type is characters");     
        currentXMLLayer=@"characters";
        
	}     
    
    
    
    //NSLog( @"  %@    %@ ,, %d", elementName, [ parentNode objectAtIndex: 0 ] , [ parentNode count ]);
    
    //rects are stored in the level array
    
    if ([elementName compare:@"rect"] == NSOrderedSame     ) {		
		[levelArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                               [attributeDict objectForKey:@"x"],@"x",
                               [attributeDict objectForKey:@"y"],@"y",
                               [attributeDict objectForKey:@"w"],@"w",
                               [attributeDict objectForKey:@"h"],@"h",
                               nil]];        
	}
    
    //bottles
    
    if ([elementName compare:@"Bottle"] == NSOrderedSame        ||
        [elementName compare:@"smallSugarBag"] == NSOrderedSame ||   
        [elementName compare:@"L1_SmallCrate"] == NSOrderedSame ) {		
        [bottleArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                 elementName,@"type",
                                 [attributeDict objectForKey:@"x"],@"x",
                                 [attributeDict objectForKey:@"y"],@"y",
                                 nil]]; 
	}    
    
    //characters
    if ([elementName compare:@"worker"] == NSOrderedSame || 
        [elementName compare:@"player"] == NSOrderedSame ||   
        [elementName compare:@"liselot"] == NSOrderedSame || 
        [elementName compare:@"inspector"] == NSOrderedSame || 
        [elementName compare:@"army"] == NSOrderedSame || 
        [elementName compare:@"chef"] == NSOrderedSame ) {	
        
		[characterArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                   elementName,@"character",  
                                   [attributeDict objectForKey:@"x"],@"x",
                                   [attributeDict objectForKey:@"y"],@"y",
                                   nil]]; 
	} 
    
    if ([elementName compare:@"node"] == NSOrderedSame && [currentXMLLayer isEqual:@"characters"] ) {
		[characterNodeArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                       [attributeDict objectForKey:@"x"],@"limitX",
                                       [attributeDict objectForKey:@"y"],@"limitY",
                                       nil]]; 
        
    }
    
    
    //BG stuff for level 1
    if ([elementName compare:@"LargeCrate"] == NSOrderedSame || 
        [elementName compare:@"level1_windows"] == NSOrderedSame || 
        [elementName compare:@"palettes"] == NSOrderedSame  ||    
        [elementName compare:@"L1_Shelf"] == NSOrderedSame ||   
        [elementName compare:@"sodaPack"] == NSOrderedSame || 
        [elementName compare:@"sugarBags"] == NSOrderedSame || 
        [elementName compare:@"sugarBagsAndCrates"] == NSOrderedSame ||
        [elementName compare:@"cratesBox"] == NSOrderedSame 
        ) {	
        
		[BGArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                            elementName,@"BGElement",  
                            [attributeDict objectForKey:@"x"],@"x",
                            [attributeDict objectForKey:@"y"],@"y",
                            _scrollfactor, @"scrollfactor",
                            [attributeDict objectForKey:@"width"],@"width",
                            [attributeDict objectForKey:@"height"],@"height",
                            nil]]; 
        
        NSLog(@" sf added and is %f", _scrollfactor);
        
	}    
    
    
    
    
    lastXMLLayer = elementName;
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName compare:@"width"] == NSOrderedSame     ) {	
        FlxG.levelWidth = [tempString floatValue];
    }
    if ([elementName compare:@"height"] == NSOrderedSame     ) {	
        FlxG.levelHeight = [tempString floatValue];
    }
    tempString = @"";   
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	[parser release];
	
}

- (void) loadLevelFromXML{
    
    int i;
    
    //BG Array
    static NSString * Image = @"";
    
    for (i = 0; i < [BGArray count]; i++) {
        NSDictionary * j = [BGArray objectAtIndex:i];
        Image = [j objectForKey:@"BGElement"] ;
        Image = [Image stringByAppendingString:@".png"];
        NSLog(@" %@ ", Image);
        
        FlxSprite * BGElement = [FlxSprite spriteWithX:[[j objectForKey:@"x"] floatValue] y:[[j objectForKey:@"y"] floatValue] graphic:Image];
        
        BGElement.scrollFactor = CGPointMake([[j objectForKey:@"scrollfactor"] floatValue], 1);
        //BGElement.scrollFactor = CGPointMake(0.5,1);
        
        //NSLog(@" %@ ", j );
        
        [self add:BGElement];
        
    }    
    
    
    //character array
    
    for (i = 0; i < [characterArray count]; i++) {
        
        NSDictionary * j = [characterArray objectAtIndex:i];
        NSDictionary * limits = [characterNodeArray objectAtIndex:i];
        
        
        //worker 
        if ( [[j objectForKey:@"character"] isEqual:@"worker"] ) {   
            enemyWorker = [EnemyWorker enemyWorkerWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue],[[j objectForKey:@"y"] floatValue]) index:0  ];
            enemyWorker.limitX = [[limits objectForKey:@"limitX"] floatValue];
            enemyWorker.limitY = [[limits objectForKey:@"limitY"] floatValue];
            enemyWorker.velocity = CGPointMake(160, 0);
            [self add:enemyWorker];
            [characters add:enemyWorker];
            [charactersWorker add:enemyWorker];
        }
        //player 
        if ( [[j objectForKey:@"character"] isEqual:@"player"] ) {        	
            player = [[Player alloc] initWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue],[[j objectForKey:@"y"] floatValue])] ;
            [self add:player];
        }  
        //army 
        if ( [[j objectForKey:@"character"] isEqual:@"army"] ) {   
            enemyArmy = [EnemyArmy enemyArmyWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue],[[j objectForKey:@"y"] floatValue]) index:i  ];
            enemyArmy.limitX = [[limits objectForKey:@"limitX"] floatValue];
            enemyArmy.limitY = [[limits objectForKey:@"limitY"] floatValue];
            enemyArmy.velocity = CGPointMake(20, 0);
            
            [self add:enemyArmy];
            [characters add:enemyArmy];
            [charactersArmy add:enemyArmy];
        }
        //chef 
        if ( [[j objectForKey:@"character"] isEqual:@"chef"] ) {   
            enemyChef = [EnemyChef enemyChefWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue],[[j objectForKey:@"y"] floatValue]) index:i  ];
            enemyChef.velocity = CGPointMake(160, 0);
            enemyChef.limitX = [[limits objectForKey:@"limitX"] floatValue];
            enemyChef.limitY = [[limits objectForKey:@"limitY"] floatValue];
            [self add:enemyChef];
            [characters add:enemyChef];
            [charactersChef add:enemyChef];
        }        
        //inspector 
        if ( [[j objectForKey:@"character"] isEqual:@"inspector"] ) {   
            enemyInspector = [EnemyInspector enemyInspectorWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue],[[j objectForKey:@"y"] floatValue]) index:i  ];
            enemyInspector.velocity = CGPointMake(160, 0);
            enemyInspector.limitX = [[limits objectForKey:@"limitX"] floatValue];
            enemyInspector.limitY = [[limits objectForKey:@"limitY"] floatValue];
            [self add:enemyInspector];
            [characters add:enemyInspector];
            [charactersInspector add:enemyInspector];
        }    
        
        //bottle array
        
        
        for (i = 0; i < [bottleArray count]; i++) {
            if ( [[j objectForKey:@"type"] isEqual:@"bottle"] ) {   
                
                NSDictionary * j = [bottleArray objectAtIndex:i];
                Bottle * bt = [Bottle bottleWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue]  ,[[j objectForKey:@"y"] floatValue])] ;
                [self add:bt]; 
                
            }
            if ( [[j objectForKey:@"type"] isEqual:@"L1_SmallCrate"] ) {  
                NSDictionary * j = [bottleArray objectAtIndex:i];
                
                crate = [Crate crateWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue]  ,[[j objectForKey:@"y"] floatValue])] ;
                [self add:crate];
                
            }
            if ( [[j objectForKey:@"type"] isEqual:@"smallSugarBag"] ) { 
                NSDictionary * j = [bottleArray objectAtIndex:i];
                
                sugarBag = [SugarBag sugarBagWithOrigin:CGPointMake([[j objectForKey:@"x"] floatValue]  ,[[j objectForKey:@"y"] floatValue])] ;
                [self add:sugarBag];
                
            }
            
        }
        
        
        // Load all rects as tileblocks
        for (int ii = 0; ii < [levelArray count]; ii++) {
            NSDictionary * jj = [levelArray objectAtIndex:ii];
            FlxTileblock * bb = [FlxTileblock tileblockWithX:[[jj objectForKey:@"x"] floatValue] y:[[jj objectForKey:@"y"] floatValue] width:[[jj objectForKey:@"w"] floatValue] height:[[jj objectForKey:@"h"] floatValue]];
            [bb loadGraphic:@"level1_tiles.png" empties:0 autoTile:YES];
            [playerPlatforms add:bb];
            [enemyPlatforms add:bb];
            
        }	
        
        
        
    }    
    
    
    
    
    
    
}


#pragma mark Initializers

- (void) loadLevelStandards
{
    // World 1 - Levels 1 - 10;
    
    if (FlxG.level <= LEVELS_IN_WORLD) {
        [FlxG playMusic:MusicMegaCannon];
        
        FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:FlxG.height];  
        [grad loadGraphic:@"level1_bgSmoothGrad.png" empties:0];
        grad.scrollFactor = CGPointMake(0, 0);
        [self add:grad]; 
    }
    
    // World 2 - Levels 11 - 20
    else if (FlxG.level <= LEVELS_IN_WORLD*2) {
        
        [FlxG playMusic:MusicIceFishing];
        
        static NSString * ImgBG = @"level2_BG.png";
        backG = [FlxSprite spriteWithX:480 y:320 graphic:ImgBG];
        backG.x = 0;
        backG.y = 0;
        backG.scrollFactor = CGPointMake(0, 0);
        [self add:backG];
        
    }
    
    //World 3 - Levels 21 - 30 - Management
    
    else if (FlxG.level <= LEVELS_IN_WORLD*3) {
        
        [FlxG playMusic:MusicPirate];
        
        static NSString * ImgGradient = @"level3_gradient.png";
        FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:FlxG.height];  
        [grad loadGraphic:ImgGradient];
        [self add:grad];
        
    }
    
    
}


- (void) loadCharacters
{
    int i;
    
    for (i=0; i<2; i++) {
        grenade  = [Grenade  grenadeWithOrigin:CGPointMake(-100,-100)] ;
		[grenades add:grenade];
        [allBullets add:grenade];
	}
    
    [self add:grenades];    
    
    
    
    explosion = [Explosion explosionWithOrigin:CGPointMake(1000,1000)   ];
    explosion.x = 1000;
    explosion.y = 1000;
	[self add:explosion];
    [allBullets add:explosion];
    
    //gibs
    
    
    int gibCount = 25;
    
    ge = [[FlxEmitter alloc] init];
    
    ge.delay = 0.02;
    
    ge.minParticleSpeed = CGPointMake(-40,
                                      -40);
    ge.maxParticleSpeed = CGPointMake(40,
                                      40);
    ge.minRotation = -72;
    ge.maxRotation = 72;
    ge.gravity = -120;
    ge.particleDrag = CGPointMake(10, 10);
    
    
    
    puffEmitter = [ge retain];
    
    
    [self add:puffEmitter];
    
    
    
    [ge createSprites:ImgBubble quantity:gibCount bakedRotations:NO
             multiple:YES collide:0.0 modelScale:1.0];
    
    
    
    //gibs
    ge2 = [[FlxEmitter alloc] init];
    ge2.delay = 0.02;
    ge2.minParticleSpeed = CGPointMake(-40,
                                       -40);
    ge2.maxParticleSpeed = CGPointMake(40,
                                       40);
    ge2.minRotation = -72;
    ge2.maxRotation = 72;
    ge2.gravity = -120;
    ge2.particleDrag = CGPointMake(10, 10);
    puffEmitter2 = [ge2 retain];
    [self add:puffEmitter2];
    [ge2 createSprites:ImgBubble quantity:gibCount bakedRotations:NO
              multiple:YES collide:0.0 modelScale:1.0];
    
    //gibs
    sEmit = [[FlxEmitter alloc] init];
    sEmit.delay = 0.02;
    sEmit.minParticleSpeed = CGPointMake(-140,
                                         0);
    sEmit.maxParticleSpeed = CGPointMake(140,
                                         0);
    sEmit.minRotation = 0;
    sEmit.maxRotation = 0;
    sEmit.gravity = 0;
    sEmit.particleDrag = CGPointMake(10, 10);
    
    sEmit.x = 0;
    sEmit.y = FlxG.levelHeight-100;
    sEmit.width = FlxG.levelWidth;
    sEmit.height = 2;
    
    steamEmitter = [sEmit retain];
    
    
    [self add:steamEmitter];
    [sEmit createSprites:ImgSteam quantity:10 bakedRotations:NO
                multiple:YES collide:0.0 modelScale:1.0]; 
    
    
    
    
}


#pragma mark Create


- (void) create
{        
    //FlxG.level = 1;
    
    speechTexts = [[NSArray alloc] initWithObjects:
                   [NSMutableArray arrayWithObjects:@"November 10, 1961.\nNews from military sources is that army forces have been mobilized and plan to invade the surronding city.",@" ",@" ", @"notepad", nil],
                   [NSMutableArray arrayWithObjects:@"Every month the same old news. Since WWII ended, every month more scare tactics.\nI run a business, my interest lies with feeding my family, not war.",@"player",@"army", @"", nil],                   
                   [NSMutableArray arrayWithObjects:@"The efforts of industry are not without casualties.\nAnd yet we work, and we work hard. Are we not entitled to that which we produce.",@"worker",@"player", @"",nil],                   
                   [NSMutableArray arrayWithObjects:@"\nYou are paid and paid well.",@"player",@"worker", @"",nil], 
                   [NSMutableArray arrayWithObjects:@"Liselot, my sweet emerald.\nI give you  my heart, my word and my life.\nI will work for our family so that they can have a good life.",@"player",@"liselot", @"0",nil], 
                   [NSMutableArray arrayWithObjects:@"\nFamily is all.",@"player",@"liselot", @"",nil],                   
                   [NSMutableArray arrayWithObjects:@"The government is blaming the Super Lemonade Factory for all the broken glass on the road.\nCan't anyone take some responsibility for themselves.",@"player",@"army", @"",nil],                   
                   [NSMutableArray arrayWithObjects:@"We run a tight ship. I learned that from my time in the Customs Office.\nWithout solid rules, everything runs foul.\nMy workers repsect this. They follow my rules.",@"player",@"worker", @"0",nil],                   
                   [NSMutableArray arrayWithObjects:@"We keep it clean here. That food inspector is such a idiot!\n\nWe keep it clean, he should leave us alone.",@"player",@"inspector", @"0",nil],                   
                   [NSMutableArray arrayWithObjects:@"The same people that create the street signs are the ones destroying and stealing them.\nCorruption is rife here!",@"player",@"army", @"0",nil],                   
                   [NSMutableArray arrayWithObjects:@"Utilitarianism promises the greatest \"good\" for the greatest number...\nIf someone else falls between the cracks, it’s not your problem.",@"inspector",@"chef", @"0",nil],                   
                   [NSMutableArray arrayWithObjects:@"If I am using my wealth to exceed\ngreater odds for my family’s happiness, I don’t see that\nas any more amoral as buying insurance.",@"player",@"0", @"0",nil],                   
                   [NSMutableArray arrayWithObjects:@"I trust that people are beings with good intentions,\nbut you can’t expect to harvest a crop in a sewer.",@"player",@"0", @"0",nil],                   
                   [NSMutableArray arrayWithObjects:@"The tragedy is not in the recognition of your fate,\nbut the weight that rests on your shoulders when no one is there to help you.",@"player",@"0", @"0",nil],                   
                   [NSMutableArray arrayWithObjects:@"Trust, faith and common good.\nAll of them are masks painted to hide corruption.",@"player",@"0", @"0",nil],                   
                   [NSMutableArray arrayWithObjects:@"\nTalk is cheap.",@"chef",@"0", @"0",nil],                                     
                   [NSMutableArray arrayWithObjects:@"\nI just heard Don't Fence Me In on the wireless. Fantastic song!",@"player",@"0", @"0",nil],                   
                   [NSMutableArray arrayWithObjects:@"Our sons will run this factory one day.\nAnd their sons.\nAnd their son's sons.",@"player",@"liselot", @"0",nil],                                  
                   [NSMutableArray arrayWithObjects:@"During the war (World War II, 1942-1945), I tried to explain to my younger sisters what chocolate is. Can you imagine, trying to describe it.",@"liselot",@"player", @"0",nil],                                  
                   [NSMutableArray arrayWithObjects:@"I will turn over every corner of this so called Super Lemonade Factory until I find some dirt.",@"inspector",@"player", @"0",nil],
                   [NSMutableArray arrayWithObjects:@"A military contract to supply soda to the military landed on my desk today. Choosing sides in the turbulent time is risky, but the rewards are great.",@"player",@"army", @"0",nil],                   
                   [NSMutableArray arrayWithObjects:@"And so he had no sleep that night. The army was not strong arming him, they couldn't care. If he said no, they'd take their business elsewhere. Their big, lucrative business.",@"",@"", @"notepad",nil],
                   [NSMutableArray arrayWithObjects:@"For my family, I signed the papers.",@"player",@"army", @"",nil],
                   [NSMutableArray arrayWithObjects:@"Although now guaranteed a steady cash flow, still he did not sleep well. He was now a military contractor, and agreed to accept all that it entails.",@"",@"", @"notepad",nil],
                   [NSMutableArray arrayWithObjects:@"No need for an inspection today. You're with us now.",@"inspector",@"player", @"",nil],                  
                   [NSMutableArray arrayWithObjects:@"With the contracts in place my job is done. You'd imagine that I'd be content with my achievements. But I am a man apart. Society does not approve of men of my persuasion.",@"army",@"", @"",nil],                   
                   [NSMutableArray arrayWithObjects:@"\nI am off to my meeting with the Govenor General.",@"player",@"", @"",nil],                    
                   [NSMutableArray arrayWithObjects:@"Sometimes I feel the information I hand over to the army is more valuable than they give credit for. I am responsible for airing the community's thoughts and grievences. Do they care?",@"player",@"", @"",nil],                    
                   [NSMutableArray arrayWithObjects:@"We care.\nTrust us.\nWe are in total control.",@"army",@"player", @"",nil],                    
                   [NSMutableArray arrayWithObjects:@"\nThe End.",@"player",@"", @"",nil],                    
                   
                   nil];
    
    
    hasCheckedGameOverScreen=NO;
    
    killedArmy = 0;
    killedChef = 0;
    killedInspector = 0;
    killedWorker = 0;
    collectedBottles = 0;
    
    FlxG.score = 0;
    bulletIndex = 0;
    discIndex = 0;
    grenadeIndex = 0;
    bulletDamage = 1.0;
    
    [self loadLevelStandards];
    
    [self loadLevelFromXML];
    
    [self loadCharacters];
    
    [self add:playerPlatforms];
    
    [FlxG followWithParam1:player param2:15];
    [FlxG followBoundsWithParam1:0 param2:0 param3:FlxG.levelWidth param4:FlxG.levelHeight+VERTICAL_OVERSHOOT_OF_LEVEL param5:YES];
    
    
    
    
    weaponText = [FlxText textWithWidth:200
                                   text:@""
                                   font:@"SmallPixel"
                                   size:16.0];
	weaponText.color = 0xffffffff;
	weaponText.alignment = @"left";
	weaponText.x = 1000;
	weaponText.y = 1000;
    weaponText.acceleration = CGPointMake(0, -100);
    weaponText.shadow = 0x00000000;
	[self add:weaponText];
    
    buttonLeft  = [FlxSprite spriteWithX:80 y:80 graphic:@"buttonArrow.png"];
    buttonLeft.x = 0;
    buttonLeft.y = FlxG.height-80;
    buttonLeft.alpha=BUTTON_START_ALPHA;
    buttonLeft.scrollFactor = CGPointMake(0, 0);
	[self add:buttonLeft];
    
    buttonRight  = [FlxSprite spriteWithX:80 y:80 graphic:@"buttonArrow.png"];
    buttonRight.x = 80;
    buttonRight.y = FlxG.height-80;
    buttonRight.angle = 180;
    buttonRight.alpha=BUTTON_START_ALPHA;
    buttonRight.scrollFactor = CGPointMake(0, 0);
    
	[self add:buttonRight];  
    
    buttonA  = [FlxSprite spriteWithX:80 y:80 graphic:@"buttonButton.png"];
    buttonA.x = 320;
    buttonA.y = FlxG.height-60;
    buttonA.alpha=BUTTON_START_ALPHA;
    buttonA.scrollFactor = CGPointMake(0, 0);
    
	[self add:buttonA];
    buttonB  = [FlxSprite spriteWithX:80 y:80 graphic:@"buttonButton.png"];
    buttonB.x = 400;
    buttonB.y = FlxG.height-60;
    buttonB.alpha=BUTTON_START_ALPHA;
    buttonB.scrollFactor = CGPointMake(0, 0);
    
	[self add:buttonB]; 
    
    gameOverScreenDarken  = [FlxSprite spriteWithX:0 y:0 graphic:nil];
	[gameOverScreenDarken createGraphicWithParam1:480 param2:320 param3:0xff000000];
	gameOverScreenDarken.visible = FALSE;
    gameOverScreenDarken.alpha = 0.6;
    gameOverScreenDarken.x = 0;
    gameOverScreenDarken.y = 0;
    gameOverScreenDarken.scrollFactor = CGPointMake(0, 0);
	[self add:gameOverScreenDarken];
    
    //sugar high rainbow graphic
    sh = [SugarHigh sugarHighWithOrigin:CGPointMake(FlxG.width/2-24, FlxG.height/2-16)];
    sh.alpha = 0.45;
    sh.visible = NO;
    sh.scrollFactor = CGPointMake(0, 0);
    [self add:sh];
    
    
    scoreText = [FlxText textWithWidth:FlxG.width
								  text:@"0"
								  font:@"SmallPixel"
								  size:24.0];
	scoreText.color = 0xffffffff;
	scoreText.alignment = @"left";
	scoreText.x = 2;
	scoreText.y = 6;
    scoreText.shadow = 0x00000000;
    scoreText.scrollFactor = CGPointMake(0, 0);
	[self add:scoreText];
    
    gameOverText = [FlxText textWithWidth:FlxG.width
                                     text:@" "
                                     font:@"SmallPixel"
                                     size:16.0];
    gameOverText.color = 0xffffffff;
	gameOverText.alignment = @"center";
	gameOverText.x = 0;
	gameOverText.y = FlxG.height*0.23;
    gameOverText.shadow = 0x00000000;
    gameOverText.visible = NO;
    gameOverText.scrollFactor = CGPointMake(0, 0);
	[self add:gameOverText];
    
    buttonPlay  = [FlxSprite spriteWithX:FlxG.width/5 y:20 graphic:@"play.png"];
    //buttonPlay.width*=2; 
    buttonPlay.alpha=1;
    buttonPlay.visible = NO;
    buttonPlay.scale = CGPointMake(2, 2);
    buttonPlay.scrollFactor = CGPointMake(0, 0);
	[self add:buttonPlay]; 
    
    buttonMenu  = [FlxSprite spriteWithX:FlxG.width/5 + FlxG.width/2 y:20 graphic:@"menu.png"];
    //buttonMenu.width*=2;
    buttonMenu.alpha=1;
    buttonMenu.visible = NO;
    buttonMenu.scale = CGPointMake(2, 2);
    buttonMenu.scrollFactor = CGPointMake(0, 0);
    
	[self add:buttonMenu];  
    
    
    
    speechBubble = [FlxTileblock tileblockWithX:40 y:180 width:FlxG.width-80 height:50];  
    [speechBubble loadGraphic:@"speechBubbleTiles.png" empties:0 autoTile:NO isSpeechBubble:4];
    speechBubble.visible=NO;
    speechBubble.scrollFactor  = CGPointMake(0, 0);
    [self add:speechBubble];
    
    notepad = [FlxTileblock tileblockWithX:40 y:180 width:FlxG.width-80 height:50];  
    [notepad loadGraphic:@"notepadTiles.png" empties:0 autoTile:YES isSpeechBubble:0];
    notepad.visible=NO;
    notepad.scrollFactor  = CGPointMake(0, 0);
    [self add:notepad];    
    
    
    speechBubbleText = [FlxText textWithWidth:FlxG.width-80
                                         text:@" "
                                         font:@"Flixel"
                                         size:8.0];
    speechBubbleText.color = 0x00000000;
	speechBubbleText.alignment = @"center";
	speechBubbleText.x = speechBubble.x;
	speechBubbleText.y = speechBubble.y;
    speechBubbleText.shadow = 0x00000000;
    speechBubbleText.visible = NO;
    speechBubbleText.scrollFactor = CGPointMake(0, 0);
	[self add:speechBubbleText];
    
    enemyGeneric = [EnemyGeneric enemyGenericWithOrigin:CGPointMake(1000,1000) index:0  ];
    enemyGeneric.dead = NO;
    enemyGeneric.visible = NO;
    enemyGeneric.scrollFactor = CGPointMake(0, 0);
    [self add:enemyGeneric];
    
    enemyListener = [EnemyGeneric enemyGenericWithOrigin:CGPointMake(1000,1000) index:0  ];
    enemyListener.scale = CGPointMake(-1,1);
    enemyListener.dead = NO;
    enemyListener.visible = NO;
    enemyListener.scrollFactor = CGPointMake(0, 0);
    [self add:enemyListener];
    
    speechBubbleTextHelp = [FlxText textWithWidth:FlxG.width
                                             text:@"<< Swipe to cycle >>"
                                             font:@"SmallPixel"
                                             size:8.0];
    speechBubbleTextHelp.color = 0xffffffff;
	speechBubbleTextHelp.alignment = @"center";
	speechBubbleTextHelp.x = 0;
	speechBubbleTextHelp.y = speechBubble.y+60;
    speechBubbleTextHelp.shadow = 0x00000000;
    speechBubbleTextHelp.visible = NO;
    speechBubbleTextHelp.scrollFactor = CGPointMake(0, 0);
	[self add:speechBubbleTextHelp];
    
    sugarHighIndicator = [FlxSprite spriteWithX:0 y:1 graphic:nil];
    [sugarHighIndicator createGraphicWithParam1:60 param2:8 param3:0xff83cf6a];
    sugarHighIndicator.x = FlxG.width/2-34;
    sugarHighIndicator.y = FlxG.height-17;    
    sugarHighIndicator.scrollFactor = CGPointMake(0, 0);
    sugarHighIndicator.scale = CGPointMake(0, 1);
    //sugarHighIndicator.offset = CGPointMake(0, -30);
    sugarHighIndicator.origin = CGPointMake(0, 60);
    [self add:sugarHighIndicator];
    
    FlxSprite * sugarHighHUD = [FlxSprite spriteWithX:0 y:1 graphic:@"sugarHighHUD.png"];
    sugarHighHUD.x = FlxG.width/2-sugarHighHUD.width/2;
    sugarHighHUD.y = FlxG.height-sugarHighHUD.height - 5;
    sugarHighHUD.scrollFactor = CGPointMake(0, 0);
    [self add:sugarHighHUD];
    
    
    
    
}

#pragma mark Dealloc


- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [levelArray release];
    [bottleArray release];
    [characterArray release];
    
    [playerPlatforms.members removeAllObjects];
    [enemyPlatforms.members removeAllObjects];
    [characters.members removeAllObjects];
    [allBullets.members removeAllObjects];
    [bullets.members removeAllObjects];
    [discs.members removeAllObjects];
    [grenades.members removeAllObjects];
    [charactersArmy.members removeAllObjects];
    [charactersChef.members removeAllObjects];
    [charactersInspector.members removeAllObjects];
    [charactersWorker.members removeAllObjects];
    
	[speechTexts release];
    [playerPlatforms release];
    [enemyPlatforms release];
    [characters release];
    [allBullets release];
    [bullets release];
    [discs release];
    [grenades release];
    [charactersArmy release];
    [charactersChef release];
    [charactersInspector release];
    [charactersWorker release];
    
    [Bullet release];
    
	[super dealloc];
}

#pragma mark Game Logic


- (void) virtualControlPad 
{
    BOOL newTouch = FlxG.touches.newTouch;
    
    buttonRight.alpha = BUTTON_START_ALPHA;
    buttonLeft.alpha = BUTTON_START_ALPHA;
    buttonA.alpha = BUTTON_START_ALPHA;
    buttonB.alpha = BUTTON_START_ALPHA;
    
    if (FlxG.touches.vcpLeftArrow) {
        buttonLeft.alpha = BUTTON_PRESSED_ALPHA;
        
    } 
    if (FlxG.touches.vcpRightArrow) {
        //player.velocity = CGPointMake(200, player.velocity.y);
        //player.scale = CGPointMake(1, 1);
        buttonRight.alpha = BUTTON_PRESSED_ALPHA;
        
    } 
    if (FlxG.touches.vcpButton2  ) { //&& player.onFloor
        //working!!!!
        //if (player.onFloor) player.velocity = CGPointMake(player.velocity.x, -360);
        //mario style:
        //[player doJump];
        //pressedJump = YES;
        buttonB.alpha = BUTTON_PRESSED_ALPHA;      
    } 
    if (FlxG.touches.vcpButton1 && (newTouch || player.rapidFire) ) {
        buttonA.alpha = BUTTON_PRESSED_ALPHA;
        //[self fireWeapon];
        
    }
    
}

- (void) playerDies {
    player.dead = YES;
    player.velocity = CGPointMake(player.velocity.x, -250);
    player.gunType = @"pistol";
    player.rapidFire = NO;
    bulletDamage = 1;
    player.isOnSugarHigh = NO;
    
    
    
}


#pragma mark Update

- (void) onStoryBack {
    currentSpeechText--;
    [self showSpeechBubbleWithSound:YES];
    
    
}

- (void) onStoryForward {
    
    currentSpeechText++;
    [self showSpeechBubbleWithSound:YES];
    
    
    
}

- (void) showSpeechBubbleWithSound:(BOOL)playSound {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int totalBottles = [prefs integerForKey:@"COLLECTED_BOTTLES"];
    
    //for random speech bubble
    //int selectedSpeechText = [FlxU random]*[speechTexts length];
    
    int maximumSpeechBubble = totalBottles/DIVISOR_FOR_STORY_UNLOCK;
    int nextStoryUnlock = totalBottles % DIVISOR_FOR_STORY_UNLOCK;
    
    int selectedSpeechText = currentSpeechText;
    
    NSLog(@" total bottles %d, maximum speech bubble %d, next story unlock??? %d , bottles til unlock %d overall length %d, current speech text %d, selected speech %d", totalBottles, maximumSpeechBubble, nextStoryUnlock, DIVISOR_FOR_STORY_UNLOCK-nextStoryUnlock, [speechTexts length], currentSpeechText, selectedSpeechText);
    
    BOOL isAtEndOfGame=NO;
    if (maximumSpeechBubble>=[speechTexts length]) {
        maximumSpeechBubble=[speechTexts length]-1;
        isAtEndOfGame=YES;
    }
    
    if (selectedSpeechText > maximumSpeechBubble) {
        selectedSpeechText = maximumSpeechBubble;
        //currentSpeechText = selectedSpeechText;
        currentSpeechText=0;
        selectedSpeechText=0;
        [FlxG play:SndError];
        
    } else if (selectedSpeechText < 0) {
        selectedSpeechText = maximumSpeechBubble;
        currentSpeechText = maximumSpeechBubble;
        
        [FlxG play:SndError];
        
    } else {
        if (playSound) [FlxG play:@"whoosh.caf"];
    }
    
    if (!isAtEndOfGame) {
        speechBubbleTextHelp.text = [[NSString stringWithFormat:@"<< Swipe to cycle >>\nCurrently viewing %d of %d available. \n Collect %d bottles to unlock more of the story.\n ", selectedSpeechText+1, maximumSpeechBubble+1, DIVISOR_FOR_STORY_UNLOCK-nextStoryUnlock ] retain];
    } else {
        speechBubbleTextHelp.text = [[NSString stringWithFormat:@"<< Swipe to cycle >>\nCurrently viewing %d of %d available. \n Story completely unlocked.\n ", selectedSpeechText+1, maximumSpeechBubble+1 ] retain];
        
    }
    
    speechBubbleText.text = [[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:0];
    
    enemyGeneric.visible = YES;
    enemyGeneric.x = speechBubble.x+20;
    enemyGeneric.y = speechBubble.y + enemyGeneric.height + speechBubble.height;
    
    enemyListener.visible = YES;
    enemyListener.x = speechBubble.x+320;
    enemyListener.y = speechBubble.y + enemyListener.height + speechBubble.height;
    
    //play correct animations for end screen characters
    if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:1]isEqual:@"player"]) {
        [enemyGeneric play:@"playerTalk"];
    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:1]isEqual:@"liselot"]) {
        [enemyGeneric play:@"liselotTalk"];
    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:1]isEqual:@"army"]) {
        [enemyGeneric play:@"armyTalk"];
    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:1]isEqual:@"inspector"]) {
        [enemyGeneric play:@"inspectorTalk"];
    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:1]isEqual:@"chef"]) {
        [enemyGeneric play:@"chefTalk"];
    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:1]isEqual:@"worker"]) {
        [enemyGeneric play:@"workerTalk"];
    } else {
        enemyGeneric.visible = NO;
    }
    
    //listening character
    if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:2]isEqual:@"player"]) {
        [enemyListener play:@"playerListen"];
    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:2]isEqual:@"liselot"]) {
        [enemyListener play:@"liselotListen"];
    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:2]isEqual:@"army"]) {
        [enemyListener play:@"armyListen"];
    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:2]isEqual:@"inspector"]) {
        [enemyListener play:@"inspectorListen"];
    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:2]isEqual:@"chef"]) {
        [enemyListener play:@"chefListen"];
    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:2]isEqual:@"worker"]) {
        [enemyListener play:@"workerListen"];
    }             
    else {
        enemyListener.visible = NO;
    }
    
    if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:3]isEqual:@"notepad"]) {
        notepad.visible = YES;
        speechBubble.visible = NO;
        
    }
    else {
        speechBubble.visible = YES;
        notepad.visible = NO;
    }
}


- (void) checkForSugarHigh
{
    //start sugar high
    if (sugarHighIndicator.scale.x >= 1) {
        [FlxG playWithParam1:SndSugarHighStart param2:0.1];
        player.isOnSugarHigh = YES;
        sugarHighIndicator.scale = CGPointMake(1, 1);
        
        //sugarHighIndicator.color = 0xffff0000;
        
        //[self upgradeWeapon];
        
    }
    
    //sugar high rainbow overlay.
    if (player.isOnSugarHigh) {
        sh.visible = YES;
        CGFloat beep = sugarHighIndicator.scale.x - SPEED_FOR_SUGAR_HIGH_REDUCTION;
        sugarHighIndicator.scale = CGPointMake(beep, 1);
        
        //sound management. Come back to this.
        //        CGFloat mod = fmod(beep, 0.05);
        //        NSLog(@"beep = %f modulo %f", beep, mod);
        //        //sound management
        //        
        //        if (mod==0.0 ) {
        //            [FlxG play:SndSugarHighWarning];
        //            NSLog(@"just got one = %f", beep);
        //        }
        
    }
    else {
        sh.visible = NO;
    }
    
    //Sugar high is over
    
    if (sugarHighIndicator.scale.x <= 0) {
        sugarHighIndicator.scale = CGPointMake(0, 1);
        player.isOnSugarHigh = NO;
        //sugarHighIndicator.color = 0xff00ff00;
        
    }
    
    
    
}

- (void) explodeShrapnelFromGrenadeAtX:(CGFloat)X y:(CGFloat)Y
{
    for (int j=0;j<SHRAPNEL_IN_GRENADE;j++) {
        Bullet * b = [bullets.members objectAtIndex:bulletIndex];
        b.x = X;
        b.y = Y;
        b.visible=YES;
        b.dead = NO;
        b.drag = CGPointMake(100, 100);
        b.scale = CGPointMake(1,1);
        
        b.velocity = CGPointMake(-400 + [FlxU random] * 800, -400 + [FlxU random] * 800);
        
        bulletIndex++;
        if (bulletIndex>=bullets.members.length) {
            bulletIndex = 0;	
        }
    } 
    
}

- (void) debugMode {
    if (FlxG.touches.debugButton1) {
        
    }
}

- (void) update
{
    
    /*
     CGPoint p = CGPointMake(player.x, player.y);
     CGPoint b = CGPointMake(bottle.x, bottle.y);
     float aaa = [FlxU getAngleBetweenPointsWithParam1:p param2:b];
     NSLog(@" angle between player and bottle %f ", aaa);
     */
    
    //game over screen
    if ( player.dead ) { 
        
        if (FlxG.touches.swipedDown) {
            [self onStoryBack];
        } else if (FlxG.touches.swipedUp) {
            [self onStoryForward];
        }
        
        
        //all these run once only.
        if (!hasCheckedGameOverScreen) {
            [self addStats];
            
            sh.visible = NO;
            
            [FlxG play:@"dead.caf"];
            [FlxG pauseMusic];
            
            gameOverScreenDarken.visible = YES;
            gameOverText.visible = YES;
            buttonPlay.visible = YES;
            buttonMenu.visible = YES;
            speechBubbleTextHelp.visible = YES;
            
            buttonLeft.alpha = 0;
            buttonRight.alpha = 0;
            buttonA.alpha = 0;
            buttonB.alpha = 0;
            
            speechBubbleText.visible = YES;
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            currentSpeechText = [prefs integerForKey:@"COLLECTED_BOTTLES"] / DIVISOR_FOR_STORY_UNLOCK;
            if (currentSpeechText>[speechTexts length]) {
                currentSpeechText=[speechTexts length]-1;
            }
            speechBubbleTextHelp.text = [[NSString stringWithFormat:@"<< Swipe to cycle >>\nCurrently viewing %d of %d available.", (currentSpeechText+1), (currentSpeechText+1) ] retain];
            
            [self showSpeechBubbleWithSound:NO];
            
        }
        hasCheckedGameOverScreen=YES;
        
        //let's play again!
        if (FlxG.touches.touchesBegan && FlxG.touches.screenTouchPoint.y < 90 && FlxG.touches.screenTouchPoint.x < FlxG.width/2) {
            [FlxG play:@"ping.caf"];
            
            // REMEMBER TO ADD
            //play correct music for level
            [FlxG unpauseMusic];
            
            hasCheckedGameOverScreen=NO;
            gameOverScreenDarken.visible = NO;
            gameOverText.visible = NO;
            buttonPlay.visible = NO;
            buttonMenu.visible = NO;
            speechBubbleText.visible = NO;
            speechBubble.visible = NO;
            notepad.visible = NO;
            enemyGeneric.visible = NO;
            enemyListener.visible = NO;
            speechBubbleTextHelp.visible = NO;
            sugarHighIndicator.scale = CGPointMake(0, 1);
            
            //[bottle resetPosition];
            [crate resetPosition];
            [sugarBag resetPosition];
            timer = 0;
            totalTimeElapsed = 0;
            player.dead = NO;
            player.visible = YES;
            FlxG.score = 0;
            scoreText.text = @"0";
            player.x = player.originalXPos;
            player.y = player.originalYPos;
            player.velocity = CGPointMake(0, 0);
            for (Enemy * s in characters.members) {
                s.dead = NO;
                s.x = s.originalXPos;
                s.y = s.originalYPos;
                //s.velocity = CGPointMake(0, 0);
                //s.acceleration = CGPointMake(0, 0);
                
            }
            
            
            return;
        } 
        //back to menu
        else if (FlxG.touches.touchesBegan && FlxG.touches.screenTouchPoint.y < 90 && FlxG.touches.screenTouchPoint.x > FlxG.width/2) {
            [FlxG play:@"ping2.caf"];
            [self addStats];
            
            [playerPlatforms.members removeAllObjects];
            [enemyPlatforms.members removeAllObjects];
            [characters.members removeAllObjects];
            [allBullets.members removeAllObjects];
            [bullets.members removeAllObjects];
            [discs.members removeAllObjects];
            [grenades.members removeAllObjects];
            [charactersArmy.members removeAllObjects];
            [charactersChef.members removeAllObjects];
            [charactersInspector.members removeAllObjects];
            [charactersWorker.members removeAllObjects];
            
            FlxG.state = [[[MenuState alloc] init] autorelease];
            
            return; 
        }
    }
    
    
    
    //[self checkForSugarHigh];
    
	timer += FlxG.elapsed;
    totalTimeElapsed += FlxG.elapsed;
    
    if (!player.dead) [self virtualControlPad];
    
    [super update];
    
    if (!player.dead) {
        [FlxU collideObject:player withGroup:playerPlatforms];
    }
    
    [FlxU collideObject:bottle withGroup:playerPlatforms];
    [FlxU collideObject:crate withGroup:playerPlatforms];
    [FlxU collideObject:sugarBag withGroup:playerPlatforms];
    //[FlxU collideObject:crate withGroup:player];
    [FlxU alternateCollideWithParam1:player param2:crate];
    [FlxU collideObject:crate withGroup:characters];
    
    
    
    //grenade collisions
    for (FlxObject * s in grenades.members) {
        if (s.velocity.x <= 1 && s.velocity.x >= -1 && !s.dead ) {
            if (player.isOnSugarHigh) {
                [self explodeShrapnelFromGrenadeAtX:s.x y:s.y];
            }
            puffEmitter.x = s.x;
            puffEmitter.y = s.y;
            [puffEmitter startWithParam1:YES param2:2 param3:20];
            
            [FlxG play:@"grenadeExplosion.caf"];
            explosion.x = s.x-explosion.width/2;
            explosion.y = s.y-explosion.height/2;
            explosion.dead = NO;
            explosion.alpha = 1;
            explosion.scale = CGPointMake(1, 1  );
            
            s.velocity = CGPointMake(0, 0   );
            s.x = 1000;
            s.y = 1000;
            s.dead = YES;
            
            
            
            
        }
        [FlxU collideObject:s withGroup:playerPlatforms];
        for (FlxObject * e in characters.members) {
            if (  ([s overlapsWithOffset:e] && !e.dead)  ) {
                
                if (player.isOnSugarHigh) {
                    [self explodeShrapnelFromGrenadeAtX:s.x y:s.y];
                }
                
                puffEmitter.x = s.x;
                puffEmitter.y = s.y;
                [puffEmitter startWithParam1:YES param2:2 param3:20];
                
                [FlxG play:@"grenadeExplosion.caf"];
                explosion.x = s.x-explosion.width/2;
                explosion.y = s.y-explosion.height/2;
                explosion.dead = NO;
                explosion.alpha = 1;
                explosion.scale = CGPointMake(1, 1  );
                
                s.velocity = CGPointMake(0, 0   );
                s.x = 1000;
                s.y = 1000;
                s.dead = YES;
                
                
                return;
                
            }
            
        }
    } //end grenade collisions
    
    
    //enemies collide with platforms and enemies touch player
    for (FlxObject * s in characters.members) {
        if (! s.dead ) {
            [FlxU collideObject:s withGroup:enemyPlatforms];
        }
		if ([s overlapsWithOffset:player] && (s.dead == NO) && (player.dead == NO)) {
            [self playerDies];
            NSLog(@"Player killed by: %@", s );
            
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
        
        for (FlxObject	* b	in allBullets.members) {
            if (!b.dead) {
                if ([s overlapsWithOffset:b] && (s.dead == NO) && [b isKindOfClass:[Bullet class]]) {
                    [s hurt:bulletDamage];
                    b.x = -100;
                    b.y = -100;
                    if (s.health<=0) {
                        [self addEnemyToTotal:s];
                    }
                }
                else if ([s overlapsWithOffset:b] && (s.dead == NO) && [b isKindOfClass:[Disc class]]) {
                    if (s.flickering) {return;}
                    [s hurt:bulletDamage];
                    if (s.health<=0) {
                        [self addEnemyToTotal:s];
                    }            
                } 
                else  if ([s overlapsWithOffset:b] && (s.dead == NO) && [b isKindOfClass:[Grenade class]]) {
                    [s hurt:100.0];
                    if (s.health<=0) {
                        [self addEnemyToTotal:s];
                    }               
                    b.x = -100;
                    b.y = -100;
                } else  if ([s overlapsWithOffset:b] && (s.dead == NO) && [b isKindOfClass:[Explosion class]]) {
                    [s hurt:100.0];
                    if (s.health<=0) {
                        [self addEnemyToTotal:s];
                    }            
                }
            }
        }
        
	}
    
    //overlaps sugar bag.
    if ([player overlapsWithOffset:sugarBag]) {
        [FlxG play:@"powerUp.caf"];
        [sugarBag resetPosition];
        
        
        CGFloat beep = sugarHighIndicator.scale.x + PERCENTAGE_SUGAR_BAG_ADDS;
        sugarHighIndicator.scale = CGPointMake(beep, 1);
        
        
        
    }    
    
    if ([player overlapsWithOffset:bottle]) {
        
        [self rearrangePlatforms];
        
        [FlxG play:SndFizz];
        [FlxG play:@"powerUp.caf"];
        
        collectedBottles++;
        if (player.isOnSugarHigh) {
            collectedBottles++;
        }
        puffEmitter2.x = bottle.x-12;
        puffEmitter2.y = bottle.y-12;
        puffEmitter2.width = 24;
        puffEmitter2.height = 24;
        [puffEmitter2 startWithParam1:YES param2:14 param3:7 ];
        
        weaponText.x = bottle.x;
        if (weaponText.x>FlxG.levelWidth-130) { weaponText.x = FlxG.levelWidth-130; }
        weaponText.y = bottle.y - 30;
        weaponText.velocity = CGPointMake(0, 0);
        
        [bottle resetPosition];
        FlxG.score += 1;
        NSString *intString = [NSString stringWithFormat:@"%d", FlxG.score];
        scoreText.text = (@"%@", intString);
        if (FlxG.score > curHighScore) {
            //NSLog(@"We got a high score");
            intString = [NSString stringWithFormat:@"%d!", FlxG.score];
            scoreText.text = (@"%@", intString);
        }
        puffEmitter.x = bottle.x-12;
        puffEmitter.y = bottle.y-12;
        puffEmitter.width = 24;
        puffEmitter.height = 24;
        [puffEmitter startWithParam1:YES param2:14 param3:7 ];
        
    }
    
    
    //[FlxU collideObject:enemy withGroup:platforms];
    //collide discs with level
    for (Disc * s in discs.members) {
        if (!s.dead) {
            [FlxU collideObject:s withGroup:playerPlatforms];
            //[FlxU alternateCollideWithParam1:s param2:playerPlatforms];
            
            if ([s overlapsWithOffset:player]) {
                [self playerDies];
                return;
            }
        }
    }
    
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
    
    //high score
    
    if (FlxG.level == 1) {
        NSInteger highScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL1"];
        if (FlxG.score > highScore) {
            [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL1"];
            highScore = FlxG.score;
        }	  
        else {
            
        }
    } else if (FlxG.level == 2) {
        NSInteger highScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL2"];
        if (FlxG.score > highScore) {
            [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL2"];
            highScore = FlxG.score;
        }	  
        else {
            
        }
    } else if (FlxG.level == 3) {
        NSInteger highScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL3"];
        if (FlxG.score > highScore) {
            [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL3"];
            highScore = FlxG.score;
        }	  
        else {
            
        }
    } else if (FlxG.level == 4) {
        NSInteger highScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL4"];
        if (FlxG.score > highScore) {
            [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL4"];
            highScore = FlxG.score;
        }	  
        else {
            
        }
    } else if (FlxG.level == 5) {
        NSInteger highScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL5"];
        if (FlxG.score > highScore) {
            [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL5"];
            highScore = FlxG.score;
        }	  
        else {
            
        }
    } else if (FlxG.level == 6) {
        NSInteger highScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL6"];
        if (FlxG.score > highScore) {
            [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL6"];
            highScore = FlxG.score;
        }	  
        else {
            
        }
    } else if (FlxG.level == 7) {
        NSInteger highScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL7"];
        if (FlxG.score > highScore) {
            [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL7"];
            highScore = FlxG.score;
        }	  
        else {
            
        }
    } else if (FlxG.level == 8) {
        NSInteger highScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL8"];
        if (FlxG.score > highScore) {
            [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL8"];
            highScore = FlxG.score;
        }	  
        else {
            
        }
    } else if (FlxG.level == 9) {
        NSInteger highScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL9"];
        if (FlxG.score > highScore) {
            [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL9"];
            highScore = FlxG.score;
        }	  
        else {
            
        }
    }
    
    
	
	[prefs synchronize];
    
    killedArmy=0;
    killedChef=0;
    killedWorker=0;
    killedInspector=0;
    collectedBottles=0;
    
}


@end

