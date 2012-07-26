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
#import "OgmoRevCinematicState.h"
#import "OptionState.h"

int f1,f2,f3,f4,f5,f6,f7,f8;
BOOL beginFade;
int frameLimit;

BOOL hasTalkedToArmy;
BOOL hasTalkedToChef;
BOOL hasTalkedToInspector;
BOOL hasTalkedToInspector2;

BOOL hasTalkedToWorker;

@implementation OgmoRevCinematicState

- (id) init
{
	if ((self = [super init])) {
		self.bgColor = 0xff35353d;
        
	}
	return self;
}



- (void) create
{       
    
    
    speechBubbleTextValues = [[NSArray alloc] initWithObjects:
                              @"In the uncertainty following World War II, Andre and Liselot received a telegram from Andre's father asking the newlyweds to come to the capital.\n \n", // - Notepad (Narrator) - 0
                              @"Andre's father would be retiring, and leaving the entire factory to Andre and Liselot, provided they can make it through the whole factory.\n \n", // - Notepad (Narrator) - 1
                              @"Each room in this factory serves an important role. Navigate the entire factory, and the whole operation will belong to you.\n \n", // - Notepad (Narrator) - 2
                              @"I knew your father but I don't know you. You must earn my trust.\n \n", // Army General - 3
                              @"Hey buddy, I haven't seen you since you were knee high.\n \n", //Chef - 4
                              @"I'll be around the factory, checking it's up to code.\n \n", //Inspector - 5
                              @"I fix things around here. You'll see me around.\n \n", //Worker - 6
                              @"The factory is the heart of the operations. Heavy, pressurized vats carbonate the sugary drinks.\n \n", // - Notepad (Narrator) - 7
                              @"The steam and heat down here is oppressive.\n \n",// - Notepad (Narrator) - 8
                              @"Our operations could use supplies manufactured here.\n \n", // Army General - 9
                              @"What do you think about making a durian flavored soft drink?\n \n", //Chef - 10
                              @"One speck of dirt and I will bury you...\n \n", //Inspector - 11
                              @"If you see any problems, I can help.\n \n", //Worker - 12
                              @"The management office is on the top floor of the building. The views over the harbor are impressive.\n \n", // - Notepad (Narrator) - 13
                              @"Making it to the end will earn\nyou the right to own the\nSuper Lemonade Factory.\n \n",// - Notepad (Narrator) - 14
                              @"We have drawn up contracts for you to supply the army. Will you accept?\n \n", // Army General - 15
                              @"The durian soft drink flavor has been a success!\n \n", // Chef - 16
                              @"One... uhh... speck of ... dirt.\n \n", //Inspector - 17
                              @"So this is how the one percent work. This is extravagant.\n \n", //Worker - 18
                              @"...in paperwork.\n \n", //19 inspector
                              nil];
    

    hasTalkedToArmy=NO;
    hasTalkedToChef=NO;
    hasTalkedToInspector=NO;
    hasTalkedToInspector2=NO;
    hasTalkedToWorker=NO;
    
    
    //[FlxG setMaxElapsed:0.01];
    frameLimit=350;

    
    //
    // ARE WE RECORDING OR PLAYBACK
    //
    
    recording=NO;
    
    
    beginFade=NO;
    
    frameNumber=0;
    

    
    
    [super create];
    
    isGameCompleteState=YES;
    
    buttonA.visible=NO;
    buttonB.visible=NO;
    buttonLeft.visible=NO;
    buttonRight.visible=NO;
    FlxG.touches.humanControlled=NO;
    pauseGraphic.visible=NO;
    
    [FlxG setMaxElapsed:0.0285];
    
    liselot.isPlayerControlled=NO;
    player.isPlayerControlled=NO;
    
    liselot.cutSceneMode=YES;

    
    //player.jumpTimer=0.45; // 0.34
    
    
    [FlxG playMusicWithParam1:@"farewell.mp3" param2:0.5];
    
    

    
    
    
    notepadx = [FlxTileblock tileblockWithX:20 y:100 width:FlxG.width-40 height:100];  
    [notepadx loadGraphic:@"notepadTiles.png" empties:0 autoTile:YES];
    notepadx.visible=NO;
    notepadx.scrollFactor  = CGPointMake(0, 0);
    [self add:notepadx];
    
    notepadTextx = [FlxText textWithWidth:FlxG.width-48
                                          text:@" "
                                          font:@"Flixel"
                                          size:16.0];
    notepadTextx.color = 0x00000000;
	notepadTextx.alignment = @"center";
	notepadTextx.x = notepadx.x+8;
	notepadTextx.y = notepadx.y;
    notepadTextx.shadow = 0x00000000;
    notepadTextx.visible = NO;
    notepadTextx.scrollFactor = CGPointMake(0, 0);
	[self add:notepadTextx];
    
    
    speechBubblex = [FlxTileblock tileblockWithX:40 y:180 width:380 height:60];  
    [speechBubblex loadGraphic:@"speechBubbleTiles.png" empties:0 autoTile:NO isSpeechBubble:22];
    speechBubblex.visible=NO;
    speechBubblex.scrollFactor  = CGPointMake(1, 1);
    [self add:speechBubblex];
    
    speechBubbleTextx = [FlxText textWithWidth:376
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
    
    enemyArmy = [EnemyGeneric enemyGenericWithOrigin:CGPointMake(1400, 240) index:0 ];
    enemyArmy.scale = CGPointMake(-1, 1);
    [self add:enemyArmy];
    [enemyArmy play:@"armyListen"];
    
    enemyChef = [EnemyGeneric enemyGenericWithOrigin:CGPointMake(1600, 240) index:1  ];
    enemyChef.scale = CGPointMake(-1, 1);
    [self add:enemyChef];
    [enemyChef play:@"chefListen"];
    
    enemyInspector = [EnemyGeneric enemyGenericWithOrigin:CGPointMake(1800, 240) index:2  ];
    enemyInspector.scale = CGPointMake(-1, 1);
    [self add:enemyInspector];
    [enemyInspector play:@"inspectorListen"];
    
    enemyWorker = [EnemyGeneric enemyGenericWithOrigin:CGPointMake(2000,240) index:3  ];
    enemyWorker.scale = CGPointMake(-1, 1);
    [self add:enemyWorker];
    [enemyWorker play:@"workerListen"];
    
    enemyArmy.alpha=0;
    enemyWorker.alpha=0;
    enemyChef.alpha=0;
    enemyInspector.alpha=0;
    
    
    
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
    
    enemyArmy.velocity=CGPointMake(-100,0);
    enemyChef.velocity=CGPointMake(-100,0);
    enemyInspector.velocity=CGPointMake(-100,0);
    enemyWorker.velocity=CGPointMake(-100,0);
    
    FlxG.restartMusic=YES;
    
    navArrow.visible=NO;
    
    
}

- (void) dealloc
{   
    
    
    [super dealloc];
}



- (void) update
{      
    

       
    player.velocity=CGPointMake(100,0);
    liselot.velocity=CGPointMake(101,0);


        
        
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
    
    
    //level 1 - 101 - events
    if (FlxG.level==101) {
        if (frameNumber==50) {
            paused=YES;
            
            [self notepad];
            notepadTextx.text = [speechBubbleTextValues objectAtIndex:0];
            
            [FlxG play:@"notepad0.caf"];
            frameNumber++;
            
        }
        
        else if (frameNumber==60) {
            paused=YES;
            
            [self notepad];
            notepadTextx.text=[speechBubbleTextValues objectAtIndex:1];
            
            [FlxG play:@"notepad1.caf"];
            frameNumber++;
        }

        else if (frameNumber==70) {
            paused=YES;
            
            [self notepad];
            notepadTextx.text=[speechBubbleTextValues objectAtIndex:2];
            
            [FlxG play:@"notepad2.caf"];
            frameNumber++;
            
        }
        
        
        else if (enemyArmy.x < player.x+ 70 && !hasTalkedToArmy) {
            paused=YES;

            [self talkTo:enemyArmy];
            speechBubbleTextx.text=[speechBubbleTextValues objectAtIndex:3];
            
            [FlxG play:@"army1.caf"];
            frameNumber++;
            
            //must put this last.
            hasTalkedToArmy=YES;
            

            

        }
        
        else if (enemyChef.x < player.x+ 70 && !hasTalkedToChef) {
            paused=YES;
            
            [self talkTo:enemyChef];
            speechBubbleTextx.text=[speechBubbleTextValues objectAtIndex:4];
            
            [FlxG play:@"chef1.caf"];
            frameNumber++;
            
            //must put this last.
            hasTalkedToChef=YES;
            


        }
        
        else if (enemyInspector.x < player.x+ 70 && !hasTalkedToInspector) {
            paused=YES;
            
            [self talkTo:enemyInspector];
            speechBubbleTextx.text=[speechBubbleTextValues objectAtIndex:11];
            [FlxG play:@"inspector4.caf"];
            frameNumber++;
            //must put this last.
            hasTalkedToInspector=YES;
            
        }
        
        else if (enemyInspector.x < player.x+ 60 && !hasTalkedToInspector2) {
            paused=YES;
            
            [self talkTo:enemyInspector];
            speechBubbleTextx.text=[speechBubbleTextValues objectAtIndex:19];
            
            [FlxG play:@"inspector5.caf"];
            frameNumber++;
            
            //must put this last.
            hasTalkedToInspector2=YES;
        }
        
        
        

        

        
        else if (enemyWorker.x < player.x+ 70 && !hasTalkedToWorker) {
            paused=YES;
            
            [self talkTo:enemyWorker];
            speechBubbleTextx.text=[speechBubbleTextValues objectAtIndex:6];
            
            [FlxG play:@"worker1.caf"];
            frameNumber++;
            
            //must put this last.
            hasTalkedToWorker=YES;
            


        }
    }
    
    //level 2 - 113 - events
    if (FlxG.level==113) {
        if (frameNumber==50) {
            paused=YES;
            
            [self notepad];
            notepadTextx.text=[speechBubbleTextValues objectAtIndex:7];
            
            [FlxG play:@"notepad3.caf"];
            frameNumber++;
            
        }
        
        else if (frameNumber==60) {
            paused=YES;
            
            [self notepad];
            notepadTextx.text=[speechBubbleTextValues objectAtIndex:8];
            
            [FlxG play:@"notepad4.caf"];
            frameNumber++;
            
        }
        
        
        else if (enemyArmy.x < player.x+ 70 && !hasTalkedToArmy) {
            paused=YES;
            
            [self talkTo:enemyArmy];
            speechBubbleTextx.text=[speechBubbleTextValues objectAtIndex:9];
            
            [FlxG play:@"army2.caf"];
            frameNumber++;
            
            
            //must put this last.
            hasTalkedToArmy=YES;
            
        }
        
        else if (enemyChef.x < player.x+ 70 && !hasTalkedToChef) {
            paused=YES;
            
            [self talkTo:enemyChef];
            speechBubbleTextx.text=[speechBubbleTextValues objectAtIndex:10];
            [FlxG play:@"chef2.caf"];
            frameNumber++;
            //must put this last.
            hasTalkedToChef=YES;
            
        }
        
        else if (enemyInspector.x < player.x+ 70 && !hasTalkedToInspector) {
            paused=YES;
            
            [self talkTo:enemyInspector];
            speechBubbleTextx.text=[speechBubbleTextValues objectAtIndex:5];
            
            [FlxG play:@"inspector1.caf"];
            frameNumber++;
            
            //must put this last.
            hasTalkedToInspector=YES;
            hasTalkedToInspector2=YES;
        }
        
        else if (enemyWorker.x < player.x+ 70 && !hasTalkedToWorker) {
            paused=YES;
            
            [self talkTo:enemyWorker];
            speechBubbleTextx.text=[speechBubbleTextValues objectAtIndex:12];
            
            [FlxG play:@"worker2.caf"];
            frameNumber++;
            
            //must put this last.
            hasTalkedToWorker=YES;
            
        }
    }
    
    //level 3 - 125 - events
    if (FlxG.level==125) {
        if (frameNumber==50) {
            paused=YES;
            
            [self notepad];
            notepadTextx.text=[speechBubbleTextValues objectAtIndex:13];
            
            [FlxG play:@"notepad5.caf"];
            frameNumber++;
            
        }
        
        else if (frameNumber==60) {
            paused=YES;
            
            [self notepad];
            notepadTextx.text=[speechBubbleTextValues objectAtIndex:14];
            [FlxG play:@"notepad7.caf"];
            frameNumber++;
        }
        
        
        else if (enemyArmy.x < player.x+ 70 && !hasTalkedToArmy) {
            paused=YES;
            
            [self talkTo:enemyArmy];
            speechBubbleTextx.text=[speechBubbleTextValues objectAtIndex:15];
            [FlxG play:@"army3.caf"];
            frameNumber++;
            //must put this last.
            hasTalkedToArmy=YES;
        }
        
        else if (enemyChef.x < player.x+ 70 && !hasTalkedToChef) {
            paused=YES;
            
            [self talkTo:enemyChef];
            speechBubbleTextx.text=[speechBubbleTextValues objectAtIndex:16];
            [FlxG play:@"chef3.caf"];
            frameNumber++;
            //must put this last.
            hasTalkedToChef=YES;
            
        }
        
        else if (enemyInspector.x < player.x+ 70 && !hasTalkedToInspector) {
            paused=YES;
            
            [self talkTo:enemyInspector];
            speechBubbleTextx.text=[speechBubbleTextValues objectAtIndex:17];
            [FlxG play:@"inspector6.caf"];
            frameNumber++;
            //must put this last.
            hasTalkedToInspector=YES;
            hasTalkedToInspector2=YES;

            
        }
        
        else if (enemyWorker.x < player.x+ 70 && !hasTalkedToWorker) {
            paused=YES;
            
            [self talkTo:enemyWorker];
            speechBubbleTextx.text=[speechBubbleTextValues objectAtIndex:18];
            
            [FlxG play:@"worker3.caf"];
            frameNumber++;
            
            //must put this last.
            hasTalkedToWorker=YES;
            
        }
    }


    
    if ((FlxG.touches.touchesBegan && FlxG.touches.screenTouchBeganPoint.y<FlxG.height/5) || FlxG.touches.iCadeSelectBegan || FlxG.touches.iCadeStartBegan) {
        
        [self stopAllSounds];

        beginFade=YES; 
    }
    
    else if ((FlxG.touches.touchesBegan && FlxG.touches.screenTouchBeganPoint.y>FlxG.height/5) || FlxG.touches.iCadeLeftBumperBegan || FlxG.touches.iCadeRightBumperBegan || FlxG.touches.iCadeYBegan  || FlxG.touches.iCadeBBegan || FlxG.touches.iCadeABegan || FlxG.touches.iCadeXBegan) {
        
        

        paused=NO;
        notepadx.visible=NO;
        notepadTextx.visible=NO;
        speechBubblex.visible=NO;
        speechBubbleTextx.visible=NO;
        
        enemyArmy.velocity=CGPointMake(-100, 0);
        enemyChef.velocity=CGPointMake(-100, 0);
        enemyInspector.velocity=CGPointMake(-100, 0);
        enemyWorker.velocity=CGPointMake(-100, 0);
        
        [self stopAllSounds];


    }
    
    if (hasTalkedToArmy && hasTalkedToChef && hasTalkedToInspector && hasTalkedToWorker && enemyWorker.x < player.x-200) {

        beginFade=YES;
    }
        
    
    
    [super update];
    
    if (_levelFinished  ){ //|| FlxG.touches.touchesBegan
        
        [self finishLevel];
        
    }
        
    if ( beginFade) {
        fadeOut.visible=YES;
        fadeOut.alpha+=0.025;
        
    }
    if (fadeOut.alpha==1) {
        [self stopAllSounds];
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
    speechBubblex.x=character.x-210;
    speechBubblex.y=character.y-80;
    speechBubblex.visible=YES;
    speechBubbleTextx.visible=YES;
    speechBubbleTextx.x=character.x+2-210;
    speechBubbleTextx.y=character.y+2-80;
    
//    NSString * talkAnimName = NSStringFromClass([character class]);
//                            
//    talkAnimName = [talkAnimName stringByAppendingString:@"Talk"];
//    
//    [character play:talkAnimName];
    
    if (!hasTalkedToArmy)
        enemyArmy.velocity=CGPointMake(0, 0);
    
    if (!hasTalkedToChef)
        enemyChef.velocity=CGPointMake(0, 0);
    
    if (!hasTalkedToInspector)
        enemyInspector.velocity=CGPointMake(0, 0);
    
    if (!hasTalkedToInspector2)
        enemyInspector.velocity=CGPointMake(0, 0);
    
    if (!hasTalkedToWorker)
        enemyWorker.velocity=CGPointMake(0, 0);
    
    [player play:@"m_idle"];
    [liselot play:@"f_idle_for_cutscene"];
    
}

-(void) notepad
{
    notepadx.visible=YES;
    notepadTextx.visible=YES;
    
    enemyArmy.velocity=CGPointMake(0, 0);
    enemyChef.velocity=CGPointMake(0, 0);
    enemyInspector.velocity=CGPointMake(0, 0);
    enemyWorker.velocity=CGPointMake(0, 0);
    
    [player play:@"m_idle"];
    [liselot play:@"f_idle"];

    
    
    
}

- (void) switchCharacters
{
    [super switchCharacters:NO flicker:0 withSound:YES followReset:NO];
    [player flicker:0];
    [liselot flicker:0];
    
}

-(void) finishLevel
{
    FlxG.restartMusic=YES;

    [self stopAllSounds];
    FlxG.level=FlxG.level-100;
    
}

- (void) stopAllSounds
{
    [FlxG stop:@"notepad0.caf"];
    [FlxG stop:@"notepad1.caf"];
    [FlxG stop:@"notepad2.caf"];
    [FlxG stop:@"notepad3.caf"];
    [FlxG stop:@"notepad4.caf"];
    [FlxG stop:@"notepad5.caf"];
    [FlxG stop:@"notepad6.caf"];
    [FlxG stop:@"notepad7.caf"];
    [FlxG stop:@"army1.caf"];
    [FlxG stop:@"army2.caf"];
    [FlxG stop:@"army3.caf"];
    [FlxG stop:@"inspector1.caf"];
    [FlxG stop:@"inspector2.caf"];
    [FlxG stop:@"inspector3.caf"];
    [FlxG stop:@"inspector4.caf"];
    [FlxG stop:@"inspector5.caf"];

    [FlxG stop:@"worker1.caf"];
    [FlxG stop:@"worker2.caf"];
    [FlxG stop:@"worker3.caf"];
    [FlxG stop:@"chef1.caf"];
    [FlxG stop:@"chef2.caf"];
    [FlxG stop:@"chef3.caf"];
}




@end

