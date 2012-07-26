//
//  LevelSelectState.m
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
// THE SOFTWARE..
//

#import "MenuState.h"
#import "LevelSelectState.h"
#import "PlayState.h"
#import "OgmoLevelState.h"

#import "Bottle.h"

#define NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_2_SIZE_REGULAR -50
#define NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_3_SIZE_REGULAR -100

#define NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_1_SIZE_LARGE -150
#define NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_2_SIZE_LARGE -200
#define NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_3_SIZE_LARGE -250

#define NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_1_SIZE_SUPER 300
#define NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_2_SIZE_SUPER 350
#define NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_3_SIZE_SUPER 400


//#import "HelpState.h"
static NSString * ImgButton = @"emptyButton.png";
static NSString * ImgButtonPressed = @"emptyButtonPressed.png";
static NSString * ImgSmallButton = @"emptySmallButton.png";
static NSString * ImgSmallButtonPressed = @"emptySmallButtonPressed.png";
static NSString * ImgPlay = @"play2x.png";
static NSString * ImgBgGrad = @"level1_bgSmoothGrad_new.png";


static NSString * SndSwipe = @"whoosh.caf";
static NSString * SndSelect = @"ping.caf";
static NSString * SndBack = @"ping2.caf";


static NSString * ImgSizeRegular = @"sizeButtonRegular.png";
static NSString * ImgSizeLarge = @"sizeButtonLarge.png";
static NSString * ImgSizeSuper = @"sizeButtonSuper.png";
static NSString * ImgSizeLocked = @"sizeButtonLocked.png";

NSInteger hs1, hs2, hs3, hs4, hs5, hs6, hs7, hs8, hs9;


NSInteger totalBottlesCollected;

FlxText * information;

FlxSprite * bgCity;
FlxSprite * bgClouds;
FlxSprite * darkenBar;
FlxSprite * sugarbags;
FlxSprite * sugarbagsR;
FlxSprite * shelves;
FlxSprite * arrow;

static int numberOfTimesSwipedLeft;
static int numberOfTimesSwipedRight;

FlxSprite * playLevel1;
FlxSprite * playLevel2;
FlxSprite * playLevel3;
FlxSprite * playLevel4;


FlxSprite * level1sizeRegular; 
FlxSprite * level2sizeRegular; 
FlxSprite * level3sizeRegular; 

FlxSprite * level1sizeLarge; 
FlxSprite * level2sizeLarge; 
FlxSprite * level3sizeLarge; 

FlxSprite * level1sizeSuper; 
FlxSprite * level2sizeSuper; 
FlxSprite * level3sizeSuper; 

FlxButton * playBtn;

static int currentLevelSelected;
static int currentSizeSelected;

@interface LevelSelectState ()
//- (void) showMusic;
//- (void) hideMusic;
//- (void) move:(FlxObject *)obj toPoint:(CGPoint)pnt duration:(CGFloat)dur;
@end


@implementation LevelSelectState

- (id) init
{
	if ((self = [super init])) {
		self.bgColor = 0x3b3224;
	}
	return self;
}

- (void) create
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    totalBottlesCollected = [prefs integerForKey:@"COLLECTED_BOTTLES"];
    
    hs1 = [prefs integerForKey:@"HIGH_SCORE_LEVEL1"];
    hs2 = [prefs integerForKey:@"HIGH_SCORE_LEVEL2"];
    hs3 = [prefs integerForKey:@"HIGH_SCORE_LEVEL3"];
    hs4 = [prefs integerForKey:@"HIGH_SCORE_LEVEL4"];
    hs5 = [prefs integerForKey:@"HIGH_SCORE_LEVEL5"];
    hs6 = [prefs integerForKey:@"HIGH_SCORE_LEVEL6"];
    hs7 = [prefs integerForKey:@"HIGH_SCORE_LEVEL7"];
    hs8 = [prefs integerForKey:@"HIGH_SCORE_LEVEL8"];
    hs9 = [prefs integerForKey:@"HIGH_SCORE_LEVEL9"];
    
    //NSLog(@"HIGH SCORES ARE %d %d %d, %d %d %d, %d %d %d", hs1,hs2,hs3,hs4,hs5,hs6,hs7,hs8,hs9);

    FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:FlxG.height];  
    [grad loadGraphic:ImgBgGrad empties:0 autoTile:NO isSpeechBubble:0 isGradient:17];
    [self add:grad];
    
    currentLevelSelected = 1;
    currentSizeSelected = 1;
    
    sugarbags = [FlxSprite spriteWithX:153 y:128 graphic:@"level1_leftSideMG.png"];
    sugarbags.x = 0;
    sugarbags.y = FlxG.height-sugarbags.height;
    [self add:sugarbags];
    sugarbags.velocity = CGPointMake(-300, 0);
    sugarbags.drag = CGPointMake(150, 150); 
    
    shelves = [FlxSprite spriteWithX:210 y:313 graphic:@"shelfLayer.png"];
    shelves.x = FlxG.width-shelves.width;
    shelves.y = FlxG.height-shelves.height;;
    [self add:shelves];
    shelves.velocity = CGPointMake(-300, 0);
    shelves.drag = CGPointMake(150, 150); 
    
    sugarbagsR = [FlxSprite spriteWithX:153 y:128 graphic:@"level1_rightSideMG.png"];
    sugarbagsR.x = FlxG.width-sugarbagsR.width+300;
    sugarbagsR.y = FlxG.height-sugarbagsR.height+1;
    [self add:sugarbagsR];
    sugarbagsR.velocity = CGPointMake(-300, 0);
    sugarbagsR.drag = CGPointMake(150, 150);    
    
    numberOfTimesSwipedRight = 0;
    
    //FlxG.cheatMode = 0;
    
    playLevel1 = [[[FlxButton alloc] initWithX:FlxG.width/2 - 114
                                             y:20
                                      callback:[FlashFunction functionWithTarget:self
                                                                         action:@selector(onPlayLevel1)]] autorelease];
    [playLevel1 loadGraphic:[FlxSprite spriteWithGraphic:@"level1Button.png"]];
//    [playLevel1 loadText:[FlxText textWithWidth:115
//                                     text:NSLocalizedString(@" Level 1 ", @" Level 1 ")
//                                     font:nil
//                                     size:8.0]];
    playLevel1.visible = YES;

    [self add:playLevel1];
    
    playLevel2 = [[[FlxButton alloc]      initWithX:FlxG.width/2 - 114
                                                  y:20
                                           callback:[FlashFunction functionWithTarget:self
                                                                               action:@selector(onPlayLevel2)]] autorelease];
    if (totalBottlesCollected>NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_2_SIZE_REGULAR) {
        [playLevel2 loadGraphic:[FlxSprite spriteWithGraphic:@"level2Button.png"]];
    } else {
        [playLevel2 loadGraphic:[FlxSprite spriteWithGraphic:@"levelLocked.png"]];
    }
    
    playLevel2.visible = NO;
    [self add:playLevel2];
    
    
    
    
    playLevel3 = [[[FlxButton alloc]      initWithX:FlxG.width/2 - 114
                                                  y:20
                                           callback:[FlashFunction functionWithTarget:self
                                                                               action:@selector(onPlayLevel3)]] autorelease];
    if (totalBottlesCollected>NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_3_SIZE_REGULAR) {
        [playLevel3 loadGraphic:[FlxSprite spriteWithGraphic:@"level3Button.png"]];
    } else {
        [playLevel3 loadGraphic:[FlxSprite spriteWithGraphic:@"levelLocked.png"]];
    }
//    [playLevel3 loadText:[FlxText textWithWidth:115
//                                           text:NSLocalizedString(@" Level 3 ", @" Level 3 ")
//                                           font:nil
//                                           size:8.0]];
    playLevel3.visible = NO;
    
    [self add:playLevel3];
    
    
    int sizeButtonsX = FlxG.width/2-60;
    int sizeButtonsY = playLevel1.y+playLevel1.height + 20;
    
    //size buttons
    level1sizeRegular = [FlxSprite spriteWithGraphic:ImgSizeRegular];
    level1sizeRegular.x = sizeButtonsX;
    level1sizeRegular.y = sizeButtonsY;
    [self add:level1sizeRegular]; 
    
    if (totalBottlesCollected>NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_2_SIZE_REGULAR) {
        level2sizeRegular = [FlxSprite spriteWithGraphic:ImgSizeRegular];
    } else {
        level2sizeRegular = [FlxSprite spriteWithGraphic:ImgSizeLocked];
    }
    level2sizeRegular.x = sizeButtonsX;
    level2sizeRegular.y = sizeButtonsY;
    [self add:level2sizeRegular];     
    
    if (totalBottlesCollected>NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_3_SIZE_REGULAR) {
        level3sizeRegular = [FlxSprite spriteWithGraphic:ImgSizeRegular];
    } else {
        level3sizeRegular = [FlxSprite spriteWithGraphic:ImgSizeLocked];
    }
    level3sizeRegular.x = sizeButtonsX;
    level3sizeRegular.y = sizeButtonsY;
    [self add:level3sizeRegular]; 
    
    
    if (totalBottlesCollected>NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_1_SIZE_LARGE) {
        level1sizeLarge = [FlxSprite spriteWithGraphic:ImgSizeLarge];
    } else {
        level1sizeLarge = [FlxSprite spriteWithGraphic:ImgSizeLocked];
    }    
    level1sizeLarge.x = sizeButtonsX;
    level1sizeLarge.y = sizeButtonsY;
    [self add:level1sizeLarge]; 
    
    if (totalBottlesCollected>NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_2_SIZE_LARGE) {
        level2sizeLarge = [FlxSprite spriteWithGraphic:ImgSizeLarge];
    } else {
        level2sizeLarge = [FlxSprite spriteWithGraphic:ImgSizeLocked];
    }      
    level2sizeLarge.x = sizeButtonsX;
    level2sizeLarge.y = sizeButtonsY;
    [self add:level2sizeLarge];     
    
    if (totalBottlesCollected>NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_3_SIZE_LARGE) {
        level3sizeLarge = [FlxSprite spriteWithGraphic:ImgSizeLarge];
    } else {
        level3sizeLarge = [FlxSprite spriteWithGraphic:ImgSizeLocked];
    }     
    level3sizeLarge.x = sizeButtonsX;
    level3sizeLarge.y = sizeButtonsY;
    [self add:level3sizeLarge];  
    
    if (totalBottlesCollected>NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_1_SIZE_SUPER) {
        level1sizeSuper = [FlxSprite spriteWithGraphic:ImgSizeSuper];
    } else {
        level1sizeSuper = [FlxSprite spriteWithGraphic:ImgSizeLocked];
    } 
    level1sizeSuper.x = sizeButtonsX;
    level1sizeSuper.y = sizeButtonsY;
    [self add:level1sizeSuper]; 
    
    if (totalBottlesCollected>NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_2_SIZE_SUPER) {
        level2sizeSuper = [FlxSprite spriteWithGraphic:ImgSizeSuper];
    } else {
        level2sizeSuper = [FlxSprite spriteWithGraphic:ImgSizeLocked];
    }     
    level2sizeSuper.x = sizeButtonsX;
    level2sizeSuper.y = sizeButtonsY;
    [self add:level2sizeSuper];     
    
    if (totalBottlesCollected>NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_3_SIZE_SUPER) {
        level3sizeSuper = [FlxSprite spriteWithGraphic:ImgSizeSuper];
    } else {
        level3sizeSuper = [FlxSprite spriteWithGraphic:ImgSizeLocked];
    }     
    level3sizeSuper.x = sizeButtonsX;
    level3sizeSuper.y = sizeButtonsY;
    [self add:level3sizeSuper];  
    
    playBtn = [[[FlxButton alloc]      initWithX: FlxG.width/2-60
                                                  y:FlxG.height - 50
                                           callback:[FlashFunction functionWithTarget:self
                                                                               action:@selector(onPlay)]] autorelease];
    [playBtn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
    [playBtn loadTextWithParam1:[FlxText textWithWidth:playBtn.width
                                                  text:NSLocalizedString(@"play", @"play")
                                                  font:@"SmallPixel"
                                                  size:16.0] param2:[FlxText textWithWidth:playBtn.width
                                                                                      text:NSLocalizedString(@"PLAY...", @"PLAY...")
                                                                                      font:@"SmallPixel"
                                                                                      size:16.0] withXOffset:0 withYOffset:playBtn.height/4];
    
    [self add:playBtn];
    
    FlxButton * backBtn = [[[FlxButton alloc]   initWithX:20
                                                        y:FlxG.height - 50
                                                callback:[FlashFunction functionWithTarget:self
                                                                                    action:@selector(onBack)]] autorelease];
    [backBtn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgSmallButton] param2:[FlxSprite spriteWithGraphic:ImgSmallButtonPressed]]; 
    [backBtn loadTextWithParam1:[FlxText textWithWidth:backBtn.width
                                                  text:NSLocalizedString(@"back", @"back")
                                                  font:@"SmallPixel"
                                                  size:16.0] param2:[FlxText textWithWidth:backBtn.width
                                                                                      text:NSLocalizedString(@"BACK...", @"BACK...")
                                                                                      font:@"SmallPixel"
                                                                                      size:16.0] withXOffset:0 withYOffset:backBtn.height/4];
    [self add:backBtn];
    
    
    information = [FlxText textWithWidth:FlxG.width
								  text:@""
								  font:@"SmallPixel"
								  size:16];
	information.color = 0xffa6605a;
	information.alignment = @"center";
	information.x = 0;
	information.y = 206;
	[self add:information];
    
    FlxText * swipeInformation = [FlxText textWithWidth:FlxG.width
                                    text:@"<< Swipe >>"
                                    font:@"SmallPixel"
                                    size:16];
	swipeInformation.color = 0xffa6605a;
	swipeInformation.alignment = @"center";
	swipeInformation.x = 0;
	swipeInformation.y = 0;
	[self add:swipeInformation]; 
    
    levelInfo = [FlxText textWithWidth:FlxG.width
                                  text:@". _ _"
                                  font:@"SmallPixel"
                                  size:16];
	levelInfo.color = 0xffa6605a;
	levelInfo.alignment = @"center";
	levelInfo.x = 0;
	levelInfo.y = playLevel1.y + playLevel1.height - 10;
	[self add:levelInfo]; 
    
    sizeInfo = [FlxText textWithWidth:FlxG.width
                                  text:@". _ _"
                                  font:@"SmallPixel"
                                  size:16];
	sizeInfo.color = 0xffa6605a;
	sizeInfo.alignment = @"center";
	sizeInfo.x = 0;
	sizeInfo.y = level1sizeRegular.y + level1sizeRegular.height - 10;
	[self add:sizeInfo]; 
    


    
}

- (void) dealloc
{
	//[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}


- (void) update
{    
    if (FlxG.touches.touchesEnded ) {
		int bottomOfLevelSticker = 150;
        float xleg = FlxG.touches.lastScreenTouchPoint.x-FlxG.touches.screenTouchBeganPoint.x;
        float yleg = FlxG.touches.lastScreenTouchPoint.y-FlxG.touches.screenTouchBeganPoint.y;
        float hypotenuse = sqrt((xleg*xleg)+(yleg*yleg));
        if (hypotenuse>22){
            float swiperotation = atan2(yleg, xleg) / M_PI * 180;
            if (swiperotation < 45 && swiperotation > -45 ) { //right
                [FlxG play:SndSwipe];

                if (FlxG.touches.screenTouchBeganPoint.y < bottomOfLevelSticker) {
                    currentLevelSelected++;
                    if (currentLevelSelected>=4) {
                        currentLevelSelected=1;
                    }
                }
                else if (FlxG.touches.screenTouchBeganPoint.y > bottomOfLevelSticker) {
                    currentSizeSelected++;
                    if (currentSizeSelected>=4) {
                        currentSizeSelected=1;
                    }
                }
                
                
            }
            if (swiperotation < -135 || swiperotation > 135 ) { //left
                //NSLog(@"swiped left");
                [FlxG play:SndSwipe];

                if (FlxG.touches.screenTouchBeganPoint.y < bottomOfLevelSticker) {
                    currentLevelSelected--;
                    if (currentLevelSelected<=0) {
                        currentLevelSelected=3;
                    }
                }
                else if (FlxG.touches.screenTouchBeganPoint.y > bottomOfLevelSticker) {
                    currentSizeSelected--;
                    if (currentSizeSelected<=0) {
                        currentSizeSelected=3;
                    }
                }
                
            }
            if (swiperotation < 135 && swiperotation > 45 ) { //down
                //NSLog(@"swiped down");
            }				
            if (swiperotation < -45 && swiperotation > -135 ) { //up
                //NSLog(@"swiped up");
            }
        }
    }
    NSString * intString;
    int bottlesNeeded;
    switch (currentLevelSelected) {
        case 1:
            levelInfo.text = @". _ _";
            
            playLevel1.visible = YES;
            playLevel2.visible = NO;
            playLevel3.visible = NO;
            
            //level 1 is warehouse - regular size - 
            if (currentSizeSelected==1) {
                sizeInfo.text = @". _ _";

                level1sizeRegular.visible = YES;
                level1sizeLarge.visible = NO;
                level1sizeSuper.visible = NO;
                level2sizeRegular.visible = NO;
                level2sizeLarge.visible = NO;
                level2sizeSuper.visible = NO;
                level3sizeRegular.visible = NO;
                level3sizeLarge.visible = NO;
                level3sizeSuper.visible = NO;
                intString = [NSString stringWithFormat:@"High Score: %d", hs1];
                information.text = (@"%@", intString);
            }
            //level 2 is factory regular size
            if (currentSizeSelected==2) {
                sizeInfo.text = @"_ . _";

                level1sizeRegular.visible = NO;
                level1sizeLarge.visible = YES;
                level1sizeSuper.visible = NO;
                level2sizeRegular.visible = NO;
                level2sizeLarge.visible = NO;
                level2sizeSuper.visible = NO;
                level3sizeRegular.visible = NO;
                level3sizeLarge.visible = NO;
                level3sizeSuper.visible = NO;
                
                bottlesNeeded =  NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_1_SIZE_LARGE - totalBottlesCollected;
                if (bottlesNeeded>0) {
                    intString = [NSString stringWithFormat:@"Collect %d more bottles to unlock", bottlesNeeded];
                    information.text = (@"%@", intString);
                } else {
                    intString = [NSString stringWithFormat:@"High Score: %d", hs4];
                    information.text = (@"%@", intString);
                }
            }
            if (currentSizeSelected==3) {
                sizeInfo.text = @"_ _ .";

                level1sizeRegular.visible = NO;
                level1sizeLarge.visible = NO;
                level1sizeSuper.visible = YES;
                level2sizeRegular.visible = NO;
                level2sizeLarge.visible = NO;
                level2sizeSuper.visible = NO;
                level3sizeRegular.visible = NO;
                level3sizeLarge.visible = NO;
                level3sizeSuper.visible = NO;
                
                bottlesNeeded =  NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_1_SIZE_SUPER - totalBottlesCollected;
                if (bottlesNeeded>0) {
                    intString = [NSString stringWithFormat:@"Collect %d more bottles to unlock", bottlesNeeded];
                    information.text = (@"%@", intString);
                } else {
                    intString = [NSString stringWithFormat:@"High Score: %d", hs7];
                    information.text = (@"%@", intString);                }
                    
            }            
            
            //information.text = @"";

            break;
        case 2:
            levelInfo.text = @"_ . _";

            playLevel1.visible = NO;
            playLevel2.visible = YES;
            playLevel3.visible = NO;
            if (currentSizeSelected==1) {
                sizeInfo.text = @". _ _";
                level1sizeRegular.visible = NO;
                level1sizeLarge.visible = NO;
                level1sizeSuper.visible = NO;
                level2sizeRegular.visible = YES;
                level2sizeLarge.visible = NO;
                level2sizeSuper.visible = NO;
                level3sizeRegular.visible = NO;
                level3sizeLarge.visible = NO;
                level3sizeSuper.visible = NO;
                
                bottlesNeeded =  NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_2_SIZE_REGULAR - totalBottlesCollected;
                if (bottlesNeeded>0) {
                    intString = [NSString stringWithFormat:@"Collect %d more bottles to unlock", bottlesNeeded];
                    information.text = (@"%@", intString);
                } else {
                    intString = [NSString stringWithFormat:@"High Score: %d", hs2];
                    information.text = (@"%@", intString);                }
            }                
            if (currentSizeSelected==2) {
                sizeInfo.text = @"_ . _";

                    level1sizeRegular.visible = NO;
                    level1sizeLarge.visible = NO;
                    level1sizeSuper.visible = NO;
                    level2sizeRegular.visible = NO;
                    level2sizeLarge.visible = YES;
                    level2sizeSuper.visible = NO;
                    level3sizeRegular.visible = NO;
                    level3sizeLarge.visible = NO;
                    level3sizeSuper.visible = NO;
                    
                    bottlesNeeded =  NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_2_SIZE_LARGE - totalBottlesCollected;
                    if (bottlesNeeded>0) {
                        intString = [NSString stringWithFormat:@"Collect %d more bottles to unlock", bottlesNeeded];
                        information.text = (@"%@", intString);
                    } else {
                        intString = [NSString stringWithFormat:@"High Score: %d", hs5];
                        information.text = (@"%@", intString);                    }
            }
            if (currentSizeSelected==3) {
                sizeInfo.text = @"_ _ .";

                level1sizeRegular.visible = NO;
                level1sizeLarge.visible = NO;
                level1sizeSuper.visible = NO;
                level2sizeRegular.visible = NO;
                level2sizeLarge.visible = NO;
                level2sizeSuper.visible = YES;
                level3sizeRegular.visible = NO;
                level3sizeLarge.visible = NO;
                level3sizeSuper.visible = NO;
                
                bottlesNeeded =  NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_2_SIZE_SUPER - totalBottlesCollected;
                if (bottlesNeeded>0) {
                    intString = [NSString stringWithFormat:@"Collect %d more bottles to unlock", bottlesNeeded];
                    information.text = (@"%@", intString);
                } else {
                    intString = [NSString stringWithFormat:@"High Score: %d", hs8];
                    information.text = (@"%@", intString);
                }                    
            }
        
            break;
        case 3:
            levelInfo.text = @"_ _ .";

            playLevel1.visible = NO;
            playLevel2.visible = NO;
            playLevel3.visible = YES;
            if (currentSizeSelected==1) {
                sizeInfo.text = @". _ _";

                level1sizeRegular.visible = NO;
                level1sizeLarge.visible = NO;
                level1sizeSuper.visible = NO;
                level2sizeRegular.visible = NO;
                level2sizeLarge.visible = NO;
                level2sizeSuper.visible = NO;
                level3sizeRegular.visible = YES;
                level3sizeLarge.visible = NO;
                level3sizeSuper.visible = NO;
                
                bottlesNeeded =  NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_3_SIZE_REGULAR - totalBottlesCollected;
                if (bottlesNeeded>0) {
                    intString = [NSString stringWithFormat:@"Collect %d more bottles to unlock", bottlesNeeded];
                    information.text = (@"%@", intString);
                } else {
                    intString = [NSString stringWithFormat:@"High Score: %d", hs3];
                    information.text = (@"%@", intString);                
                }
            }
            if (currentSizeSelected==2) {
                sizeInfo.text = @"_ . _";

                    level1sizeRegular.visible = NO;
                    level1sizeLarge.visible = NO;
                    level1sizeSuper.visible = NO;
                    level2sizeRegular.visible = NO;
                    level2sizeLarge.visible = NO;
                    level2sizeSuper.visible = NO;
                    level3sizeRegular.visible = NO;
                    level3sizeLarge.visible = YES;
                    level3sizeSuper.visible = NO;
                    
                    bottlesNeeded =  NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_3_SIZE_LARGE - totalBottlesCollected;
                    if (bottlesNeeded>0) {
                        intString = [NSString stringWithFormat:@"Collect %d more bottles to unlock", bottlesNeeded];
                        information.text = (@"%@", intString);
                    } else {
                        intString = [NSString stringWithFormat:@"High Score: %d", hs6];
                        information.text = (@"%@", intString);
                    }
            }
            if (currentSizeSelected==3) {
                sizeInfo.text = @"_ _ .";

                level1sizeRegular.visible = NO;
                level1sizeLarge.visible = NO;
                level1sizeSuper.visible = NO;
                level2sizeRegular.visible = NO;
                level2sizeLarge.visible = NO;
                level2sizeSuper.visible = NO;
                level3sizeRegular.visible = NO;
                level3sizeLarge.visible = NO;
                level3sizeSuper.visible = YES;
                
                bottlesNeeded =  NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_3_SIZE_SUPER - totalBottlesCollected;
                if (bottlesNeeded>0) {
                    intString = [NSString stringWithFormat:@"Collect %d more \nbottles to unlock", bottlesNeeded];
                    information.text = (@"%@", intString);
                } else {
                    intString = [NSString stringWithFormat:@"High Score: %d", hs9];
                    information.text = (@"%@", intString);
                }
            }
            
//            bottlesNeeded =  NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_3_SIZE_REGULAR - totalBottlesCollected;
//            if (bottlesNeeded>0) {
//                intString = [NSString stringWithFormat:@"Collect %d more bottles to unlock" , bottlesNeeded];
//                information.text = (@"@", intString);
//            } else {
//                information.text = @"";
//            }
            
            break;
            
        default:
            break;
    }
    
    if (FlxG.debugMode) {
        if (FlxG.touches.debugButton1) {
            information.y --;
            //NSLog(@"Information.y = %f", information.y);
        }
    }

    //NSLog(@"x: %f, ", sugarbagsR.x);
	
	[super update];
	

	
}

- (void) onBack
{
    [FlxG playWithParam1:@"ping2" param2:PING2_VOL param3:NO];

    FlxG.state = [[[MenuState alloc] init] autorelease];
    return;
}


- (void) onPlay
{
    BOOL ok = NO;
    int level = 1;
    if (currentLevelSelected==1 && currentSizeSelected==1) {
        ok = YES;
        level=1;
    }
    else if (currentLevelSelected==1 && currentSizeSelected==2 && totalBottlesCollected > NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_1_SIZE_LARGE) {
        ok = YES;
        level=4;
    }
    else if (currentLevelSelected==1 && currentSizeSelected==3 && totalBottlesCollected > NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_1_SIZE_SUPER)  {
        ok = YES;
        level=7;
    }
    
    else if (currentLevelSelected==2 && currentSizeSelected==1 && totalBottlesCollected > NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_2_SIZE_REGULAR) {
        ok = YES;
        level=2;
    }
    else if (currentLevelSelected==2 && currentSizeSelected==2 && totalBottlesCollected > NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_2_SIZE_LARGE) {
        ok = YES;
        level=5;
    }
    else if (currentLevelSelected==2 && currentSizeSelected==3 && totalBottlesCollected > NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_2_SIZE_SUPER) {
        ok = YES;
        level=8;
    }
    else if (currentLevelSelected==3 && currentSizeSelected==1 && totalBottlesCollected > NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_3_SIZE_REGULAR) {
        ok = YES;
        level=3;
    }
    else if (currentLevelSelected==3 && currentSizeSelected==2 && totalBottlesCollected > NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_3_SIZE_LARGE) {
        ok = YES;
        level=6;
    }
    else if (currentLevelSelected==3 && currentSizeSelected==3 && totalBottlesCollected > NUMBER_OF_BOTTLES_TO_UNLOCK_LEVEL_3_SIZE_SUPER) {
        ok = YES;
        level=9;
    }
    
    if (ok) {
        [FlxG play:SndSelect];

        FlxG.level = level;
        FlxG.state = [[[OgmoLevelState alloc] init] autorelease];
        return;
    }
    else {
        
        [FlxG play:@"trick4.caf"];

    }
    
    

    
    
    
}


@end

