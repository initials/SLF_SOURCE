////
////  MenuState.m
////  Canabalt
////
////  Copyright Semi Secret Software 2009-2010. All rights reserved.
////
//// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//// THE SOFTWARE. 
////
//
//#import "FlxImageInfo.h"
//
//#import "PlayState.h"
//#import "MenuState.h"
//
//#import "Player.h"
//#import "Enemy.h"
//#import "EnemyArmy.h"
//#import "EnemyChef.h"
//#import "EnemyInspector.h"
//#import "EnemyWorker.h"
//#import "EnemyGeneric.h"
//
//#import "Bullet.h"
//#import "Disc.h"
//#import "Grenade.h"
//#import "Explosion.h"
//#import "Bottle.h"
//#import "SugarBag.h"
//#import "Crate.h"
//#import "Gun.h"
//#import "Cloud.h"
//
//#import "SugarHigh.h"
//
//#define debugGround 0
//#define BULLETSINSHOTGUNBLAST 10
//#define BUTTON_START_ALPHA 0.4
//#define BUTTON_PRESSED_ALPHA 0.6
//#define DIVISOR_FOR_STORY_UNLOCK 10
//#define SPEED_FOR_SUGAR_HIGH_REDUCTION 0.00500000
//#define PERCENTAGE_SUGAR_BAG_ADDS 1 //0.2
//#define SHRAPNEL_IN_GRENADE 10
//#define VERTICAL_OVERSHOOT_OF_LEVEL 50
//
//CGFloat timer;
//CGFloat totalTimeElapsed;
//CGFloat swiperotation;
//CGFloat hypotenuse;
//CGFloat bulletDamage;
//CGFloat gunOffsetToPlayer;
//int previousWeapon;
//
////virtual control pad vars
//int previousNumberOfTouches;
//BOOL newTouch;
//
//static FlxEmitter * puffEmitter = nil;
//static FlxEmitter * puffEmitter2 = nil;
//static FlxEmitter * steamEmitter = nil;
//SugarHigh * sh;
//FlxSprite * sugarHighIndicator;
//
//static NSString * ImgSteam = @"steam.png";
//static NSString * ImgBubble = @"bubble.png";
//static NSString * MusicMegaCannon = @"megacannon.mp3";
//static NSString * MusicIceFishing = @"icefishing.mp3";
//static NSString * MusicPirate = @"pirate.mp3";
//static NSString * SndFizz = @"openDrinkFizz_bfxr ";
//static NSString * SndShoot01 = @"shoot01 ";
//
//static NSString * SndError = @"error ";
//static NSString * SndSugarHighWarning = @"sugarHighWarning ";
//static NSString * SndSugarHighStart = @"sugarHighStart ";
//
//
//
//
//int killedArmy;
//int killedChef;
//int killedWorker;
//int killedInspector;
//int collectedBottles;
//
//static int levelWidth = 48;
//static int levelHeight = 32;
//
//
//BOOL hasCheckedGameOverScreen;
//
//NSInteger curHighScore;
//
//int currentSpeechText;
//
//
//
//
//@implementation PlayState
//
//- (id) init
//{
//	if ((self = [super init])) {
//		self.bgColor = 0xff35353d;
//        playerPlatforms = [[FlxGroup alloc] init];
//        enemyPlatforms = [[FlxGroup alloc] init];
//
//        characters = [[FlxGroup alloc] init];
//        
//        charactersArmy= [[FlxGroup alloc] init];
//        charactersChef= [[FlxGroup alloc] init];
//        charactersInspector= [[FlxGroup alloc] init];
//        charactersWorker= [[FlxGroup alloc] init];
//
//        allBullets = [[FlxGroup alloc] init];
//        bullets = [[FlxGroup alloc] init];
//        discs = [[FlxGroup alloc] init];
//        grenades = [[FlxGroup alloc] init];
//
//	}
//	return self;
//}
//
//#pragma mark Initializers
//
//
//- (void) loadCharacters
//{
//    int i;
//    
//    for (i=0; i<3; i++) {
//		enemyArmy = [EnemyArmy enemyArmyWithOrigin:CGPointMake(1000,1000) index:i  ];
//        enemyArmy.dead = YES;
//		[self add:enemyArmy];
//        [characters add:enemyArmy];
//        [charactersArmy add:enemyArmy];
//	} 
//    
//    for (i=0; i<3; i++) {
//		enemyChef = [EnemyChef enemyChefWithOrigin:CGPointMake(1000,1000) index:i  ];
//        enemyChef.dead = YES;
//		[self add:enemyChef];
//        [characters add:enemyChef];
//        [charactersChef add:enemyChef];
//	} 
//    
//    for (i=0; i<3; i++) {
//		enemyWorker = [EnemyWorker enemyWorkerWithOrigin:CGPointMake(1000,1000) index:i  ];
//        enemyWorker.dead = YES;
//		[self add:enemyWorker];
//        [characters add:enemyWorker];
//        [charactersWorker add:enemyWorker];
//	} 
//    
//    for (i=0; i<3; i++) {
//		enemyInspector = [EnemyInspector enemyInspectorWithOrigin:CGPointMake(1000,1000) index:i  ];
//        enemyInspector.dead = YES;
//		[self add:enemyInspector];
//        [characters add:enemyInspector];
//        [charactersInspector add:enemyInspector];
//	} 
//
//    
//    for (i=0; i<80; i++) {
//        bullet = [Bullet bulletWithOrigin:CGPointMake(-100,-100)] ;
//		[bullets add:bullet];
//        [allBullets add:bullet];
//	}
//    
//    [self add:bullets];
//    
//    for (i=0; i<12; i++) {
//        disc  = [Disc discWithOrigin:CGPointMake(-100,-100)] ;
//        disc.dead = YES;
//		[discs add:disc];
//        [allBullets add:disc];
//	}
//    
//    [self add:discs];
//    
//    for (i=0; i<2; i++) {
//        grenade  = [Grenade  grenadeWithOrigin:CGPointMake(-100,-100)] ;
//		[grenades add:grenade];
//        [allBullets add:grenade];
//	}
//    
//    [self add:grenades];    
//	
//	//for(i = 0; i < 10; i++)
//	//{		
//	player = [[Player alloc] initWithOrigin:CGPointMake(FlxG.width/2,175)] ;
//	//player.acceleration = CGPointMake(0, 900);
//    //player.drag = CGPointMake(500, 500);
//	[self add:player];
//    
//    gun = [Gun gunWithOrigin:CGPointMake(player.x,player.y)] ;
//	[self add:gun];
//    
//    bottle = [Bottle bottleWithOrigin:CGPointMake(-100,-100)] ;
//    [bottle resetPosition];
//	[self add:bottle];
//    
//    crate = [Crate crateWithOrigin:CGPointMake(-100,-100)] ;
//    [crate resetPosition];
//	[self add:crate];
//    
//    sugarBag = [SugarBag sugarBagWithOrigin:CGPointMake(-100,-100)] ;
//    [sugarBag resetPosition];
//	[self add:sugarBag];
//    
//    explosion = [Explosion explosionWithOrigin:CGPointMake(1000,1000)   ];
//    explosion.x = 1000;
//    explosion.y = 1000;
//	[self add:explosion];
//    [allBullets add:explosion];
//    
//    //gibs
//    
//    
//    int gibCount = 25;
//    
//    ge = [[FlxEmitter alloc] init];
//
//    ge.delay = 0.02;
//    
//    ge.minParticleSpeed = CGPointMake(-40,
//                                      -40);
//    ge.maxParticleSpeed = CGPointMake(40,
//                                      40);
//    ge.minRotation = -72;
//    ge.maxRotation = 72;
//    ge.gravity = -120;
//    ge.particleDrag = CGPointMake(10, 10);
//    
//    
//    
//    puffEmitter = [ge retain];
//        
//    
//    [self add:puffEmitter];
//    
//    
//    
//    [ge createSprites:ImgBubble quantity:gibCount bakedRotations:NO
//             multiple:YES collide:0.0 modelScale:1.0];
//    
//    
//    
//    //gibs
//    ge2 = [[FlxEmitter alloc] init];
//    ge2.delay = 0.02;
//    ge2.minParticleSpeed = CGPointMake(-40,
//                                      -40);
//    ge2.maxParticleSpeed = CGPointMake(40,
//                                      40);
//    ge2.minRotation = -72;
//    ge2.maxRotation = 72;
//    ge2.gravity = -120;
//    ge2.particleDrag = CGPointMake(10, 10);
//    puffEmitter2 = [ge2 retain];
//    [self add:puffEmitter2];
//    [ge2 createSprites:ImgBubble quantity:gibCount bakedRotations:NO
//             multiple:YES collide:0.0 modelScale:1.0];
//
//    //gibs
//    sEmit = [[FlxEmitter alloc] init];
//    sEmit.delay = 0.02;
//    sEmit.minParticleSpeed = CGPointMake(-140,
//                                       0);
//    sEmit.maxParticleSpeed = CGPointMake(140,
//                                       0);
//    sEmit.minRotation = 0;
//    sEmit.maxRotation = 0;
//    sEmit.gravity = 0;
//    sEmit.particleDrag = CGPointMake(10, 10);
//    
//    sEmit.x = 0;
//    sEmit.y = FlxG.levelHeight-100;
//    sEmit.width = FlxG.levelWidth;
//    sEmit.height = 2;
//    
//    steamEmitter = [sEmit retain];
//    
//    
//    [self add:steamEmitter];
//    [sEmit createSprites:ImgSteam quantity:10 bakedRotations:NO
//              multiple:YES collide:0.0 modelScale:1.0]; 
//    
//
//    
//    
//}
//
//- (void) setLevelSize {
//    if (FlxG.level==1 || FlxG.level==2 || FlxG.level==3) {
//        FlxG.levelWidth = 480;
//        FlxG.levelHeight = 320;
//    }
//    if (FlxG.level==4 || FlxG.level==5 || FlxG.level==6) {
//        FlxG.levelWidth = 720;
//        FlxG.levelHeight = 480;
//    }        
//    if (FlxG.level==7 || FlxG.level==8 || FlxG.level==9) {
//        FlxG.levelWidth = 960;
//        FlxG.levelHeight = 640;
//    }
//
//}
//
//- (void) loadLevelBlocksFromImage {
//    static NSString * ImgTiles;
//    static NSString * ImgSpecialSquareBlock;
//    static NSString * ImgSpecialPlatform;
//
//    
//    NSData* pixelData;
//
//    if (FlxG.level==1) {
//        ImgTiles = @"level1_tiles.png";
//        ImgSpecialSquareBlock = @"level1_specialBlock.png";
//        ImgSpecialPlatform = @"level1_specialPlatform.png";
//        pixelData = [FlxImageInfo readImage:@"level1_map.png"];
//    }
//    if (FlxG.level==2 ) {
//        ImgTiles = @"level2_tiles.png";
//        ImgSpecialSquareBlock = @"level2_specialBlock.png";
//        ImgSpecialPlatform = @"level2_specialPlatform.png";
//        pixelData = [FlxImageInfo readImage:@"level2_map.png"];
//
//    }        
//    if (FlxG.level==3) {
//        ImgTiles = @"level3_tiles.png";
//        ImgSpecialSquareBlock = @"level3_specialBlock.png";
//        ImgSpecialPlatform = @"level3_specialPlatform.png";
//        pixelData = [FlxImageInfo readImage:@"level3_map.png"];
//
//    }
//    if (FlxG.level==4) {
//        ImgTiles = @"level1_tiles.png";
//        ImgSpecialSquareBlock = @"level1_specialBlock.png";
//        ImgSpecialPlatform = @"level1_specialPlatform.png";
//        pixelData = [FlxImageInfo readImage:@"level4_map.png"];
//        
//    }
//    if (FlxG.level==5) {
//        ImgTiles = @"level2_tiles.png";
//        ImgSpecialSquareBlock = @"level2_specialBlock.png";
//        ImgSpecialPlatform = @"level2_specialPlatform.png";
//        pixelData = [FlxImageInfo readImage:@"level5_map.png"];
//        
//    }      
//    if (FlxG.level==6) {
//        ImgTiles = @"level3_tiles.png";
//        ImgSpecialSquareBlock = @"level3_specialBlock.png";
//        ImgSpecialPlatform = @"level3_specialPlatform.png";
//        pixelData = [FlxImageInfo readImage:@"level6_map.png"];
//        
//    }   
//    if (FlxG.level==7) {
//        ImgTiles = @"level1_tiles.png";
//        ImgSpecialSquareBlock = @"level1_specialBlock.png";
//        ImgSpecialPlatform = @"level1_specialPlatform.png";
//        pixelData = [FlxImageInfo readImage:@"level7_map.png"];
//        
//    }
//    if (FlxG.level==8) {
//        ImgTiles = @"level2_tiles.png";
//        ImgSpecialSquareBlock = @"level2_specialBlock.png";
//        ImgSpecialPlatform = @"level2_specialPlatform.png";        
//        pixelData = [FlxImageInfo readImage:@"level8_map.png"];
//        
//    }      
//    if (FlxG.level==9) {
//        ImgTiles = @"level3_tiles.png";
//        ImgSpecialSquareBlock = @"level3_specialBlock.png";
//        ImgSpecialPlatform = @"level3_specialPlatform.png";
//        pixelData = [FlxImageInfo readImage:@"level9_map.png"];
//        
//    } 
//    levelWidth = FlxG.levelWidth / 10;
//    levelHeight = FlxG.levelHeight / 10;
//    
////    static NSString * ImgTiles = @"level1_tiles.png";
////    NSData* pixelData = [FlxImageInfo readImage:@"level1_map.png"];
//    
//    unsigned char* pixelBytes = (unsigned char *)[pixelData bytes];
//    
//    int j = 0;
//    
//    //look at each pixel
//    //black = 20x20 block
//    //red = HORIZONTAL length
//    //green = VERTICAL length
//    //blue = Arbitrary ID
//    
//    int arbID=0;
//    
//    for(int i = 0; i < [pixelData length]; i += 4) {
//        
//        int red1 = pixelBytes[i];
//        int green1 = pixelBytes[i+1];
//        int blue1 = pixelBytes[i+2];
//        int alpha1 = pixelBytes[i+3];
//        
//        
//        //if pixel is black, make one 20 x 20 block
//        if (pixelBytes[i]==0 && pixelBytes[i+1]==0 && pixelBytes[i+2]==0 && pixelBytes[i+3]==255) {
//            //NSLog(@"Found a black Pixel");
//            bl = [FlxTileblock tileblockWithX:( (j)%levelWidth)*10 y:((j) / levelWidth) * 10 width:10 height:10];  
//            //[bl loadGraphic:ImgTiles empties:0 autoTile:YES isSpeechBubble:0];
//            
//            [bl loadGraphic:ImgTiles 
//                    empties:0 
//                   autoTile:YES 
//             isSpeechBubble:0 
//                 isGradient:0 
//                arbitraryID:blue1
//                      index:arbID];
//            bl.originalXPos = ((j)%levelWidth)*10;
//            bl.originalYPos = ((j) / levelWidth) * 10;
//            
//            [playerPlatforms add:bl]; 
//            
//            [enemyPlatforms add:bl]; 
//            
//            arbID++;
//        } 
//        
//        //if pixel has some red and some green
//        else if (pixelBytes[i]>0 && pixelBytes[i+1]>0 && pixelBytes[i+2]<100 && pixelBytes[i+3]==255) {
//            //NSLog(@"Found a red+blue Pixel");
//            int w = pixelBytes[i]*10;
//            int h = pixelBytes[i+1]*10;
//            bl = [FlxTileblock tileblockWithX:( (j)%levelWidth)*10 y:((j) / levelWidth) * 10 width:w height:h];  
//            [bl loadGraphic:ImgTiles 
//                    empties:0 
//                   autoTile:YES 
//             isSpeechBubble:0 
//                 isGradient:0 
//                arbitraryID:blue1
//                      index:arbID] ;
//            
//            bl.originalXPos = ((j)%levelWidth)*10;
//            bl.originalYPos = ((j) / levelWidth) * 10;
//            
//            [playerPlatforms add:bl]; 
//            [enemyPlatforms add:bl]; 
//            
//            arbID++;
//        }
//        
//        //if pixel has an a blue pixel of 100 - square platform.
//        else if (pixelBytes[i]>0 && pixelBytes[i+1]>0 && pixelBytes[i+2]==100 && pixelBytes[i+3]==255) {
//            //NSLog(@"Found a red+blue Pixel");
//            int w = pixelBytes[i]*10;
//            int h = pixelBytes[i+1]*10;
//            bl = [FlxTileblock tileblockWithX:( (j)%levelWidth)*10 y:((j) / levelWidth) * 10 width:w height:h];  
//            [bl loadGraphic:ImgSpecialSquareBlock 
//                    empties:0 
//                   autoTile:NO 
//             isSpeechBubble:0 
//                 isGradient:0 
//                arbitraryID:blue1
//                      index:arbID] ;
//            
//            bl.originalXPos = ((j)%levelWidth)*10;
//            bl.originalYPos = ((j) / levelWidth) * 10;
//            
//            [playerPlatforms add:bl]; 
//            [enemyPlatforms add:bl]; 
//            
//            arbID++;
//        }    
//        
//        //if pixel has an a blue pixel of 99 - specialPlatform
//        else if (pixelBytes[i]>0 && pixelBytes[i+1]>0 && pixelBytes[i+2]==101 && pixelBytes[i+3]==255) {
//            //NSLog(@"Found a red+blue Pixel");
//            int w = pixelBytes[i]*10;
//            int h = pixelBytes[i+1]*10;
////            bl = [FlxTileblock tileblockWithX:( (j)%levelWidth)*10 y:((j) / levelWidth) * 10 width:w height:h];  
////            [bl loadGraphic:ImgSpecialPlatform
////                    empties:0 
////                   autoTile:NO 
////             isSpeechBubble:0 
////                 isGradient:0 
////                arbitraryID:blue1
////                      index:arbID] ;
//            
//            FlxSprite * specialBlock = [FlxSprite spriteWithX:( (j)%levelWidth)*10 y:((j) / levelWidth) * 10 graphic:ImgSpecialPlatform];
//            specialBlock.width = w;
//            specialBlock.height = h;
//            specialBlock.fixed = YES;
//            
//            specialBlock.originalXPos = ((j)%levelWidth)*10;
//            specialBlock.originalYPos = ((j) / levelWidth) * 10;
//            
//            [playerPlatforms add:specialBlock]; 
//            [enemyPlatforms add:specialBlock]; 
//            
//            arbID++;
//        } 
//        
//        
//        
//        //NSLog(@"PIXEL DATA %d %hhu %hhu %hhu %hhu %d %d", i, pixelBytes[i], pixelBytes[i+1], pixelBytes[i+2], pixelBytes[i+3], (j%48)*10, (j / 48) * 10 );
//        j++;
//    }
//    
//}
//
//
//#pragma mark Load Levels
//
//
////Size small
////Level: Warehouse
//
//- (void) loadLevel1
//{
//    static NSString * ImgBG = @"shelfLayer.png";
//    static NSString * ImgWindows = @"level1_windows.png";
//    static NSString * ImgGradient = @"level1_bgSmoothGrad.png";
//    static NSString * ImgLeftMG = @"level1_leftSideMG.png";
//    static NSString * ImgRightMG = @"level1_rightSideMG.png";
//
//    [FlxG playMusic:MusicMegaCannon];
//    
//    FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:FlxG.height];  
//    [grad loadGraphic:ImgGradient empties:0 autoTile:NO isSpeechBubble:0 isGradient:4];
//    [self add:grad]; 
//    
//    FlxTileblock * windows = [FlxTileblock tileblockWithX:0 y:100 width:580 height:54];  
//    [windows loadGraphic:ImgWindows empties:0 autoTile:NO isSpeechBubble:0 isGradient:0];
//    
//    [self add:windows]; 
//
//    backG = [FlxSprite spriteWithX:210 y:313 graphic:ImgBG];
//    backG.x = FlxG.width-backG.width-100;
//    backG.y = FlxG.height-backG.height;
//	[self add:backG];
//    
//    FlxSprite * sugarbags = [FlxSprite spriteWithX:153 y:128 graphic:ImgLeftMG];
//    sugarbags.x = 0;
//    sugarbags.y = FlxG.height-sugarbags.height;
//    [self add:sugarbags];
//    
//    FlxSprite * sugarbagsR = [FlxSprite spriteWithX:147 y:181 graphic:ImgRightMG];
//    sugarbagsR.x = FlxG.width-sugarbagsR.width;
//    sugarbagsR.y = FlxG.height-sugarbagsR.height;
//    [self add:sugarbagsR];
//   
//    [self loadLevelBlocksFromImage];
//    
//    [self loadCharacters];
//    
//    [bottle play:@"orange"];
//
//    [self add:playerPlatforms];
//    
//    [FlxG followWithParam1:player param2:15];
//    [FlxG followBoundsWithParam1:0 param2:0 param3:0 param4:FlxG.levelHeight+VERTICAL_OVERSHOOT_OF_LEVEL param5:YES];
//    
//    
//
//    
//}
//
////Size small
////Level: Production (Green)
//
//- (void) loadLevel2
//{
//    [FlxG playMusic:MusicIceFishing];
//    static NSString * ImgBG = @"level2_BG.png";
//    static NSString * ImgLeftMG = @"level2_MG2.png";
//    static NSString * ImgRightMG = @"level2_MG1.png";
//    static NSString * ImgFMGTank = @"level2_FMG3.png";
//
//    static NSString * ImgChainTile = @"level2_chainTile.png";
//
////    FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:FlxG.height];  
////    [grad loadGraphic:ImgGradient empties:0 autoTile:NO isSpeechBubble:0 isGradient:4];
////    [self add:grad]; 
//     
//    backG = [FlxSprite spriteWithX:480 y:320 graphic:ImgBG];
//    backG.x = 0;
//    backG.y = 0;
//    backG.scrollFactor = CGPointMake(0, 0);
//	[self add:backG];
//    
//    FlxTileblock * bgChain1 = [FlxTileblock tileblockWithX:50 y:0 width:13 height:100];  
//    [bgChain1 loadGraphic:ImgChainTile empties:0 autoTile:NO isSpeechBubble:0 isGradient:0];
//    //bgChain1.scrollFactor = CGPointMake(0.25, 0.25);
//    [self add:bgChain1]; 
//    FlxTileblock * bgChain2 = [FlxTileblock tileblockWithX:bgChain1.x+70 y:0 width:13 height:100];  
//    [bgChain2 loadGraphic:ImgChainTile empties:0 autoTile:NO isSpeechBubble:0 isGradient:0];
//    //bgChain2.scrollFactor = CGPointMake(0.25, 0.25);
//    [self add:bgChain2];
//    
//    FlxSprite * fmgTank = [FlxSprite spriteWithX:bgChain1.x-20 y:90 graphic:ImgFMGTank];
//    //fmgTank.scrollFactor = CGPointMake(0.25, 0.25);
//    [self add:fmgTank];    
//    
//    
//    FlxSprite * tank = [FlxSprite spriteWithX:107 y:200 graphic:ImgLeftMG];
//    //tank.scrollFactor = CGPointMake(0.5, 0.5);
//    tank.x = 0;
//    tank.y = 107;
//    [self add:tank];
//    
//    FlxSprite * tankR = [FlxSprite spriteWithX:180 y:370 graphic:ImgRightMG];
//    tankR.x = FlxG.levelWidth-tankR.width;
//    tankR.y = -40;
//    //tankR.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:tankR];
//    
//    [self loadLevelBlocksFromImage];
//    
//    [self loadCharacters];
//    
//    [self add:playerPlatforms];
//    
//    [FlxG followWithParam1:player param2:15];
//    [FlxG followBoundsWithParam1:0 param2:0 param3:0 param4:FlxG.levelHeight+VERTICAL_OVERSHOOT_OF_LEVEL param5:YES];
//    
//    [sEmit startWithParam1:NO param2:0.05 param3:0.1 ];  
//}
//
////Size small
////Level: Management (Yellow)
//
//- (void) loadLevel3
//{
//    [FlxG playMusic:MusicPirate];
//    
//    static NSString * ImgGradient = @"level3_gradient.png";
//    static NSString * ImgMG = @"level3_MG.png";
//    static NSString * ImgMGpylon = @"level3_MG_pylon.png";
//    
//    FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:FlxG.height];  
//    [grad loadGraphic:ImgGradient];
//    //grad.scrollFactor = CGPointMake(0, 0);
//    [self add:grad];
//    
//    FlxSprite * cloud = [Cloud cloudWithOrigin:CGPointMake(10, 10)];
//    //cloud.scrollFactor = CGPointMake(0.5, 0.5);
//    cloud.velocity = CGPointMake(-50, 0);
//    [self add:cloud];
//    
//    FlxSprite * sprMG = [FlxSprite spriteWithX:259 y:440 graphic:ImgMG];
//    sprMG.x = FlxG.width - sprMG.width;
//    sprMG.y = FlxG.height - sprMG.height - 20;
//    sprMG.scale = CGPointMake(1, 1 );
//    //sprMG.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sprMG];
//    
//    FlxSprite * sprMGpylon = [FlxSprite spriteWithX:24 y:320 graphic:ImgMGpylon];
//    sprMGpylon.x = 150;
//    sprMGpylon.y = FlxG.height*1.5 - sprMG.height - 20;
//    sprMGpylon.scale = CGPointMake(1, 2 );
//    //sprMGpylon.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sprMGpylon];    
//    
//    sprMGpylon = [FlxSprite spriteWithX:24 y:320 graphic:ImgMGpylon];
//    sprMGpylon.x = 100;
//    sprMGpylon.y = FlxG.height*1.5 - sprMG.height - 20;
//    sprMGpylon.scale = CGPointMake(1, 2 );
//    sprMGpylon.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sprMGpylon]; 
//    
//    sprMGpylon = [FlxSprite spriteWithX:24 y:320 graphic:ImgMGpylon];
//    sprMGpylon.x = 50;
//    sprMGpylon.y = FlxG.height*1.5 - sprMG.height - 20;
//    sprMGpylon.scale = CGPointMake(1, 2 );
//    sprMGpylon.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sprMGpylon];  
//    
//    [self loadLevelBlocksFromImage];
//    
//    [self loadCharacters];
//    
//    [self add:playerPlatforms];
//    
//    [FlxG followWithParam1:player param2:15];
//    [FlxG followBoundsWithParam1:0 param2:0 param3:0 param4:FlxG.levelHeight+VERTICAL_OVERSHOOT_OF_LEVEL param5:YES];
//   
//}
//
//
//
//- (void) loadLevel4
//{
//    static NSString * ImgBG = @"shelfLayer.png";
//    static NSString * ImgTiles = @"level1_tiles.png";
//    static NSString * ImgWindows = @"level1_windows.png";
//    static NSString * ImgGradient = @"level1_bgSmoothGrad.png";
//    static NSString * ImgLeftMG = @"level1_leftSideMG.png";
//    static NSString * ImgRightMG = @"level1_rightSideMG.png";
//    
//    [FlxG playMusic:MusicMegaCannon];
//    
//    FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:FlxG.height];  
//    [grad loadGraphic:ImgGradient empties:0 autoTile:NO isSpeechBubble:0 isGradient:4];
//    grad.scrollFactor = CGPointMake(0, 0);
//    [self add:grad]; 
//    
//    FlxTileblock * windows = [FlxTileblock tileblockWithX:0 y:100 width:580 height:54];  
//    [windows loadGraphic:ImgWindows empties:0 autoTile:NO isSpeechBubble:0 isGradient:0];
//    windows.scrollFactor = CGPointMake(0.25, 0.25);
//    [self add:windows]; 
//    
//    backG = [FlxSprite spriteWithX:210 y:313 graphic:ImgBG];
//    backG.x = FlxG.width-backG.width-100;
//    backG.y = FlxG.height*1.1125-backG.height-10;
//    backG.scrollFactor = CGPointMake(0.25, 0.25);
//	[self add:backG];
//    
//    FlxSprite * sugarbags = [FlxSprite spriteWithX:153 y:128 graphic:ImgLeftMG];
//    sugarbags.x = 0;
//    sugarbags.y = FlxG.height*1.25-sugarbags.height-20;
//    sugarbags.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sugarbags];
//        
//    FlxSprite * sugarbagsR = [FlxSprite spriteWithX:147 y:181 graphic:ImgRightMG];
//    
//    //put x and y back here
//    sugarbagsR.x = FlxG.width*1.25-sugarbagsR.width;
//    sugarbagsR.y = FlxG.height*1.25-sugarbagsR.height-20;
//    sugarbagsR.scrollFactor = CGPointMake(.5, .5);
//
//    [self add:sugarbagsR];
//    
//    [self loadLevelBlocksFromImage];
//    
//    [self loadCharacters];
//    
//    [bottle play:@"orange"];
//    
//    [self add:playerPlatforms];
//    
//    
//    [FlxG followWithParam1:player param2:15];
//    [FlxG followBoundsWithParam1:0 param2:0 param3:FlxG.levelWidth param4:FlxG.levelHeight+VERTICAL_OVERSHOOT_OF_LEVEL param5:YES];   
//}
//
////size medium
////level: Green production
//
//- (void) loadLevel5
//{
//    [FlxG playMusic:MusicIceFishing];
//    static NSString * ImgBG = @"level2_BG.png";
//    static NSString * ImgLeftMG = @"level2_MG2.png";
//    static NSString * ImgRightMG = @"level2_MG1.png";
//    static NSString * ImgFMGTank = @"level2_FMG3.png";
//    static NSString * ImgChainTile = @"level2_chainTile.png";
//    
//    backG = [FlxSprite spriteWithX:480 y:320 graphic:ImgBG];
//    backG.x = 0;
//    backG.y = 0;
//    backG.scrollFactor = CGPointMake(0, 0);
//	[self add:backG];
//    
//    FlxTileblock * bgChain1 = [FlxTileblock tileblockWithX:50 y:0 width:13 height:100];  
//    [bgChain1 loadGraphic:ImgChainTile empties:0 autoTile:NO isSpeechBubble:0 isGradient:0];
//    bgChain1.scrollFactor = CGPointMake(0.25, 0.25);
//    [self add:bgChain1]; 
//    FlxTileblock * bgChain2 = [FlxTileblock tileblockWithX:bgChain1.x+70 y:0 width:13 height:100];  
//    [bgChain2 loadGraphic:ImgChainTile empties:0 autoTile:NO isSpeechBubble:0 isGradient:0];
//    bgChain2.scrollFactor = CGPointMake(0.25, 0.25);
//    [self add:bgChain2];
//    
//    FlxSprite * fmgTank = [FlxSprite spriteWithX:bgChain1.x-20 y:90 graphic:ImgFMGTank];
//    fmgTank.scrollFactor = CGPointMake(0.25, 0.25);
//    [self add:fmgTank];    
//    
//    FlxSprite * tank = [FlxSprite spriteWithX:107 y:200 graphic:ImgLeftMG];
//    tank.scrollFactor = CGPointMake(0.5, 0.5);
//    tank.x = 0;
//    tank.y = 107;
//    [self add:tank];
//    
//    FlxSprite * tankR = [FlxSprite spriteWithX:180 y:370 graphic:ImgRightMG];
//    tankR.x = 600-tankR.width;
//    tankR.y = 0;
//    tankR.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:tankR];
//    
//    [self loadLevelBlocksFromImage];
//    
//    [self loadCharacters];
//    
//    [self add:playerPlatforms];
//    
//    FlxTileblock * chainTile = [FlxTileblock tileblockWithX:500 y:0 width:13 height:820];  
//    [chainTile loadGraphic:ImgChainTile empties:0 autoTile:NO isSpeechBubble:0 isGradient:0];
//    chainTile.scrollFactor = CGPointMake(1.5, 1.5);
//    [self add:chainTile]; 
//    
//    [FlxG followWithParam1:player param2:15];
//    [FlxG followBoundsWithParam1:0 param2:0 param3:FlxG.levelWidth param4:FlxG.levelHeight+VERTICAL_OVERSHOOT_OF_LEVEL param5:YES];
//    
//    [sEmit startWithParam1:NO param2:0.05 param3:0.1 ];  
//}
//
//- (void) loadLevel6
//{
//    [FlxG playMusic:MusicPirate];
//
//    static NSString * ImgGradient = @"level3_gradient.png";
//    static NSString * ImgMG = @"level3_MG.png";
//    static NSString * ImgMGpylon = @"level3_MG_pylon.png";
//    
//    FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:FlxG.height];  
//    [grad loadGraphic:ImgGradient];
//    grad.scrollFactor = CGPointMake(0, 0);
//    [self add:grad];
//    
//    FlxSprite * cloud = [Cloud cloudWithOrigin:CGPointMake(10, 10)];
//    cloud.scrollFactor = CGPointMake(0.5, 0.5);
//    cloud.velocity = CGPointMake(-50, 0);
//    [self add:cloud];
//    
//    FlxSprite * sprMG = [FlxSprite spriteWithX:259 y:440 graphic:ImgMG];
//    sprMG.x = FlxG.width - sprMG.width;
//    sprMG.y = FlxG.height*1.25 - sprMG.height - 20;
//    sprMG.scale = CGPointMake(1, 1 );
//    sprMG.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sprMG];
//    
//    FlxSprite * sprMGpylon = [FlxSprite spriteWithX:24 y:320 graphic:ImgMGpylon];
//    sprMGpylon.x = 150;
//    sprMGpylon.y = FlxG.height*1.5 - sprMG.height - 20;
//    sprMGpylon.scale = CGPointMake(1, 2 );
//    sprMGpylon.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sprMGpylon];
//    
//    sprMGpylon = [FlxSprite spriteWithX:24 y:320 graphic:ImgMGpylon];
//    sprMGpylon.x = 100;
//    sprMGpylon.y = FlxG.height*1.5 - sprMG.height - 20;
//    sprMGpylon.scale = CGPointMake(1, 2 );
//    sprMGpylon.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sprMGpylon]; 
//    
//    sprMGpylon = [FlxSprite spriteWithX:24 y:320 graphic:ImgMGpylon];
//    sprMGpylon.x = 50;
//    sprMGpylon.y = FlxG.height*1.5 - sprMG.height - 20;
//    sprMGpylon.scale = CGPointMake(1, 2 );
//    sprMGpylon.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sprMGpylon];  
//    
//    
//    //right side
//    sprMGpylon = [FlxSprite spriteWithX:24 y:320 graphic:ImgMGpylon];
//    sprMGpylon.x = FlxG.width ;
//    sprMGpylon.y = FlxG.height*1.5 - sprMG.height - 20;
//    sprMGpylon.scale = CGPointMake(1, 2 );
//    sprMGpylon.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sprMGpylon];    
//    
//    sprMGpylon = [FlxSprite spriteWithX:24 y:320 graphic:ImgMGpylon];
//    sprMGpylon.x = FlxG.width + 50;
//    sprMGpylon.y = FlxG.height*1.5 - sprMG.height - 20;
//    sprMGpylon.scale = CGPointMake(1, 2 );
//    sprMGpylon.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sprMGpylon]; 
//    
//    sprMGpylon = [FlxSprite spriteWithX:24 y:320 graphic:ImgMGpylon];
//    sprMGpylon.x = FlxG.width + 100;
//    sprMGpylon.y = FlxG.height*1.5 - sprMG.height - 20;
//    sprMGpylon.scale = CGPointMake(1, 2 );
//    sprMGpylon.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sprMGpylon];
//    
//    [self loadLevelBlocksFromImage];
//    
//    [self loadCharacters];
//    
//    [self add:playerPlatforms];
//    
//    [FlxG followWithParam1:player param2:15];
//    [FlxG followBoundsWithParam1:0 param2:0 param3:FlxG.levelWidth param4:FlxG.levelHeight+VERTICAL_OVERSHOOT_OF_LEVEL param5:YES];    
//}
//
////size large
////level: Warehouse, purple
//
//- (void) loadLevel7
//{
//    static NSString * ImgBG = @"shelfLayer.png";
//    static NSString * ImgTiles = @"level1_tiles.png";
//    static NSString * ImgWindows = @"level1_windows.png";
//    static NSString * ImgGradient = @"level1_bgSmoothGrad.png";
//    static NSString * ImgLeftMG = @"level1_leftSideMG.png";
//    static NSString * ImgRightMG = @"level1_rightSideMG.png";
//    
//    [FlxG playMusic:MusicMegaCannon];
//    
//    FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:FlxG.height];  
//    [grad loadGraphic:ImgGradient empties:0 autoTile:NO isSpeechBubble:0 isGradient:4];
//    grad.scrollFactor = CGPointMake(0, 0);
//    [self add:grad]; 
//    
//    FlxTileblock * windows = [FlxTileblock tileblockWithX:0 y:100 width:580 height:54];  
//    [windows loadGraphic:ImgWindows empties:0 autoTile:NO isSpeechBubble:0 isGradient:0];
//    windows.scrollFactor = CGPointMake(0.25, 0.25);
//    [self add:windows]; 
//    
//    backG = [FlxSprite spriteWithX:210 y:313 graphic:ImgBG];
//    backG.x = FlxG.width-backG.width-100;
//    backG.y = FlxG.height*1.25-backG.height-10;
//    backG.scrollFactor = CGPointMake(0.25, 0.25);
//	[self add:backG];
//    
//    FlxSprite * sugarbags = [FlxSprite spriteWithX:153 y:128 graphic:ImgLeftMG];
//    sugarbags.x = 0;
//    sugarbags.y = FlxG.height*1.5-sugarbags.height-20;
//    sugarbags.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sugarbags];
//    
//    FlxSprite * sugarbagsR = [FlxSprite spriteWithX:147 y:181 graphic:ImgRightMG];
//    
//    //put x and y back here
//    sugarbagsR.x = FlxG.width*1.5-sugarbagsR.width;
//    sugarbagsR.y = FlxG.height*1.5-sugarbagsR.height-20;
//    sugarbagsR.scrollFactor = CGPointMake(.5, .5);
//    
//    [self add:sugarbagsR];
//    
//    [self loadLevelBlocksFromImage];
//    
//    [self loadCharacters];
//    
//    [bottle play:@"orange"];
//    
//    [self add:playerPlatforms];
//    
//    [FlxG followWithParam1:player param2:15];
//    [FlxG followBoundsWithParam1:0 param2:0 param3:FlxG.levelWidth param4:FlxG.levelHeight+VERTICAL_OVERSHOOT_OF_LEVEL param5:YES];
//    
//}
//
////size large
////level: Green production
//
//- (void) loadLevel8
//{
//    [FlxG playMusic:MusicIceFishing];
//    static NSString * ImgBG = @"level2_BG.png";
//    static NSString * ImgLeftMG = @"level2_MG2.png";
//    static NSString * ImgRightMG = @"level2_MG1.png";
//    static NSString * ImgFMGTank = @"level2_FMG3.png";
//    static NSString * ImgChainTile = @"level2_chainTile.png";
//    
//    backG = [FlxSprite spriteWithX:480 y:320 graphic:ImgBG];
//    backG.x = 0;
//    backG.y = 0;
//    backG.scrollFactor = CGPointMake(0, 0);
//	[self add:backG];
//    
//    FlxTileblock * bgChain1 = [FlxTileblock tileblockWithX:100 y:0 width:13 height:100];  
//    [bgChain1 loadGraphic:ImgChainTile empties:0 autoTile:NO isSpeechBubble:0 isGradient:0];
//    bgChain1.scrollFactor = CGPointMake(0.25, 0.25);
//    [self add:bgChain1]; 
//    
//    FlxTileblock * bgChain2 = [FlxTileblock tileblockWithX:bgChain1.x+70 y:0 width:13 height:100];  
//    [bgChain2 loadGraphic:ImgChainTile empties:0 autoTile:NO isSpeechBubble:0 isGradient:0];
//    bgChain2.scrollFactor = CGPointMake(0.25, 0.25);
//    [self add:bgChain2];
//    
//    FlxSprite * fmgTank = [FlxSprite spriteWithX:bgChain1.x-20 y:90 graphic:ImgFMGTank];
//    fmgTank.scrollFactor = CGPointMake(0.25, 0.25);
//    [self add:fmgTank];    
//    
//    FlxSprite * tank = [FlxSprite spriteWithX:107 y:200 graphic:ImgLeftMG];
//    tank.scrollFactor = CGPointMake(0.5, 0.5);
//    tank.x = 0;
//    tank.y = 107;
//    [self add:tank];
//    
//    FlxSprite * tankR = [FlxSprite spriteWithX:180 y:440 graphic:ImgRightMG];
//    tankR.x = FlxG.width*1.5-tankR.width;
//    tankR.y = 0;
//    tankR.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:tankR];
//    
//    [self loadLevelBlocksFromImage];
//    
//    [self loadCharacters];
//    
//    [self add:playerPlatforms];
//    
//    FlxTileblock * chainTile = [FlxTileblock tileblockWithX:500 y:0 width:13 height:820];  
//    [chainTile loadGraphic:ImgChainTile empties:0 autoTile:NO isSpeechBubble:0 isGradient:0];
//    chainTile.scrollFactor = CGPointMake(1.5, 1.5);
//    [self add:chainTile]; 
//    
//    [FlxG followWithParam1:player param2:15];
//    [FlxG followBoundsWithParam1:0 param2:0 param3:FlxG.levelWidth param4:FlxG.levelHeight+VERTICAL_OVERSHOOT_OF_LEVEL param5:YES];
//    
//    [sEmit startWithParam1:NO param2:0.05 param3:0.1 ];  
//}
//
//
////level large management
//
//- (void) loadLevel9
//{
//    [FlxG playMusic:MusicPirate];
//    
//    static NSString * ImgGradient = @"level3_gradient.png";
//    static NSString * ImgMG = @"level3_MG.png";
//    static NSString * ImgMGpylon = @"level3_MG_pylon.png";
//
//    
//    FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:FlxG.height];  
//    [grad loadGraphic:ImgGradient];
//    grad.scrollFactor = CGPointMake(0, 0);
//    [self add:grad];
//    
//    FlxSprite * cloud = [Cloud cloudWithOrigin:CGPointMake(10, 10)];
//    //cloud.x = 265;
//    //cloud.y = 321;
//    //cloud.scale = CGPointMake(1, 1 );
//    cloud.scrollFactor = CGPointMake(0.5, 0.5);
//    cloud.velocity = CGPointMake(-50, 0);
//    [self add:cloud];
//    
//    FlxSprite * sprMG = [FlxSprite spriteWithX:259 y:440 graphic:ImgMG];
//    sprMG.x = FlxG.width - sprMG.width;
//    sprMG.y = FlxG.height*1.5 - sprMG.height - 20;
//    sprMG.scale = CGPointMake(1, 1 );
//    sprMG.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sprMG];
//    
//    FlxSprite * sprMGpylon = [FlxSprite spriteWithX:24 y:320 graphic:ImgMGpylon];
//    sprMGpylon.x = 150;
//    sprMGpylon.y = FlxG.height*1.5 - sprMG.height - 20;
//    sprMGpylon.scale = CGPointMake(1, 2 );
//    sprMGpylon.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sprMGpylon];    
//
//    sprMGpylon = [FlxSprite spriteWithX:24 y:320 graphic:ImgMGpylon];
//    sprMGpylon.x = 100;
//    sprMGpylon.y = FlxG.height*1.5 - sprMG.height - 20;
//    sprMGpylon.scale = CGPointMake(1, 2 );
//    sprMGpylon.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sprMGpylon]; 
//    
//    sprMGpylon = [FlxSprite spriteWithX:24 y:320 graphic:ImgMGpylon];
//    sprMGpylon.x = 50;
//    sprMGpylon.y = FlxG.height*1.5 - sprMG.height - 20;
//    sprMGpylon.scale = CGPointMake(1, 2 );
//    sprMGpylon.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sprMGpylon];  
//    
//    
//    //right side
//    sprMGpylon = [FlxSprite spriteWithX:24 y:320 graphic:ImgMGpylon];
//    sprMGpylon.x = FlxG.width + 50;
//    sprMGpylon.y = FlxG.height*1.5 - sprMG.height - 20;
//    sprMGpylon.scale = CGPointMake(1, 2 );
//    sprMGpylon.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sprMGpylon];    
//    
//    sprMGpylon = [FlxSprite spriteWithX:24 y:320 graphic:ImgMGpylon];
//    sprMGpylon.x = FlxG.width + 100;
//    sprMGpylon.y = FlxG.height*1.5 - sprMG.height - 20;
//    sprMGpylon.scale = CGPointMake(1, 2 );
//    sprMGpylon.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sprMGpylon]; 
//    
//    sprMGpylon = [FlxSprite spriteWithX:24 y:320 graphic:ImgMGpylon];
//    sprMGpylon.x = FlxG.width + 150;
//    sprMGpylon.y = FlxG.height*1.5 - sprMG.height - 20;
//    sprMGpylon.scale = CGPointMake(1, 2 );
//    sprMGpylon.scrollFactor = CGPointMake(0.5, 0.5);
//    [self add:sprMGpylon];
//    
//    
//    [self loadLevelBlocksFromImage];
//    
//    [self loadCharacters];
//    
//    [self add:playerPlatforms];
//    
//    [FlxG followWithParam1:player param2:15];
//    [FlxG followBoundsWithParam1:0 param2:0 param3:FlxG.levelWidth param4:FlxG.levelHeight+VERTICAL_OVERSHOOT_OF_LEVEL param5:YES];
//    
////    FlxSprite * bottomBlocker  = [FlxSprite spriteWithX:0 y:0 graphic:nil];
////	[bottomBlocker createGraphicWithParam1:480 param2:VERTICAL_OVERSHOOT_OF_LEVEL param3:0xffaf8f4e];
////    bottomBlocker.x = 0;
////    bottomBlocker.y = FlxG.levelHeight;
////    bottomBlocker.scrollFactor = CGPointMake(0, 1);
////	[self add:bottomBlocker];
//    
//    
//    
//}
//
//
//#pragma mark Create
//
//
//- (void) create
//{
//    [self setLevelSize];
//    
//    gunOffsetToPlayer= 16;
//    
//    //FlxG.level = 1;
//    
//    speechTexts = [[NSArray alloc] initWithObjects:
//                   [NSMutableArray arrayWithObjects:@"November 10, 1961.\nNews from military sources is that army forces have been mobilized and plan to invade the surronding city.",@" ",@" ", @"notepad", nil],
//                   [NSMutableArray arrayWithObjects:@"Every month the same old news. Since WWII ended, every month more scare tactics.\nI run a business, my interest lies with feeding my family, not war.",@"player",@"army", @"", nil],                   
//                   [NSMutableArray arrayWithObjects:@"The efforts of industry are not without casualties.\nAnd yet we work, and we work hard. Are we not entitled to that which we produce.",@"worker",@"player", @"",nil],                   
//                   [NSMutableArray arrayWithObjects:@"\nYou are paid and paid well.",@"player",@"worker", @"",nil], 
//                   [NSMutableArray arrayWithObjects:@"Liselot, my sweet emerald.\nI give you  my heart, my word and my life.\nI will work for our family so that they can have a good life.",@"player",@"liselot", @"0",nil], 
//                   [NSMutableArray arrayWithObjects:@"\nFamily is all.",@"player",@"liselot", @"",nil],                   
//                   [NSMutableArray arrayWithObjects:@"The government is blaming the Super Lemonade Factory for all the broken glass on the road.\nCan't anyone take some responsibility for themselves.",@"player",@"army", @"",nil],                   
//                   [NSMutableArray arrayWithObjects:@"We run a tight ship. I learned that from my time in the Customs Office.\nWithout solid rules, everything runs foul.\nMy workers repsect this. They follow my rules.",@"player",@"worker", @"0",nil],                   
//                   [NSMutableArray arrayWithObjects:@"We keep it clean here. That food inspector is such a idiot!\n\nWe keep it clean, he should leave us alone.",@"player",@"inspector", @"0",nil],                   
//                   [NSMutableArray arrayWithObjects:@"The same people that create the street signs are the ones destroying and stealing them.\nCorruption is rife here!",@"player",@"army", @"0",nil],                   
//                   [NSMutableArray arrayWithObjects:@"Utilitarianism promises the greatest \"good\" for the greatest number...\nIf someone else falls between the cracks, it’s not your problem.",@"inspector",@"chef", @"0",nil],                   
//                   [NSMutableArray arrayWithObjects:@"If I am using my wealth to exceed\ngreater odds for my family’s happiness, I don’t see that\nas any more amoral as buying insurance.",@"player",@"0", @"0",nil],                   
//                   [NSMutableArray arrayWithObjects:@"I trust that people are beings with good intentions,\nbut you can’t expect to harvest a crop in a sewer.",@"player",@"0", @"0",nil],                   
//                   [NSMutableArray arrayWithObjects:@"The tragedy is not in the recognition of your fate,\nbut the weight that rests on your shoulders when no one is there to help you.",@"player",@"0", @"0",nil],                   
//                   [NSMutableArray arrayWithObjects:@"Trust, faith and common good.\nAll of them are masks painted to hide corruption.",@"player",@"0", @"0",nil],                   
//                   [NSMutableArray arrayWithObjects:@"\nTalk is cheap.",@"chef",@"0", @"0",nil],                                     
//                   [NSMutableArray arrayWithObjects:@"\nI just heard Don't Fence Me In on the wireless. Fantastic song!",@"player",@"0", @"0",nil],                   
//                   [NSMutableArray arrayWithObjects:@"Our sons will run this factory one day.\nAnd their sons.\nAnd their son's sons.",@"player",@"liselot", @"0",nil],                                  
//                   [NSMutableArray arrayWithObjects:@"During the war (World War II, 1942-1945), I tried to explain to my younger sisters what chocolate is. Can you imagine, trying to describe it.",@"liselot",@"player", @"0",nil],                                  
//                   [NSMutableArray arrayWithObjects:@"I will turn over every corner of this so called Super Lemonade Factory until I find some dirt.",@"inspector",@"player", @"0",nil],
//                   [NSMutableArray arrayWithObjects:@"A military contract to supply soda to the military landed on my desk today. Choosing sides in the turbulent time is risky, but the rewards are great.",@"player",@"army", @"0",nil],                   
//                   [NSMutableArray arrayWithObjects:@"And so he had no sleep that night. The army was not strong arming him, they couldn't care. If he said no, they'd take their business elsewhere. Their big, lucrative business.",@"",@"", @"notepad",nil],
//                   [NSMutableArray arrayWithObjects:@"For my family, I signed the papers.",@"player",@"army", @"",nil],
//                   [NSMutableArray arrayWithObjects:@"Although now guaranteed a steady cash flow, still he did not sleep well. He was now a military contractor, and agreed to accept all that it entails.",@"",@"", @"notepad",nil],
//                   [NSMutableArray arrayWithObjects:@"No need for an inspection today. You're with us now.",@"inspector",@"player", @"",nil],                  
//                   [NSMutableArray arrayWithObjects:@"With the contracts in place my job is done. You'd imagine that I'd be content with my achievements. But I am a man apart. Society does not approve of men of my persuasion.",@"army",@"", @"",nil],                   
//                   [NSMutableArray arrayWithObjects:@"\nI am off to my meeting with the Govenor General.",@"player",@"", @"",nil],                    
//                   [NSMutableArray arrayWithObjects:@"Sometimes I feel the information I hand over to the army is more valuable than they give credit for. I am responsible for airing the community's thoughts and grievences. Do they care?",@"player",@"", @"",nil],                    
//                   [NSMutableArray arrayWithObjects:@"We care.\nTrust us.\nWe are in total control.",@"army",@"player", @"",nil],                    
//                   [NSMutableArray arrayWithObjects:@"\nThe End.",@"player",@"", @"",nil],                    
//                   
//                                    nil];
//    
//    
//    hasCheckedGameOverScreen=NO;
//    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    if (FlxG.level == 1) {
//        curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL1"];
//    } else if (FlxG.level == 2) {
//        curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL2"];
//    } else if (FlxG.level == 3) {
//        curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL3"];
//    } else if (FlxG.level == 4) {
//        curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL4"];
//    } else if (FlxG.level == 5) {
//        curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL5"];
//    } else if (FlxG.level == 6) {
//        curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL6"];
//    } else if (FlxG.level == 7) {
//        curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL7"];
//    } else if (FlxG.level == 8) {
//        curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL8"];
//    } else if (FlxG.level == 9) {
//        curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL9"];
//    }
//    
//    killedArmy = 0;
//    killedChef = 0;
//    killedInspector = 0;
//    killedWorker = 0;
//    collectedBottles = 0;
//    
//    FlxG.score = 0;
//    bulletIndex = 0;
//    discIndex = 0;
//    grenadeIndex = 0;
//    bulletDamage = 1.0;
//    
//    switch (FlxG.level) {
//        case 1:
//            [self loadLevel1];
//            break;
//        case 2:
//            [self loadLevel2];
//            break;
//        case 3:
//            [self loadLevel3];
//            break;
//        case 4:
//            [self loadLevel4];
//            break;
//        case 5:
//            [self loadLevel5];
//            break;
//        case 6:
//            [self loadLevel6];
//            break;
//        case 7:
//            [self loadLevel7];
//            break;
//        case 8:
//            [self loadLevel8];
//            break;            
//        case 9:
//            [self loadLevel9];
//            break;              
//        default:
//            break;
//    }
//    
//    weaponText = [FlxText textWithWidth:200
//                                   text:@""
//                                   font:@"SmallPixel"
//                                   size:16.0];
//	weaponText.color = 0xffffffff;
//	weaponText.alignment = @"left";
//	weaponText.x = 1000;
//	weaponText.y = 1000;
//    weaponText.acceleration = CGPointMake(0, -100);
//    weaponText.shadow = 0x00000000;
//	[self add:weaponText];
//    
//    buttonLeft  = [FlxSprite spriteWithX:80 y:80 graphic:@"buttonArrow.png"];
//    buttonLeft.x = 0;
//    buttonLeft.y = FlxG.height-80;
//    buttonLeft.alpha=BUTTON_START_ALPHA;
//    buttonLeft.scrollFactor = CGPointMake(0, 0);
//	[self add:buttonLeft];
//    
//    buttonRight  = [FlxSprite spriteWithX:80 y:80 graphic:@"buttonArrow.png"];
//    buttonRight.x = 80;
//    buttonRight.y = FlxG.height-80;
//    buttonRight.angle = 180;
//    buttonRight.alpha=BUTTON_START_ALPHA;
//    buttonRight.scrollFactor = CGPointMake(0, 0);
//
//	[self add:buttonRight];  
//    
//    buttonA  = [FlxSprite spriteWithX:80 y:80 graphic:@"buttonButton.png"];
//    buttonA.x = 320;
//    buttonA.y = FlxG.height-60;
//    buttonA.alpha=BUTTON_START_ALPHA;
//    buttonA.scrollFactor = CGPointMake(0, 0);
//
//	[self add:buttonA];
//    buttonB  = [FlxSprite spriteWithX:80 y:80 graphic:@"buttonButton.png"];
//    buttonB.x = 400;
//    buttonB.y = FlxG.height-60;
//    buttonB.alpha=BUTTON_START_ALPHA;
//    buttonB.scrollFactor = CGPointMake(0, 0);
//
//	[self add:buttonB]; 
//    
//    gameOverScreenDarken  = [FlxSprite spriteWithX:0 y:0 graphic:nil];
//	[gameOverScreenDarken createGraphicWithParam1:480 param2:320 param3:0xff000000];
//	gameOverScreenDarken.visible = FALSE;
//    gameOverScreenDarken.alpha = 0.6;
//    gameOverScreenDarken.x = 0;
//    gameOverScreenDarken.y = 0;
//    gameOverScreenDarken.scrollFactor = CGPointMake(0, 0);
//	[self add:gameOverScreenDarken];
//    
//    //sugar high rainbow graphic
//    sh = [SugarHigh sugarHighWithOrigin:CGPointMake(FlxG.width/2-24, FlxG.height/2-16)];
//    sh.alpha = 0.45;
//    sh.visible = NO;
//    sh.scrollFactor = CGPointMake(0, 0);
//    [self add:sh];
//    
//    
//    scoreText = [FlxText textWithWidth:FlxG.width
//								  text:@"0"
//								  font:@"SmallPixel"
//								  size:24.0];
//	scoreText.color = 0xffffffff;
//	scoreText.alignment = @"left";
//	scoreText.x = 2;
//	scoreText.y = 6;
//    scoreText.shadow = 0x00000000;
//    scoreText.scrollFactor = CGPointMake(0, 0);
//	[self add:scoreText];
//    
//    gameOverText = [FlxText textWithWidth:FlxG.width
//								  text:@" "
//								  font:@"SmallPixel"
//								  size:16.0];
//    gameOverText.color = 0xffffffff;
//	gameOverText.alignment = @"center";
//	gameOverText.x = 0;
//	gameOverText.y = FlxG.height*0.23;
//    gameOverText.shadow = 0x00000000;
//    gameOverText.visible = NO;
//    gameOverText.scrollFactor = CGPointMake(0, 0);
//	[self add:gameOverText];
//    
//    buttonPlay  = [FlxSprite spriteWithX:FlxG.width/5 y:20 graphic:@"play.png"];
//    //buttonPlay.width*=2; 
//    buttonPlay.alpha=1;
//    buttonPlay.visible = NO;
//    buttonPlay.scale = CGPointMake(2, 2);
//    buttonPlay.scrollFactor = CGPointMake(0, 0);
//	[self add:buttonPlay]; 
//    
//    buttonMenu  = [FlxSprite spriteWithX:FlxG.width/5 + FlxG.width/2 y:20 graphic:@"menu.png"];
//    //buttonMenu.width*=2;
//    buttonMenu.alpha=1;
//    buttonMenu.visible = NO;
//    buttonMenu.scale = CGPointMake(2, 2);
//    buttonMenu.scrollFactor = CGPointMake(0, 0);
//
//	[self add:buttonMenu];  
//    
//
//    
//    speechBubble = [FlxTileblock tileblockWithX:40 y:180 width:FlxG.width-80 height:50];  
//    [speechBubble loadGraphic:@"speechBubbleTiles.png" empties:0 autoTile:NO isSpeechBubble:4];
//    speechBubble.visible=NO;
//    speechBubble.scrollFactor  = CGPointMake(0, 0);
//    [self add:speechBubble];
//    
//    notepad = [FlxTileblock tileblockWithX:40 y:180 width:FlxG.width-80 height:50];  
//    [notepad loadGraphic:@"notepadTiles.png" empties:0 autoTile:YES isSpeechBubble:0];
//    notepad.visible=NO;
//    notepad.scrollFactor  = CGPointMake(0, 0);
//    [self add:notepad];    
//    
//    
//    speechBubbleText = [FlxText textWithWidth:FlxG.width-80
//                                     text:@" "
//                                     font:@"Flixel"
//                                     size:8.0];
//    speechBubbleText.color = 0x00000000;
//	speechBubbleText.alignment = @"center";
//	speechBubbleText.x = speechBubble.x;
//	speechBubbleText.y = speechBubble.y;
//    speechBubbleText.shadow = 0x00000000;
//    speechBubbleText.visible = NO;
//    speechBubbleText.scrollFactor = CGPointMake(0, 0);
//	[self add:speechBubbleText];
//    
//    enemyGeneric = [EnemyGeneric enemyGenericWithOrigin:CGPointMake(1000,1000) index:0  ];
//    enemyGeneric.dead = NO;
//    enemyGeneric.visible = NO;
//    enemyGeneric.scrollFactor = CGPointMake(0, 0);
//    [self add:enemyGeneric];
//    
//    enemyListener = [EnemyGeneric enemyGenericWithOrigin:CGPointMake(1000,1000) index:0  ];
//    enemyListener.scale = CGPointMake(-1,1);
//    enemyListener.dead = NO;
//    enemyListener.visible = NO;
//    enemyListener.scrollFactor = CGPointMake(0, 0);
//    [self add:enemyListener];
//    
//    speechBubbleTextHelp = [FlxText textWithWidth:FlxG.width
//                                         text:@"<< Swipe to cycle >>"
//                                         font:@"SmallPixel"
//                                         size:8.0];
//    speechBubbleTextHelp.color = 0xffffffff;
//	speechBubbleTextHelp.alignment = @"center";
//	speechBubbleTextHelp.x = 0;
//	speechBubbleTextHelp.y = speechBubble.y+60;
//    speechBubbleTextHelp.shadow = 0x00000000;
//    speechBubbleTextHelp.visible = NO;
//    speechBubbleTextHelp.scrollFactor = CGPointMake(0, 0);
//	[self add:speechBubbleTextHelp];
//    
//    sugarHighIndicator = [FlxSprite spriteWithX:0 y:1 graphic:nil];
//    [sugarHighIndicator createGraphicWithParam1:60 param2:8 param3:0xff83cf6a];
//    sugarHighIndicator.x = FlxG.width/2-34;
//    sugarHighIndicator.y = FlxG.height-17;    
//    sugarHighIndicator.scrollFactor = CGPointMake(0, 0);
//    sugarHighIndicator.scale = CGPointMake(0, 1);
//    //sugarHighIndicator.offset = CGPointMake(0, -30);
//    sugarHighIndicator.origin = CGPointMake(0, 60);
//    [self add:sugarHighIndicator];
//    
//    FlxSprite * sugarHighHUD = [FlxSprite spriteWithX:0 y:1 graphic:@"sugarHighHUD.png"];
//    sugarHighHUD.x = FlxG.width/2-sugarHighHUD.width/2;
//    sugarHighHUD.y = FlxG.height-sugarHighHUD.height - 5;
//    sugarHighHUD.scrollFactor = CGPointMake(0, 0);
//    [self add:sugarHighHUD];
//    
//
//    
//   
//}
//
//#pragma mark Dealloc
//
//
//- (void) dealloc
//{
//	[[NSNotificationCenter defaultCenter] removeObserver:self];
//    
//    [playerPlatforms.members removeAllObjects];
//    [enemyPlatforms.members removeAllObjects];
//    [characters.members removeAllObjects];
//    [allBullets.members removeAllObjects];
//    [bullets.members removeAllObjects];
//    [discs.members removeAllObjects];
//    [grenades.members removeAllObjects];
//    [charactersArmy.members removeAllObjects];
//    [charactersChef.members removeAllObjects];
//    [charactersInspector.members removeAllObjects];
//    [charactersWorker.members removeAllObjects];
//    
//	[speechTexts release];
//    [playerPlatforms release];
//    [enemyPlatforms release];
//    [characters release];
//    [allBullets release];
//    [bullets release];
//    [discs release];
//    [grenades release];
//    [charactersArmy release];
//    [charactersChef release];
//    [charactersInspector release];
//    [charactersWorker release];
//    
//    [Bullet release];
//    
//	[super dealloc];
//}
//
//#pragma mark Game Logic
//
//- (void) fireWeapon
//{
//    [FlxG play:SndShoot01];
//    
//    if ([player.gunType isEqual:@"pistol"] ) {
//        Bullet * b = [bullets.members objectAtIndex:bulletIndex];
//        b.x = player.x+b.width;
//        b.y = player.y-5;
//        b.visible=YES;
//        b.dead = NO;
//        b.drag = CGPointMake(0, 0);
//        b.scale = CGPointMake(1,1);
//        if (player.scale.x < 0) {
//            b.velocity = CGPointMake(-300, 0);
//            b.x = player.x-b.width-4;
//
//        }
//        else {
//            b.velocity = CGPointMake(300, 0);
//            b.x = player.x+b.width+4;
//
//        }
//        bulletIndex++;
//        if (bulletIndex>=bullets.members.length) {
//            bulletIndex = 0;	
//        }
//    } if ([player.gunType isEqual:@"revolver"]) {
//        Bullet * b = [bullets.members objectAtIndex:bulletIndex];
//        b.y = player.y-5;
//        b.visible=YES;
//        b.dead = NO;
//        b.drag = CGPointMake(0, 0);
//        b.scale = CGPointMake(1.5, 1.5);
//        if (player.scale.x < 0) {
//            b.velocity = CGPointMake(-500, 0);
//            b.x = player.x-b.width-4;
//
//        }
//        else {
//            b.velocity = CGPointMake(500, 0);
//            b.x = player.x+b.width+4;
//
//        }
//        bulletIndex++;
//        if (bulletIndex>=bullets.members.length) {
//            bulletIndex = 0;	
//        }
//    } 
//    
//    
//    else if ([player.gunType isEqual:@"dualpistol"]) {
//        Bullet * b = [bullets.members objectAtIndex:bulletIndex];
//        b.x = player.x+b.width;
//        b.y = player.y;
//        b.visible=YES;
//        b.dead = NO;
//        b.velocity = CGPointMake(-300, 0);
//        b.drag = CGPointMake(0, 0);
//        b.scale = CGPointMake(1,1);
//
//        bulletIndex++;
//        if (bulletIndex>=bullets.members.length) {
//            bulletIndex = 0;	
//        }
//        Bullet * v = [bullets.members objectAtIndex:bulletIndex];
//        v.x = player.x+v.width;
//        v.y = player.y;
//        v.visible=YES;
//        v.dead = NO;
//        v.velocity = CGPointMake(300, 0);
//        v.drag = CGPointMake(0, 0);
//        v.scale = CGPointMake(1,1);
//
//        bulletIndex++;
//        if (bulletIndex>=bullets.members.length) {
//            bulletIndex = 0;	
//        }                    
//    } else if ([player.gunType isEqual:@"machinegun"]) {
//        Bullet * b = [bullets.members objectAtIndex:bulletIndex];
//        b.y = player.y-5;
//        b.visible=YES;
//        b.dead = NO;
//        b.drag = CGPointMake(0, 0);
//        b.scale = CGPointMake(1,1);
//
//        if (player.scale.x < 0) {
//            b.velocity = CGPointMake(-300, -20 + [FlxU random] * 40);
//            CGFloat nv = player.velocity.x + 50;
//            player.velocity = CGPointMake(nv, player.velocity.y);
//            b.x = player.x-b.width-4;
//
//        }
//        else {
//            b.velocity = CGPointMake(300, -20 + [FlxU random] * 40);
//            CGFloat nv = player.velocity.x - 50;
//            player.velocity = CGPointMake(nv, player.velocity.y);
//            b.x = player.x+b.width+4;
//
//        }
//        bulletIndex++;
//        if (bulletIndex>=bullets.members.length) {
//            bulletIndex = 0;	
//        }
//    }else if ([player.gunType isEqual:@"minigun"]) {
//        
//        [[FlxG quake] startWithIntensity:0.02 duration:0.1];
//        Bullet * b = [bullets.members objectAtIndex:bulletIndex];
//        b.x = player.x+b.width;
//        b.y = player.y;
//        b.visible=YES;
//        b.dead = NO;
//        b.drag = CGPointMake(0, 0);
//        b.scale = CGPointMake(1,1);
//
//        if (player.scale.x < 0) {
//            b.velocity = CGPointMake(-300, -40 + [FlxU random] * 80);
//            //kick back
//            CGFloat nv = player.velocity.x + 150;
//            player.velocity = CGPointMake(nv, player.velocity.y/5);
//        }
//        else {
//            b.velocity = CGPointMake(300, -40 + [FlxU random] * 80);
//            CGFloat nv = player.velocity.x - 150;
//            player.velocity = CGPointMake(nv, player.velocity.y/5);
//            
//        }
//
//        bulletIndex++;
//        if (bulletIndex>=bullets.members.length) {
//            bulletIndex = 0;	
//        }        
//        
//        Bullet * bb = [bullets.members objectAtIndex:bulletIndex];
//        bb.x = player.x+b.width;
//        bb.y = player.y;
//        bb.visible=YES;
//        bb.dead = NO;
//        bb.drag = CGPointMake(0, 0);
//        bb.scale = CGPointMake(1,1);
//        
//        if (player.scale.x < 0) {
//            bb.velocity = CGPointMake(-300, -40 + [FlxU random] * 80);
//        }
//        else {
//            bb.velocity = CGPointMake(300, -40 + [FlxU random] * 80);
//        }
//        bulletIndex++;
//        if (bulletIndex>=bullets.members.length) {
//            bulletIndex = 0;	
//        }
//        
//        
//    } else if ([player.gunType isEqual:@"discgun"]) {
//        Disc * d = [discs.members objectAtIndex:discIndex];
//        
//        d.y = player.y;
//        d.visible=YES;
//        d.dead = NO;
//        d.numberOfBounces = 0;
//        if (player.scale.x < 0) {
//            d.x = player.x-d.width-8;
//            d.velocity = CGPointMake(-250, -30); //400
//        }
//        else {
//            d.x = player.x+d.width+8;
//
//            d.velocity = CGPointMake(250, -30);
//            
//        }
//        discIndex++;
//        if (discIndex>=discs.members.length) {
//            discIndex = 0;	
//        }
//    }else if ([player.gunType isEqual:@"shotgun"]) {
//        
//        for (int j=0;j<BULLETSINSHOTGUNBLAST;j++) {
//            Bullet * b = [bullets.members objectAtIndex:bulletIndex];
//            b.x = player.x+b.width;
//            b.y = player.y;
//            b.visible=YES;
//            b.dead = NO;
//            b.drag = CGPointMake(800, 100);
//            b.scale = CGPointMake(1,1);
//
//            if (player.scale.x < 0) {
//                b.velocity = CGPointMake(-400 - [FlxU random] * 100, -60 + [FlxU random] * 120);
//                CGFloat nv = player.velocity.x + 50;
//                player.velocity = CGPointMake(nv, player.velocity.y);
//            }
//            else {
//                b.velocity = CGPointMake(300 + [FlxU random] * 100, -60 + [FlxU random] * 120);
//                CGFloat nv = player.velocity.x - 50;
//                player.velocity = CGPointMake(nv, player.velocity.y);
//                
//            }
//            bulletIndex++;
//            if (bulletIndex>=bullets.members.length) {
//                bulletIndex = 0;	
//            }
//        } 
//    } else if ([player.gunType isEqual:@"grenadelauncher"]) {
//        Grenade * g = [grenades.members objectAtIndex:grenadeIndex];
//        if (!g.dead) { return; } ;
//        g.x = player.x+g.width;
//        g.y = player.y;
//        g.visible=YES;
//        g.dead = NO;
//        if (player.scale.x < 0) {
//            g.velocity = CGPointMake(-300, -250);
//        }
//        else {
//            g.velocity = CGPointMake(300, -250);
//            
//        }
//        grenadeIndex++;
//        if (grenadeIndex>=grenades.members.length) {
//            grenadeIndex = 0;	
//        }
//        
//    }
//    
//}
//
//- (void) virtualControlPad 
//{
//    BOOL newTouch = FlxG.touches.newTouch;
//    
//    buttonRight.alpha = BUTTON_START_ALPHA;
//    buttonLeft.alpha = BUTTON_START_ALPHA;
//    buttonA.alpha = BUTTON_START_ALPHA;
//    buttonB.alpha = BUTTON_START_ALPHA;
//
//    if (FlxG.touches.vcpLeftArrow) {
//        buttonLeft.alpha = BUTTON_PRESSED_ALPHA;
//                
//    } 
//    if (FlxG.touches.vcpRightArrow) {
//        //player.velocity = CGPointMake(200, player.velocity.y);
//        //player.scale = CGPointMake(1, 1);
//        buttonRight.alpha = BUTTON_PRESSED_ALPHA;
//
//    } 
//    if (FlxG.touches.vcpButton2  ) { //&& player.onFloor
//        //working!!!!
//        //if (player.onFloor) player.velocity = CGPointMake(player.velocity.x, -360);
//        //mario style:
//        //[player doJump];
//        //pressedJump = YES;
//        buttonB.alpha = BUTTON_PRESSED_ALPHA;      
//    } 
//    if (FlxG.touches.vcpButton1 && (newTouch || player.rapidFire) ) {
//        buttonA.alpha = BUTTON_PRESSED_ALPHA;
//        [self fireWeapon];
//        
//    }
//        
////            if (p.y > 81 && p.y < 160 && (newTouch || player.rapidFire) ) { 
////                [self fireWeapon];
////                buttonA.alpha = BUTTON_PRESSED_ALPHA;
////
////            }
//        
//    
//}
//
//- (void) playerDies {
//    player.dead = YES;
//    player.velocity = CGPointMake(player.velocity.x, -250);
//    player.gunType = @"pistol";
//    player.rapidFire = NO;
//    bulletDamage = 1;
//    player.isOnSugarHigh = NO;
//    
//
//    
//}
//
//- (void) setNewWeapon:(int)newWeapon
//{
//    
//    int ch=newWeapon;
//    if (ch==-1) {
//        ch = 1 + ([FlxU random] * 5);
//        if (ch==previousWeapon) {
//            ch = ch + 1;
//        }
//    }
//    
//    //uncomment for same gun all the time.
//    //ch =4 ;
//
//    switch (ch) {
//        case 0:
//            player.gunType = @"pistol";
//            player.rapidFire = NO;
//            weaponText.text = @"tapioca pearls";
//            bulletDamage = 1;
//            break;
//        case -1:
//            player.gunType = @"dualpistol";
//            player.rapidFire = NO;
//            weaponText.text = @"dual pistol";
//            bulletDamage = 1;
//
//            break;
//        case 1:
//            player.gunType = @"machinegun";
//            player.rapidFire = YES;
//            weaponText.text = @"rapid fire pearls";
//            bulletDamage = 1;
//            break;
//        case -2:
//            player.gunType = @"minigun";
//            player.rapidFire = YES;
//            weaponText.text = @"extreme pearls";
//            bulletDamage = 2;
//
//            break;  
//        case 2:
//            player.gunType = @"discgun";
//            player.rapidFire = NO; //change to NO
//            weaponText.text = @"bottle caps";
//            bulletDamage = 5;
//
//            break; 
//        case 3:
//            player.gunType = @"revolver";
//            player.rapidFire = NO;
//            weaponText.text = @"mega pearls";
//            bulletDamage = 5;
//
//            
//            break; 
//        case 4:
//            player.gunType = @"shotgun";
//            player.rapidFire = NO;
//            weaponText.text = @"pearl spray";
//            bulletDamage = 2;
//            
//            
//            break;  
//        case 5:
//            player.gunType = @"grenadelauncher";
//            player.rapidFire = NO;
//            weaponText.text = @"soda bulbs";
//            bulletDamage = 1;
//            
//            
//            break;
//            
//        default:
//            player.gunType = @"pistol";
//            player.rapidFire = YES;
//            weaponText.text = @"rapid fire";
//            bulletDamage = 1;
//            break;
//
//            
//            break;
//    }
//
//
//    [gun play:player.gunType];
//    
//    previousWeapon = ch;
//}
//
//#pragma mark Update
//
//- (void) rearrangePlatforms {
//    
//
//    
//    if (FlxG.level==1) {
//        FlxTileblock * mover = [playerPlatforms getRandom];
//        //NSLog(@"%d", mover.index);
//        
////        if (mover.arbitraryID !=0) {
////            mover.moving = YES;
////            mover.moveStart = CGPointMake(mover.x-100, mover.y);
////            mover.moveEnd = CGPointMake(mover.x, mover.y);
////            mover.velocity = CGPointMake(70,0);
////            mover.oscillate = YES;
////        }
//        
//        
//        
////        if (mover.arbitraryID !=0) {
////            int multipler = 1;
////            //mover.drag = CGPointMake(5000,5000);
////            if ([FlxU random] <= 0.5 ) {
////                multipler = -1;
////            }
////            
////            mover.velocity = CGPointMake(mover.arbitraryID*100*multipler, 0 );
////            
////            
////        } 
//        
//        
//        
//        
////        if (mover.index == 1 || mover.index == 5 || mover.index == 9) {
////            mover.moving = YES;
////            mover.moveStart = CGPointMake(mover.x, mover.y);
////            mover.moveEnd = CGPointMake(mover.x+120, mover.y);
////            mover.velocity = CGPointMake(50,0);
////            mover.oscillate = YES;
////            
////            
////        }
//        
//        
//        if (mover.index == 2 && !mover.moving) {
//            mover.moving = YES;
//            mover.moveStart = CGPointMake(mover.x, mover.y);
//            mover.moveEnd = CGPointMake(mover.x, mover.y+120);
//            mover.velocity = CGPointMake(0,50);
//            mover.oscillate = YES;
//            
//            
//        }
//        
//        else if (mover.index == 10 && !mover.moving) {
//            mover.moving = YES;
//            mover.moveStart = CGPointMake(mover.x-100, mover.y);
//            mover.moveEnd = CGPointMake(mover.x+100, mover.y);
//            mover.velocity = CGPointMake(50,0);
//            mover.oscillate = YES;
//            
//            
//        }
//    }
//    
//    if (FlxG.level==9) {
//        //FlxTileblock * mover = [playerPlatforms getRandom];
//        for (FlxTileblock * mover in playerPlatforms.members ) {
//            if ([mover isKindOfClass:[ FlxTileblock class]]) {
//                //NSLog(@" arbID %d", mover.arbitraryID);
//                if (mover.arbitraryID>=100) {
//                    
//                    NSString *intString = [NSString stringWithFormat:@"%d", mover.arbitraryID];
//                    
//                    NSLog(@" sideways = %c, upways = %c ... %@", [intString characterAtIndex:1],  [intString characterAtIndex:2], intString);
//                    
//                    int xMov = [intString characterAtIndex:1];
//                    int yMov = [intString characterAtIndex:2];
//
//
//                    
//                    mover.moving = YES;
//                    mover.moveStart = CGPointMake(mover.x-(xMov*10), mover.y-(yMov*10) );
//                    mover.moveEnd = CGPointMake(mover.x, mover.y);
//                    mover.velocity = CGPointMake(0,50);
//                    mover.oscillate = YES;
//                    
//                    
//                }
//            }
//        }
//        
//    
//    }
//    
//    
//    
//    
//    
//    
//}
//
//- (void) onStoryBack {
//    currentSpeechText--;
//    [self showSpeechBubbleWithSound:YES];
//
//
//}
//
//- (void) onStoryForward {
//    
//    currentSpeechText++;
//    [self showSpeechBubbleWithSound:YES];
//
//
//
//}
//
//- (void) showSpeechBubbleWithSound:(BOOL)playSound {
//    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    int totalBottles = [prefs integerForKey:@"COLLECTED_BOTTLES"];
//    
//    //for random speech bubble
//    //int selectedSpeechText = [FlxU random]*[speechTexts length];
//    
//    int maximumSpeechBubble = totalBottles/DIVISOR_FOR_STORY_UNLOCK;
//    int nextStoryUnlock = totalBottles % DIVISOR_FOR_STORY_UNLOCK;
//
//    int selectedSpeechText = currentSpeechText;
//    
//    NSLog(@" total bottles %d, maximum speech bubble %d, next story unlock??? %d , bottles til unlock %d overall length %d, current speech text %d, selected speech %d", totalBottles, maximumSpeechBubble, nextStoryUnlock, DIVISOR_FOR_STORY_UNLOCK-nextStoryUnlock, [speechTexts length], currentSpeechText, selectedSpeechText);
//    
//    BOOL isAtEndOfGame=NO;
//    if (maximumSpeechBubble>=[speechTexts length]) {
//        maximumSpeechBubble=[speechTexts length]-1;
//        isAtEndOfGame=YES;
//    }
//    
//    if (selectedSpeechText > maximumSpeechBubble) {
//        selectedSpeechText = maximumSpeechBubble;
//        //currentSpeechText = selectedSpeechText;
//        currentSpeechText=0;
//        selectedSpeechText=0;
//        [FlxG play:SndError];
//
//    } else if (selectedSpeechText < 0) {
//        selectedSpeechText = maximumSpeechBubble;
//        currentSpeechText = maximumSpeechBubble;
//
//        [FlxG play:SndError];
//
//    } else {
//        if (playSound) [FlxG play:@"whoosh.caf"];
//    }
////    
////    intString = [NSString stringWithFormat:@"<< Swipe to cycle >>\nCurrently viewing %d of %d available.\nCollect %d more bottles to unlock more of the story", nextStoryUnlock];
////    information.text = (@"%@", intString);
//    
////    if (selectedSpeechText >= [speechTexts length]) {
////        selectedSpeechText=[speechTexts length];
////    }
//    
//    
//    if (!isAtEndOfGame) {
//        speechBubbleTextHelp.text = [[NSString stringWithFormat:@"<< Swipe to cycle >>\nCurrently viewing %d of %d available. \n Collect %d bottles to unlock more of the story.\n ", selectedSpeechText+1, maximumSpeechBubble+1, DIVISOR_FOR_STORY_UNLOCK-nextStoryUnlock ] retain];
//    } else {
//        speechBubbleTextHelp.text = [[NSString stringWithFormat:@"<< Swipe to cycle >>\nCurrently viewing %d of %d available. \n Story completely unlocked.\n ", selectedSpeechText+1, maximumSpeechBubble+1 ] retain];
//        
//    }
//    
//
//
//    
//    speechBubbleText.text = [[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:0];
//    
//    enemyGeneric.visible = YES;
//    enemyGeneric.x = speechBubble.x+20;
//    enemyGeneric.y = speechBubble.y + enemyGeneric.height + speechBubble.height;
//    
//    enemyListener.visible = YES;
//    enemyListener.x = speechBubble.x+320;
//    enemyListener.y = speechBubble.y + enemyListener.height + speechBubble.height;
//    
//    //play correct animations for end screen characters
//    if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:1]isEqual:@"player"]) {
//        [enemyGeneric play:@"playerTalk"];
//    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:1]isEqual:@"liselot"]) {
//        [enemyGeneric play:@"liselotTalk"];
//    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:1]isEqual:@"army"]) {
//        [enemyGeneric play:@"armyTalk"];
//    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:1]isEqual:@"inspector"]) {
//        [enemyGeneric play:@"inspectorTalk"];
//    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:1]isEqual:@"chef"]) {
//        [enemyGeneric play:@"chefTalk"];
//    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:1]isEqual:@"worker"]) {
//        [enemyGeneric play:@"workerTalk"];
//    } else {
//        enemyGeneric.visible = NO;
//    }
//    
//    //listening character
//    if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:2]isEqual:@"player"]) {
//        [enemyListener play:@"playerListen"];
//    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:2]isEqual:@"liselot"]) {
//        [enemyListener play:@"liselotListen"];
//    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:2]isEqual:@"army"]) {
//        [enemyListener play:@"armyListen"];
//    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:2]isEqual:@"inspector"]) {
//        [enemyListener play:@"inspectorListen"];
//    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:2]isEqual:@"chef"]) {
//        [enemyListener play:@"chefListen"];
//    } else if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:2]isEqual:@"worker"]) {
//        [enemyListener play:@"workerListen"];
//    }             
//    else {
//        enemyListener.visible = NO;
//    }
//    
//    if ([[[speechTexts objectAtIndex:selectedSpeechText] objectAtIndex:3]isEqual:@"notepad"]) {
//        notepad.visible = YES;
//        speechBubble.visible = NO;
//
//    }
//    else {
//        speechBubble.visible = YES;
//        notepad.visible = NO;
//    }
//}
//
//- (void) upgradeWeapon
//{
//    if ([player.gunType isEqual:@"pistol"]) {
//        [self setNewWeapon:1];
//        //player.gunType=@"machinegun";
//    }
//    else if ([player.gunType isEqual:@"shotgun"]) {
//        [self setNewWeapon:-2];
//        //player.gunType=@"minigun";
//        //player.rapidFire=YES;
//    }
//    else if ([player.gunType isEqual:@"machinegun"]) {
//        [self setNewWeapon:-2];
//        //player.gunType=@"minigun";
//    }
//    else if ([player.gunType isEqual:@"revolver"]) {
//        player.rapidFire=YES;
//        
//    } 
//    else if ([player.gunType isEqual:@"discgun"]) {
//        player.rapidFire=YES;
//    }
//}
//
//
//
//- (void) checkForSugarHigh
//{
//    //start sugar high
//    if (sugarHighIndicator.scale.x >= 1) {
//        [FlxG playWithParam1:SndSugarHighStart param2:0.1];
//        player.isOnSugarHigh = YES;
//        sugarHighIndicator.scale = CGPointMake(1, 1);
//        
//        //sugarHighIndicator.color = 0xffff0000;
//        
//        [self upgradeWeapon];
//        
//    }
//
//    //sugar high rainbow overlay.
//    if (player.isOnSugarHigh) {
//        sh.visible = YES;
//        CGFloat beep = sugarHighIndicator.scale.x - SPEED_FOR_SUGAR_HIGH_REDUCTION;
//        sugarHighIndicator.scale = CGPointMake(beep, 1);
//        
//        //sound management. Come back to this.
////        CGFloat mod = fmod(beep, 0.05);
////        NSLog(@"beep = %f modulo %f", beep, mod);
////        //sound management
////        
////        if (mod==0.0 ) {
////            [FlxG play:SndSugarHighWarning];
////            NSLog(@"just got one = %f", beep);
////        }
//        
//    }
//    else {
//        sh.visible = NO;
//    }
//    
//    //Sugar high is over
//    
//    if (sugarHighIndicator.scale.x <= 0) {
//        sugarHighIndicator.scale = CGPointMake(0, 1);
//        player.isOnSugarHigh = NO;
//        //sugarHighIndicator.color = 0xff00ff00;
//
//    }
//    
//    
//    
//}
//
//- (void) explodeShrapnelFromGrenadeAtX:(CGFloat)X y:(CGFloat)Y
//{
//    for (int j=0;j<SHRAPNEL_IN_GRENADE;j++) {
//        Bullet * b = [bullets.members objectAtIndex:bulletIndex];
//        b.x = X;
//        b.y = Y;
//        b.visible=YES;
//        b.dead = NO;
//        b.drag = CGPointMake(100, 100);
//        b.scale = CGPointMake(1,1);
//        
//        b.velocity = CGPointMake(-400 + [FlxU random] * 800, -400 + [FlxU random] * 800);
//        
//        bulletIndex++;
//        if (bulletIndex>=bullets.members.length) {
//            bulletIndex = 0;	
//        }
//    } 
//    
//}
//
//- (void) debugMode {
//    if (FlxG.touches.debugButton1) {
//        
//    }
//}
//
//- (void) update
//{
//    /*
//    CGPoint p = CGPointMake(player.x, player.y);
//    CGPoint b = CGPointMake(bottle.x, bottle.y);
//    float aaa = [FlxU getAngleBetweenPointsWithParam1:p param2:b];
//    NSLog(@" angle between player and bottle %f ", aaa);
//    */
//                                                    
//    //game over screen
//    if ( player.dead ) { 
//        
//        if (FlxG.touches.swipedDown) {
//            [self onStoryBack];
//        } else if (FlxG.touches.swipedUp) {
//            [self onStoryForward];
//        }
//        
//        
//        //all these run once only.
//        if (!hasCheckedGameOverScreen) {
//            [self addStats];
//
//            sh.visible = NO;
//            
//            [FlxG play:@"dead "];
//            [FlxG pauseMusic];
//            
//            gameOverScreenDarken.visible = YES;
//            gameOverText.visible = YES;
//            buttonPlay.visible = YES;
//            buttonMenu.visible = YES;
//            speechBubbleTextHelp.visible = YES;
//            
//            buttonLeft.alpha = 0;
//            buttonRight.alpha = 0;
//            buttonA.alpha = 0;
//            buttonB.alpha = 0;
//            
//            speechBubbleText.visible = YES;
//            
//            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//            
//            currentSpeechText = [prefs integerForKey:@"COLLECTED_BOTTLES"] / DIVISOR_FOR_STORY_UNLOCK;
//            if (currentSpeechText>[speechTexts length]) {
//                currentSpeechText=[speechTexts length]-1;
//            }
//            speechBubbleTextHelp.text = [[NSString stringWithFormat:@"<< Swipe to cycle >>\nCurrently viewing %d of %d available.", (currentSpeechText+1), (currentSpeechText+1) ] retain];
//            
//            [self showSpeechBubbleWithSound:NO];
//            
//            if (FlxG.level==1) { curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL1"]; }
//            if (FlxG.level==2) { curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL2"]; }
//            if (FlxG.level==3) { curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL3"]; }
//            if (FlxG.level==4) { curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL4"]; }
//            if (FlxG.level==5) { curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL5"]; }
//            if (FlxG.level==6) { curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL6"]; }
//            if (FlxG.level==7) { curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL7"]; }
//            if (FlxG.level==8) { curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL8"]; }
//            if (FlxG.level==9) { curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL9"]; }
//            
//            if (FlxG.score > curHighScore) {
//                if (FlxG.level==1) {
//                    [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL1"];
//                } else if (FlxG.level==2) {
//                    [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL2"];
//                } else if (FlxG.level==3) {
//                    [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL3"];
//                } else if (FlxG.level==4) {
//                    [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL4"];
//                } else if (FlxG.level==5) {
//                    [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL5"];
//                } else if (FlxG.level==6) {
//                    [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL6"];
//                } else if (FlxG.level==7) {
//                    [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL7"];
//                } else if (FlxG.level==8) {
//                    [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL8"];
//                } else if (FlxG.level==9) {
//                    [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL9"];
//                }
//                
//                
//                gameOverText.text = [[NSString stringWithFormat:@"Game Over\nNew high score!\nYour score was %d\nYour old high score was %d\n ", FlxG.score, curHighScore ] retain];
//                curHighScore = FlxG.score;
//                
//                if (FlxG.level==1) { curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL1"]; }
//                if (FlxG.level==2) { curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL2"]; }
//                if (FlxG.level==3) { curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL3"]; }
//                if (FlxG.level==4) { curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL4"]; }
//                if (FlxG.level==5) { curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL5"]; }
//                if (FlxG.level==6) { curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL6"]; }                
//                if (FlxG.level==7) { curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL7"]; }
//                if (FlxG.level==8) { curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL8"]; }
//                if (FlxG.level==9) { curHighScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL9"]; }                
//            }	  
//            else {
//                gameOverText.text = [[NSString stringWithFormat:@"Game Over\nYour score was %d\nYour high score is %d\n ", FlxG.score, curHighScore ] retain];
//            }
//        }
//        hasCheckedGameOverScreen=YES;
//        
//        //let's play again!
//        if (FlxG.touches.touchesBegan && FlxG.touches.screenTouchPoint.y < 90 && FlxG.touches.screenTouchPoint.x < FlxG.width/2) {
//            [FlxG play:@"ping "];
//            //[FlxG unpauseMusic];
//            
//            //play correct music for level
//            if (FlxG.level==1 || FlxG.level==4 || FlxG.level==7)
//                [FlxG playMusic:MusicMegaCannon];
//            if (FlxG.level==2 || FlxG.level==5 || FlxG.level==8)
//                [FlxG playMusic:MusicIceFishing];
//            if (FlxG.level==3 || FlxG.level==6 || FlxG.level==9)
//                [FlxG playMusic:MusicPirate];
//            
//            [self setNewWeapon:0];
//            hasCheckedGameOverScreen=NO;
//            gameOverScreenDarken.visible = NO;
//            gameOverText.visible = NO;
//            buttonPlay.visible = NO;
//            buttonMenu.visible = NO;
//            speechBubbleText.visible = NO;
//            speechBubble.visible = NO;
//            notepad.visible = NO;
//            enemyGeneric.visible = NO;
//            enemyListener.visible = NO;
//            speechBubbleTextHelp.visible = NO;
//            sugarHighIndicator.scale = CGPointMake(0, 1);
//            
//            [bottle resetPosition];
//            [crate resetPosition];
//            [sugarBag resetPosition];
//            timer = 0;
//            totalTimeElapsed = 0;
//            player.dead = NO;
//            player.visible = YES;
//            FlxG.score = 0;
//            scoreText.text = @"0";
//            player.x = FlxG.width / 2;
//            player.y = 175;
//            player.velocity = CGPointMake(0, 0);
//            for (Enemy * s in characters.members) {
//                s.dead = YES;
//                s.x = 1000;
//                s.y = 1000;
//                s.velocity = CGPointMake(0, 0);
//                s.acceleration = CGPointMake(0, 0);
//                
//            }
//            
//            for (FlxObject * block in playerPlatforms.members) {
//                block.x = block.originalXPos;
//                block.y = block.originalYPos;
//                block.moving = NO;
//                block.velocity = CGPointMake(0, 0);
//            }
//
//            
//            return;
//        } 
//        //back to menu
//        else if (FlxG.touches.touchesBegan && FlxG.touches.screenTouchPoint.y < 90 && FlxG.touches.screenTouchPoint.x > FlxG.width/2) {
//            [FlxG play:@"ping2 "];
//            [self addStats];
//            
//            [playerPlatforms.members removeAllObjects];
//            [enemyPlatforms.members removeAllObjects];
//            [characters.members removeAllObjects];
//            [allBullets.members removeAllObjects];
//            [bullets.members removeAllObjects];
//            [discs.members removeAllObjects];
//            [grenades.members removeAllObjects];
//            [charactersArmy.members removeAllObjects];
//            [charactersChef.members removeAllObjects];
//            [charactersInspector.members removeAllObjects];
//            [charactersWorker.members removeAllObjects];
//            
//            FlxG.state = [[[MenuState alloc] init] autorelease];
//            
//            return; 
//        }
//    }
//    
//    
//    
//    [self checkForSugarHigh];
//    
//	timer += FlxG.elapsed;
//    totalTimeElapsed += FlxG.elapsed;
//    
//    
//    //the following code uses a gamma curve to determine whether to drop an enemy every time the timer hits 0.5
//    //the gamma goes up as the game progresses.
//    CGFloat gamma = 0.45 + totalTimeElapsed / 100;
//    if (gamma > 2.0) gamma = 2.0;
//    
//    CGFloat x = [FlxU random];
//    CGFloat y = (gamma * x / (2 - gamma + 2 * x * (gamma - 1)) );
//    
//    //NSLog(@" %f %f gamma: %f", totalTimeElapsed, y, gamma);
//    
//    //spawn an enemy;
//    if (timer > 0.5 ){
//        if (y > 0.5 && y < 0.6) {
//            //NSLog(@"%@", [characters getFirstDead]);
//            FlxObject * n = [charactersArmy getRandom];
//            if (n.dead) {
//                [n resetSwarm:0];
//            }
//        } else if (y > 0.6 && y < 0.7) {
//            //NSLog(@"%@", [characters getFirstDead]);
//            FlxObject * n = [charactersChef getRandom];
//            if (n.dead) {
//                [n resetSwarm:0];
//            }
//        } 
//        
//        else  if (y > 0.7 && y < 0.8) {
//            FlxObject * n = [charactersInspector getRandom];
//            if (n.dead) {
//                [n resetSwarm:0];
//            }
//        } else  if (y > 0.8 ) {
//            FlxObject * n = [charactersWorker getRandom];
//            if (n.dead) {
//                [n resetSwarm:0];
//            }
//        }
//        //NSLog(@" Just dropped a : %@ ", [n class]);
//        
//        timer = 0;
//    }
//    
//    if (!player.dead) [self virtualControlPad];
//              
//        [super update];
//    
//    if (!player.dead) {
//        [FlxU collideObject:player withGroup:playerPlatforms];
//    }
//    
//    [FlxU collideObject:bottle withGroup:playerPlatforms];
//    [FlxU collideObject:crate withGroup:playerPlatforms];
//    [FlxU collideObject:sugarBag withGroup:playerPlatforms];
//    //[FlxU collideObject:crate withGroup:player];
//    [FlxU alternateCollideWithParam1:player param2:crate];
//    [FlxU collideObject:crate withGroup:characters];
//
//
//    
//    //grenade collisions
//    for (FlxObject * s in grenades.members) {
//        if (s.velocity.x <= 1 && s.velocity.x >= -1 && !s.dead ) {
//            if (player.isOnSugarHigh) {
//                [self explodeShrapnelFromGrenadeAtX:s.x y:s.y];
//            }
//            puffEmitter.x = s.x;
//            puffEmitter.y = s.y;
//            [puffEmitter startWithParam1:YES param2:2 param3:20];
//            
//            [FlxG play:@"grenadeExplosion "];
//            explosion.x = s.x-explosion.width/2;
//            explosion.y = s.y-explosion.height/2;
//            explosion.dead = NO;
//            explosion.alpha = 1;
//            explosion.scale = CGPointMake(1, 1  );
//            
//            s.velocity = CGPointMake(0, 0   );
//            s.x = 1000;
//            s.y = 1000;
//            s.dead = YES;
//            
//
//            
//
//        }
//        [FlxU collideObject:s withGroup:playerPlatforms];
//        for (FlxObject * e in characters.members) {
//            if (  ([s overlapsWithOffset:e] && !e.dead)  ) {
//                
//                if (player.isOnSugarHigh) {
//                    [self explodeShrapnelFromGrenadeAtX:s.x y:s.y];
//                }
//                
//                puffEmitter.x = s.x;
//                puffEmitter.y = s.y;
//                [puffEmitter startWithParam1:YES param2:2 param3:20];
//
//                [FlxG play:@"grenadeExplosion "];
//                explosion.x = s.x-explosion.width/2;
//                explosion.y = s.y-explosion.height/2;
//                explosion.dead = NO;
//                explosion.alpha = 1;
//                explosion.scale = CGPointMake(1, 1  );
//                
//                s.velocity = CGPointMake(0, 0   );
//                s.x = 1000;
//                s.y = 1000;
//                s.dead = YES;
//
//                
//                return;
//
//            }
//
//        }
//    } //end grenade collisions
//    
//    
//    //enemies collide with platforms and enemies touch player
//    for (FlxObject * s in characters.members) {
//        if (! s.dead ) {
//            [FlxU collideObject:s withGroup:enemyPlatforms];
//        }
//		if ([s overlapsWithOffset:player] && (s.dead == NO) && (player.dead == NO)) {
//            [self playerDies];
//            NSLog(@"Player killed by: %@", s );
//            
//            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//            
//            if ([s isKindOfClass:[EnemyArmy class]]) {
//                NSInteger existingNumberOfArmyKilled = [prefs integerForKey:@"KILLED_BY_ARMY"];
//                existingNumberOfArmyKilled += 1;
//                [prefs setInteger:existingNumberOfArmyKilled forKey:@"KILLED_BY_ARMY"];
//            }
//            else if ([s isKindOfClass:[EnemyChef class]]) {
//                NSInteger existingNumberOfChefKilled = [prefs integerForKey:@"KILLED_BY_CHEF"];
//                existingNumberOfChefKilled += 1;
//                [prefs setInteger:existingNumberOfChefKilled forKey:@"KILLED_BY_CHEF"];
//            }
//            
//            else if ([s isKindOfClass:[EnemyInspector class]]) {
//                NSInteger existingNumberOfInspectorKilled = [prefs integerForKey:@"KILLED_BY_INSPECTOR"];
//                existingNumberOfInspectorKilled += 1;
//                [prefs setInteger:existingNumberOfInspectorKilled forKey:@"KILLED_BY_INSPECTOR"];
//            }
//            
//            else if ([s isKindOfClass:[EnemyWorker class]]) {
//                NSInteger existingNumberOfWorkerKilled = [prefs integerForKey:@"KILLED_BY_WORKER"];
//                existingNumberOfWorkerKilled += 1;
//                [prefs setInteger:existingNumberOfWorkerKilled forKey:@"KILLED_BY_WORKER"];
//            }
//			
//		}
//        
//        for (FlxObject	* b	in allBullets.members) {
//            if (!b.dead) {
//                if ([s overlapsWithOffset:b] && (s.dead == NO) && [b isKindOfClass:[Bullet class]]) {
//                    [s hurt:bulletDamage];
//                    b.x = -100;
//                    b.y = -100;
//                    if (s.health<=0) {
//                        [self addEnemyToTotal:s];
//                    }
//                }
//                else if ([s overlapsWithOffset:b] && (s.dead == NO) && [b isKindOfClass:[Disc class]]) {
//                    if (s.flickering) {return;}
//                    [s hurt:bulletDamage];
//                    if (s.health<=0) {
//                        [self addEnemyToTotal:s];
//                    }            
//                } 
//                else  if ([s overlapsWithOffset:b] && (s.dead == NO) && [b isKindOfClass:[Grenade class]]) {
//                    [s hurt:100.0];
//                    if (s.health<=0) {
//                        [self addEnemyToTotal:s];
//                    }               
//                    b.x = -100;
//                    b.y = -100;
//                } else  if ([s overlapsWithOffset:b] && (s.dead == NO) && [b isKindOfClass:[Explosion class]]) {
//                    [s hurt:100.0];
//                    if (s.health<=0) {
//                        [self addEnemyToTotal:s];
//                    }            
//                }
//            }
//        }
//        
//	}
//    
//    //overlaps sugar bag.
//    if ([player overlapsWithOffset:sugarBag]) {
//        [FlxG play:@"powerUp "];
//        [sugarBag resetPosition];
//        
//        
//        CGFloat beep = sugarHighIndicator.scale.x + PERCENTAGE_SUGAR_BAG_ADDS;
//        sugarHighIndicator.scale = CGPointMake(beep, 1);
//        
//
//        
//    }    
//    
//    if ([player overlapsWithOffset:bottle]) {
//        
//        [self rearrangePlatforms];
//        
//        [FlxG play:SndFizz];
//        [FlxG play:@"powerUp "];
//        
//        collectedBottles++;
//        if (player.isOnSugarHigh) {
//            collectedBottles++;
//        }
//        puffEmitter2.x = bottle.x-12;
//        puffEmitter2.y = bottle.y-12;
//        puffEmitter2.width = 24;
//        puffEmitter2.height = 24;
//        [puffEmitter2 startWithParam1:YES param2:14 param3:7 ];
//        
//        weaponText.x = bottle.x;
//        if (weaponText.x>FlxG.levelWidth-130) { weaponText.x = FlxG.levelWidth-130; }
//        weaponText.y = bottle.y - 30;
//        weaponText.velocity = CGPointMake(0, 0);
//
//        [bottle resetPosition];
//        [self setNewWeapon:-1];
//        FlxG.score += 1;
//        NSString *intString = [NSString stringWithFormat:@"%d", FlxG.score];
//        scoreText.text = (@"%@", intString);
//        if (FlxG.score > curHighScore) {
//            //NSLog(@"We got a high score");
//            intString = [NSString stringWithFormat:@"%d!", FlxG.score];
//            scoreText.text = (@"%@", intString);
//        }
//        puffEmitter.x = bottle.x-12;
//        puffEmitter.y = bottle.y-12;
//        puffEmitter.width = 24;
//        puffEmitter.height = 24;
//        [puffEmitter startWithParam1:YES param2:14 param3:7 ];
//
//    }
//    
//    
//    //[FlxU collideObject:enemy withGroup:platforms];
//    //collide discs with level
//    for (Disc * s in discs.members) {
//        if (!s.dead) {
//            [FlxU collideObject:s withGroup:playerPlatforms];
//            //[FlxU alternateCollideWithParam1:s param2:playerPlatforms];
//            
//            if ([s overlapsWithOffset:player]) {
//                [self playerDies];
//                return;
//            }
//        }
//    }
//    
//    //gunOffsetToPlayer = player.scale.x ? 21 : 11;
//    if (player.scale.x==1) {
//        gunOffsetToPlayer=11;
//    } else if (player.scale.x==-1) {
//        gunOffsetToPlayer=21;
//    }
//    
//    
//    gun.x = player.x-gunOffsetToPlayer;
//    gun.y = player.y-19;  
//    gun.scale = CGPointMake(player.scale.x, player.scale.y);
//    
////    if (FlxG.touches.debugButton1) {
////        gunOffsetToPlayer++;
////        NSLog(@"gun offset = %f", gunOffsetToPlayer);
////    }
////    if (FlxG.touches.debugButton2) {
////        gunOffsetToPlayer--;
////        NSLog(@"gun offset = %f", gunOffsetToPlayer);
////    }    
//    
//}
//
//
//#pragma mark Stats
//
//
//-(void) addEnemyToTotal:(Enemy *)toAdd
//{
//    if ([toAdd isKindOfClass:[EnemyArmy class]]) {
//        killedArmy++;
//    }
//    else if ([toAdd isKindOfClass:[EnemyChef class]]) {
//        killedChef++;
//    }if ([toAdd isKindOfClass:[EnemyInspector class]]) {
//        killedInspector++;
//    }if ([toAdd isKindOfClass:[EnemyWorker class]]) {
//        killedWorker++;
//    }
//    
//}
//
//- (void) addStats {
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    
//    // getting an NSInteger
//    NSInteger existingNumberOfArmyKilled = [prefs integerForKey:@"KILLED_ARMY"];
//    existingNumberOfArmyKilled += killedArmy;
//    [prefs setInteger:existingNumberOfArmyKilled forKey:@"KILLED_ARMY"];
//    
//    NSInteger existingNumberOfChefKilled = [prefs integerForKey:@"KILLED_CHEF"];
//    existingNumberOfChefKilled += killedChef;
//    [prefs setInteger:existingNumberOfChefKilled forKey:@"KILLED_CHEF"];
//    
//    NSInteger existingNumberOfInspectorKilled = [prefs integerForKey:@"KILLED_INSPECTOR"];
//    existingNumberOfInspectorKilled += killedInspector;
//    [prefs setInteger:existingNumberOfInspectorKilled forKey:@"KILLED_INSPECTOR"];
//    
//    NSInteger existingNumberOfWorkerKilled = [prefs integerForKey:@"KILLED_WORKER"];
//    existingNumberOfWorkerKilled += killedWorker;
//    [prefs setInteger:existingNumberOfWorkerKilled forKey:@"KILLED_WORKER"];
//    
//    NSInteger existingNumberOfBottles = [prefs integerForKey:@"COLLECTED_BOTTLES"];
//    existingNumberOfBottles += collectedBottles;
//    [prefs setInteger:existingNumberOfBottles forKey:@"COLLECTED_BOTTLES"];
//    
//    //high score
//    
//    if (FlxG.level == 1) {
//        NSInteger highScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL1"];
//        if (FlxG.score > highScore) {
//            [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL1"];
//            highScore = FlxG.score;
//        }	  
//        else {
//            
//        }
//    } else if (FlxG.level == 2) {
//        NSInteger highScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL2"];
//        if (FlxG.score > highScore) {
//            [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL2"];
//            highScore = FlxG.score;
//        }	  
//        else {
//            
//        }
//    } else if (FlxG.level == 3) {
//        NSInteger highScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL3"];
//        if (FlxG.score > highScore) {
//            [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL3"];
//            highScore = FlxG.score;
//        }	  
//        else {
//            
//        }
//    } else if (FlxG.level == 4) {
//        NSInteger highScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL4"];
//        if (FlxG.score > highScore) {
//            [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL4"];
//            highScore = FlxG.score;
//        }	  
//        else {
//            
//        }
//    } else if (FlxG.level == 5) {
//        NSInteger highScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL5"];
//        if (FlxG.score > highScore) {
//            [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL5"];
//            highScore = FlxG.score;
//        }	  
//        else {
//            
//        }
//    } else if (FlxG.level == 6) {
//        NSInteger highScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL6"];
//        if (FlxG.score > highScore) {
//            [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL6"];
//            highScore = FlxG.score;
//        }	  
//        else {
//            
//        }
//    } else if (FlxG.level == 7) {
//        NSInteger highScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL7"];
//        if (FlxG.score > highScore) {
//            [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL7"];
//            highScore = FlxG.score;
//        }	  
//        else {
//            
//        }
//    } else if (FlxG.level == 8) {
//        NSInteger highScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL8"];
//        if (FlxG.score > highScore) {
//            [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL8"];
//            highScore = FlxG.score;
//        }	  
//        else {
//            
//        }
//    } else if (FlxG.level == 9) {
//        NSInteger highScore = [prefs integerForKey:@"HIGH_SCORE_LEVEL9"];
//        if (FlxG.score > highScore) {
//            [prefs setInteger:FlxG.score forKey:@"HIGH_SCORE_LEVEL9"];
//            highScore = FlxG.score;
//        }	  
//        else {
//            
//        }
//    }
//    
//
//	
//	[prefs synchronize];
//    
//    killedArmy=0;
//    killedChef=0;
//    killedWorker=0;
//    killedInspector=0;
//    collectedBottles=0;
//    
//}
//
//
//@end
//
