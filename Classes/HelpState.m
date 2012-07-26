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

#import "HelpState.h"

#import "FlxImageInfo.h"

int c; 

FlxSprite * bgCity;
FlxSprite * bgClouds;

FlxText * headingText;
FlxText * headingTextShadow;
static NSString * ImgBgGrad = @"level2_gradient.png";
static NSString * SndBack = @"ping2.caf";
static NSString * ImgEmptyButton = @"emptySmallButtonF.png";
static NSString * ImgEmptyButtonPressed = @"emptySmallButtonPressedF.png";
static NSString * ImgTiles = @"level2_tiles.png";

@interface HelpState ()
@end


@implementation HelpState

- (id) init
{
	if ((self = [super init])) {
		self.bgColor = 0x40a98c;
	}
	return self;
}

- (void) create
{
    
    
    FlxTileblock * grad = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:320];  
    [grad loadGraphic:ImgBgGrad];
    [self add:grad];  
    
//    NSString * a = [[UIDevice currentDevice] uniqueIdentifier];
//    NSString * b = [NSString stringWithFormat:@"hi%@%@%@", a[2], a[4], a[6]];
    
    
    aboutText = [FlxText textWithWidth:FlxG.width
								  text:@"Initials Presents\n\nSUPER LEMONADE FACTORY\n\nA Game By Shane Brouwer\n\nArt\nMiguelito\n\nMusic\nEasyname\n\nMarketing\nSurprise Attack\n\nIllustration\ndoggerland.deviantart.com\n\nIn Game Voice Talent\nRoy Kelly\nKellyCommaRoy {a} gmail.com\n\nTrailer Voice Talent\nTom Mitchell\n\nAdditional Art and Copywriting\nElizabeth Docking\n\nEngine\nFlixel\n\nLevel Editor\nOgmo Editor\n\nSound Effects\nbfxr\n\nSpecial Thanks\nAdam Atomic and Semi Secret Software. Thank you for Flixel.\n\nIQPierce\nCracked the code to allow custom fonts.\nCheck out his Flixel game Connectrode.\n\nScott Rapson\nThanks for your in depth beta testing.\n\nMatt Thorson\nFor the Ogmo Editor\n\nJon K\nThis game was built from your Flixel iOS template.\n\naxcho\nThanks for the retina help.\n\nChevy Ray\nGot me interested in the Ogmo Editor with the source code to the Ludum Dare winning game Flee Buster.\n\nAny resemblance to real persons, living or dead is purely coincidental.\n\nDedicated to Marten and Gerardus.\n\nEmail initials {a} initialsgames.com\n "
								  font:@"SmallPixel"
								  size:16];
	aboutText.color = 0xffffffff;
	aboutText.alignment = @"center";
	aboutText.x = 0;
	aboutText.y = FlxG.height;
    aboutText.velocity = CGPointMake(0, -45); //-35
	[self add:aboutText];
        
    FlxTileblock * gradTopBar = [FlxTileblock tileblockWithX:0 y:0 width:FlxG.width height:40];  
    [gradTopBar loadGraphic:ImgTiles empties:0 autoTile:YES];
    [self add:gradTopBar]; 
    
    gradTopBar = [FlxTileblock tileblockWithX:0 y:FlxG.height-40 width:FlxG.width height:40];  
    [gradTopBar loadGraphic:ImgTiles empties:0 autoTile:YES];
    [self add:gradTopBar]; 
    
    headingText = [FlxText textWithWidth:FlxG.width
                                    text:@"CREDITS"
                                    font:@"SmallPixel"
                                    size:16.0];
	headingText.color = 0xff337052;
	headingText.alignment = @"center";
	headingText.x = 0;
	headingText.y = 8;
	[self add:headingText];
    
    
    
    back = [[[FlxButton alloc]      initWithX:20
                                            y:FlxG.height-40
                                     callback:[FlashFunction functionWithTarget:self
                                                                         action:@selector(onBack)]] autorelease];
    [back loadGraphicWithParam1:[FlxSprite spriteWithGraphic:ImgEmptyButton] param2:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed] param3:[FlxSprite spriteWithGraphic:ImgEmptyButtonPressed]];
    [back loadTextWithParam1:[FlxText textWithWidth:back.width
                                               text:NSLocalizedString(@"back", @"back")
                                               font:@"SmallPixel"
                                               size:16.0] param2:[FlxText textWithWidth:back.width
                                                                                   text:NSLocalizedString(@"back ...", @"back ...")
                                                                                   font:@"SmallPixel"
                                                                                   size:16.0] withXOffset:0 withYOffset:back.height/4] ;	
	[self add:back]; 
    
    if (FlxG.gamePad==0) {
        back._selected=NO;
    } 
    else {
        back._selected=YES;
    }
    
    
    [FlxG checkAchievement:kViewCredits];
    	
}

- (void) loadLevelBlocksFromImage {
    static NSString * ImgTiles = @"level2_tiles.png";
    static NSString * ImgSpecialSquareBlock = @"level2_specialBlock.png";
    static NSString * ImgSpecialPlatform = @"level2_specialPlatform.png";
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




- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

	[super dealloc];
}


- (void) update
{
    

    
    
    
    if (aboutText.y<-1265) {
        aboutText.y=FlxG.height;
    }
    
    if (FlxG.touches.touching || FlxG.touches.iCadeUp  || FlxG.touches.iCadeDown  || FlxG.touches.iCadeLeft  || FlxG.touches.iCadeRight )
    {
        aboutText.velocity=CGPointMake(0, -80);
    }
    else 
    {
        aboutText.velocity=CGPointMake(0, -45);

    }
    
    
//    if (FlxG.touches.touchesBegan) {
//        [FlxG checkAchievement:kViewCredits];
//    }
    
	[super update];
	
    if (FlxG.touches.iCadeBBegan) {
        [self onBack];
        return;
    }
    
    if (FlxG.touches.iCadeABegan && back._selected)  {
        [self onBack];
        return;
    }
	
}

- (void) onBack
{
    
    [FlxG play:SndBack];

	FlxG.state = [[[MenuState alloc] init] autorelease];
    return;
}


@end

