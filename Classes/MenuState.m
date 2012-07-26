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

#import "PlayState.h"

#import "OgmoLevelState.h"

#import "WorldSelectState.h"

#import "HelpState.h"

#import "OptionState.h"

#import "StatsState.h"

#import "IntroState.h"

#import "NavArrow.h"

static NSString * SndSelect = @"ping.caf";


static NSString * ImgBubble = @"bubble.png";

static NSString * ImgSugarBags = @"level1_leftSideMG.png";
static NSString * ImgShelves = @"L1_Shelf.png";

static NSString * ImgBgGrad = @"level1_bgSmoothGrad_new.png";
//static NSString * SndMusic = @"echo.mp3";

static NSString * ImgEmptyButtonS = @"superSmallButton.png";
static NSString * ImgEmptyButtonPressedS = @"superSmallButtonPressed.png";

static NSString * ImgEmptyButton = @"emptyButton.png";
static NSString * ImgEmptyButtonPressed = @"emptyButtonPressed.png";

static int toRate;
static int lastButtonBeforeMore;


static FlxEmitter * puffEmitter = nil;


FlxSprite * bgCity;
FlxSprite * bgClouds;

FlxText * title;





static int numberOfTimesSwipedLeft;
static int numberOfTimesSwipedRight;
FlxButton * play;
FlxSprite * sugarbags;
FlxSprite * shelves;
NavArrow * navArrow;

int cycles;
int konamiProgress;


BOOL justLaunched;

enum {
	MENU,
	ABOUT,
	PLAY,
};



@interface MenuState ()
//- (void) showMusic;
//- (void) hideMusic;
//- (void) move:(FlxObject *)obj toPoint:(CGPoint)pnt duration:(CGFloat)dur;
@end


@implementation MenuState

- (id) init
{
	if ((self = [super init])) {
		self.bgColor = 0xdbd0c2;
        toRate=0;
	}
	return self;
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        //NSLog(@"ok");
        

        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:1 forKey:@"HAS_RATED"];
        [prefs synchronize];

        toRate=1;

    }
    else if (buttonIndex == 1)
    {
        //NSLog(@"cancel");
        FlxG.hasRatedThisSession=YES;
    }
    
    else
    {
        //NSLog(@"NEVER");
        FlxG.hasRatedThisSession=YES;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:1 forKey:@"HAS_RATED"];
        [prefs synchronize];
    }
}

- (void) create
{

    
    //[FlxG checkAchievement:nil];
//    [FlxG logInToGameCenter];
    lastButtonBeforeMore=1;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger numOfPlays = [prefs integerForKey:@"NUMBER_OF_PLAYS"];
    NSInteger hasRated = [prefs integerForKey:@"HAS_RATED"];
    
//    NSLog(@"%d %d", numOfPlays, hasRated);

    //if (numOfPlays%5==4 && !hasRated && FlxG.hasRatedThisSession==NO) {
    if (NO) {

        UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: @"Please rate Super Lemonade Factory in the app store."
                                                        message: @"" 
                                                       delegate: self 
                                              cancelButtonTitle: @"Rate In App Store" 
                                              otherButtonTitles: @"No Thanks", 
                                                                 @"Don't ask again",
                                                                 nil] autorelease];
        [alert show]; 
    }
    
    
    NSInteger hc = [prefs integerForKey:@"HARDCORE_MODE"];
    if (!hc) {
        FlxG.hardCoreMode=0;

    }
    else if (hc) {
        FlxG.hardCoreMode=1;
        
    }   
    cycles=0;
    konamiProgress=0;
    
    numberOfTimesSwipedRight = 0;
//    if (justLaunched) {
    //[FlxG playMusicWithParam1:SndMusic param2:1];
//        justLaunched = NO;
//    }
    
    FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:320];  
    [grad loadGraphic:ImgBgGrad empties:0 autoTile:NO isSpeechBubble:0 isGradient:17];
    [self add:grad]; 
    
    int gibCount = 800;
    
    ge = [[FlxEmitter alloc] init];
    
    //ge.delay = 0.02;
    
    ge.minParticleSpeed = CGPointMake(-40,
                                      -40);
    ge.maxParticleSpeed = CGPointMake(40,
                                      40);
    
    ge.minRotation = 0;
    ge.maxRotation = 0;
    ge.gravity = -60;
    ge.particleDrag = CGPointMake(10, 10);
    
    ge.x = 0;
    ge.y = FlxG.height;
    ge.width = FlxG.width;
    ge.height = 2;
    
    puffEmitter = [ge retain];
    
    
    [self add:puffEmitter];
    
    
    
    [ge createSprites:ImgBubble quantity:gibCount bakedRotations:NO
             multiple:YES collide:0.0 modelScale:1.0];
    
    [ge startWithParam1:NO param2:0.05 param3:0.1 ];
    
    
    shelves = [FlxSprite spriteWithX:210 y:313 graphic:ImgShelves];
    shelves.x = FlxG.width-shelves.width;
    shelves.y = FlxG.height-shelves.height;;
    [self add:shelves];
    
    
    title = [FlxText textWithWidth:FlxG.width
                                         text:@"SUPER LEMONADE FACTORY"
                                         font:@"SmallPixel"
                                         size:16.0];
    title.color = 0xffffffff;
	title.alignment = @"center";
	title.x = 0;
	title.y = 8;
    title.shadow = 0x00000000;
    title.visible = YES;
	[self add:title];
    
    
    //button positions.
    
    float sy=130;
    float oy=190;
    float cy=250;
    if (FlxG.iPad) {
        sy=140;
        oy=210;
        cy=280;
    }
    
    playBtn = [[[FlxButton alloc] initWithX:FlxG.width/2-391
                                            y:70
                                     callback:[FlashFunction functionWithTarget:self
                                                                         action:@selector(onPlay)]] autorelease];
    playBtn.visible=NO;
    [playBtn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgEmptyButton] param2:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed]];
    [playBtn loadTextWithParam1:[FlxText textWithWidth:playBtn.width
                                          text:NSLocalizedString(@"factory floor", @"factory floor")
                                          font:@"SmallPixel"
                                                  size:16.0] param2:[FlxText textWithWidth:playBtn.width
                                                                                      text:NSLocalizedString(@"play game", @"play game")
                                                                                      font:@"SmallPixel"
                                                                                      size:16.0] withXOffset:3 withYOffset:playBtn.height/4] ;
	playBtn.velocity = CGPointMake(300, 0);
	playBtn.drag = CGPointMake(150, 150);
    playBtn.origin = CGPointMake(20, 20);
    
	
	[self add:playBtn];
	
	statsBtn = [[[FlxButton alloc] initWithX:FlxG.width/2-533-104+5+8
                                       y:sy
                                callback:[FlashFunction functionWithTarget:self
                                                                    action:@selector(onStats)]] autorelease];
    statsBtn.visible=NO;
    [statsBtn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgEmptyButton] param2:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed]];
    [statsBtn loadTextWithParam1:[FlxText textWithWidth:playBtn.width
                                                  text:NSLocalizedString(@"output ratio", @"output ratio")
                                                  font:@"SmallPixel"
                                                  size:16.0] param2:[FlxText textWithWidth:playBtn.width
                                                                                      text:NSLocalizedString(@"statisitics", @"statistics")
                                                                                      font:@"SmallPixel"
                                                                                      size:16.0] withXOffset:0 withYOffset:playBtn.height/4] ;
	statsBtn.velocity = CGPointMake(400, 0);
	statsBtn.drag = CGPointMake(150, 150);
	
	[self add:statsBtn];
	
	optionsBtn = [[[FlxButton alloc] initWithX:FlxG.width/2-533-104-267-20
                                            y:oy
                                     callback:[FlashFunction functionWithTarget:self
                                                                         action:@selector(onOptions)]] autorelease];
    optionsBtn.visible=NO;
    [optionsBtn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgEmptyButton] param2:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed]];
    [optionsBtn loadTextWithParam1:[FlxText textWithWidth:playBtn.width
                                                   text:NSLocalizedString(@"customer service", @"customer service")
                                                   font:@"SmallPixel"
                                                   size:16.0] param2:[FlxText textWithWidth:playBtn.width
                                                                                       text:NSLocalizedString(@"help", @"help")
                                                                                       font:@"SmallPixel"
                                                                                       size:16.0] withXOffset:0 withYOffset:playBtn.height/4] ;
	optionsBtn.velocity = CGPointMake(500, 0);
	optionsBtn.drag = CGPointMake(150, 150);
	
	[self add:optionsBtn];
    
	creditsBtn = [[[FlxButton alloc] initWithX:FlxG.width/2-533-104-620-43+9
                                             y:cy
                                      callback:[FlashFunction functionWithTarget:self
                                                                          action:@selector(onCredits)]] autorelease];
    creditsBtn.visible=NO;
    [creditsBtn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgEmptyButton] param2:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed]];
    [creditsBtn loadTextWithParam1:[FlxText textWithWidth:playBtn.width
                                                   text:NSLocalizedString(@"ingredients", @"ingredients")
                                                   font:@"SmallPixel"
                                                   size:16.0] param2:[FlxText textWithWidth:playBtn.width
                                                                                       text:NSLocalizedString(@"credits", @"credits")
                                                                                       font:@"SmallPixel"
                                                                                       size:16.0] withXOffset:0 withYOffset:playBtn.height/4] ;
	creditsBtn.velocity = CGPointMake(600, 0);
	creditsBtn.drag = CGPointMake(150, 150);
	
	[self add:creditsBtn];
    
    
    moreBtn = [[[FlxButton alloc] initWithX:FlxG.width+50
                                             y:cy
                                      callback:[FlashFunction functionWithTarget:self
                                                                          action:@selector(onMore)]] autorelease];
    moreBtn.visible=NO;
    [moreBtn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgEmptyButtonS] param2:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressedS] param3:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressedS]];
    [moreBtn loadTextWithParam1:[FlxText textWithWidth:62
                                                     text:NSLocalizedString(@"more", @"more")
                                                     font:@"SmallPixel"
                                                     size:16.0] param2:[FlxText textWithWidth:62
                                                                                         text:NSLocalizedString(@"more", @"more")
                                                                                         font:@"SmallPixel"
                                                                                         size:16.0] withXOffset:0 withYOffset:playBtn.height/4] ;	
    moreBtn.velocity = CGPointMake(-200, 0);
	moreBtn.drag = CGPointMake(150, 150);
	[self add:moreBtn];
    
    
    
    rateBtn = [[[FlxButton alloc] initWithX:FlxG.width/2-182/2
                                          y:70
                                   callback:[FlashFunction functionWithTarget:self
                                                                       action:@selector(onRate)]] autorelease];
    rateBtn.visible=NO;
    [rateBtn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgEmptyButton] param2:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed]];
    [rateBtn loadTextWithParam1:[FlxText textWithWidth:playBtn.width
                                                  text:NSLocalizedString(@"rate app", @"rate app")
                                                  font:@"SmallPixel"
                                                  size:16.0] param2:[FlxText textWithWidth:playBtn.width
                                                                                      text:NSLocalizedString(@"rate app", @"rate app")
                                                                                      font:@"SmallPixel"
                                                                                      size:16.0] withXOffset:3 withYOffset:playBtn.height/4] ;
    
	
	[self add:rateBtn];


	twitterBtn = [[[FlxButton alloc] initWithX:FlxG.width/2-182/2
                                           y:sy
                                    callback:[FlashFunction functionWithTarget:self
                                                                        action:@selector(onTwitter)]] autorelease];
    twitterBtn.visible=NO;
    [twitterBtn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgEmptyButton] param2:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed]];
    [twitterBtn loadTextWithParam1:[FlxText textWithWidth:playBtn.width
                                                   text:NSLocalizedString(@"twitter", @"twitter")
                                                   font:@"SmallPixel"
                                                   size:16.0] param2:[FlxText textWithWidth:playBtn.width
                                                                                       text:NSLocalizedString(@"twitter", @"twitter")
                                                                                       font:@"SmallPixel"
                                                                                       size:16.0] withXOffset:0 withYOffset:playBtn.height/4] ;

	
	[self add:twitterBtn];
    

	facebookBtn = [[[FlxButton alloc] initWithX:FlxG.width/2-182/2
                                             y:oy
                                      callback:[FlashFunction functionWithTarget:self
                                                                          action:@selector(onFacebook)]] autorelease];
    facebookBtn.visible=NO;
    [facebookBtn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgEmptyButton] param2:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed]];
    [facebookBtn loadTextWithParam1:[FlxText textWithWidth:playBtn.width
                                                     text:NSLocalizedString(@"facebook", @"facebook")
                                                     font:@"SmallPixel"
                                                     size:16.0] param2:[FlxText textWithWidth:playBtn.width
                                                                                         text:NSLocalizedString(@"facebook", @"facebook")
                                                                                         font:@"SmallPixel"
                                                                                         size:16.0] withXOffset:0 withYOffset:playBtn.height/4] ;
	
	[self add:facebookBtn];
    
	soundtrackBtn = [[[FlxButton alloc] initWithX:FlxG.width/2-182/2
                                             y:cy
                                      callback:[FlashFunction functionWithTarget:self
                                                                          action:@selector(onSoundtrack)]] autorelease];
    soundtrackBtn.visible=NO;
    [soundtrackBtn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgEmptyButton] param2:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed]];
    [soundtrackBtn loadTextWithParam1:[FlxText textWithWidth:playBtn.width
                                                     text:NSLocalizedString(@"soundtrack", @"soundtrack")
                                                     font:@"SmallPixel"
                                                     size:16.0] param2:[FlxText textWithWidth:playBtn.width
                                                                                         text:NSLocalizedString(@"soundtrack", @"soundtrack")
                                                                                         font:@"SmallPixel"
                                                                                         size:16.0] withXOffset:0 withYOffset:playBtn.height/4] ;

	
	[self add:soundtrackBtn];
    
    
    
    
    
    
    
    
    
//	FlxButton * achBtn = [[[FlxButton alloc] initWithX:FlxG.width/2
//                                                     y:FlxG.height-30
//                                      callback:[FlashFunction functionWithTarget:self
//                                                                          action:@selector(onAch)]] autorelease];
//    [achBtn loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgEmptyButton] param2:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed]];
//    [achBtn loadTextWithParam1:[FlxText textWithWidth:playBtn.width
//                                                     text:NSLocalizedString(@"achievements", @"achievements")
//                                                     font:@"SmallPixel"
//                                                     size:16.0] param2:[FlxText textWithWidth:playBtn.width
//                                                                                         text:NSLocalizedString(@"achievements", @"achievements")
//                                                                                         font:@"SmallPixel"
//                                                                                         size:16.0] withXOffset:0 withYOffset:playBtn.height/4] ;
//
//	[self add:achBtn];    
    
    
//    if (FlxG.iPad) {
//        //70, 130, 190, 250
//        //new
//        //70, 140, 210, 280
//        statsBtn.y=140;
//        optionsBtn.y = 210;
//        creditsBtn.y = 280;
//    }
    
    
    sugarbags = [FlxSprite spriteWithX:153 y:128 graphic:ImgSugarBags];
    sugarbags.x = 0;
    sugarbags.y = FlxG.height-sugarbags.height;
    [self add:sugarbags];
    
    navArrow = [NavArrow navArrowWithOrigin:CGPointMake(0, 0)];
    [self add:navArrow]; 
    
    navArrow.currentValue=1;
    navArrow.maxValue=5;
    
    navArrow.loc1=CGPointMake(rateBtn.x-navArrow.width, rateBtn.y+navArrow.height/2);
    navArrow.loc2=CGPointMake(twitterBtn.x-navArrow.width, twitterBtn.y+navArrow.height/2);
    navArrow.loc3=CGPointMake(facebookBtn.x-navArrow.width, facebookBtn.y+navArrow.height/2);
    navArrow.loc4=CGPointMake(soundtrackBtn.x-navArrow.width, soundtrackBtn.y+navArrow.height/2);
    navArrow.loc5=CGPointMake(FlxG.width-90, cy+navArrow.height/2);
    
    if (FlxG.gamePad==0) {
        navArrow.visible=NO;
        playBtn._selected=NO;
    } 
    else {
        playBtn._selected=YES;
        statsBtn._selected=NO;
        optionsBtn._selected=NO;
        creditsBtn._selected=NO;
        moreBtn._selected=NO;
        rateBtn._selected=NO;
        twitterBtn._selected=NO;
        facebookBtn._selected=NO;
        soundtrackBtn._selected=NO;
    }
    
//    if (FlxG.gamePad!=0) {
//        playBtn.velocity=CGPointMake(0, 0);
//        playBtn.x=FlxG.width/2-182/2;
//        playBtn.visible=YES;
//        
//        optionsBtn.visible=YES;
//        optionsBtn.velocity=CGPointMake(0, 0);
//        optionsBtn.x=FlxG.width/2-182/2;
//        
//        statsBtn.visible=YES;
//        statsBtn.velocity=CGPointMake(0, 0);
//        statsBtn.x=FlxG.width/2-182/2;
//        
//        creditsBtn.visible=YES; 
//        creditsBtn.velocity=CGPointMake(0, 0);
//        creditsBtn.x=FlxG.width/2-182/2;
//        
//        rateBtn.visible=NO;
//        facebookBtn.visible=NO;
//        twitterBtn.visible=NO;
//        soundtrackBtn.visible=NO;
//        
//    }
    
    
    FlxG.touches.humanControlled=YES;
    
    NSInteger LAX, LAY, RAX, RAY, B1X, B1Y, B2X, B2Y;
        
//    if (FlxG.iPad) {
//         LAX = [prefs integerForKey:@"LEFT_ARROW_POSITION_X_IPAD"];
//         LAY = [prefs integerForKey:@"LEFT_ARROW_POSITION_Y_IPAD"];
//         RAX = [prefs integerForKey:@"RIGHT_ARROW_POSITION_X_IPAD"];
//         RAY = [prefs integerForKey:@"RIGHT_ARROW_POSITION_Y_IPAD"];
//        
//         B1X = [prefs integerForKey:@"BUTTON_1_POSITION_X_IPAD"];
//         B1Y = [prefs integerForKey:@"BUTTON_1_POSITION_Y_IPAD"];
//         B2X = [prefs integerForKey:@"BUTTON_2_POSITION_X_IPAD"];
//         B2Y = [prefs integerForKey:@"BUTTON_2_POSITION_Y_IPAD"];
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
    
    
    FlxG.leftArrowPosition = CGPointMake(LAX, LAY);
    FlxG.rightArrowPosition = CGPointMake(RAX, RAY);
    FlxG.button1Position = CGPointMake(B1X, B1Y);
    FlxG.button2Position = CGPointMake(B2X, B2Y);
    
    //NSLog(@"%f %f", FlxG.leftArrowPosition.x, FlxG.leftArrowPosition.y);
    
    
//    [FlxG levelProgressWarehouse];
//    [FlxG levelProgressFactory];
//    [FlxG levelProgressManagement];
//    [FlxG levelProgress];
//    
//    [FlxG hclevelProgressWarehouse];
//    [FlxG hclevelProgressFactory];
//    [FlxG hclevelProgressManagement]; 
//    [FlxG hclevelProgress];
    
    
		
}

- (void) dealloc
{
	//[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}


- (void) update
{
    //NSLog(@"%f", playBtn.x);
    
//    if (FlxG.touches.swipedUp || FlxG.touches.swipedDown || FlxG.touches.swipedLeft || FlxG.touches.swipedRight) 
//        NSLog(@"u%d, d%d, l%d, r%d", FlxG.touches.swipedUp,FlxG.touches.swipedDown,FlxG.touches.swipedLeft,FlxG.touches.swipedRight);
    
    if (toRate==1) {
        
        //NSString* url = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=481170364&mt=8";
        
        //[[UIApplication sharedApplication] openURL: [NSURL URLWithString: url ]];
        
        //[FlxU openURL:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=481170364&mt=8"];
        
        [self onRate];
        
        toRate=0;
        
    }
    if (cycles>0 && cycles<3){
        playBtn.visible=YES;
        optionsBtn.visible=YES;
        statsBtn.visible=YES;
        creditsBtn.visible=YES;
        moreBtn.visible=YES;

    }
    cycles++;
    
    
    //DEBUG STUFF TO BE TAKEN OUT
    
//    if (FlxG.touches.swipedUp) {
//        numberOfTimesSwipedRight++;
//        [FlxG playWithParam1:@"ping2.caf" param2:PING_VOL param3:NO ];
//    }
//    if (numberOfTimesSwipedRight>4) {
//        [FlxG playWithParam1:@"tagtone2.caf" param2:0.5 param3:NO];
//        
//        [FlxG pauseMusic];
//        numberOfTimesSwipedRight=0;
//        FlxG.debugMode=YES;
//        title.text = @"SUP3R L!MON@D3 F&C*0RY D3BUG M0D3";
//        [[FlxG quake] startWithIntensity:0.05 duration:0.8];
//    }
//    if (FlxG.touches.swipedDown) {
//        [FlxG play:@"error"];
//
//        FlxG.debugMode=NO;
//        title.text = @"SUPER LEMONADE FACTORY";
//
//    }
    
    //END DEBUG STUFF
    
    //KONAMI CODE
    
    //RIGHT 5 + 7
    if (FlxG.touches.swipedRight || FlxG.touches.iCadeRightBegan) {
        if (konamiProgress==5 || konamiProgress==7) {
            konamiProgress++;
        }
        else {
            konamiProgress=0;
        }
    }
    //LEFT 4 + 6
    if (FlxG.touches.swipedLeft || FlxG.touches.iCadeLeftBegan) {
        if (konamiProgress==4 || konamiProgress==6) {
            konamiProgress++;
        }
        else {
            konamiProgress=0;
        }
    }
    //UP 0 + 1
    if (FlxG.touches.swipedUp  || FlxG.touches.iCadeUpBegan) {
        if (konamiProgress==0 || konamiProgress==1) {
            konamiProgress++;
        }
        else {
            konamiProgress=0;
        }
    }
    //DOWN 2 + 3
    if (FlxG.touches.swipedDown || FlxG.touches.iCadeDownBegan) {
        if (konamiProgress==2 || konamiProgress==3) {
            konamiProgress++;
        }
        else {
            konamiProgress=0;
        }
    }
    // [A] 9
    if ( (FlxG.touches.vcpButton1 && FlxG.touches.newTouch)  || FlxG.touches.iCadeXBegan) {
        if (konamiProgress==9) {
            konamiProgress++;
        }
        else {
            konamiProgress=0;
        }
    }
    // [B] 8
    if ( (FlxG.touches.vcpButton2 && FlxG.touches.newTouch) || FlxG.touches.iCadeYBegan){
        if (konamiProgress==8) {
            konamiProgress++;
        }
        else {
            konamiProgress=0;
        }
    }
    if (konamiProgress==10) {
        
        //FlxG.debugMode=YES;

        [FlxG playWithParam1:@"tagtone2.caf" param2:0.5 param3:NO];
        [[FlxG quake] startWithIntensity:0.02 duration:0.8];
        konamiProgress=0;
        //title.text = @"SUP3R L!MON@D3 F&C*0RY D3BUG M0D3";
        [FlxG pauseMusic];
        [FlxG showAlertWithTitle:@"Sorry" message:@"Debug Mode has been removed"];
        
    }
//    if (FlxG.touches.swipedDown && FlxG.debugMode==YES) {
//        [FlxG play:@"error.caf"];
//        FlxG.debugMode=NO;
//        title.text = @"SUPER LEMONADE FACTORY";
//        
//    }
    
    
//    NSLog(@"konami code %d", konamiProgress);
    
    
    if (FlxG.touches.iCadeDownBegan ) {
        [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];
        
        navArrow.currentValue++;
        lastButtonBeforeMore=navArrow.currentValue;
    }
    else if (FlxG.touches.iCadeUpBegan ) {
        [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];

        navArrow.currentValue--;
        lastButtonBeforeMore=navArrow.currentValue;

    }    
    else if (FlxG.touches.iCadeRightBegan) {
        [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];

        if (navArrow.currentValue!=5){
            navArrow.currentValue=5;
        }
        else {
            navArrow.currentValue=lastButtonBeforeMore;  
        }
    }
    else if (FlxG.touches.iCadeLeftBegan) {
        [FlxG playWithParam1:@"joy.caf" param2:JOY_VOL param3:NO];

        if (navArrow.currentValue==5){
            navArrow.currentValue=lastButtonBeforeMore;
        }
        else {
            navArrow.currentValue=5;  
        }    
    }
    
    if (FlxG.gamePad!=0) {
        switch (navArrow.currentValue) {
            case 1:
                if (playBtn.visible) {
                    playBtn._selected=YES;
                    statsBtn._selected=NO;
                    optionsBtn._selected=NO;
                    creditsBtn._selected=NO;
                    moreBtn._selected=NO;
                    rateBtn._selected=NO;
                    twitterBtn._selected=NO;
                    facebookBtn._selected=NO;
                    soundtrackBtn._selected=NO;
                }
                else {
                    playBtn._selected=NO;
                    statsBtn._selected=NO;
                    optionsBtn._selected=NO;
                    creditsBtn._selected=NO;
                    moreBtn._selected=NO;
                    rateBtn._selected=YES;
                    twitterBtn._selected=NO;
                    facebookBtn._selected=NO;
                    soundtrackBtn._selected=NO;
                }
                break;
            case 2:
                if (playBtn.visible) {
                    playBtn._selected=NO;
                    statsBtn._selected=YES;
                    optionsBtn._selected=NO;
                    creditsBtn._selected=NO;
                    moreBtn._selected=NO;
                    rateBtn._selected=NO;
                    twitterBtn._selected=NO;
                    facebookBtn._selected=NO;
                    soundtrackBtn._selected=NO;
                }
                else {
                    playBtn._selected=NO;
                    statsBtn._selected=NO;
                    optionsBtn._selected=NO;
                    creditsBtn._selected=NO;
                    moreBtn._selected=NO;
                    rateBtn._selected=NO;
                    twitterBtn._selected=YES;
                    facebookBtn._selected=NO;
                    soundtrackBtn._selected=NO;
                }
                break; 
            case 3:
                if (playBtn.visible) {
                    playBtn._selected=NO;
                    statsBtn._selected=NO;
                    optionsBtn._selected=YES;
                    creditsBtn._selected=NO;
                    moreBtn._selected=NO;
                    rateBtn._selected=NO;
                    twitterBtn._selected=NO;
                    facebookBtn._selected=NO;
                    soundtrackBtn._selected=NO;
                }
                else {
                    playBtn._selected=NO;
                    statsBtn._selected=NO;
                    optionsBtn._selected=NO;
                    creditsBtn._selected=NO;
                    moreBtn._selected=NO;
                    rateBtn._selected=NO;
                    twitterBtn._selected=NO;
                    facebookBtn._selected=YES;
                    soundtrackBtn._selected=NO;
                }
                break; 
            case 4:
                if (playBtn.visible) {
                    playBtn._selected=NO;
                    statsBtn._selected=NO;
                    optionsBtn._selected=NO;
                    creditsBtn._selected=YES;
                    moreBtn._selected=NO;
                    rateBtn._selected=NO;
                    twitterBtn._selected=NO;
                    facebookBtn._selected=NO;
                    soundtrackBtn._selected=NO;
                }
                else {
                    playBtn._selected=NO;
                    statsBtn._selected=NO;
                    optionsBtn._selected=NO;
                    creditsBtn._selected=NO;
                    moreBtn._selected=NO;
                    rateBtn._selected=NO;
                    twitterBtn._selected=NO;
                    facebookBtn._selected=NO;
                    soundtrackBtn._selected=YES;
                }
                break; 
            case 5:
                playBtn._selected=NO;
                statsBtn._selected=NO;
                optionsBtn._selected=NO;
                creditsBtn._selected=NO;
                moreBtn._selected=YES;
                rateBtn._selected=NO;
                twitterBtn._selected=NO;
                facebookBtn._selected=NO;
                soundtrackBtn._selected=NO;
                break; 
            default:
                break;
        }
    }
    
    
    
    
    if ( FlxG.touches.iCadeABegan) {
        
        if (navArrow.currentValue==1) {
            if (playBtn.visible) {
                [self onPlay];


            }
            else {
                [self onRate];
            }
        }
        else if (navArrow.currentValue==2) {
            if (statsBtn.visible) {
                [self onStats];

                
            }
            else {
                [self onTwitter];
            }
            
        }
        else if (navArrow.currentValue==3) {
            if (optionsBtn.visible) {
                [self onOptions];

            }
            else {
                [self onFacebook];
            }
            
        }
        else if (navArrow.currentValue==4) {
            if (creditsBtn.visible) {
                [self onCredits];

            }
            else {
                [self onSoundtrack];
            } 
        }
        else if (navArrow.currentValue==5) {
            [self onMore];

        }
    }    

	[super update];
    
//    if (FlxG.touches.screenTouchBeganPoint.x < 20 && FlxG.touches.screenTouchBeganPoint.y < 20 && FlxG.touches.touchesBegan) {
//        FlxG.state = [[[IntroState alloc] init] autorelease];
//        return;
//    }
    
	
}




- (void) onPlay
{
    [FlxG playWithParam1:SndSelect param2:PING_VOL param3:NO];

    FlxG.level = 1;
	FlxG.state = [[[WorldSelectState alloc] init] autorelease];
    return;

}

- (void) onStats
{
    [FlxG playWithParam1:SndSelect param2:PING_VOL param3:NO];

    FlxG.level = 1;
	FlxG.state = [[[StatsState alloc] init] autorelease];
    return;
    
}

- (void) onCredits
{
    [FlxG playWithParam1:SndSelect param2:PING_VOL param3:NO];

    FlxG.level = 1;
	FlxG.state = [[[HelpState alloc] init] autorelease];
    return;
    
}

- (void) onOptions
{
    [FlxG playWithParam1:SndSelect param2:PING_VOL param3:NO];

    FlxG.level = 1;
	FlxG.state = [[[OptionState alloc] init] autorelease];
    return;
    
}


- (void) onMore
{
    [FlxG playWithParam1:SndSelect param2:PING_VOL param3:NO];
    
    if (playBtn.visible==YES) {
        playBtn.visible=NO;
        optionsBtn.visible=NO;
        statsBtn.visible=NO;
        creditsBtn.visible=NO;  
        rateBtn.visible=YES;
        facebookBtn.visible=YES;
        twitterBtn.visible=YES;
        soundtrackBtn.visible=YES;

    }
    else {
        
        playBtn.velocity=CGPointMake(0, 0);
        playBtn.x=FlxG.width/2-182/2;
        playBtn.visible=YES;
        
        optionsBtn.visible=YES;
        optionsBtn.velocity=CGPointMake(0, 0);
        optionsBtn.x=FlxG.width/2-182/2;
        
        statsBtn.visible=YES;
        statsBtn.velocity=CGPointMake(0, 0);
        statsBtn.x=FlxG.width/2-182/2;
        
        creditsBtn.visible=YES; 
        creditsBtn.velocity=CGPointMake(0, 0);
        creditsBtn.x=FlxG.width/2-182/2;
        
        rateBtn.visible=NO;
        facebookBtn.visible=NO;
        twitterBtn.visible=NO;
        soundtrackBtn.visible=NO;
    }
    
}
- (void) onRate
{
    [FlxU openURL:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=481170364&mt=8"];

}

- (void) onTwitter {
    [FlxU openURL:@"http://www.twitter.com/initials_games/"];

}
- (void) onFacebook{
    [FlxU openURL:@"http://www.facebook.com/pages/Super-Lemonade-Factory/308694105837846"];

}
- (void) onSoundtrack{
    [FlxU openURL:@"http://easyname.bandcamp.com/album/megacannon"];

}



@end

