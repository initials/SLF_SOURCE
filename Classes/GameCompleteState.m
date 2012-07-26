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

#import "GameCompleteState.h"
#import "MenuState.h"


@implementation GameCompleteState

FlxSprite * congrats;
int curSc;
int frameNum;
int eventCounter;
BOOL beginFade;

EnemyGeneric * player2;
EnemyGeneric * liselot2;

- (id) init
{
    if ((self = [super init])) {
        self.bgColor = 0xff35353d;
    }
    return self;
}


- (void) create
{
    
    
    [super create];
    
    isGameCompleteState=YES;
    
    [FlxG playMusic:@"farewell.mp3"];
    
    player2 = [EnemyGeneric enemyGenericWithOrigin:CGPointMake(1600, 240) index:-1 ];
    [self add:player2];
    [player2 play:@"playerListen"];
    
    liselot2 = [EnemyGeneric enemyGenericWithOrigin:CGPointMake(1600, 240) index:-2  ];
    liselot2.scale = CGPointMake(-1, 1);
    [self add:liselot2];
    [liselot2 play:@"liselotListen"]; 
    
    player2.x=player.x;
    player2.y=player.y+11;
    liselot2.x=liselot.x;
    liselot2.y=liselot.y+11;
    
    player.visible=NO;
    liselot.visible=NO;
    
    
    buttonA.visible=NO;
    buttonB.visible=NO;
    buttonLeft.visible=NO;
    buttonRight.visible=NO;
    FlxG.touches.humanControlled=NO;
    pauseGraphic.visible=NO;
    liselot.isPlayerControlled=NO;
    player.isPlayerControlled=NO;
    hud.visible=NO;
    
    
    liselot.cutSceneMode=YES;
    
    beginFade=NO;

    
    
    helloText = [FlxText textWithWidth:FlxG.width
                                  text:@"You now own the Super Lemonade Factory!"
                                  font:@"SmallPixel"
                                  size:16.0];
    helloText.color = 0xffae8160;
    helloText.alignment = @"center";
    helloText.x = 0;
    helloText.y = 70;
    helloText.visible=NO;
    [self add:helloText];
    
    curSc=20;
    frameNum=0;
    eventCounter=0;
    
    congrats  = [FlxSprite spriteWithX:70 y:120 graphic:nil];
    [congrats loadGraphicWithParam1:@"congrats330x31.png" param2:YES param3:NO param4:330 param5:31];
	[self add:congrats];
    [congrats addAnimationWithParam1:@"cycle" param2:[NSMutableArray intArrayWithSize:4 ints:0,1,2,3] param3:4]; 
    [congrats play:@"cycle"];
    congrats.scale=CGPointMake(curSc, curSc);
    
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
    
    
    
    
    nextText = [FlxText textWithWidth:FlxG.width-10
                                 text:@" Tap to continue "
                                 font:@"SmallPixel"
                                 size:16.0];
    nextText.color = 0xff96765e;
	nextText.alignment = @"right";
	nextText.x = 0;
	nextText.y = FlxG.height-28;
    nextText.shadow = 0x00ffffff;
    nextText.scrollFactor = CGPointZero;
    nextText.alpha=0;
	[self add:nextText]; 
    
    fadeOut  = [FlxSprite spriteWithX:0 y:0 graphic:nil];
	[fadeOut createGraphicWithParam1:FlxG.width param2:FlxG.height param3:0xff000000];
    fadeOut.alpha = 0;
    fadeOut.x = 0;
    fadeOut.y = 0;
    fadeOut.scrollFactor = CGPointZero;
    fadeOut.drag = CGPointMake(500, 500);
	[self add:fadeOut];
    
    if (FlxG.level==49999) {
        [FlxG checkAchievement:kFactoryOwner];
    }
    
    if (FlxG.level!=49999) {
        congrats.visible=NO;
        helloText.visible=NO;
    }
    
    
    
    
 
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}


- (void) update
{

    
    if (!paused) {
        frameNum++;
        nextText.alpha=0;

    }
    else {
        nextText.alpha+=0.05;
        [player2 update];
        [liselot2 update];
    }
    
    
    
    


    if (FlxG.level==49999 || FlxG.level==59999) {
        congrats.scale=CGPointMake(curSc, curSc);
        if (curSc>1 && frameNum%4==1)
            curSc--;
        
        if (curSc==1) {
            
        }    
        if (curSc==1 && !paused) {
            eventCounter++;
        }
    }
    else {
        if (!paused) {
            eventCounter++;

        }

    }
    
    
    if (FlxG.touches.touchesBegan || FlxG.touches.iCadeABegan) {
        if (eventCounter<150) {
            paused=NO;
            notepadx.visible=NO;
            notepadTextx.visible=NO;
            speechBubblex.visible=NO;
            speechBubbleTextx.visible=NO;
            [player2 play:@"playerListen"];
            [liselot2 play:@"liselotListen"];
            return;
            
        }
    }
    
    
    
    
    [super update];
    

    if (eventCounter==3 && (FlxG.level==49999 || FlxG.level==59999)) {
        paused=YES;
        helloText.visible=YES;        
    }
    
    if (!FlxG.hardCoreMode){
        
        if (FlxG.level==49997 || FlxG.level==59997){
            if (eventCounter==5) {
                paused=YES;
                [self talkTo:player2];
                speechBubbleTextx.text=@"Nothing has changed here since I was a kid.";
                helloText.visible=NO;
                eventCounter++;
            }
            
            if (eventCounter==25) {
                paused=YES;
                [self talkTo:liselot2];
                speechBubbleTextx.text=@"You know what Thomas Wolfe said about going home?";
                eventCounter++;
            }
            
            if (eventCounter==45) {
                paused=YES;
                [self talkTo:player2];
                speechBubbleTextx.text=@"He had valid points but I'm not George Webber...";
                helloText.visible=NO;
                eventCounter++;
            }
            
            if (eventCounter==65) {
                paused=YES;
                [self talkTo:player2];
                speechBubbleTextx.text=@"...and I'm not interested in re-living my youth.";
                helloText.visible=NO;
                eventCounter++;
            }
            
            if (eventCounter==86) {
                paused=YES;
                [self talkTo:liselot2];
                speechBubbleTextx.text=@"The future is ours.";
                eventCounter++;
            }
            
            if (eventCounter==105) {
                beginFade=YES;
            }
            
        }
        
        if (FlxG.level==49998 || FlxG.level==59998){
            if (eventCounter==5) {
                paused=YES;
                [self talkTo:player2];
                speechBubbleTextx.text=@"Fresh ingredients in, refreshing drinks out.";
                helloText.visible=NO;
                eventCounter++;
            }
            
            if (eventCounter==25) {
                paused=YES;
                [self talkTo:liselot2];
                speechBubbleTextx.text=@"Yuck, I am drenched in sweat. It's disgusting in here.";
                eventCounter++;
            }
            
            if (eventCounter==45) {
                paused=YES;
                [self talkTo:player2];
                speechBubbleTextx.text=@"Let's get out of here, it's time to go home.";
                eventCounter++;
            }
            
            if (eventCounter==65) {
                paused=YES;
                [self talkTo:liselot2];
                speechBubbleTextx.text=@"The day escapes.";
                eventCounter++;
            }
            
            if (eventCounter==85) {
                beginFade=YES;
            }
            
        }
        
        
        if (FlxG.level==49999 || FlxG.level==59999){
            if (eventCounter==20) {
                paused=YES;
                [self talkTo:player2];
                speechBubbleTextx.text=@"Owning this factory will be a honor and a challenge.";
                helloText.visible=NO;
                eventCounter++;
            }
            
            if (eventCounter==40) {
                paused=YES;
                [self talkTo:liselot2];
                speechBubbleTextx.text=@"I think we'll do a great job.";
                eventCounter++;
            }
            
            if (eventCounter==60) {
                paused=YES;
                [self talkTo:player2];
                speechBubbleTextx.text=@"We signed on to supply the military with soft drinks for their rations.";
                eventCounter++;
            }
            
            if (eventCounter==80) {
                paused=YES;
                [self talkTo:liselot2];
                speechBubbleTextx.text=@"I quite liked the new durian flavor we are now producing.";
                eventCounter++;
            }
            
            if (eventCounter==100) {
                paused=YES;
                [self talkTo:player2];
                speechBubbleTextx.text=@"We won't be adopting our handyman's anarchist ideals.";
                eventCounter++;

                
            }
            
            if (eventCounter==120) {
                paused=YES;
                
                [self talkTo:liselot2];
                speechBubbleTextx.text=@"We've managed to avoid the food inspector's wrath this time.";
                eventCounter++;
            }
            
            if (eventCounter==140) {
                paused=YES;
                
                [self talkTo:player2];
                speechBubbleTextx.text=@"And us? We're still wildly in love.";
                eventCounter++;
            }
            
            if (eventCounter==150) {
                beginFade=YES;
            }
            
        }
    }
    else if (FlxG.hardCoreMode){
        
        
        if (FlxG.level==49997 || FlxG.level==59997){
            
            if (eventCounter==5) {
                paused=YES;
                [self talkTo:liselot2];
                speechBubbleTextx.text=@"How does it feel to be home?";
                eventCounter++;
            }
            
            if (eventCounter==25) {
                paused=YES;
                [self talkTo:player2];
                speechBubbleTextx.text=@"I grew up here. I thought I knew every inch of this town.";
                helloText.visible=NO;
                eventCounter++;
            }
            
            if (eventCounter==45) {
                paused=YES;
                [self talkTo:player2];
                speechBubbleTextx.text=@"With you by my side it feels like Paris at night.";
                helloText.visible=NO;
                eventCounter++;
            }
            

            
            if (eventCounter==65) {
                beginFade=YES;
            }
            
        }
        
        if (FlxG.level==49998 || FlxG.level==59998){
            if (eventCounter==5) {
                paused=YES;
                [self talkTo:player2];
                speechBubbleTextx.text=@"When the carbon dioxide hits the water, it's magic.";
                helloText.visible=NO;
                eventCounter++;
            }
            
            if (eventCounter==25) {
                paused=YES;
                [self talkTo:liselot2];
                speechBubbleTextx.text=@"The contents of the bottle is greater than the sum of it's parts.";
                eventCounter++;
            }
            
            if (eventCounter==45) {
                beginFade=YES;
            }
            
        }
        
        if (FlxG.level==49999 || FlxG.level==59999){

            if (eventCounter==20) {
                paused=YES;
                [self talkTo:player2];
                speechBubbleTextx.text=@"It's been hard work but well worth it.";
                helloText.visible=NO;
                eventCounter++; 
            }
            
            if (eventCounter==40) {
                paused=YES;
                
                [self talkTo:liselot2];
                speechBubbleTextx.text=@"We've seen every inch of the factory. Our factory.";
                eventCounter++;

            }
            
            if (eventCounter==60) {
                paused=YES;
                
                [self talkTo:player2];
                speechBubbleTextx.text=@"It turns out the army was working with Henry K. Beecher.";
                eventCounter++;  
            }
            
            if (eventCounter==80) {
                paused=YES;
                
                [self talkTo:liselot2];
                speechBubbleTextx.text=@"He used our lemonade in his placebo effect research.";
                eventCounter++;  
            }
            
            if (eventCounter==100) {
                paused=YES;
                
                [self talkTo:player2];
                speechBubbleTextx.text=@"Our handyman still brings in socialist libertarian pamphlets.";
                eventCounter++; 
            }
            
            if (eventCounter==120) {
                paused=YES;
                
                [self talkTo:liselot2];
                speechBubbleTextx.text=@"The food inspector was taking bribes and is now in jail.";
                eventCounter++;  
            }
            
            if (eventCounter==140) {
                paused=YES;
                
                [self talkTo:player2];
                speechBubbleTextx.text=@"We'll see you next time in the sequel.";
                eventCounter++;
            }
            if (eventCounter==145) {
                paused=YES;
                
                [self talkTo:liselot2];
                speechBubbleTextx.text=@"Super Lemonade Factory II: Assembly Line Simulator.";
                eventCounter++;  
            }
            if (eventCounter==150) {
                beginFade=YES;
                
            }
        }
    }
    
    if (beginFade) {
        fadeOut.visible=YES;
        fadeOut.alpha+=0.020;
        
    }
    
    

    
    if (fadeOut.alpha>0.98) {
        FlxG.level=1;
        FlxG.state = [[[MenuState alloc] init] autorelease];
        return; 
    }
    
    
}

-(void) talkTo:(EnemyGeneric *)character
{
    speechBubblex.x=character.x-210;
    speechBubblex.y=character.y-90;
    speechBubblex.visible=YES;
    speechBubbleTextx.visible=YES;
    speechBubbleTextx.x=character.x+2-210;
    speechBubbleTextx.y=character.y+2-90;
    
//    if ([character isKindOfClass:[Player class]]) {
//        [player2 play:@"playerTalk"];
//        NSLog(@"yes it is m");
//    }
//    else if ([character isKindOfClass:[Liselot class]]) {
//        [liselot2 play:@"liselotTalk"];
//        NSLog(@"yes it is f");
//
//    }    
    if (character._index==-1) {
        [player2 play:@"playerTalk"];
    }
    if (character._index==-2) {
        [liselot2 play:@"liselotTalk"];
        
    } 
    
    
}

-(void) notepad
{
    notepadx.visible=YES;
    notepadTextx.visible=YES;
    
}


@end

