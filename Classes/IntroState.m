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
#import "IntroState.h"

float characterAlphaCounter;
float characterScaleCounter;

int frameCount; 

FlxSprite * logo;
FlxSprite * liselot;
FlxSprite * andre;
FlxSprite * worker;
FlxSprite * army;

int frameLimit;
FlxTileblock * grad;
static NSString * ImgBgGrad = @"level1_bgSmoothGrad_new.png";
BOOL canFade;
FlxText * pressStart;
NSInteger numOfPlays;


@interface IntroState ()
@end


@implementation IntroState

- (id) init
{
	if ((self = [super init])) {
		self.bgColor = 0xd3bdb2;
	}
	return self;
}

- (void) create
{
    
    FlxG.gamePad = 0;

    
    
//    grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:320];  
//    [grad loadGraphic:ImgBgGrad empties:0 autoTile:NO isSpeechBubble:0 isGradient:17];
//    [self add:grad]; 
    
    frameLimit=200;
    frameCount=0;
    characterAlphaCounter=1.0;
    characterScaleCounter=1.0;
    canFade=NO;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    numOfPlays = [prefs integerForKey:@"NUMBER_OF_PLAYS"];
    
    logo = [FlxSprite spriteWithX:FlxG.width/2 - 228/2
                                y:FlxG.height/2 - 116/2
                          graphic:@"logo_button.png"];
    [self add:logo];
    
    worker = [FlxSprite spriteWithX:20+640
                                  y:20
                            graphic:@"worker_drawing.png"];
    [self add:worker];
    worker.velocity=CGPointMake(0, 0); //-1600
    worker.drag=CGPointMake(2000, 2000);
    
    
    army = [FlxSprite spriteWithX:FlxG.width-239-640
                                y:20
                          graphic:@"army_drawing.png"];
    [self add:army];
    army.velocity=CGPointMake(0, 0); //1600
    army.drag=CGPointMake(2000, 2000);
    
    
    

    
//    //if (numOfPlays%5==4) {
//    if (NO) {    
        andre = [FlxSprite spriteWithX:20+640
                                     y:0
                               graphic:@"andre_drawing.png"];
        
    //    andre.offset=CGPointMake(andre.width/2, andre.height/2);
        [self add:andre];
        andre.velocity=CGPointMake(-1630, 0);
        andre.drag=CGPointMake(2000, 2000);

        
        liselot = [FlxSprite spriteWithX:FlxG.width-20-239-640
                                       y:0
                                 graphic:@"liselot_drawing.png"];
        [self add:liselot];
        liselot.velocity=CGPointMake(1630, 0);
        liselot.drag=CGPointMake(2000, 2000);
    
    
    
    

    
    
    
    
    
        
        if (!FlxG.retinaDisplay) {
    //        liselot.scale=CGPointMake(0.5, 0.5);
    //        andre.scale=CGPointMake(0.5, 0.5);
            
    }
    

    
//    [FlxGame zoomChange];
    
    [FlxG play:@"SndOnShoulders.caf"];
    [FlxG pauseMusic];
    
    pressStart = [FlxText textWithWidth:FlxG.width
                              text:@"TAP TO START"
                              font:@"SmallPixel"
                              size:24.0];
    pressStart.color = 0xffffffff;
	pressStart.alignment = @"center";
	pressStart.x = 0;
	pressStart.y = FlxG.height-36;
    pressStart.alpha=0;
    pressStart.shadow=0xff000000;
	[self add:pressStart];
    
}





- (void) dealloc
{
    
	[super dealloc];
}


- (void) update
{
    
//    NSLog(@"%f %f ", andre.x, andre.velocity.x);
    
    andre.x=roundf(andre.x);
    liselot.x=roundf(liselot.x);
    
    if (andre.velocity.x >= -1.0 ){
        //logo.acceleration=CGPointMake(0, 600);
        logo.alpha-=0.05;
        pressStart.alpha+=0.1;
        


        
    }
    
    
    
    if (canFade) {
        
        //if (numOfPlays%5==4) {
            
    //        andre.drag=CGPointMake(0, 0);
            andre.velocity=CGPointMake(800, 0);

    //        liselot.drag=CGPointMake(0, 0);
            liselot.velocity=CGPointMake(-800, 0);
            
    //        andre.scale=CGPointMake(characterScaleCounter, characterScaleCounter);
    //        liselot.scale=CGPointMake(characterScaleCounter, characterScaleCounter);

        liselot.alpha=characterAlphaCounter;
        andre.alpha=characterAlphaCounter;
        characterScaleCounter+=0.1;

        characterAlphaCounter-=0.1;
        
    }
    
    frameCount++;
    
    if (FlxG.touches.touchesBegan || ( FlxG.touches.iCadeStartBegan || FlxG.touches.iCadeLeftBumperBegan || FlxG.touches.iCadeSelectBegan ||FlxG.touches.iCadeRightBumperBegan ||FlxG.touches.iCadeYBegan ||FlxG.touches.iCadeBBegan ||FlxG.touches.iCadeABegan ||FlxG.touches.iCadeXBegan ) ) {
        army.velocity=CGPointMake(1600, 0);
        worker.velocity=CGPointMake(-1600, 0);

        canFade=YES;
//        pressStart.visible=NO;
        [FlxG play:@"jump.caf"];
        
    }
    
    if ( (FlxG.touches.iCadeStartBegan || FlxG.touches.iCadeLeftBumperBegan || FlxG.touches.iCadeSelectBegan ||FlxG.touches.iCadeRightBumperBegan ||FlxG.touches.iCadeYBegan ||FlxG.touches.iCadeBBegan ||FlxG.touches.iCadeABegan ||FlxG.touches.iCadeXBegan) && FlxG.gamePad==0 ) {
        [FlxG showAlertWithTitle:@"Joystick alert" message:@"External joystick detected!"];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSInteger gp = [prefs integerForKey:@"GAME_PAD"];
        
        //NSLog(@"GamePad stored as %d", gp);
        
        if (gp==0) {
        FlxG.gamePad=1;
        }
        else {
            FlxG.gamePad=gp;
        }
        
    }
    
    
	[super update];
	
//    if (andre.alpha==0.0) {
    if (army.x>400) {
        
//        if (FlxG.retinaDisplay) {
//            FlxGame * game = [FlxG game];
//            game.textureBufferZoom=YES;
//        }
        
        FlxG.state = [[[MenuState alloc] init] autorelease];
        return;
    }
	
	
}



@end

