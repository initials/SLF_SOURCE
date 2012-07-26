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

#import "TBXML.h"

#import "Player.h"
#import "Liselot.h"
#import "EnemyArmy.h"
#import "EnemyChef.h"
#import "EnemyInspector.h"
#import "EnemyWorker.h"
#import "EnemyGeneric.h"
#import "Hud.h"
#import "NavArrow.h"

@class Enemy;
@class Hud;



@class ScoreCaps;

@class Bottle;
@class SugarBag;
@class Crate;

@class Explosion;
@class MenuState;
@class Gun;

@class Exit;
@class HelpLabel;


@interface OgmoLevelState : FlxState <NSXMLParserDelegate>
{
    
    NavArrow * navArrow;
    
    TBXML * tbxml;
    //places to store level
    NSMutableArray *levelArray;
    NSMutableArray *levelArrayFake;

    NSMutableArray *movingPlatformsArray;
    NSMutableArray *movingPlatformsLimitsArray;

    
    NSMutableArray *bottleArray;
    NSMutableArray *hazardArray;

    NSMutableArray *BGArray1;
    NSMutableArray *BGArray2;
    NSMutableArray *BGArray3;
    NSMutableArray *FGArray1;

    NSMutableArray *characterArray;    
    NSMutableArray *characterNodeArray;    

    
    FlxTileblock * bl;
    FlxTileblock * speechBubble;
    HelpLabel * helpTextBubble;

    FlxText * speechBubbleText;
    FlxText * speechBubbleTextHelp;
    
    FlxText * levelNameInfo;
    
    FlxTileblock * notepad;

    FlxSprite * backG;
    FlxSprite * gameOverScreenDarken;
    
    Exit * exit;
    
    Explosion * explosion;
    
    FlxGroup * playerPlatforms;
    FlxGroup * enemyPlatforms;
    
    FlxGroup * helpBoxes;
    
    FlxGroup * characters;
    FlxGroup * talkCharacters;
    
    FlxGroup * charactersArmy;
    FlxGroup * charactersChef;
    FlxGroup * charactersInspector;
    FlxGroup * charactersWorker;
    
    FlxGroup * hazards;
    
    FlxGroup * crates;

    
    FlxButton * left;
    FlxButton * right;
    FlxText * weaponText;

    FlxText * helpText;
    
	FlxText * scoreText;
	Player * player;
    
    EnemyArmy * enemyArmy;
    EnemyChef * enemyChef;
    EnemyInspector * enemyInspector;
    EnemyWorker * enemyWorker;
    
    EnemyGeneric * enemyGeneric;
    EnemyGeneric * enemyListener;
    
    Liselot * liselot;
    
    Bottle * bottle;
	Crate * crate;
    SugarBag * sugarBag;
    
    FlxSprite * ground;
	FlxSprite * target;
	FlxSprite * movingTarget;
	FlxSprite * powerMeter;
    
    FlxSprite * buttonLeft;
    FlxSprite * buttonRight;
    FlxSprite * buttonA;
    FlxSprite * buttonB;
    
    // new
    
    FlxButton * buttonPlay;
    
    
    //new button, used to be sprite
    
    FlxButton * buttonMenu;
    
    
    FlxSprite * pauseGraphic;
    FlxSprite * resumeGraphic;
    FlxSprite * fadeInOut;
    FlxSprite * buttonRestart;
    
//    ScoreCaps * capLevel;
//    ScoreCaps * capAndre;
//    ScoreCaps * capLiselot;
    
    FlxSprite * andreIcon;
    FlxSprite * liselotIcon;
    
    FlxSprite * talkIcon;


    FlxSprite * followObject;
    
    CGPoint tempPointForFollowObject;


    Hud * hud;
    
    FlxEmitter * ge;
    FlxEmitter * ge2;
    
    FlxEmitter * cEmit;

    
    FlxEmitter * sEmit;
    
    
    NSArray * speechTexts;

    
    BOOL paused;
    BOOL _levelFinished;


    int speechTextCycler;
    int timerForGameComplete;
    
    BOOL isGameCompleteState;
    
    
}

- (void) addStats;

- (void) switchCharacters;
- (void) switchCharacters:(BOOL)withBubbles flicker:(float)flickerLength;
- (void) switchCharacters:(BOOL)withBubbles flicker:(float)flickerLength withSound:(BOOL)withSoundPlay;
- (void) switchCharacters:(BOOL)withBubbles flicker:(float)flickerLength withSound:(BOOL)withSoundPlay followReset:(BOOL)withFollowReset;


@end

