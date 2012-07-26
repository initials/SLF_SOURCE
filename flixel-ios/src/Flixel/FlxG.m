//
//  FlxG.m
//  flixel-ios
//
//  Copyright Semi Secret Software 2009-2010. All rights reserved.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
#import <Flixel/Flixel.h>

#import <AudioToolbox/AudioToolbox.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <CoreAudio/CoreAudioTypes.h>

//GK
#import "AppSpecificValues.h"
#import "GameCenterManager.h"
#import <GameKit/GameKit.h>
#import "BCAchievementNotificationCenter.h"

typedef struct {
    ALuint source;
    ALuint buffer;
    void * data;
    UInt32 byteCount;
    ALenum dataFormat;
    Float64 sampleRate;
} SoundParameters;

//for sysctlbyname
#include <sys/types.h>
#include <sys/sysctl.h>

@interface UIDevice (Platform)
- (NSString *) platform;
@end

@implementation UIDevice (Platform)
- (NSString *) platform;
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}
@end

@implementation NSArray (IntArray)
+ (NSArray *) intArrayWithSize:(NSUInteger)size ints:(int)first, ...;
{
    va_list argumentList;
    NSMutableArray * array = [NSMutableArray array];
    va_start(argumentList, first);
    [array addObject:[NSNumber numberWithInt:first]];
    for (NSUInteger i=1; i<size; ++i) {
        int val = va_arg(argumentList, int);
        [array addObject:[NSNumber numberWithInt:val]];
    }
    va_end(argumentList);
    return array;
}   
@end

@implementation NSMutableArray (IntArray)
+ (NSMutableArray *) intArrayWithSize:(NSUInteger)size ints:(int)first, ...;
{
    va_list argumentList;
    NSMutableArray * array = [NSMutableArray array];
    va_start(argumentList, first);
    [array addObject:[NSNumber numberWithInt:first]];
    for (NSUInteger i=1; i<size; ++i) {
        int val = va_arg(argumentList, int);
        [array addObject:[NSNumber numberWithInt:val]];
    }
    va_end(argumentList);
    return array;
}   
@end

static int check_other_audio_count;

static BOOL checkedVibration = NO;
static BOOL doVibration = NO;

static FlxGame * _game;
static BOOL gameStarted = NO;
static BOOL _mute;
static FlashPoint * _scrollTarget;
static NSMutableDictionary * _cache;

static CGFloat screenScale;
static BOOL iPad;
static BOOL retinaDisplay;
static BOOL iPhone3GS;
static BOOL iPhone3G;
static BOOL iPhone1G;
static BOOL iPodTouch1G;
static BOOL iPodTouch2G;
static BOOL iPodTouch3G;

//static BOOL debug;
static float elapsed;
static float maxElapsed;
static float timeScale;
static int width;
static int height;

static NSMutableArray * levels;
static NSMutableArray * completeAchievements;

static int level;
static int levelWidth;
static int levelHeight;
static BOOL debugMode;
static int gamePad;

static CGPoint leftArrowPosition;
static CGPoint rightArrowPosition;

static CGPoint button1Position;
static CGPoint button2Position;

static BOOL restartMusic;

static BOOL hasRatedThisSession;

static BOOL hardCoreMode;
static BOOL winnitron;
static BOOL oldSchool;
static BOOL flives;
static BOOL mlives;
static float timeLeft;

static BOOL isGameCenterAvailable;

static NSMutableArray * scores;
static int score;
//static NSMutableArray * saves;
//static int save;
static FlxSound * music;
static NSMutableDictionary * sounds;
static FlxObject * followTarget;
static BOOL pauseFollow;
static FlashPoint * followLead;
static float followLerp;
static FlashPoint * followMin;
static FlashPoint * followMax;
static FlashPoint * scroll;
static FlxQuake * quake;
static FlxFlash * flash;
static FlxFade * fade;
//audio stuff
static AVAudioPlayer * audioPlayer;
static NSTimeInterval audioPlayerTime = 0;
//static float fadeTimer;
//static float fadeVolume;
//static float fadeDuration;
static float fadeOutDuration;
static float fadeOutTimer;
static float fadeOutVolume;
static ALCdevice * device;
static ALCcontext * context;
static UInt32 isOtherAudioPlaying;
static BOOL needToCheckForOtherAudio;
static BOOL musicPaused;
static FlxTouches * touches;
static float soundEffectsMasterVolume;
static float musicMasterVolume;

//GK
GameCenterManager * gameCenterManager;


@interface FlxG (Sound)
+ (SoundParameters *) getSoundParameters:(NSString *)embeddedSound;
@end


@interface FlxG ()
+ (void) doFollow;
+ (void) unfollow;
+ (void) initAudio;
+ (void) checkForOtherAudio;
// + (void) audioSessionBeginInterruption;
// + (void) audioSessionEndInterruption;
+ (void) beginInterruption;
+ (void) endInterruption;
+ (void) setupOpenAL;
+ (void) teardownOpenAL;
+ (void) delayedCheckForOtherAudio;
+ (void) restartAudioPlayer;

@end



@interface FlxGame (PrivateGame)
@property (readonly) FlxState * state;
@end

@implementation FlxGame (PrivateGame)
- (FlxState *) state
{
    return _state;
}
@end



// void audioSessionInterruptHandler(void * userData, UInt32 interruptionState) {
//   if (interruptionState == kAudioSessionBeginInterruption) {
//     [FlxG audioSessionBeginInterruption];
//   } else if (interruptionState == kAudioSessionEndInterruption) {
//     [FlxG audioSessionEndInterruption];
//   }
// }

typedef ALvoid AL_APIENTRY (*alBufferDataStaticProcPtr) (const ALint bid, ALenum format, ALvoid* data, ALsizei size, ALsizei freq);

ALvoid alBufferDataStaticProc(const ALint bid, ALenum format, ALvoid* data, ALsizei size, ALsizei freq) {
    static alBufferDataStaticProcPtr proc = NULL;
    if (proc == NULL)
        proc = (alBufferDataStaticProcPtr) alcGetProcAddress(NULL, (const ALCchar*) "alBufferDataStatic");
    if (proc)
        proc(bid, format, data, size, freq);
    return;
}

typedef ALvoid AL_APIENTRY (*alcMacOSXMixerOutputRateProcPtr) (const ALfloat value);
ALvoid alcMacOSXMixerOutputRateProc(const ALfloat value) {
    static alcMacOSXMixerOutputRateProcPtr proc = NULL;
    if (proc == NULL)
        proc = (alcMacOSXMixerOutputRateProcPtr) alcGetProcAddress(NULL, (const ALCchar*) "alcMacOSXMixerOutputRate");
    if (proc)
        proc(value);
    return;
}


@implementation FlxG

+ (void) didEnterBackground;
{
    //   //todo - turn off sounds? so that ipod music can play for example?
    //   NSLog(@"preemptively setting sound to ambient sound");
    //   UInt32 category = kAudioSessionCategory_AmbientSound;
    //   AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
    //  			  sizeof(category),
    //  			  &category);
    
    if (_game)
        [_game didEnterBackground];
}
+ (void) willEnterForeground;
{
    if (_game)
        [_game willEnterForeground];
}
+ (void) willResignActive;
{
    @synchronized(self) {
        if (audioPlayer && audioPlayer.playing) {
            NSLog(@"forcing audioPlayer to pause");
            [audioPlayer pause];
            //save away playback location
            audioPlayerTime = [audioPlayer currentTime];
            [audioPlayer stop];
        }
    }
    NSError * error;
    [[AVAudioSession sharedInstance] setActive:NO error:&error];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient
                                           error:&error];
    
    needToCheckForOtherAudio = YES;
    if (_game)
        _game.paused = YES;
}
+ (void) didBecomeActive;
{
    //called once at application launch
    if (_game)
        _game.paused = NO;
    
    if (_game && !gameStarted) {
        [_game start];
        gameStarted = YES;
    }
    
    check_other_audio_count = 0;
    
    //check audio state again -> should we start playing background music?
    [self checkForOtherAudio];
    
    if (isOtherAudioPlaying) {
        NSLog(@"other audio is playing");
        [self delayedCheckForOtherAudio];
    } else {
        NSLog(@"no other audio playing");
        [self restartAudioPlayer];
    }
}

+ (void) delayedCheckForOtherAudio
{
    NSLog(@"delayed check for other audio");
    if (check_other_audio_count != 0) {
        needToCheckForOtherAudio = YES;
        [self checkForOtherAudio];
    }
    if (check_other_audio_count < 4 && isOtherAudioPlaying) {
        check_other_audio_count++;
        [self performSelector:@selector(delayedCheckForOtherAudio)
                   withObject:nil
                   afterDelay:2.0];
    } else {
        [self restartAudioPlayer];
    }
}

+ (void) restartAudioPlayer
{
    @synchronized(self) {
        if (!isOtherAudioPlaying) {
            NSError * error;
            //set fake category, so that we guarantee no software decoding...
            NSString * fakeCategory = AVAudioSessionCategoryPlayback;
            [[AVAudioSession sharedInstance] setCategory:fakeCategory
                                                   error:&error];
            [[AVAudioSession sharedInstance] setActive:YES error:&error];
            [[AVAudioSession sharedInstance] setActive:NO error:&error];
            NSString * realCategory = AVAudioSessionCategorySoloAmbient;
            [[AVAudioSession sharedInstance] setCategory:realCategory
                                                   error:&error];
            [[AVAudioSession sharedInstance] setActive:YES error:&error];
        }
        if (audioPlayer && !isOtherAudioPlaying && !audioPlayer.playing) {
            NSLog(@"trying to get audioPlayer to play again...");
            audioPlayer.volume = musicMasterVolume;
            [audioPlayer setCurrentTime:audioPlayerTime];
            [audioPlayer prepareToPlay];
            if (!musicPaused)
                [audioPlayer play];
        } else {
            if (audioPlayer == nil)
                NSLog(@"no audio player..");
            if (isOtherAudioPlaying)
                NSLog(@"thinks other audio is playing...");
            if (audioPlayer.playing)
                NSLog(@"thinks audio player is already playing...");
        }
    }
}



// {

//   NSError * error;
//   if (!isOtherAudioPlaying) {
//     //set fake category, so that we guarantee no software decoding...
//     NSString * fakeCategory = AVAudioSessionCategoryPlayback;
//     [[AVAudioSession sharedInstance] setCategory:fakeCategory
// 					   error:&error];
//     [[AVAudioSession sharedInstance] setActive:YES error:&error];
//     [[AVAudioSession sharedInstance] setActive:NO error:&error];
//     NSString * realCategory = AVAudioSessionCategorySoloAmbient;
//     [[AVAudioSession sharedInstance] setCategory:realCategory
// 					   error:&error];
//     [[AVAudioSession sharedInstance] setActive:YES error:&error];
//   }

//   @synchronized(self) {
//     if (audioPlayer && !isOtherAudioPlaying && !audioPlayer.playing) {
//       NSLog(@"trying to get audioPlayer to play again...");
//       //load it up to the right location
//       [audioPlayer setCurrentTime:audioPlayerTime];
//       [audioPlayer prepareToPlay];
//       if (!musicPaused)
// 	[audioPlayer play];
//     } else {
//       if (!audioPlayer)
// 	NSLog(@"no audio player..");
//       if (isOtherAudioPlaying)
// 	NSLog(@"thinks other audio is playing...");
//       if (audioPlayer.playing)
// 	NSLog(@"thinks audio player is already playing...");
//     }
//   }
// }


+ (void) initialize
{
    if (self == [FlxG class]) {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
            screenScale = [UIScreen mainScreen].scale;
        else
            screenScale = 1.0;
        
        if (_cache == nil)
            _cache = [[NSMutableDictionary alloc] init];
        
        //     if ([[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound)
        //       iPad = YES;
        //     else
        //       iPad = NO;
        if ([UIDevice instancesRespondToSelector:@selector(userInterfaceIdiom)] &&
            [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            iPad = YES;
        else
            iPad = NO;
        //NSLog(@"iPad: %d", iPad);
        if ([UIScreen instancesRespondToSelector:@selector(scale)] &&
            [[UIScreen mainScreen] scale] == 2.0)
            retinaDisplay = YES;
        else
            retinaDisplay = NO;
        if ([[UIDevice currentDevice].platform isEqualToString:@"iPhone1,1"])
            iPhone1G = YES;
        else
            iPhone1G = NO;
        if ([[UIDevice currentDevice].platform isEqualToString:@"iPhone1,2"])
            iPhone3G = YES;
        else
            iPhone3G = NO;
        if ([[UIDevice currentDevice].platform isEqualToString:@"iPhone2,1"])
            iPhone3GS = YES;
        else
            iPhone3GS = NO;
        if ([[UIDevice currentDevice].platform isEqualToString:@"iPod1,1"])
            iPodTouch1G = YES;
        else
            iPodTouch1G = NO;
        if ([[UIDevice currentDevice].platform isEqualToString:@"iPod2,1"])
            iPodTouch2G = YES;
        else
            iPodTouch2G = NO;
        if ([[UIDevice currentDevice].platform isEqualToString:@"iPod3,1"])
            iPodTouch3G = YES;
        else
            iPodTouch3G = NO;
        timeScale = 1;
        maxElapsed = 1.0/20;
        touches = [[FlxTouches alloc] init];
        [self initAudio];
        //GK
        gameCenterManager= [[[GameCenterManager alloc] init] autorelease];
        [gameCenterManager setDelegate: self];
        [gameCenterManager authenticateLocalUser];
    }
}

+ (void)logInToGameCenter{
    NSLog(@"FlxG logintoGK does nothing");
}

+ (CGFloat) screenScale { return screenScale; }

+ (BOOL) iPad { return iPad; }
+ (BOOL) retinaDisplay { return retinaDisplay; }
+ (BOOL) iPhone1G { return iPhone1G; }
+ (BOOL) iPhone3G { return iPhone3G; }
+ (BOOL) iPhone3GS { return iPhone3GS; }
+ (BOOL) iPodTouch1G { return iPodTouch1G; }
+ (BOOL) iPodTouch2G { return iPodTouch2G; }
+ (BOOL) iPodTouch3G { return iPodTouch3G; }


+ (void) setMusic:(FlxSound *)newMusic; { [music autorelease]; music = [newMusic retain]; }
+ (FlxSound *) music; { return music; }
+ (void) setQuake:(FlxQuake *)newQuake; { [quake autorelease]; quake = [newQuake retain]; }
+ (FlxQuake *) quake; { return quake; }

+ (void) setLevel:(int)newLevel; { level = newLevel; }
+ (int) level; { return level; }

+ (void) setLevelWidth:(int)newLevelWidth; { levelWidth = newLevelWidth; }
+ (int) levelWidth; { return levelWidth; }
+ (void) setLevelHeight:(int)newLevelHeight; { levelHeight = newLevelHeight; }
+ (int) levelHeight; { return levelHeight; }

+ (void) setLeftArrowPosition:(CGPoint)newLeftArrowPosition; { leftArrowPosition = newLeftArrowPosition; }
+ (CGPoint) leftArrowPosition; { return leftArrowPosition; }

+ (void) setRightArrowPosition:(CGPoint)newRightArrowPosition; { rightArrowPosition = newRightArrowPosition; }
+ (CGPoint) rightArrowPosition; { return rightArrowPosition; }

+ (void) setButton1Position:(CGPoint)newButton1Position; { button1Position = newButton1Position; }
+ (CGPoint) button1Position; { return button1Position; }

+ (void) setButton2Position:(CGPoint)newButton2Position; { button2Position = newButton2Position; }
+ (CGPoint) button2Position; { return button2Position; }

+ (void) setDebugMode:(BOOL)newDebugMode; { debugMode = newDebugMode; }
+ (BOOL) debugMode; { return debugMode; }

+ (void) setGamePad:(int)newGamePad; { gamePad = newGamePad; }
+ (int) gamePad; { return gamePad; }

+ (void) setRestartMusic:(BOOL)newRestartMusic; { restartMusic = newRestartMusic; }
+ (BOOL) restartMusic; { return restartMusic; }

+ (void) setHasRatedThisSession:(BOOL)newHasRatedThisSession; { hasRatedThisSession = newHasRatedThisSession; }
+ (BOOL) hasRatedThisSession; { return hasRatedThisSession; }

+ (void) setHardCoreMode:(BOOL)newHardCoreMode; { hardCoreMode = newHardCoreMode; }
+ (BOOL) hardCoreMode; { return hardCoreMode; }

+ (void) setWinnitron:(BOOL)newWinnitron; { winnitron = newWinnitron; }
+ (BOOL) winnitron; { return winnitron; }

+ (void) setOldSchool:(BOOL)newOldSchool; { oldSchool = newOldSchool; }
+ (BOOL) oldSchool; { return oldSchool; }

+ (void) setFlives:(BOOL)newFlives; { flives = newFlives; }
+ (BOOL) flives; { return flives; }
+ (void) setMlives:(BOOL)newMlives; { mlives = newMlives; }
+ (BOOL) mlives; { return mlives; }

+ (void) setTimeLeft:(float)newTimeLeft; { timeLeft = newTimeLeft; }
+ (float) timeLeft; { return timeLeft; }


+ (void) setIsGameCenterAvailable:(BOOL)newIsGameCenterAvailable; { isGameCenterAvailable = newIsGameCenterAvailable; }
+ (BOOL) isGameCenterAvailable { 
    BOOL o = [gameCenterManager isGameCenterAvailable];
    //NSLog(@"available ? %d", o);
    return o;
    //return isGameCenterAvailable; 
}

// + (void) setState:(FlxState *)newState; { [state autorelease]; state = [newState retain]; }
// + (FlxState *) state; { return state; }
+ (void) setElapsed:(float)newElapsed; { elapsed = newElapsed; }
+ (float) elapsed; { return elapsed; }
+ (void) setMaxElapsed:(float)newMaxElapsed; { maxElapsed = newMaxElapsed; }
+ (float) maxElapsed; { return maxElapsed; }
+ (void) setScroll:(FlashPoint *)newScroll; { [scroll autorelease]; scroll = [newScroll retain]; }
+ (FlashPoint *) scroll; { return scroll; }
+ (void) setScore:(int)newScore; { score = newScore; }
+ (int) score; { return score; }
+ (void) setFlash:(FlxFlash *)newFlash; { [flash autorelease]; flash = [newFlash retain]; }
+ (FlxFlash *) flash; { return flash; }
+ (void) setLevels:(NSMutableArray *)newLevels; { [levels autorelease]; levels = [newLevels copy]; }
+ (NSMutableArray *) levels; { return levels; }
+ (void) setFade:(FlxFade *)newFade; { [fade autorelease]; fade = [newFade retain]; }
+ (FlxFade *) fade; { return fade; }
+ (void) setHeight:(int)newHeight; { height = newHeight; }
+ (int) height; { return height; }
+ (void) setTimeScale:(float)newTimeScale; { timeScale = newTimeScale; }
+ (float) timeScale; { return timeScale; }
+ (FlxTouches *) touches; { return touches; }
+ (void) setScores:(NSMutableArray *)newScores; { [scores autorelease]; scores = [newScores copy]; }
+ (NSMutableArray *) scores; { return scores; }
+ (void) setWidth:(int)newWidth; { width = newWidth; }
+ (int) width; { return width; }

// + (void) setGame:(FlxGame *)newGame; { [game autorelease]; game = [newGame retain]; }
// + (FlxGame *) game; { return game; }

//GK
+ (void) resetAchievements{
    [gameCenterManager resetAchievements];
    //FlxG.score=0;
}

+ (void) checkAchievement:(NSString *)achievement
{
    [gameCenterManager isGameCenterAvailable];
    
    isGameCenterAvailable = [self isGameCenterAvailable];
    
    //NSLog(@"gc avail %d", isGameCenterAvailable);
    
    if (isGameCenterAvailable){
        NSString* identifier= NULL;
        double percentComplete= 100;
        
        identifier = achievement;
        if(identifier!= NULL)
        {
            [gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
        }
    }
}

+ (void) checkAchievements
{
    //	NSString* identifier= NULL;
    //	double percentComplete= 0;
    //	switch(FlxG.score)
    //	{
    //		case 1:
    //		{
    //			identifier= kAchievementGotOneTap;
    //			percentComplete= 100.0;
    //			break;
    //		}
    //		case 2:
    //		{
    //			identifier= kAchievementHidden20Taps;
    //			percentComplete= 50.0;
    //			break;
    //		}
    //		case 3:
    //		{
    //			identifier= kAchievementHidden20Taps;
    //			percentComplete= 100.0;
    //			break;
    //		}
    //		case 4:
    //		{
    //			identifier= kAchievementBigOneHundred;
    //			percentComplete= 50.0;
    //			break;
    //		}
    //		case 5:
    //		{
    //			identifier= kAchievementBigOneHundred;
    //			percentComplete= 75.0;
    //			break;
    //		}
    //		case 6:
    //		{
    //			identifier= kAchievementBigOneHundred;
    //			percentComplete= 100.0;
    //			break;
    //		}
    //			
    //	}
    //	if(identifier!= NULL)
    //	{
    //		[gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
    //	}
}


+ (void) showUIAlertWithTitle: (NSString*) title message: (NSString*) message
{
    UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: title message: message 
                                                   delegate: NULL 
                                          cancelButtonTitle: @"OK" 
                                          otherButtonTitles: NULL] autorelease];
    [alert show];
}







+ (void) showAlertWithTitle: (NSString*) title message: (NSString*) message
{
    //	UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: title message: message 
    //                                                   delegate: NULL cancelButtonTitle: @"OK" otherButtonTitles: NULL] autorelease];
    //	[alert show];
    
    [[BCAchievementNotificationCenter defaultCenter] notifyWithTitle:title message:message image:nil];
    
}

+ (void) showAlertWithTitle: (NSString*) title message: (NSString*) message image:(UIImage *)image
{
    
    [[BCAchievementNotificationCenter defaultCenter] notifyWithTitle:title message:message image:image];
    
}


+ (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error;
{
	if((error == NULL) && (ach != NULL))
	{
		if(ach.percentComplete == 100.0)
		{
            //			[self showAlertWithTitle: @"Achievement Earned!"
            //                             message: [NSString stringWithFormat: @"Super Lemonade Factory Achievement! \"%@\"", NSLocalizedString(ach.identifier, NULL)]];
            [self showAlertWithTitle: @"Achievement Earned!"
                             message: [NSString stringWithFormat: @"\"%@\"", NSLocalizedString(ach.identifier, NULL)]];
            
		}
		else
		{
			if(ach.percentComplete > 0)
			{
				[self showAlertWithTitle: @"Achievement Progress!"
                                 message: [NSString stringWithFormat: @"Great job!  You're %.0f\%% of the way to: \"%@\"",ach.percentComplete, NSLocalizedString(ach.identifier, NULL)]];
			}
		}
	}
	else
	{
//		[self showAlertWithTitle: @"Achievement Submission Failed!"
//                         message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
	}
}

+ (void) achievementResetResult: (NSError*) error;
{
	FlxG.score = 0;
	if(error != NULL)
	{
		[self showAlertWithTitle: @"Achievement Reset Failed!"
                         message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
	}
}

//+ (void) retrieveAchievmentMetadata
//{
//    [GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *scores, NSError *error)
//     {
//         if(error != NULL) { // error handling  }
//         for (GKAchievement* achievement in scores) {
//             // work with achievement here, store it in your cache or smith
//             //NSLog(@"%@, %f", achievement.identifier, achievement.percentComplete);
//         }
//         
//     }];
// }
     
+ (NSMutableDictionary *) returnCompleteAchievements
{

//NSLog(@"ok");
//    [GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *scores, NSError *error)
//     {
//         if(error != NULL) { // error handling }
////         for (GKAchievement* achievement in scores) {
////             // work with achievement here, store it in your cache or smith
////             NSLog(@"%@, %f", achievement.identifier, achievement.percentComplete);
////             //[completeAchievements addObject:achievement];
////             
////             
////         }
//         
//         NSMutableDictionary* tempCache = [NSMutableDictionary dictionaryWithCapacity: [scores count]];
//         for (GKAchievement* score in scores)
//         {
//             [tempCache setObject: score forKey: score.identifier];
//         }
//         
//         self.earnedAchievementCache= tempCache;
//
//
//         
//     }];
//    
//    return self.earnedAchievementCache;

    return gameCenterManager.earnedAchievementCache;
}
     
     //GK END
     


+ (void) initAudio
{

    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1.0], @"MusicVolume",
                                                             [NSNumber numberWithFloat:1.0], @"SoundEffectsVolume",
                                                             [NSNumber numberWithFloat:0.7], @"buttonPressedAlpha",
                                                             [NSNumber numberWithFloat:0.3], @"buttonStartAlpha",
                                                             [NSNumber numberWithFloat:1], @"InGameHelp",
                                                             [NSNumber numberWithFloat:1], @"SwitchOnPlayerDeath",
                                                             [NSNumber numberWithFloat:0.70], @"SmoothCameraMoveDuration",
                                                             [NSNumber numberWithFloat:0], @"Vibrate",
                                                             
                                                             [NSNumber numberWithFloat:0], @"LEFT_ARROW_POSITION_X",
                                                             [NSNumber numberWithFloat:240], @"LEFT_ARROW_POSITION_Y",
                                                             [NSNumber numberWithFloat:80], @"RIGHT_ARROW_POSITION_X",
                                                             [NSNumber numberWithFloat:240], @"RIGHT_ARROW_POSITION_Y",  
                                                             
                                                             [NSNumber numberWithFloat:320], @"BUTTON_1_POSITION_X",
                                                             [NSNumber numberWithFloat:240], @"BUTTON_1_POSITION_Y",
                                                             [NSNumber numberWithFloat:400], @"BUTTON_2_POSITION_X",
                                                             [NSNumber numberWithFloat:240], @"BUTTON_2_POSITION_Y", 
                                                                                                                        
                                                             
                                                             [NSNumber numberWithFloat:1], @"CURRENT_WORLD_SELECTED", 

                                                             
                                                             
                                                             nil]];
    
    if (self.iPad) {
        [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [NSNumber numberWithFloat:0], @"LEFT_ARROW_POSITION_X",
                                                                 [NSNumber numberWithFloat:304], @"LEFT_ARROW_POSITION_Y",
                                                                 [NSNumber numberWithFloat:80], @"RIGHT_ARROW_POSITION_X",
                                                                 [NSNumber numberWithFloat:304], @"RIGHT_ARROW_POSITION_Y",  
                                                                 [NSNumber numberWithFloat:352], @"BUTTON_1_POSITION_X",
                                                                 [NSNumber numberWithFloat:304], @"BUTTON_1_POSITION_Y",
                                                                 [NSNumber numberWithFloat:432], @"BUTTON_2_POSITION_X",
                                                                 [NSNumber numberWithFloat:304], @"BUTTON_2_POSITION_Y",                                                              
                                                                 nil]];
    }
    
    
    soundEffectsMasterVolume = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SoundEffectsVolume"] floatValue];
    musicMasterVolume = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MusicVolume"] floatValue];
    [sounds autorelease];
    sounds = [[NSMutableDictionary alloc] init];
    
    NSError * error;
    
    //implicitly initialize audio session by referencing it
    [AVAudioSession sharedInstance];
    
    //set delegate
    [[AVAudioSession sharedInstance] setDelegate:self];
    
    //   AudioSessionInitialize(NULL,
    // 			 NULL,
    //  			 audioSessionInterruptHandler,
    //  			 self);
    isOtherAudioPlaying = 0;
    needToCheckForOtherAudio = YES;
    [self checkForOtherAudio];
    [self setupOpenAL];
    //make active
    if (!isOtherAudioPlaying)
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
}

+ (BOOL) isOtherMusicPlaying
{
    return isOtherAudioPlaying;
}

+ (void) vibrate;
{
    if (checkedVibration == NO) {
        doVibration = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Vibrate"] boolValue];
        checkedVibration = YES;
    }
    if (doVibration)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


+ (FlxGame *) game
{
    return _game;
}

+ (void) loadTextureAtlas;
{
    // look for all png files
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSMutableArray * dirs = [NSMutableArray arrayWithObject:resourcePath];
    
    NSMutableArray * pngs = [NSMutableArray array];
    
    while ([dirs count] > 0) {
        NSString * dir = [dirs lastObject];
        [dirs removeLastObject];
        NSDirectoryEnumerator * dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:dir];
        NSString * file;
        while (file = [dirEnum nextObject]) {
            //concat dir with file
            file = [NSString pathWithComponents:[NSArray arrayWithObjects:dir, file, nil]];
            BOOL isDir = NO;
            if ([[NSFileManager defaultManager] fileExistsAtPath:file isDirectory:&isDir]) {
                if (isDir) {
                    [dirs addObject:file];
                } else {
                    if ([[NSFileManager defaultManager] isReadableFileAtPath:file] &&
                        [[file pathExtension] isEqualToString:@"png"]) {
                        [pngs addObject:file];
                    }
                }
            }
        }
    }
    
    //compute overall area of pngs
    int totalArea = 0;
    for (NSString * png in pngs) {
        UIImage * image = [UIImage imageWithContentsOfFile:png];
        totalArea += (int)(image.size.width*image.size.height);
    }
    
}

+ (void) groupIntoTextureAtlases:(NSArray *)images ofSize:(CGSize)maxSize;
{
    NSMutableArray * toFit = [NSMutableArray arrayWithArray:images];
    
    while ([toFit count] > 0) {
        NSMutableArray * couldNotFit = [NSMutableArray array];
        while ([toFit count] > 0 &&
               [self groupIntoTextureAtlas:toFit ofSize:maxSize] == NO) {
            if ([toFit count] > 1) //make sure we don't get stuck in an infinite loop
                [couldNotFit addObject:[toFit lastObject]];
            else {
                //at least load this image to it's own texture
                // 	NSLog(@"toFit lastObject: %@", [toFit lastObject]);
                //TODO:
            }
            [toFit removeLastObject];
        }
        toFit = couldNotFit;
    }
}

+ (BOOL) groupIntoTextureAtlas:(NSArray *)imageFiles
{
    GLint maxTextureSize = FlxGLView.maxTextureSize;
    CGSize size = CGSizeMake((float)maxTextureSize, (float)maxTextureSize);
    return [self groupIntoTextureAtlas:imageFiles ofSize:size];
}

+ (BOOL) groupIntoTextureAtlas:(NSArray *)imageFiles ofSize:(CGSize)size
{
    //   fprintf(stderr, "\n\n\n");
    int totalArea = 0;
    for (NSString * imageFile in imageFiles) {
        //UIImage * image = [UIImage imageNamed:imageFile];
        NSString * filename = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], imageFile];
        UIImage * image = [UIImage imageWithContentsOfFile:filename];
        
        //NSLog(@"image:%@, size:%dx%d", imageFile, (int)(image.size.width), (int)(image.size.height));
        totalArea += (int)(image.size.width*image.size.height);
    }
    //NSLog(@"totalArea: %d", totalArea);
    //fprintf(stderr, "\n\n\n");
    
    if (totalArea > size.width*size.height) {
        //NSLog(@"bailing early, impossible to fit in requested size");
        return NO;
    }
    
    //try to pack all this stuff together into a 1024x1024 (maxTextureSize x maxTextureSize) texture, keeping track of offsets
    NSMutableArray * blocks = [NSMutableArray arrayWithArray:imageFiles];
    NSMutableArray * placedBlocks = [NSMutableArray array];
    
    NSMutableDictionary * placements = [NSMutableDictionary dictionary];
    
    CGRect enclosingRectangle = CGRectZero;
    
    //place the first image
    NSString * firstFile = [blocks lastObject];
    //UIImage * first = [UIImage imageNamed:firstFile];
    NSString * firstFilename = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], firstFile];
    UIImage * first = [UIImage imageWithContentsOfFile:firstFilename];
    [blocks removeLastObject];
    [placedBlocks addObject:firstFile];
    
    CGRect firstPlacement = CGRectMake(0, 0, first.size.width, first.size.height);
    [placements setObject:[NSValue valueWithCGRect:firstPlacement] forKey:firstFile];
    
    enclosingRectangle = firstPlacement;
    
    //GLint maxTextureSize = FlxGLView.maxTextureSize;
    GLint maxTextureWidth = (GLint)size.width;
    GLint maxTextureHeight = (GLint)size.height;
    
    //NSLog(@"MAX TEXTURE SIZE: (%d,%d)", maxTextureWidth, maxTextureHeight);
    
    for (NSString * block in blocks) {
        int objective = INT_MAX; //find the best placement for block, need to reset objective so that we can minimize
        CGRect bestPlacement = CGRectZero;
        //UIImage * image = [UIImage imageNamed:block];
        NSString * blockFilename = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], block];
        UIImage * image = [UIImage imageWithContentsOfFile:blockFilename];
        for (NSString * placed in placedBlocks) {
            CGRect placedRect = [[placements objectForKey:placed] CGRectValue];
            for (int a = 0; a < 4; ++a) {
                for (int b = 0; b < 4; ++b) {
                    //place corner b of block on corner a of placed
                    //corner 0: bottom left
                    //corner 1: bottom right
                    //corner 2: top left
                    //corner 3: top right
                    CGRect placement = CGRectZero;
                    placement.size = image.size;
                    //where do we put it?
                    CGPoint origin = CGPointZero;
                    switch (a) {
                        case 0:
                            origin = placedRect.origin;
                            break;
                        case 1:
                            origin = CGPointMake(placedRect.origin.x+placedRect.size.width, placedRect.origin.y);
                            break;
                        case 2:
                            origin = CGPointMake(placedRect.origin.x, placedRect.origin.y+placedRect.size.height);
                            break;
                        case 3:
                            origin = CGPointMake(placedRect.origin.x+placedRect.size.width, placedRect.origin.y+placedRect.size.height);
                            break;
                    }
                    switch (b) {
                        case 0:
                            //nothing, already in right place
                            break;
                        case 1:
                            origin = CGPointMake(origin.x-image.size.width, origin.y);
                            break;
                        case 2:
                            origin = CGPointMake(origin.x, origin.y-image.size.height);
                            break;
                        case 3:
                            origin = CGPointMake(origin.x-image.size.width, origin.y-image.size.height);
                            break;
                    }
                    //check boundary conditions
                    if (origin.x < 0 || origin.y < 0 ||
                        origin.x+image.size.width >= maxTextureWidth ||
                        origin.y+image.size.height >= maxTextureHeight)
                        break;
                    //check overlap conditions
                    CGRect potentialPlacement = CGRectMake(origin.x, origin.y, image.size.width, image.size.height);
                    BOOL overlaps = NO;
                    for (NSString * placed2 in placedBlocks) {
                        CGRect placedRect2 = [[placements objectForKey:placed2] CGRectValue];
                        if (CGRectIntersectsRect(potentialPlacement, placedRect2)) {
                            overlaps = YES;
                            break;
                        }
                    }
                    if (overlaps)
                        break;
                    //calculate newObjective
                    CGRect potentialEnclosingRectangle = enclosingRectangle;
                    if (potentialEnclosingRectangle.size.width < potentialPlacement.origin.x+potentialPlacement.size.width)
                        potentialEnclosingRectangle.size.width = potentialPlacement.origin.x + potentialPlacement.size.width;
                    if (potentialEnclosingRectangle.size.height < potentialPlacement.origin.y+potentialPlacement.size.height)
                        potentialEnclosingRectangle.size.height = potentialPlacement.origin.y + potentialPlacement.size.height;
                    int newObjective = potentialEnclosingRectangle.size.width*potentialEnclosingRectangle.size.height +
                    (potentialPlacement.origin.y + potentialEnclosingRectangle.size.width)/2;
                    if (newObjective < objective) {
                        objective = newObjective;
                        bestPlacement = potentialPlacement;
                    }
                }
            }
        }
        //check if we found a placement
        if (CGRectEqualToRect(bestPlacement, CGRectZero)) {
            //NSLog(@"Could not find a valid placement! bailing...");
            return NO;
        }
        
        //add best placement to placements
        [placements setObject:[NSValue valueWithCGRect:bestPlacement] forKey:block];
        [placedBlocks addObject:block];
        
        if (enclosingRectangle.size.width < bestPlacement.origin.x+bestPlacement.size.width)
            enclosingRectangle.size.width = bestPlacement.origin.x + bestPlacement.size.width;
        if (enclosingRectangle.size.height < bestPlacement.origin.y+bestPlacement.size.height)
            enclosingRectangle.size.height = bestPlacement.origin.y+bestPlacement.size.height;
    }
    
#if 0
    //would be cool to actually generate the atlas image...
    
    
    unsigned char * data = calloc(maxTextureWidth*maxTextureHeight*4, sizeof(unsigned char));
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGContextRef imageContext = CGBitmapContextCreate(data,
                                                      maxTextureWidth,
                                                      maxTextureHeight,
                                                      8,
                                                      maxTextureWidth*4,
                                                      colorspace,
                                                      kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorspace);
    
    //can i somehow erase everything in imageContext?
    CGContextClearRect(imageContext,
                       CGRectMake(0, 0, maxTextureWidth, maxTextureHeight));
    
    for (NSString * imageFile in placements) {
        //UIImage * image = [UIImage imageNamed:imageFile];
        NSString * imageFilename = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], imageFile];
        UIImage * image = [UIImage imageWithContentsOfFile:imageFilename];
        CGRect placement = [[placements objectForKey:imageFile] CGRectValue];
        CGContextDrawImage(imageContext,
                           placement,
                           image.CGImage);
    }
    
    //somehow render to a uiimage?
    CGImageRef atlasCGImage = CGBitmapContextCreateImage(imageContext);
    UIImage * atlasImage = [UIImage imageWithCGImage:atlasCGImage];
    //write it to the photo library?
    
    UIImageWriteToSavedPhotosAlbum(atlasImage, nil, NULL, NULL);
    
    CGImageRelease(atlasCGImage);
    
    CGContextRelease(imageContext);
    free(data);
    
#endif
    
    //create an opengl texture to hold all of these images
    //then set up texture objects to correspond to this opengl texture with
    //appropriate offsets and texture coordinates
    
    //    NSLog(@"enclosingRectangle: [%f,%f,%f,%f]",
    //  	enclosingRectangle.origin.x,
    //  	enclosingRectangle.origin.y,
    //  	enclosingRectangle.size.width,
    //  	enclosingRectangle.size.height);
    
    SemiSecretTexture * atlasTexture = [SemiSecretTexture textureWithSize:enclosingRectangle.size
                                                                   images:imageFiles
                                                                locations:placements];
    
    //   NSLog(@"atlasTexture.texture: %d", atlasTexture.texture);
    
    for (NSString * imageFile in imageFiles) {
        CGRect placement = [[placements objectForKey:imageFile] CGRectValue];
        SemiSecretTexture * texture = [SemiSecretTexture textureWithAtlasTexture:atlasTexture
                                                                          offset:placement.origin
                                                                            size:placement.size];
        [_cache setObject:texture forKey:imageFile];
        //     NSLog(@" -> %@", imageFile);
    }
    
    //NSLog(@"_cache: %@", [_cache description]);
    
    return YES;
}

+ (void) clearTextureCache
{
    [_cache removeAllObjects];
}


+ (void) log:(NSString *)Data;
{
    NSLog(@"FlxG.log: %@", Data);
    //    [_game._console log:(Data == nil) ? @"ERROR: null object" : [Data toString]];
}

// - (void) setElapsed:(float)newElapsed
// {
//   elapsed = newElapsed*timeScale;
// }

+ (void) setState:(FlxState *)State
{
    [_game switchState:State];
}

+ (FlxState *) state
{
    return _game.state;
}


// + (BOOL) pause;
// {
//    return _pause;
// }
// + (void) pause:(BOOL)Pause;
// {
//    BOOL op = _pause;
//    _pause = Pause;
//    if (_pause != op)
//       {
//          if (_pause)
//             {
//                [_game pauseGame];
//                [self pauseSounds];
//             }
//          else
//             {
//                [_game unpauseGame];
//                [self playSounds];
//             }
//       }
// }
// + (void) resetInput;
// {
//    [keys reset];
//    [mouse reset];
// }


+ (void) playMusic:(NSString *)Music;
{
    return [self playMusicWithParam1:Music param2:1];
}

+ (void) playMusicWithParam1:(NSString *)Music param2:(float)Volume;
{
    
    //     if (isOtherAudioPlaying)
    //       return;
    
    //   [NSThread detachNewThreadSelector:@selector(reallyPlayMusic:) toTarget:self withObject:Music];
    
//    [self performSelector:@selector(reallyPlayMusic:)
//               withObject:Music
//               afterDelay:0.0];
    
    float volume = musicMasterVolume*Volume; //[[[NSUserDefaults standardUserDefaults] objectForKey:@"MusicVolume"] floatValue];
    
    if (volume > 0.0) {
        NSError * error;
        
        @synchronized(self) {
            if (audioPlayer)
                [audioPlayer release];
            audioPlayer =
            [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], Music] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                                   error:&error];
            if (audioPlayer) {
                audioPlayer.delegate = self;
                audioPlayer.numberOfLoops = -1;
                if (!isOtherAudioPlaying)
                    [audioPlayer play];
                audioPlayer.volume = volume;
            } else {
                NSLog(@"error!");
            }
            if (error) {
                NSLog(@"error: %@, %@", error, [error localizedDescription]);
            }
        }
    }
    
    
    
    
}



+ (void) reallyPlayMusic:(NSString *)Music
{
    //   NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];  
    
    float volume = musicMasterVolume; //[[[NSUserDefaults standardUserDefaults] objectForKey:@"MusicVolume"] floatValue];
    
    if (volume > 0.0) {
        NSError * error;
        
        @synchronized(self) {
            if (audioPlayer)
                [audioPlayer release];
            audioPlayer =
            [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], Music] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                                   error:&error];
            if (audioPlayer) {
                audioPlayer.delegate = self;
                audioPlayer.numberOfLoops = -1;
                if (!isOtherAudioPlaying)
                    [audioPlayer play];
                audioPlayer.volume = volume;
            } else {
                NSLog(@"error!");
            }
            if (error) {
                NSLog(@"error: %@, %@", error, [error localizedDescription]);
            }
        }
    }
    
    //   [pool release];
}


+ (void) fadeOutMusic:(float)duration;
{
    // float volume = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MusicVolume"] floatValue];
    float volume = musicMasterVolume;
    fadeOutVolume = volume;
    fadeOutTimer = fadeOutDuration = duration;
}


+ (void) updateSounds;
{
    
//    NSLog(@"%f", audioPlayer.volume);
    
    if (fadeOutTimer <= 0)
        return;
    
    fadeOutTimer -= elapsed;
    if (fadeOutTimer < 0)
        fadeOutTimer = 0;
    
    @synchronized(self) {
        audioPlayer.volume = fadeOutVolume * (fadeOutTimer/fadeOutDuration);
        
        if (fadeOutTimer == 0) {
            [audioPlayer release];
            audioPlayer = nil;
        }
    }
}

+ (void) pauseMusic
{
    @synchronized(self) {
        if (audioPlayer) {
            [audioPlayer pause];
            musicPaused = YES;
        }
    }
}

+ (void) unpauseMusic
{
    @synchronized(self) {
        if (audioPlayer && !isOtherAudioPlaying && !audioPlayer.playing) {
            [audioPlayer play];
            musicPaused = NO;
        }
    }
}

// + (void) applicationWillResignActive:(NSNotification *)note
// {
//   @synchronized(self) {
//     if (audioPlayer && audioPlayer.playing) {
//       NSLog(@"forcing audioPlayer to pause");
//       [audioPlayer pause];
//     }
//   }
//   needToCheckForOtherAudio = YES;
// }

// + (void) applicationDidBecomeActive:(NSNotification *)note
// {
//   if (needToCheckForOtherAudio == NO)
//     return;
//   //check audio state again -> should we start playing background music?
//   [self checkForOtherAudio];
//   @synchronized(self) {
//     if (audioPlayer && !isOtherAudioPlaying && !audioPlayer.playing) {
//       NSLog(@"trying to get audioPlayer to play again...");
//       if (!musicPaused)
// 	[audioPlayer play];
//     } else {
//       if (!audioPlayer)
// 	NSLog(@"no audio player..");
//       if (isOtherAudioPlaying)
// 	NSLog(@"thinks other audio is playing...");
//       if (audioPlayer.playing)
// 	NSLog(@"thinks audio player is already playing...");
//     }
//   }
// }

//+ (void) audioSessionBeginInterruption
+ (void) beginInterruption
{
    [self teardownOpenAL]; // why was this commented out?
    NSError * error;
    [[AVAudioSession sharedInstance] setActive:NO error:&error];
    NSLog(@"beginInterruption");
    needToCheckForOtherAudio = YES;
}

//+ (void) audioSessionEndInterruption
+ (void) endInterruption
{
    NSLog(@"endInterruption");
    NSError * error;
    [self checkForOtherAudio];
    [self setupOpenAL];
    if (!isOtherAudioPlaying)
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    //reload effects
    for (NSValue * sound in [sounds objectEnumerator]) {
        SoundParameters * sp = (SoundParameters *)[sound pointerValue];
        alGenSources(1, &sp->source);
        alGenBuffers(1, &sp->buffer);
        alBufferDataStaticProc(sp->buffer,
                               sp->dataFormat,
                               sp->data,
                               sp->byteCount,
                               sp->sampleRate);
        alSourcei(sp->source, AL_BUFFER, sp->buffer);
    }
}

+ (void) audioPlayerBeginInterruption:(AVAudioPlayer *)player;
{
    needToCheckForOtherAudio = YES;
    if (isOtherAudioPlaying)
        return;
    @synchronized(self) {
        [player pause];
    }
}

+ (void) audioPlayerEndInterruption:(AVAudioPlayer *)player;
{
    [self checkForOtherAudio];
    @synchronized(self) {
        if (player && !isOtherAudioPlaying && !player.playing)
            [player play];
    }
}

+ (void) checkForOtherAudio
{
    if (!needToCheckForOtherAudio)
        return;
    
    UInt32 sizeOfIsOtherAudioPlaying = sizeof(isOtherAudioPlaying);
    AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying,
                            &sizeOfIsOtherAudioPlaying,
                            &isOtherAudioPlaying);
    
    
    NSString * category = AVAudioSessionCategorySoloAmbient;
    if (isOtherAudioPlaying) {
        category = AVAudioSessionCategoryAmbient;
        NSLog(@"setting category to ambient sound");
    } else {
        NSLog(@"setting to solo ambient");
    }
    
    NSError * error;
    [[AVAudioSession sharedInstance] setCategory:category
                                           error:&error];
    
    if (!isOtherAudioPlaying)
        AudioSessionSetActive(true); //this was commented out, need to comment again?
    
    needToCheckForOtherAudio = NO;
}

+ (void) setupOpenAL
{
    device = NULL;
    context = NULL;
    OSStatus result;
    device = alcOpenDevice(NULL);
    result = alGetError();
    if (result != AL_NO_ERROR)
        NSLog(@"Error opening output device: %x", (int)result);
    if (device == NULL)
        return;
    //alcMacOSXMixerOutputRateProc(44100);
    //alcMacOSXMixerOutputRateProc(22050);
    context = alcCreateContext(device, 0);
    result = alGetError();
    if (result != AL_NO_ERROR)
        NSLog(@"Error creating OpenAL context: %x", (int)result);
    if (context == NULL)
        return;
    alcMakeContextCurrent(context);
    result = alGetError();
    if (result != AL_NO_ERROR)
        NSLog(@"Error setting current OpenAL context: %x", (int)result);
    alListener3f(AL_POSITION, 0.0, 0.0, 1.0);
    
    result = alGetError();
    if (result != AL_NO_ERROR)
        NSLog(@"Error setting listener position: %x", (int)result);
    
}

+ (void) teardownOpenAL
{
    for (NSValue * sound in [sounds objectEnumerator]) {
        SoundParameters * sp = (SoundParameters *)[sound pointerValue];
        alDeleteSources(1, &sp->source);
    }
    if (context)
        alcDestroyContext(context);
    if (device)
        alcCloseDevice(device);
}

+ (void) loadSound:(NSString *)filename
{
    
    NSValue * sound = [sounds objectForKey:filename];
    if (sound)
        return;
    
    NSString * path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename];
    
    ALuint source;
    ALuint soundBuffer;
    void * soundData;
    
    alGenSources(1, &source);
    
    AudioStreamBasicDescription dataFormat;
    AudioFileID audioFileID;
    UInt32 dataFormatSize = sizeof(dataFormat);
    UInt64 byteCount;
    UInt32 byteCountSize = sizeof(byteCount);
    CFURLRef url = (CFURLRef)[NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    OSStatus result = noErr;
#if TARGET_OS_IPHONE
    result = AudioFileOpenURL(url, kAudioFileReadPermission, 0, &audioFileID);
#else
    result = AudioFileOpenURL(url, fsRdPerm, 0, &audioFileID);
#endif
    //assert no error
    if (result != noErr)
        NSLog(@"Error opening file (%@): %d", filename, (int)result);
    
    result = AudioFileGetProperty(audioFileID, kAudioFilePropertyDataFormat, &dataFormatSize, &dataFormat);
    //assert no error
    if (result != noErr)
        NSLog(@"Error getting file format (%@): %d", filename, (int)result);
    
    result = AudioFileGetProperty(audioFileID, kAudioFilePropertyAudioDataByteCount, &byteCountSize, &byteCount);
    
    if (result != noErr)
        NSLog(@"Error getting file data size (%@): %d", filename, (int)result);
    
    UInt32 byteCount32 = (UInt32)byteCount;
    
    soundData = malloc(byteCount32);
    
    result = AudioFileReadBytes(audioFileID, false, 0, &byteCount32, soundData);
    
    if (result != noErr)
        NSLog(@"Error reading file data (%@): %d", filename, (int)result);
    
    alGenBuffers(1, &soundBuffer);
    
    result = alGetError();
    if (result != AL_NO_ERROR)
        NSLog(@"Error generating buffer (%@): %x", filename, (int)result);
    
    ALenum alDataFormat;
    if (dataFormat.mFormatID != kAudioFormatLinearPCM)
        alDataFormat = -1;
    else if ((dataFormat.mChannelsPerFrame > 2) ||
             (dataFormat.mChannelsPerFrame < 1))
        alDataFormat = -1;
    else if (dataFormat.mBitsPerChannel == 8)
        alDataFormat = (dataFormat.mChannelsPerFrame == 1) ? AL_FORMAT_MONO8 : AL_FORMAT_STEREO8;
    else if (dataFormat.mBitsPerChannel == 16)
        alDataFormat = (dataFormat.mChannelsPerFrame == 1) ? AL_FORMAT_MONO16 : AL_FORMAT_STEREO16;
    else
        alDataFormat = -1;
    
    alBufferDataStaticProc(soundBuffer,
                           alDataFormat,
                           soundData,
                           byteCount32,
                           dataFormat.mSampleRate);
    
    result = alGetError();
    if (result != AL_NO_ERROR)
        NSLog(@"Error attaching data to buffer (%@): %x", filename, (int)result);
    
    AudioFileClose(audioFileID);
    
    alSourcei(source, AL_BUFFER, soundBuffer);
    
    alSourcef(source, AL_GAIN, soundEffectsMasterVolume);
    
    result = alGetError();
    if (result != AL_NO_ERROR)
        NSLog(@"Error attaching file data to effect (%@): %x", filename, (int)result);
    
    SoundParameters * sp = (SoundParameters *)malloc(sizeof(SoundParameters));
    sp->source = source;
    sp->buffer = soundBuffer;
    sp->data = soundData;
    sp->dataFormat = alDataFormat;
    sp->byteCount = byteCount32;
    sp->sampleRate = dataFormat.mSampleRate;
    [sounds setObject:[NSValue valueWithPointer:sp] forKey:filename];
}


+ (FlxSound *) play:(NSString *)EmbeddedSound;
{
    return [self playWithParam1:EmbeddedSound param2:1];
}
+ (FlxSound *) playWithParam1:(NSString *)EmbeddedSound param2:(float)Volume;
{
    return [self playWithParam1:EmbeddedSound param2:Volume param3:NO];
}
+ (FlxSound *) playWithParam1:(NSString *)EmbeddedSound param2:(float)Volume param3:(BOOL)Looped;
{
    NSValue * sound = [sounds objectForKey:EmbeddedSound];
    if (!sound) {
        [self loadSound:EmbeddedSound];
        sound = [sounds objectForKey:EmbeddedSound];
        if (!sound) {
            NSLog(@"unable to load sound: %@", EmbeddedSound);
            return nil;
        }
    }
    
    SoundParameters * sp = (SoundParameters *)[sound pointerValue];
    OSStatus result = AL_NO_ERROR;
    alSourcef(sp->source, AL_GAIN, Volume*soundEffectsMasterVolume);
    if (Looped)
        alSourcei(sp->source, AL_LOOPING, AL_TRUE);
    else
        alSourcei(sp->source, AL_LOOPING, AL_FALSE);
    alSourcePlay(sp->source);
    result = alGetError();
    if (result != AL_NO_ERROR)
        NSLog(@"Error playing sound: %@, error: %x", EmbeddedSound, (int)result);
    
    //    unsigned int sl = sounds.length;
    //    for ( unsigned int i = 0; i < sl; i++ )
    //       if (!(((FlxSound *)([sounds objectAtIndex:i]))).active)
    //          break;
    //    if ([sounds objectAtIndex:i] == nil)
    //       [sounds objectAtIndex:i] = [[[FlxSound alloc] init] autorelease];
    //    FlxSound * s = [sounds objectAtIndex:i];
    //    [s loadEmbeddedWithParam1:EmbeddedSound param2:Looped];
    //    s.volume = Volume;
    //    [s play];
    //    return s;
    return nil;
}

+ (FlxSound *) play:(NSString *)EmbeddedSound withVolume:(float)Volume;
{
    return [self playWithParam1:EmbeddedSound param2:Volume];
}
+ (FlxSound *) play:(NSString *)EmbeddedSound withVolume:(float)Volume looped:(BOOL)Looped;
{
    return [self playWithParam1:EmbeddedSound param2:Volume param3:Looped];
}

+ (void) stop:(NSString *)EmbeddedSound;
{
    NSValue * sound = [sounds objectForKey:EmbeddedSound];
    if (!sound)
        return;
    
    SoundParameters * sp = (SoundParameters *)[sound pointerValue];
    OSStatus result = AL_NO_ERROR;
    alSourceStop(sp->source);
    result = alGetError();
    if (result != AL_NO_ERROR)
        NSLog(@"Error stopping sound: %@, error: %x", EmbeddedSound, (int)result);
}

+ (BOOL) playing:(NSString *)EmbeddedSound
{
    NSValue * sound = [sounds objectForKey:EmbeddedSound];
    if (!sound)
        return NO;
    
    SoundParameters * sp = (SoundParameters *)[sound pointerValue];
    OSStatus result = AL_NO_ERROR;
    int value;
    alGetSourcei(sp->source, AL_SOURCE_STATE, &value);
    result = alGetError();
    if (result != AL_NO_ERROR) {
        NSLog(@"Could not determine state for sound: %@, error: %x", EmbeddedSound, (int)result);
        return NO;
    }
        
    return value == AL_PLAYING;
}



+ (BOOL) checkBitmapCache:(NSString *)Key;
{
    return ([_cache objectForKey:Key] != nil); // && ([_cache objectForKey:Key] != nil);
}

+ (SemiSecretTexture *) addTextureWithParam1:(NSString *)Graphic param2:(BOOL)Unique;
{
    NSString * key = Graphic;
    if (Unique && [_cache objectForKey:key] != nil) {
        unsigned int inc = 0;
        NSString * ukey;
        do {
            ukey = [NSString stringWithFormat:@"%@%d", key, inc++];
        } while ([_cache objectForKey:ukey] != nil);
        key = ukey;
    }
    
    SemiSecretTexture * texture = [_cache objectForKey:key];
    if (texture == nil) {
        texture = [SemiSecretTexture textureWithImage:Graphic];
        [_cache setObject:texture forKey:key];
    }
    return texture;
}

+ (void) setTexture:(SemiSecretTexture *)Texture forKey:(NSString *)Key;
{
    [_cache setObject:Texture forKey:Key];
}

+ (SemiSecretTexture *) createBitmapWithParam1:(unsigned int)Width param2:(unsigned int)Height param3:(unsigned int)Color param4:(BOOL)Unique param5:(NSString *)Key;
{
    NSString * key = Key;
    if (key == nil) {
        key = [NSString stringWithFormat:@"%dx%d:%d", Width, Height, Color];
        if (Unique && [_cache objectForKey:key] != nil) {
            unsigned int inc = 0;
            NSString * ukey;
            do {
                ukey = [NSString stringWithFormat:@"%@%d", key, inc++];
            } while ([_cache objectForKey:ukey] != nil);
            key = ukey;
        }
    }
    SemiSecretTexture * texture = [_cache objectForKey:key];
    if (texture == nil) {
        //todo: how to make this the requested size? does it matter?
        texture = [SemiSecretTexture textureWithColor:Color];
        [_cache setObject:texture forKey:key];
    }
    return texture;
}

+ (void) setPauseFollow:(BOOL)newPauseFollow;
{
    pauseFollow = newPauseFollow;
}
+ (BOOL) pauseFollow;
{
    return pauseFollow;
}
+ (void) follow:(FlxObject *)Target;
{
    return [self followWithParam1:Target param2:1];
}
+ (void) followWithParam1:(FlxObject *)Target param2:(float)Lerp;
{
    pauseFollow = NO;
    [followTarget autorelease];
    followTarget = [Target retain];
    followLerp = Lerp;
    //   if (_scrollTarget == nil) //why is this necessary?
    //     _scrollTarget = [[FlashPoint alloc] init];
    //   _scrollTarget.x = ((int)width >> 1) - followTarget.x - ((int)(followTarget.width) >> 1) + (((FlxSprite *)(followTarget))).offset.x;
    //   _scrollTarget.y = ((int)height >> 1) - followTarget.y - ((int)(followTarget.height) >> 1) + (((FlxSprite *)(followTarget))).offset.y;
    _scrollTarget.x = ((int)width>>1)-followTarget.x-((int)(followTarget.width)>>1);
    _scrollTarget.y = ((int)height>>1)-followTarget.y-((int)(followTarget.height)>>1);
    scroll.x = _scrollTarget.x;
    scroll.y = _scrollTarget.y;
    [self doFollow];
}
+ (void) followAdjust;
{
    return [self followAdjust:0];
}
+ (void) followAdjust:(float)LeadX;
{
    return [self followAdjustWithParam1:LeadX param2:0];
}
+ (void) followAdjustWithParam1:(float)LeadX param2:(float)LeadY;
{
    [followLead autorelease];
    followLead = [[FlashPoint alloc] initWithX:LeadX y:LeadY];
}
+ (void) followBounds;
{
    return [self followBounds:0];
}
+ (void) followBounds:(int)MinX;
{
    return [self followBoundsWithParam1:MinX param2:0];
}
+ (void) followBoundsWithParam1:(int)MinX param2:(int)MinY;
{
    return [self followBoundsWithParam1:MinX param2:MinY param3:0];
}
+ (void) followBoundsWithParam1:(int)MinX param2:(int)MinY param3:(int)MaxX;
{
    return [self followBoundsWithParam1:MinX param2:MinY param3:MaxX param4:0];
}
+ (void) followBoundsWithParam1:(int)MinX param2:(int)MinY param3:(int)MaxX param4:(int)MaxY;
{
    return [self followBoundsWithParam1:MinX param2:MinY param3:MaxX param4:MaxY param5:YES];
}
+ (void) followBoundsWithParam1:(int)MinX param2:(int)MinY param3:(int)MaxX param4:(int)MaxY param5:(BOOL)UpdateWorldBounds;
{
    [followMin autorelease];
    followMin = [[FlashPoint alloc] initWithX:-MinX y:-MinY];
    [followMax autorelease];
    followMax = [[FlashPoint alloc] initWithX:-MaxX + width y:-MaxY + height];
    if (followMax.x > followMin.x)
        followMax.x = followMin.x;
    if (followMax.y > followMin.y)
        followMax.y = followMin.y;
    if (UpdateWorldBounds)
        [FlxU setWorldBoundsWithParam1:-MinX param2:-MinY param3:-MinX + MaxX param4:-MinY + MaxY];
    [self doFollow];
}
// - (Stage *) stage;
// {
//    if ((_game._state != nil) && (_game._state.parent != nil))
//       return _game._state.parent.stage;
//    return nil;
// }
// - (FlxState *) state;
// {
//    return _game._state;
// }
// - (void) state:(FlxState *)State;
// {
//    [_game switchState:State];
// }

+ (void) setGameData:(FlxGame *)Game width:(int)Width height:(int)Height zoom:(float)Zoom;
{
    //is SemiSecretGLView setup?
    [_game autorelease];
    _game = [Game retain];
    width = Width;
    height = Height;
    _mute = NO;
    //_volume = 0.5;
    
    
    
    [scroll autorelease];
    scroll = nil;
    [_scrollTarget autorelease];
    _scrollTarget = nil;
    [self unfollow];
    FlxG.levels = [[[NSMutableArray alloc] init] autorelease];
    FlxG.scores = [[[NSMutableArray alloc] init] autorelease];
    level = 0;
    score = 0;
    FlxU.seed = NAN;
    
    
    [quake autorelease];
    quake = [(FlxQuake *)[FlxQuake alloc] initWithParam1:Zoom];
    [flash autorelease];
    flash = [[FlxFlash alloc] init];
    [fade autorelease];
    fade = [[FlxFade alloc] init];
    
    [FlxU setWorldBounds];
}

+ (void) doFollow;
{
    if (!pauseFollow) {
        if (followTarget != nil) {
            _scrollTarget.x = ((int)width >> 1) - followTarget.x - ((int)(followTarget.width) >> 1);
            _scrollTarget.y = ((int)height >> 1) - followTarget.y - ((int)(followTarget.height) >> 1);
            if ((followLead != nil) && ([followTarget isKindOfClass:[FlxSprite class]])) {
                _scrollTarget.x -= (((FlxSprite *)(followTarget))).velocity.x * followLead.x;
                _scrollTarget.y -= (((FlxSprite *)(followTarget))).velocity.y * followLead.y;
            }
            scroll.x += (_scrollTarget.x - scroll.x) * followLerp * FlxG.elapsed;
            scroll.y += (_scrollTarget.y - scroll.y) * followLerp * FlxG.elapsed;
            if (followMin != nil) {
                if (scroll.x > followMin.x)
                    scroll.x = followMin.x;
                if (scroll.y > followMin.y)
                    scroll.y = followMin.y;
            }
            if (followMax != nil) {
                if (scroll.x < followMax.x)
                    scroll.x = followMax.x;
                if (scroll.y < followMax.y)
                    scroll.y = followMax.y;
            }
        }
    }
}

+ (void) unfollow;
{
    [followTarget autorelease];
    followTarget = nil;
    [followLead autorelease];
    followLead = nil;
    followLerp = 1;
    [followMin autorelease];
    followMin = nil;
    [followMax autorelease];
    followMax = nil;
    if (scroll == nil)
        scroll = [[FlashPoint alloc] init];
    else
        scroll.x = scroll.y = 0;
    if (_scrollTarget == nil)
        _scrollTarget = [[FlashPoint alloc] init];
    else
        _scrollTarget.x = _scrollTarget.y = 0;
}

+ (int) levelProgress
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSInteger level1,level2,level3,level4,level5,
    level6, level7,level8,level9, level10,
    level11,level12,level13,level14, level15,
    level16,level17,level18,level19, level20,
    level21,level22,level23,level24, level25,
    level26,level27,level28,level29, level30,
    level31,level32,level33,level34,level35,level36;
    
    level1 = [prefs integerForKey:@"level1"];
    level2 = [prefs integerForKey:@"level2"];
    level3 = [prefs integerForKey:@"level3"];    
    level4 = [prefs integerForKey:@"level4"];
    level5 = [prefs integerForKey:@"level5"];
    level6 = [prefs integerForKey:@"level6"];
    level7 = [prefs integerForKey:@"level7"];
    level8 = [prefs integerForKey:@"level8"];
    level9 = [prefs integerForKey:@"level9"];
    level10 = [prefs integerForKey:@"level10"];
    level11 = [prefs integerForKey:@"level11"];
    level12 = [prefs integerForKey:@"level12"];
    
    level13 = [prefs integerForKey:@"level13"];
    level14 = [prefs integerForKey:@"level14"];
    level15 = [prefs integerForKey:@"level15"];
    level16 = [prefs integerForKey:@"level16"];
    level17 = [prefs integerForKey:@"level17"];
    level18 = [prefs integerForKey:@"level18"];
    level19 = [prefs integerForKey:@"level19"];
    level20 = [prefs integerForKey:@"level20"];
    level21 = [prefs integerForKey:@"level21"];
    level22 = [prefs integerForKey:@"level22"];
    level23 = [prefs integerForKey:@"level23"];
    level24 = [prefs integerForKey:@"level24"];
    
    level25 = [prefs integerForKey:@"level25"];
    level26 = [prefs integerForKey:@"level26"];
    level27 = [prefs integerForKey:@"level27"];
    level28 = [prefs integerForKey:@"level28"];
    level29 = [prefs integerForKey:@"level29"];
    level30 = [prefs integerForKey:@"level30"];
    level31 = [prefs integerForKey:@"level31"];
    level32 = [prefs integerForKey:@"level32"];
    level33 = [prefs integerForKey:@"level33"];
    level34 = [prefs integerForKey:@"level34"];
    level35 = [prefs integerForKey:@"level35"];
    level36 = [prefs integerForKey:@"level36"];    
    
    NSInteger levelsComplete = 0;
    
    if (level1>=1) levelsComplete++;
    if (level2>=1) levelsComplete++;
    if (level3>=1) levelsComplete++;
    if (level4>=1) levelsComplete++;
    if (level5>=1) levelsComplete++;
    if (level6>=1) levelsComplete++;
    if (level7>=1) levelsComplete++;
    if (level8>=1) levelsComplete++;
    if (level9>=1) levelsComplete++;
    if (level10>=1) levelsComplete++;
    if (level11>=1) levelsComplete++;
    if (level12>=1) levelsComplete++;
    
    if (level13>=1) levelsComplete++;
    if (level14>=1) levelsComplete++;
    if (level15>=1) levelsComplete++;
    if (level16>=1) levelsComplete++;
    if (level17>=1) levelsComplete++;
    if (level18>=1) levelsComplete++;
    if (level19>=1) levelsComplete++;
    if (level20>=1) levelsComplete++;
    if (level21>=1) levelsComplete++;
    if (level22>=1) levelsComplete++;
    if (level23>=1) levelsComplete++;
    if (level24>=1) levelsComplete++;
    
    if (level25>=1) levelsComplete++;
    if (level26>=1) levelsComplete++;
    if (level27>=1) levelsComplete++;
    if (level28>=1) levelsComplete++;
    if (level29>=1) levelsComplete++;
    if (level30>=1) levelsComplete++;   
    if (level31>=1) levelsComplete++;
    if (level32>=1) levelsComplete++;
    if (level33>=1) levelsComplete++;
    if (level34>=1) levelsComplete++;
    if (level35>=1) levelsComplete++;
    if (level36>=1) levelsComplete++; 
    
    
    NSInteger levelsPoints = level1+level2+level3+level4+level5+
    level6+ level7+level8+level9+level10+
    level11+level12+level13+level14+level15+
    level16+ level17+level18+level19+level20+
    level21+level22+level23+level24    +level25+
    level26+level27+level28+level29+ level30+
    level31+level32+level33+level34+level35+level36 - levelsComplete;
    
    if (levelsPoints==36) {
        [self checkAchievement:k108Caps];
    }
    
//    NSLog(@"Level points %d", levelsPoints);
    
    return levelsPoints;
}

+ (int) levelProgressWarehouse {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSInteger level1,level2,level3,level4,level5,
    level6, level7,level8,level9, level10,
    level11,level12;
    
    level1 = [prefs integerForKey:@"level1"];
    level2 = [prefs integerForKey:@"level2"];
    level3 = [prefs integerForKey:@"level3"];    
    level4 = [prefs integerForKey:@"level4"];
    level5 = [prefs integerForKey:@"level5"];
    level6 = [prefs integerForKey:@"level6"];
    level7 = [prefs integerForKey:@"level7"];
    level8 = [prefs integerForKey:@"level8"];
    level9 = [prefs integerForKey:@"level9"];
    level10 = [prefs integerForKey:@"level10"];
    level11 = [prefs integerForKey:@"level11"];
    level12 = [prefs integerForKey:@"level12"];
    
    NSInteger levelsComplete = 0;
    
    if (level1>=1) levelsComplete++;
    if (level2>=1) levelsComplete++;
    if (level3>=1) levelsComplete++;
    if (level4>=1) levelsComplete++;
    if (level5>=1) levelsComplete++;
    if (level6>=1) levelsComplete++;
    if (level7>=1) levelsComplete++;
    if (level8>=1) levelsComplete++;
    if (level9>=1) levelsComplete++;
    if (level10>=1) levelsComplete++;
    if (level11>=1) levelsComplete++;
    if (level12>=1) levelsComplete++;
    
    NSInteger levelsPoints = level1+level2+level3+level4+level5+
    level6+ level7+level8+level9+level10+
    level11+level12 - levelsComplete;
    
    if (levelsComplete >= 12) {
        [self checkAchievement:kUnlockAllWarehouseLevels];
    }
    
    if (levelsPoints==12) {
        [self checkAchievement:k3CapWarehouse];
    }
    
    return levelsPoints;
}

+ (int) levelProgressManagement
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSInteger level25,
    level26,level27,level28,level29, level30,
    level31,level32,level33,level34,level35,level36;
    
    level25 = [prefs integerForKey:@"level25"];
    level26 = [prefs integerForKey:@"level26"];
    level27 = [prefs integerForKey:@"level27"];
    level28 = [prefs integerForKey:@"level28"];
    level29 = [prefs integerForKey:@"level29"];
    level30 = [prefs integerForKey:@"level30"];
    level31 = [prefs integerForKey:@"level31"];
    level32 = [prefs integerForKey:@"level32"];
    level33 = [prefs integerForKey:@"level33"];
    level34 = [prefs integerForKey:@"level34"];
    level35 = [prefs integerForKey:@"level35"];
    level36 = [prefs integerForKey:@"level36"];    
    
    NSInteger levelsComplete = 0;
    
    if (level25>=1) levelsComplete++;
    if (level26>=1) levelsComplete++;
    if (level27>=1) levelsComplete++;
    if (level28>=1) levelsComplete++;
    if (level29>=1) levelsComplete++;
    if (level30>=1) levelsComplete++;   
    if (level31>=1) levelsComplete++;
    if (level32>=1) levelsComplete++;
    if (level33>=1) levelsComplete++;
    if (level34>=1) levelsComplete++;
    if (level35>=1) levelsComplete++;
    if (level36>=1) levelsComplete++; 
    
    
    NSInteger levelsPoints = level25+
    level26+level27+level28+level29+ level30+
    level31+level32+level33+level34+level35+level36 - levelsComplete;
    
    if (levelsComplete >= 12) {
        [self checkAchievement:kUnlockAllManagementLevels];
    }
    
    if (levelsPoints==12) {
        [self checkAchievement:k3CapManagement];
    }
    
    return levelsPoints;
}
+ (int) levelProgressFactory
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSInteger level13,level14, level15,
    level16,level17,level18,level19, level20,
    level21,level22,level23,level24 ;
    
    level13 = [prefs integerForKey:@"level13"];
    level14 = [prefs integerForKey:@"level14"];
    level15 = [prefs integerForKey:@"level15"];
    level16 = [prefs integerForKey:@"level16"];
    level17 = [prefs integerForKey:@"level17"];
    level18 = [prefs integerForKey:@"level18"];
    level19 = [prefs integerForKey:@"level19"];
    level20 = [prefs integerForKey:@"level20"];
    level21 = [prefs integerForKey:@"level21"];
    level22 = [prefs integerForKey:@"level22"];
    level23 = [prefs integerForKey:@"level23"];
    level24 = [prefs integerForKey:@"level24"];
    
    NSInteger levelsComplete = 0;
    
    if (level13>=1) levelsComplete++;
    if (level14>=1) levelsComplete++;
    if (level15>=1) levelsComplete++;
    if (level16>=1) levelsComplete++;
    if (level17>=1) levelsComplete++;
    if (level18>=1) levelsComplete++;
    if (level19>=1) levelsComplete++;
    if (level20>=1) levelsComplete++;
    if (level21>=1) levelsComplete++;
    if (level22>=1) levelsComplete++;
    if (level23>=1) levelsComplete++;
    if (level24>=1) levelsComplete++;
    
    
    NSInteger levelsPoints = level13+level14+level15+
    level16+ level17+level18+level19+level20+
    level21+level22+level23+level24 - levelsComplete;
    
    if (levelsComplete >= 12) {
        [self checkAchievement:kUnlockAllFactoryLevels];
    }
    
    if (levelsPoints==12) {
        [self checkAchievement:k3CapFactory];
    }
    
    return levelsPoints;   
}



+ (int) hclevelProgress
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSInteger hclevel1,hclevel2,hclevel3,hclevel4,hclevel5,
    hclevel6, hclevel7,hclevel8,hclevel9, hclevel10,
    hclevel11,hclevel12,hclevel13,hclevel14, hclevel15,
    hclevel16,hclevel17,hclevel18,hclevel19, hclevel20,
    hclevel21,hclevel22,hclevel23,hclevel24, hclevel25,
    hclevel26,hclevel27,hclevel28,hclevel29, hclevel30,
    hclevel31,hclevel32,hclevel33,hclevel34,hclevel35,hclevel36;
    
    hclevel1 = [prefs integerForKey:@"hclevel1"];
    hclevel2 = [prefs integerForKey:@"hclevel2"];
    hclevel3 = [prefs integerForKey:@"hclevel3"];    
    hclevel4 = [prefs integerForKey:@"hclevel4"];
    hclevel5 = [prefs integerForKey:@"hclevel5"];
    hclevel6 = [prefs integerForKey:@"hclevel6"];
    hclevel7 = [prefs integerForKey:@"hclevel7"];
    hclevel8 = [prefs integerForKey:@"hclevel8"];
    hclevel9 = [prefs integerForKey:@"hclevel9"];
    hclevel10 = [prefs integerForKey:@"hclevel10"];
    hclevel11 = [prefs integerForKey:@"hclevel11"];
    hclevel12 = [prefs integerForKey:@"hclevel12"];
    
    hclevel13 = [prefs integerForKey:@"hclevel13"];
    hclevel14 = [prefs integerForKey:@"hclevel14"];
    hclevel15 = [prefs integerForKey:@"hclevel15"];
    hclevel16 = [prefs integerForKey:@"hclevel16"];
    hclevel17 = [prefs integerForKey:@"hclevel17"];
    hclevel18 = [prefs integerForKey:@"hclevel18"];
    hclevel19 = [prefs integerForKey:@"hclevel19"];
    hclevel20 = [prefs integerForKey:@"hclevel20"];
    hclevel21 = [prefs integerForKey:@"hclevel21"];
    hclevel22 = [prefs integerForKey:@"hclevel22"];
    hclevel23 = [prefs integerForKey:@"hclevel23"];
    hclevel24 = [prefs integerForKey:@"hclevel24"];
    
    hclevel25 = [prefs integerForKey:@"hclevel25"];
    hclevel26 = [prefs integerForKey:@"hclevel26"];
    hclevel27 = [prefs integerForKey:@"hclevel27"];
    hclevel28 = [prefs integerForKey:@"hclevel28"];
    hclevel29 = [prefs integerForKey:@"hclevel29"];
    hclevel30 = [prefs integerForKey:@"hclevel30"];
    hclevel31 = [prefs integerForKey:@"hclevel31"];
    hclevel32 = [prefs integerForKey:@"hclevel32"];
    hclevel33 = [prefs integerForKey:@"hclevel33"];
    hclevel34 = [prefs integerForKey:@"hclevel34"];
    hclevel35 = [prefs integerForKey:@"hclevel35"];
    hclevel36 = [prefs integerForKey:@"hclevel36"];    
    
    NSInteger hclevelsComplete = 0;
    
    if (hclevel1>=1) hclevelsComplete++;
    if (hclevel2>=1) hclevelsComplete++;
    if (hclevel3>=1) hclevelsComplete++;
    if (hclevel4>=1) hclevelsComplete++;
    if (hclevel5>=1) hclevelsComplete++;
    if (hclevel6>=1) hclevelsComplete++;
    if (hclevel7>=1) hclevelsComplete++;
    if (hclevel8>=1) hclevelsComplete++;
    if (hclevel9>=1) hclevelsComplete++;
    if (hclevel10>=1) hclevelsComplete++;
    if (hclevel11>=1) hclevelsComplete++;
    if (hclevel12>=1) hclevelsComplete++;
    
    if (hclevel13>=1) hclevelsComplete++;
    if (hclevel14>=1) hclevelsComplete++;
    if (hclevel15>=1) hclevelsComplete++;
    if (hclevel16>=1) hclevelsComplete++;
    if (hclevel17>=1) hclevelsComplete++;
    if (hclevel18>=1) hclevelsComplete++;
    if (hclevel19>=1) hclevelsComplete++;
    if (hclevel20>=1) hclevelsComplete++;
    if (hclevel21>=1) hclevelsComplete++;
    if (hclevel22>=1) hclevelsComplete++;
    if (hclevel23>=1) hclevelsComplete++;
    if (hclevel24>=1) hclevelsComplete++;
    
    if (hclevel25>=1) hclevelsComplete++;
    if (hclevel26>=1) hclevelsComplete++;
    if (hclevel27>=1) hclevelsComplete++;
    if (hclevel28>=1) hclevelsComplete++;
    if (hclevel29>=1) hclevelsComplete++;
    if (hclevel30>=1) hclevelsComplete++;   
    if (hclevel31>=1) hclevelsComplete++;
    if (hclevel32>=1) hclevelsComplete++;
    if (hclevel33>=1) hclevelsComplete++;
    if (hclevel34>=1) hclevelsComplete++;
    if (hclevel35>=1) hclevelsComplete++;
    if (hclevel36>=1) hclevelsComplete++; 
    
    
    NSInteger hclevelsPoints = hclevel1+hclevel2+hclevel3+hclevel4+hclevel5+
    hclevel6+ hclevel7+hclevel8+hclevel9+hclevel10+
    hclevel11+hclevel12+hclevel13+hclevel14+hclevel15+
    hclevel16+ hclevel17+hclevel18+hclevel19+hclevel20+
    hclevel21+hclevel22+hclevel23+hclevel24    +hclevel25+
    hclevel26+hclevel27+hclevel28+hclevel29+ hclevel30+
    hclevel31+hclevel32+hclevel33+hclevel34+hclevel35+hclevel36 - hclevelsComplete;
    
    if (hclevelsPoints==36) {
        [self checkAchievement:khc108Caps];
    }
    
    return hclevelsPoints;
}

+ (int) hclevelProgressWarehouse {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSInteger hclevel1,hclevel2,hclevel3,hclevel4,hclevel5,
    hclevel6, hclevel7,hclevel8,hclevel9, hclevel10,
    hclevel11,hclevel12;
    
    hclevel1 = [prefs integerForKey:@"hclevel1"];
    hclevel2 = [prefs integerForKey:@"hclevel2"];
    hclevel3 = [prefs integerForKey:@"hclevel3"];    
    hclevel4 = [prefs integerForKey:@"hclevel4"];
    hclevel5 = [prefs integerForKey:@"hclevel5"];
    hclevel6 = [prefs integerForKey:@"hclevel6"];
    hclevel7 = [prefs integerForKey:@"hclevel7"];
    hclevel8 = [prefs integerForKey:@"hclevel8"];
    hclevel9 = [prefs integerForKey:@"hclevel9"];
    hclevel10 = [prefs integerForKey:@"hclevel10"];
    hclevel11 = [prefs integerForKey:@"hclevel11"];
    hclevel12 = [prefs integerForKey:@"hclevel12"];
    
    NSInteger hclevelsComplete = 0;
    
    if (hclevel1>=1) hclevelsComplete++;
    if (hclevel2>=1) hclevelsComplete++;
    if (hclevel3>=1) hclevelsComplete++;
    if (hclevel4>=1) hclevelsComplete++;
    if (hclevel5>=1) hclevelsComplete++;
    if (hclevel6>=1) hclevelsComplete++;
    if (hclevel7>=1) hclevelsComplete++;
    if (hclevel8>=1) hclevelsComplete++;
    if (hclevel9>=1) hclevelsComplete++;
    if (hclevel10>=1) hclevelsComplete++;
    if (hclevel11>=1) hclevelsComplete++;
    if (hclevel12>=1) hclevelsComplete++;
    
    NSInteger hclevelsPoints =  hclevel1+hclevel2+hclevel3+hclevel4+hclevel5+
                                hclevel6+ hclevel7+hclevel8+hclevel9+hclevel10+
                                hclevel11+hclevel12 - hclevelsComplete;
    
    if (hclevelsComplete >= 12) {
        [self checkAchievement:khcUnlockAllWarehouseLevels];
    }
    
    if (hclevelsPoints==12) {
        [self checkAchievement:khc3CapWarehouse];
    }
    
    //NSLog(@"warehouse prog=%d", hclevelsPoints);
    
    return hclevelsPoints;
}

+ (int) hclevelProgressManagement
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSInteger hclevel25,
    hclevel26,hclevel27,hclevel28,hclevel29, hclevel30,
    hclevel31,hclevel32,hclevel33,hclevel34,hclevel35,hclevel36;
    
    hclevel25 = [prefs integerForKey:@"hclevel25"];
    hclevel26 = [prefs integerForKey:@"hclevel26"];
    hclevel27 = [prefs integerForKey:@"hclevel27"];
    hclevel28 = [prefs integerForKey:@"hclevel28"];
    hclevel29 = [prefs integerForKey:@"hclevel29"];
    hclevel30 = [prefs integerForKey:@"hclevel30"];
    hclevel31 = [prefs integerForKey:@"hclevel31"];
    hclevel32 = [prefs integerForKey:@"hclevel32"];
    hclevel33 = [prefs integerForKey:@"hclevel33"];
    hclevel34 = [prefs integerForKey:@"hclevel34"];
    hclevel35 = [prefs integerForKey:@"hclevel35"];
    hclevel36 = [prefs integerForKey:@"hclevel36"];    
    
    NSInteger hclevelsComplete = 0;
    
    if (hclevel25>=1) hclevelsComplete++;
    if (hclevel26>=1) hclevelsComplete++;
    if (hclevel27>=1) hclevelsComplete++;
    if (hclevel28>=1) hclevelsComplete++;
    if (hclevel29>=1) hclevelsComplete++;
    if (hclevel30>=1) hclevelsComplete++;   
    if (hclevel31>=1) hclevelsComplete++;
    if (hclevel32>=1) hclevelsComplete++;
    if (hclevel33>=1) hclevelsComplete++;
    if (hclevel34>=1) hclevelsComplete++;
    if (hclevel35>=1) hclevelsComplete++;
    if (hclevel36>=1) hclevelsComplete++; 
    
    
    NSInteger hclevelsPoints = hclevel25+
    hclevel26+hclevel27+hclevel28+hclevel29+ hclevel30+
    hclevel31+hclevel32+hclevel33+hclevel34+hclevel35+hclevel36 - hclevelsComplete;
    
    if (hclevelsComplete >= 12) {
        [self checkAchievement:khcUnlockAllManagementLevels];
    }
    
    if (hclevelsPoints==12) {
        [self checkAchievement:khc3CapManagement];
    }
    
    return hclevelsPoints;
}
+ (int) hclevelProgressFactory
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSInteger hclevel13,hclevel14, hclevel15,
    hclevel16,hclevel17,hclevel18,hclevel19, hclevel20,
    hclevel21,hclevel22,hclevel23,hclevel24 ;
    
    hclevel13 = [prefs integerForKey:@"hclevel13"];
    hclevel14 = [prefs integerForKey:@"hclevel14"];
    hclevel15 = [prefs integerForKey:@"hclevel15"];
    hclevel16 = [prefs integerForKey:@"hclevel16"];
    hclevel17 = [prefs integerForKey:@"hclevel17"];
    hclevel18 = [prefs integerForKey:@"hclevel18"];
    hclevel19 = [prefs integerForKey:@"hclevel19"];
    hclevel20 = [prefs integerForKey:@"hclevel20"];
    hclevel21 = [prefs integerForKey:@"hclevel21"];
    hclevel22 = [prefs integerForKey:@"hclevel22"];
    hclevel23 = [prefs integerForKey:@"hclevel23"];
    hclevel24 = [prefs integerForKey:@"hclevel24"];
    
    NSInteger hclevelsComplete = 0;
    
    if (hclevel13>=1) hclevelsComplete++;
    if (hclevel14>=1) hclevelsComplete++;
    if (hclevel15>=1) hclevelsComplete++;
    if (hclevel16>=1) hclevelsComplete++;
    if (hclevel17>=1) hclevelsComplete++;
    if (hclevel18>=1) hclevelsComplete++;
    if (hclevel19>=1) hclevelsComplete++;
    if (hclevel20>=1) hclevelsComplete++;
    if (hclevel21>=1) hclevelsComplete++;
    if (hclevel22>=1) hclevelsComplete++;
    if (hclevel23>=1) hclevelsComplete++;
    if (hclevel24>=1) hclevelsComplete++;
    
    
    NSInteger hclevelsPoints = hclevel13+hclevel14+hclevel15+
    hclevel16+ hclevel17+hclevel18+hclevel19+hclevel20+
    hclevel21+hclevel22+hclevel23+hclevel24 - hclevelsComplete;
    
    if (hclevelsComplete >= 12) {
        [self checkAchievement:khcUnlockAllFactoryLevels];
    }
    
    if (hclevelsPoints==12) {
        [self checkAchievement:khc3CapFactory];
    }
    
    return hclevelsPoints;   
}

+ (int) talkToEnemyProgress
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSInteger ARMY1 = [prefs integerForKey:@"TALKED_TO_ARMY1"];
    NSInteger ARMY2 = [prefs integerForKey:@"TALKED_TO_ARMY2"];
    NSInteger ARMY3 = [prefs integerForKey:@"TALKED_TO_ARMY3"];
    NSInteger ARMY4 = [prefs integerForKey:@"TALKED_TO_ARMY4"];
    NSInteger ARMY5 = [prefs integerForKey:@"TALKED_TO_ARMY5"];
    NSInteger ARMY6 = [prefs integerForKey:@"TALKED_TO_ARMY6"];
    NSInteger ARMY7 = [prefs integerForKey:@"TALKED_TO_ARMY7"];
    NSInteger ARMY8 = [prefs integerForKey:@"TALKED_TO_ARMY8"];
    NSInteger ARMY9 = [prefs integerForKey:@"TALKED_TO_ARMY9"];
    NSInteger ARMY10 = [prefs integerForKey:@"TALKED_TO_ARMY10"];
    NSInteger ARMY11 = [prefs integerForKey:@"TALKED_TO_ARMY11"];
    NSInteger ARMY12 = [prefs integerForKey:@"TALKED_TO_ARMY12"];    
    NSInteger ARMY13 = [prefs integerForKey:@"TALKED_TO_ARMY13"];
    NSInteger ARMY14 = [prefs integerForKey:@"TALKED_TO_ARMY14"];
    NSInteger ARMY15 = [prefs integerForKey:@"TALKED_TO_ARMY15"];
    NSInteger ARMY16 = [prefs integerForKey:@"TALKED_TO_ARMY16"];
    NSInteger ARMY17 = [prefs integerForKey:@"TALKED_TO_ARMY17"];
    NSInteger ARMY18 = [prefs integerForKey:@"TALKED_TO_ARMY18"];
    NSInteger ARMY19 = [prefs integerForKey:@"TALKED_TO_ARMY19"];
    NSInteger ARMY20 = [prefs integerForKey:@"TALKED_TO_ARMY20"];
    NSInteger ARMY21 = [prefs integerForKey:@"TALKED_TO_ARMY21"];
    NSInteger ARMY22 = [prefs integerForKey:@"TALKED_TO_ARMY22"];    
    NSInteger ARMY23 = [prefs integerForKey:@"TALKED_TO_ARMY23"];
    NSInteger ARMY24 = [prefs integerForKey:@"TALKED_TO_ARMY24"];
    NSInteger ARMY25 = [prefs integerForKey:@"TALKED_TO_ARMY25"];
    NSInteger ARMY26 = [prefs integerForKey:@"TALKED_TO_ARMY26"];
    NSInteger ARMY27 = [prefs integerForKey:@"TALKED_TO_ARMY27"];
    NSInteger ARMY28 = [prefs integerForKey:@"TALKED_TO_ARMY28"];
    NSInteger ARMY29 = [prefs integerForKey:@"TALKED_TO_ARMY29"];
    NSInteger ARMY30 = [prefs integerForKey:@"TALKED_TO_ARMY30"];
    NSInteger ARMY31 = [prefs integerForKey:@"TALKED_TO_ARMY31"];
    NSInteger ARMY32 = [prefs integerForKey:@"TALKED_TO_ARMY32"];
    NSInteger ARMY33 = [prefs integerForKey:@"TALKED_TO_ARMY33"];
    NSInteger ARMY34 = [prefs integerForKey:@"TALKED_TO_ARMY34"];
    NSInteger ARMY35 = [prefs integerForKey:@"TALKED_TO_ARMY35"];
    NSInteger ARMY36 = [prefs integerForKey:@"TALKED_TO_ARMY36"];
    
    NSInteger CHEF1 = [prefs integerForKey:@"TALKED_TO_CHEF1"];
    NSInteger CHEF2 = [prefs integerForKey:@"TALKED_TO_CHEF2"];
    NSInteger CHEF3 = [prefs integerForKey:@"TALKED_TO_CHEF3"];
    NSInteger CHEF4 = [prefs integerForKey:@"TALKED_TO_CHEF4"];
    NSInteger CHEF5 = [prefs integerForKey:@"TALKED_TO_CHEF5"];
    NSInteger CHEF6 = [prefs integerForKey:@"TALKED_TO_CHEF6"];
    NSInteger CHEF7 = [prefs integerForKey:@"TALKED_TO_CHEF7"];
    NSInteger CHEF8 = [prefs integerForKey:@"TALKED_TO_CHEF8"];
    NSInteger CHEF9 = [prefs integerForKey:@"TALKED_TO_CHEF9"];
    NSInteger CHEF10 = [prefs integerForKey:@"TALKED_TO_CHEF10"];
    NSInteger CHEF11 = [prefs integerForKey:@"TALKED_TO_CHEF11"];
    NSInteger CHEF12 = [prefs integerForKey:@"TALKED_TO_CHEF12"];    
    NSInteger CHEF13 = [prefs integerForKey:@"TALKED_TO_CHEF13"];
    NSInteger CHEF14 = [prefs integerForKey:@"TALKED_TO_CHEF14"];
    NSInteger CHEF15 = [prefs integerForKey:@"TALKED_TO_CHEF15"];
    NSInteger CHEF16 = [prefs integerForKey:@"TALKED_TO_CHEF16"];
    NSInteger CHEF17 = [prefs integerForKey:@"TALKED_TO_CHEF17"];
    NSInteger CHEF18 = [prefs integerForKey:@"TALKED_TO_CHEF18"];
    NSInteger CHEF19 = [prefs integerForKey:@"TALKED_TO_CHEF19"];
    NSInteger CHEF20 = [prefs integerForKey:@"TALKED_TO_CHEF20"];
    NSInteger CHEF21 = [prefs integerForKey:@"TALKED_TO_CHEF21"];
    NSInteger CHEF22 = [prefs integerForKey:@"TALKED_TO_CHEF22"];    
    NSInteger CHEF23 = [prefs integerForKey:@"TALKED_TO_CHEF23"];
    NSInteger CHEF24 = [prefs integerForKey:@"TALKED_TO_CHEF24"];
    NSInteger CHEF25 = [prefs integerForKey:@"TALKED_TO_CHEF25"];
    NSInteger CHEF26 = [prefs integerForKey:@"TALKED_TO_CHEF26"];
    NSInteger CHEF27 = [prefs integerForKey:@"TALKED_TO_CHEF27"];
    NSInteger CHEF28 = [prefs integerForKey:@"TALKED_TO_CHEF28"];
    NSInteger CHEF29 = [prefs integerForKey:@"TALKED_TO_CHEF29"];
    NSInteger CHEF30 = [prefs integerForKey:@"TALKED_TO_CHEF30"];
    NSInteger CHEF31 = [prefs integerForKey:@"TALKED_TO_CHEF31"];
    NSInteger CHEF32 = [prefs integerForKey:@"TALKED_TO_CHEF32"];
    NSInteger CHEF33 = [prefs integerForKey:@"TALKED_TO_CHEF33"];
    NSInteger CHEF34 = [prefs integerForKey:@"TALKED_TO_CHEF34"];
    NSInteger CHEF35 = [prefs integerForKey:@"TALKED_TO_CHEF35"];
    NSInteger CHEF36 = [prefs integerForKey:@"TALKED_TO_CHEF36"];
    
    NSInteger INSPECTOR1 = [prefs integerForKey:@"TALKED_TO_INSPECTOR1"];
    NSInteger INSPECTOR2 = [prefs integerForKey:@"TALKED_TO_INSPECTOR2"];
    NSInteger INSPECTOR3 = [prefs integerForKey:@"TALKED_TO_INSPECTOR3"];
    NSInteger INSPECTOR4 = [prefs integerForKey:@"TALKED_TO_INSPECTOR4"];
    NSInteger INSPECTOR5 = [prefs integerForKey:@"TALKED_TO_INSPECTOR5"];
    NSInteger INSPECTOR6 = [prefs integerForKey:@"TALKED_TO_INSPECTOR6"];
    NSInteger INSPECTOR7 = [prefs integerForKey:@"TALKED_TO_INSPECTOR7"];
    NSInteger INSPECTOR8 = [prefs integerForKey:@"TALKED_TO_INSPECTOR8"];
    NSInteger INSPECTOR9 = [prefs integerForKey:@"TALKED_TO_INSPECTOR9"];
    NSInteger INSPECTOR10 = [prefs integerForKey:@"TALKED_TO_INSPECTOR10"];
    NSInteger INSPECTOR11 = [prefs integerForKey:@"TALKED_TO_INSPECTOR11"];
    NSInteger INSPECTOR12 = [prefs integerForKey:@"TALKED_TO_INSPECTOR12"];    
    NSInteger INSPECTOR13 = [prefs integerForKey:@"TALKED_TO_INSPECTOR13"];
    NSInteger INSPECTOR14 = [prefs integerForKey:@"TALKED_TO_INSPECTOR14"];
    NSInteger INSPECTOR15 = [prefs integerForKey:@"TALKED_TO_INSPECTOR15"];
    NSInteger INSPECTOR16 = [prefs integerForKey:@"TALKED_TO_INSPECTOR16"];
    NSInteger INSPECTOR17 = [prefs integerForKey:@"TALKED_TO_INSPECTOR17"];
    NSInteger INSPECTOR18 = [prefs integerForKey:@"TALKED_TO_INSPECTOR18"];
    NSInteger INSPECTOR19 = [prefs integerForKey:@"TALKED_TO_INSPECTOR19"];
    NSInteger INSPECTOR20 = [prefs integerForKey:@"TALKED_TO_INSPECTOR20"];
    NSInteger INSPECTOR21 = [prefs integerForKey:@"TALKED_TO_INSPECTOR21"];
    NSInteger INSPECTOR22 = [prefs integerForKey:@"TALKED_TO_INSPECTOR22"];    
    NSInteger INSPECTOR23 = [prefs integerForKey:@"TALKED_TO_INSPECTOR23"];
    NSInteger INSPECTOR24 = [prefs integerForKey:@"TALKED_TO_INSPECTOR24"];
    NSInteger INSPECTOR25 = [prefs integerForKey:@"TALKED_TO_INSPECTOR25"];
    NSInteger INSPECTOR26 = [prefs integerForKey:@"TALKED_TO_INSPECTOR26"];
    NSInteger INSPECTOR27 = [prefs integerForKey:@"TALKED_TO_INSPECTOR27"];
    NSInteger INSPECTOR28 = [prefs integerForKey:@"TALKED_TO_INSPECTOR28"];
    NSInteger INSPECTOR29 = [prefs integerForKey:@"TALKED_TO_INSPECTOR29"];
    NSInteger INSPECTOR30 = [prefs integerForKey:@"TALKED_TO_INSPECTOR30"];
    NSInteger INSPECTOR31 = [prefs integerForKey:@"TALKED_TO_INSPECTOR31"];
    NSInteger INSPECTOR32 = [prefs integerForKey:@"TALKED_TO_INSPECTOR32"];
    NSInteger INSPECTOR33 = [prefs integerForKey:@"TALKED_TO_INSPECTOR33"];
    NSInteger INSPECTOR34 = [prefs integerForKey:@"TALKED_TO_INSPECTOR34"];
    NSInteger INSPECTOR35 = [prefs integerForKey:@"TALKED_TO_INSPECTOR35"];
    NSInteger INSPECTOR36 = [prefs integerForKey:@"TALKED_TO_INSPECTOR36"];
    
    NSInteger WORKER1 = [prefs integerForKey:@"TALKED_TO_WORKER1"];
    NSInteger WORKER2 = [prefs integerForKey:@"TALKED_TO_WORKER2"];
    NSInteger WORKER3 = [prefs integerForKey:@"TALKED_TO_WORKER3"];
    NSInteger WORKER4 = [prefs integerForKey:@"TALKED_TO_WORKER4"];
    NSInteger WORKER5 = [prefs integerForKey:@"TALKED_TO_WORKER5"];
    NSInteger WORKER6 = [prefs integerForKey:@"TALKED_TO_WORKER6"];
    NSInteger WORKER7 = [prefs integerForKey:@"TALKED_TO_WORKER7"];
    NSInteger WORKER8 = [prefs integerForKey:@"TALKED_TO_WORKER8"];
    NSInteger WORKER9 = [prefs integerForKey:@"TALKED_TO_WORKER9"];
    NSInteger WORKER10 = [prefs integerForKey:@"TALKED_TO_WORKER10"];
    NSInteger WORKER11 = [prefs integerForKey:@"TALKED_TO_WORKER11"];
    NSInteger WORKER12 = [prefs integerForKey:@"TALKED_TO_WORKER12"];    
    NSInteger WORKER13 = [prefs integerForKey:@"TALKED_TO_WORKER13"];
    NSInteger WORKER14 = [prefs integerForKey:@"TALKED_TO_WORKER14"];
    NSInteger WORKER15 = [prefs integerForKey:@"TALKED_TO_WORKER15"];
    NSInteger WORKER16 = [prefs integerForKey:@"TALKED_TO_WORKER16"];
    NSInteger WORKER17 = [prefs integerForKey:@"TALKED_TO_WORKER17"];
    NSInteger WORKER18 = [prefs integerForKey:@"TALKED_TO_WORKER18"];
    NSInteger WORKER19 = [prefs integerForKey:@"TALKED_TO_WORKER19"];
    NSInteger WORKER20 = [prefs integerForKey:@"TALKED_TO_WORKER20"];
    NSInteger WORKER21 = [prefs integerForKey:@"TALKED_TO_WORKER21"];
    NSInteger WORKER22 = [prefs integerForKey:@"TALKED_TO_WORKER22"];    
    NSInteger WORKER23 = [prefs integerForKey:@"TALKED_TO_WORKER23"];
    NSInteger WORKER24 = [prefs integerForKey:@"TALKED_TO_WORKER24"];
    NSInteger WORKER25 = [prefs integerForKey:@"TALKED_TO_WORKER25"];
    NSInteger WORKER26 = [prefs integerForKey:@"TALKED_TO_WORKER26"];
    NSInteger WORKER27 = [prefs integerForKey:@"TALKED_TO_WORKER27"];
    NSInteger WORKER28 = [prefs integerForKey:@"TALKED_TO_WORKER28"];
    NSInteger WORKER29 = [prefs integerForKey:@"TALKED_TO_WORKER29"];
    NSInteger WORKER30 = [prefs integerForKey:@"TALKED_TO_WORKER30"];
    NSInteger WORKER31 = [prefs integerForKey:@"TALKED_TO_WORKER31"];
    NSInteger WORKER32 = [prefs integerForKey:@"TALKED_TO_WORKER32"];
    NSInteger WORKER33 = [prefs integerForKey:@"TALKED_TO_WORKER33"];
    NSInteger WORKER34 = [prefs integerForKey:@"TALKED_TO_WORKER34"];
    NSInteger WORKER35 = [prefs integerForKey:@"TALKED_TO_WORKER35"];
    NSInteger WORKER36 = [prefs integerForKey:@"TALKED_TO_WORKER36"];
    
    NSInteger talkedToCount  = 0;     

    if (ARMY1>=1 || CHEF1>=1 || INSPECTOR1>=1 || WORKER1>=1) {
        talkedToCount++;
//        NSLog(@"1 %d %d %d %d ", ARMY1,CHEF1,INSPECTOR1,WORKER1 );
    }
//    NSLog(@"1-test %d %d %d %d ", ARMY1,CHEF1,INSPECTOR1,WORKER1 );

    if (ARMY2>=1 || CHEF2>=1 || INSPECTOR2>=1 || WORKER2>=1) {
        talkedToCount++;
//        NSLog(@"2");
    }
    if (ARMY3>=1 || CHEF3>=1 || INSPECTOR3>=1 || WORKER3>=1) {
        talkedToCount++;
//        NSLog(@"3");
    }
    if (ARMY4>=1 || CHEF4>=1 || INSPECTOR4>=1 || WORKER4>=1) {
        talkedToCount++;
//        NSLog(@"4");
    }
    if (ARMY5>=1 || CHEF5>=1 || INSPECTOR5>=1 || WORKER5>=1) {
        talkedToCount++;
//        NSLog(@"5");
    }
    if (ARMY6>=1 || CHEF6>=1 || INSPECTOR6>=1 || WORKER6>=1) {
        talkedToCount++;
//        NSLog(@"6");
    }
    if (ARMY7>=1 || CHEF7>=1 || INSPECTOR7>=1 || WORKER7>=1) {
        talkedToCount++;
//        NSLog(@"7");
    }
    if (ARMY8>=1 || CHEF8>=1 || INSPECTOR8>=1 || WORKER8>=1) {
        talkedToCount++;
//        NSLog(@"8");
    }
    if (ARMY9>=1 || CHEF9>=1 || INSPECTOR9>=1 || WORKER9>=1) {
        talkedToCount++;
//        NSLog(@"9");
    }
    if (ARMY10>=1 || CHEF10>=1 || INSPECTOR10>=1 || WORKER10>=1) {
        talkedToCount++;
//        NSLog(@"10");
    }
    if (ARMY11>=1 || CHEF11>=1 || INSPECTOR11>=1 || WORKER11>=1) {
        talkedToCount++;
//        NSLog(@"11");
    }
    if (ARMY12>=1 || CHEF12>=1 || INSPECTOR12>=1 || WORKER12>=1) {
        talkedToCount++;
//        NSLog(@"12");
    }
    if (ARMY13>=1 || CHEF13>=1 || INSPECTOR13>=1 || WORKER13>=1) {
        talkedToCount++;
        
    }
    if (ARMY14>=1 || CHEF14>=1 || INSPECTOR14>=1 || WORKER14>=1) {
        talkedToCount++;
    }
    if (ARMY15>=1 || CHEF15>=1 || INSPECTOR15>=1 || WORKER15>=1) {
        talkedToCount++;
    }
    if (ARMY16>=1 || CHEF16>=1 || INSPECTOR16>=1 || WORKER16>=1) {
        talkedToCount++;
    }
    if (ARMY17>=1 || CHEF17>=1 || INSPECTOR17>=1 || WORKER17>=1) {
        talkedToCount++;
    }
    if (ARMY18>=1 || CHEF18>=1 || INSPECTOR18>=1 || WORKER18>=1) {
        talkedToCount++;
    }
    if (ARMY19>=1 || CHEF19>=1 || INSPECTOR19>=1 || WORKER19>=1) {
        talkedToCount++;
    }
    if (ARMY20>=1 || CHEF20>=1 || INSPECTOR20>=1 || WORKER20>=1) {
        talkedToCount++;
    }
    if (ARMY21>=1 || CHEF21>=1 || INSPECTOR21>=1 || WORKER21>=1) {
        talkedToCount++;
    }
    if (ARMY22>=1 || CHEF22>=1 || INSPECTOR22>=1 || WORKER22>=1) {
        talkedToCount++;
    }
    if (ARMY23>=1 || CHEF23>=1 || INSPECTOR23>=1 || WORKER23>=1) {
        talkedToCount++;
    }
    if (ARMY24>=1 || CHEF24>=1 || INSPECTOR24>=1 || WORKER24>=1) {
        talkedToCount++;
    }
    if (ARMY25>=1 || CHEF25>=1 || INSPECTOR25>=1 || WORKER25>=1) {
        talkedToCount++;
    }
    if (ARMY26>=1 || CHEF26>=1 || INSPECTOR26>=1 || WORKER26>=1) {
        talkedToCount++;
    }
    if (ARMY27>=1 || CHEF27>=1 || INSPECTOR27>=1 || WORKER27>=1) {
        talkedToCount++;
    }
    if (ARMY28>=1 || CHEF28>=1 || INSPECTOR28>=1 || WORKER28>=1) {
        talkedToCount++;
    }
    if (ARMY29>=1 || CHEF29>=1 || INSPECTOR29>=1 || WORKER29>=1) {
        talkedToCount++;
    }
    if (ARMY30>=1 || CHEF30>=1 || INSPECTOR30>=1 || WORKER30>=1) {
        talkedToCount++;
    }
    if (ARMY31>=1 || CHEF31>=1 || INSPECTOR31>=1 || WORKER31>=1) {
        talkedToCount++;
    }
    if (ARMY32>=1 || CHEF32>=1 || INSPECTOR32>=1 || WORKER32>=1) {
        talkedToCount++;
    }
    if (ARMY33>=1 || CHEF33>=1 || INSPECTOR33>=1 || WORKER33>=1) {
        talkedToCount++;
    }
    if (ARMY34>=1 || CHEF34>=1 || INSPECTOR34>=1 || WORKER34>=1) {
        talkedToCount++;
    }
    if (ARMY35>=1 || CHEF35>=1 || INSPECTOR35>=1 || WORKER35>=1) {
        talkedToCount++;
    }
    if (ARMY36>=1 || CHEF36>=1 || INSPECTOR36>=1 || WORKER36>=1) {
        talkedToCount++;
    }
    
    
    
    
    /*
    NSInteger talkedToCount  =      
    ARMY1 +  
    ARMY2 +  
    ARMY3 +  
    ARMY4 +   
    ARMY5 +   
    ARMY6 +   
    ARMY7 +   
    ARMY8 +   
    ARMY9 +   
    ARMY10 +  
    ARMY11 +  
    ARMY12 +      
    ARMY13 +  
    ARMY14 +  
    ARMY15 +  
    ARMY16 +  
    ARMY17 +  
    ARMY18 +  
    ARMY19 +  
    ARMY20 +  
    ARMY21 +  
    ARMY22 +      
    ARMY23 +  
    ARMY24 +  
    ARMY25 +  
    ARMY26 +  
    ARMY27 +  
    ARMY28 +  
    ARMY29 +  
    ARMY30 +  
    ARMY31 +  
    ARMY32 +  
    ARMY33 +  
    ARMY34 +  
    ARMY35 +  
    ARMY36 +  
    
    CHEF1 +   
    CHEF2 +   
    CHEF3 +   
    CHEF4 +   
    CHEF5 +   
    CHEF6 +   
    CHEF7 +   
    CHEF8 +   
    CHEF9 +   
    CHEF10 +  
    CHEF11 +  
    CHEF12 +      
    CHEF13 +  
    CHEF14 +  
    CHEF15 +  
    CHEF16 +  
    CHEF17 +  
    CHEF18 +  
    CHEF19 +  
    CHEF20 +  
    CHEF21 +  
    CHEF22 +      
    CHEF23 +  
    CHEF24 +  
    CHEF25 +  
    CHEF26 +  
    CHEF27 +  
    CHEF28 +  
    CHEF29 +  
    CHEF30 +  
    CHEF31 +  
    CHEF32 +  
    CHEF33 +  
    CHEF34 +  
    CHEF35 +  
    CHEF36 +  
    
    INSPECTOR1 +  
    INSPECTOR2 +   
    INSPECTOR3 +   
    INSPECTOR4 +  
    INSPECTOR5 +  
    INSPECTOR6 +  
    INSPECTOR7 +  
    INSPECTOR8 +  
    INSPECTOR9 +  
    INSPECTOR10 +   
    INSPECTOR11 +   
    INSPECTOR12 +       
    INSPECTOR13 +   
    INSPECTOR14 +   
    INSPECTOR15 +   
    INSPECTOR16 +   
    INSPECTOR17 +   
    INSPECTOR18 +   
    INSPECTOR19 +   
    INSPECTOR20 +   
    INSPECTOR21 +   
    INSPECTOR22 +       
    INSPECTOR23 +  
    INSPECTOR24 +  
    INSPECTOR25 +  
    INSPECTOR26 +  
    INSPECTOR27 +   
    INSPECTOR28 +   
    INSPECTOR29 +  
    INSPECTOR30 +  
    INSPECTOR31 +   
    INSPECTOR32 +  
    INSPECTOR33 +  
    INSPECTOR34 +  
    INSPECTOR35 +  
    INSPECTOR36 +  
    
    WORKER1 +  
    WORKER2 +  
    WORKER3 +  
    WORKER4 +   
    WORKER5 +   
    WORKER6 +   
    WORKER7 +   
    WORKER8 +   
    WORKER9 +   
    WORKER10 +   
    WORKER11 +   
    WORKER12 +       
    WORKER13 +   
    WORKER14 +   
    WORKER15 +   
    WORKER16 +  
    WORKER17 +   
    WORKER18 +   
    WORKER19 +   
    WORKER20 +   
    WORKER21 +   
    WORKER22 +       
    WORKER23 +   
    WORKER24 +   
    WORKER25 +   
    WORKER26 +  
    WORKER27 +  
    WORKER28 +  
    WORKER29 +  
    WORKER30 +  
    WORKER31 +  
    WORKER32 +  
    WORKER33 +   
    WORKER34 +  
    WORKER35 +   
    WORKER36 ;
     
     */
    
//    NSLog(@"%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d... %d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d... %d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d... %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d ... ",     ARMY1 ,  
//          ARMY2 ,  
//          ARMY3 ,  
//          ARMY4 ,   
//          ARMY5 ,   
//          ARMY6 ,   
//          ARMY7 ,   
//          ARMY8 ,   
//          ARMY9 ,   
//          ARMY10 ,  
//          ARMY11 ,  
//          ARMY12 ,      
//          ARMY13 ,  
//          ARMY14 ,  
//          ARMY15 ,  
//          ARMY16 ,  
//          ARMY17 ,  
//          ARMY18 ,  
//          ARMY19 ,  
//          ARMY20 ,  
//          ARMY21 ,  
//          ARMY22 ,      
//          ARMY23 ,  
//          ARMY24 ,  
//          ARMY25 ,  
//          ARMY26 ,  
//          ARMY27 ,  
//          ARMY28 ,  
//          ARMY29 ,  
//          ARMY30 ,  
//          ARMY31 ,  
//          ARMY32 ,  
//          ARMY33 ,  
//          ARMY34 ,  
//          ARMY35 ,  
//          ARMY36 ,  
//          
//          CHEF1 ,   
//          CHEF2 ,   
//          CHEF3 ,   
//          CHEF4 ,   
//          CHEF5 ,   
//          CHEF6 ,   
//          CHEF7 ,   
//          CHEF8 ,   
//          CHEF9 ,   
//          CHEF10 ,  
//          CHEF11 ,  
//          CHEF12 ,      
//          CHEF13 ,  
//          CHEF14 ,  
//          CHEF15 ,  
//          CHEF16 ,  
//          CHEF17 ,  
//          CHEF18 ,  
//          CHEF19 ,  
//          CHEF20 ,  
//          CHEF21 ,  
//          CHEF22 ,      
//          CHEF23 ,  
//          CHEF24 ,  
//          CHEF25 ,  
//          CHEF26 ,  
//          CHEF27 ,  
//          CHEF28 ,  
//          CHEF29 ,  
//          CHEF30 ,  
//          CHEF31 ,  
//          CHEF32 ,  
//          CHEF33 ,  
//          CHEF34 ,  
//          CHEF35 ,  
//          CHEF36 ,  
//          
//          INSPECTOR1 ,  
//          INSPECTOR2 ,   
//          INSPECTOR3 ,   
//          INSPECTOR4 ,  
//          INSPECTOR5 ,  
//          INSPECTOR6 ,  
//          INSPECTOR7 ,  
//          INSPECTOR8 ,  
//          INSPECTOR9 ,  
//          INSPECTOR10 ,   
//          INSPECTOR11 ,   
//          INSPECTOR12 ,       
//          INSPECTOR13 ,   
//          INSPECTOR14 ,   
//          INSPECTOR15 ,   
//          INSPECTOR16 ,   
//          INSPECTOR17 ,   
//          INSPECTOR18 ,   
//          INSPECTOR19 ,   
//          INSPECTOR20 ,   
//          INSPECTOR21 ,   
//          INSPECTOR22 ,       
//          INSPECTOR23 ,  
//          INSPECTOR24 ,  
//          INSPECTOR25 ,  
//          INSPECTOR26 ,  
//          INSPECTOR27 ,   
//          INSPECTOR28 ,   
//          INSPECTOR29 ,  
//          INSPECTOR30 ,  
//          INSPECTOR31 ,   
//          INSPECTOR32 ,  
//          INSPECTOR33 ,  
//          INSPECTOR34 ,  
//          INSPECTOR35 ,  
//          INSPECTOR36 ,  
//          
//          WORKER1 ,  
//          WORKER2 ,  
//          WORKER3 ,  
//          WORKER4 ,   
//          WORKER5 ,   
//          WORKER6 ,   
//          WORKER7 ,   
//          WORKER8 ,   
//          WORKER9 ,   
//          WORKER10 ,   
//          WORKER11 ,   
//          WORKER12 ,       
//          WORKER13 ,   
//          WORKER14 ,   
//          WORKER15 ,   
//          WORKER16 ,  
//          WORKER17 ,   
//          WORKER18 ,   
//          WORKER19 ,   
//          WORKER20 ,   
//          WORKER21 ,   
//          WORKER22 ,       
//          WORKER23 ,   
//          WORKER24 ,   
//          WORKER25 ,   
//          WORKER26 ,  
//          WORKER27 ,  
//          WORKER28 ,  
//          WORKER29 ,  
//          WORKER30 ,  
//          WORKER31 ,  
//          WORKER32 ,  
//          WORKER33 ,   
//          WORKER34 ,  
//          WORKER35 ,   
//          WORKER36);
    
//    NSLog(@"%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d... \n%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d... \n%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d...",     ARMY1 ,  
//          ARMY2 ,  
//          ARMY3 ,  
//          ARMY4 ,   
//          ARMY5 ,   
//          ARMY6 ,   
//          ARMY7 ,   
//          ARMY8 ,   
//          ARMY9 ,   
//          ARMY10 ,  
//          ARMY11 ,  
//          ARMY12 ,      
//          ARMY13 ,  
//          ARMY14 ,  
//          ARMY15 ,  
//          ARMY16 ,  
//          ARMY17 ,  
//          ARMY18 ,  
//          ARMY19 ,  
//          ARMY20 ,  
//          ARMY21 ,  
//          ARMY22 ,      
//          ARMY23 ,  
//          ARMY24 ,  
//          ARMY25 ,  
//          ARMY26 ,  
//          ARMY27 ,  
//          ARMY28 ,  
//          ARMY29 ,  
//          ARMY30 ,  
//          ARMY31 ,  
//          ARMY32 ,  
//          ARMY33 ,  
//          ARMY34 ,  
//          ARMY35 ,  
//          ARMY36 ,  
//          
//          CHEF1 ,   
//          CHEF2 ,   
//          CHEF3 ,   
//          CHEF4 ,   
//          CHEF5 ,   
//          CHEF6 ,   
//          CHEF7 ,   
//          CHEF8 ,   
//          CHEF9 ,   
//          CHEF10 ,  
//          CHEF11 ,  
//          CHEF12 ,      
//          CHEF13 ,  
//          CHEF14 ,  
//          CHEF15 ,  
//          CHEF16 ,  
//          CHEF17 ,  
//          CHEF18 ,  
//          CHEF19 ,  
//          CHEF20 ,  
//          CHEF21 ,  
//          CHEF22 ,      
//          CHEF23 ,  
//          CHEF24 ,  
//          CHEF25 ,  
//          CHEF26 ,  
//          CHEF27 ,  
//          CHEF28 ,  
//          CHEF29 ,  
//          CHEF30 ,  
//          CHEF31 ,  
//          CHEF32 ,  
//          CHEF33 ,  
//          CHEF34 ,  
//          CHEF35 ,  
//          CHEF36 ,  
//          
//          INSPECTOR1 ,  
//          INSPECTOR2 ,   
//          INSPECTOR3 ,   
//          INSPECTOR4 ,  
//          INSPECTOR5 ,  
//          INSPECTOR6 ,  
//          INSPECTOR7 ,  
//          INSPECTOR8 ,  
//          INSPECTOR9 ,  
//          INSPECTOR10 ,   
//          INSPECTOR11 ,   
//          INSPECTOR12 ,       
//          INSPECTOR13 ,   
//          INSPECTOR14 ,   
//          INSPECTOR15 ,   
//          INSPECTOR16 ,   
//          INSPECTOR17 ,   
//          INSPECTOR18 ,   
//          INSPECTOR19 ,   
//          INSPECTOR20 ,   
//          INSPECTOR21 ,   
//          INSPECTOR22 ,       
//          INSPECTOR23 ,  
//          INSPECTOR24 ,  
//          INSPECTOR25 ,  
//          INSPECTOR26 ,  
//          INSPECTOR27 ,   
//          INSPECTOR28 ,   
//          INSPECTOR29 ,  
//          INSPECTOR30 ,  
//          INSPECTOR31 ,   
//          INSPECTOR32 ,  
//          INSPECTOR33 ,  
//          INSPECTOR34 ,  
//          INSPECTOR35 ,  
//          INSPECTOR36 );
//    
//    NSLog(@"WORKER SCORES %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d ... ", 
//          WORKER1 ,  
//          WORKER2 ,  
//          WORKER3 ,  
//          WORKER4 ,   
//          WORKER5 ,   
//          WORKER6 ,   
//          WORKER7 ,   
//          WORKER8 ,   
//          WORKER9 ,   
//          WORKER10 ,   
//          WORKER11 ,   
//          WORKER12 ,       
//          WORKER13 ,   
//          WORKER14 ,   
//          WORKER15 ,   
//          WORKER16 ,  
//          WORKER17 ,   
//          WORKER18 ,   
//          WORKER19 ,   
//          WORKER20 ,   
//          WORKER21 ,   
//          WORKER22 ,       
//          WORKER23 ,   
//          WORKER24 ,   
//          WORKER25 ,   
//          WORKER26 ,  
//          WORKER27 ,  
//          WORKER28 ,  
//          WORKER29 ,  
//          WORKER30 ,  
//          WORKER31 ,  
//          WORKER32 ,  
//          WORKER33 ,   
//          WORKER34 ,  
//          WORKER35 ,   
//          WORKER36);
    
//    NSLog(@" no submit! talked to %d", talkedToCount);

    
    if (talkedToCount >= 36) {
//        NSLog(@" submit! talked to %d", talkedToCount);

        [self checkAchievement:kTalkToAllEmployees];
    }
    
    return talkedToCount;   
}

+ (int) talkToAndreProgress
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    
    
    NSInteger ANDRE1 = [prefs integerForKey:@"TALKED_TO_ANDRE1"];
    NSInteger ANDRE2 = [prefs integerForKey:@"TALKED_TO_ANDRE2"];
    NSInteger ANDRE3 = [prefs integerForKey:@"TALKED_TO_ANDRE3"];
    NSInteger ANDRE4 = [prefs integerForKey:@"TALKED_TO_ANDRE4"];
    NSInteger ANDRE5 = [prefs integerForKey:@"TALKED_TO_ANDRE5"];
    NSInteger ANDRE6 = [prefs integerForKey:@"TALKED_TO_ANDRE6"];
    NSInteger ANDRE7 = [prefs integerForKey:@"TALKED_TO_ANDRE7"];
    NSInteger ANDRE8 = [prefs integerForKey:@"TALKED_TO_ANDRE8"];
    NSInteger ANDRE9 = [prefs integerForKey:@"TALKED_TO_ANDRE9"];
    NSInteger ANDRE10 = [prefs integerForKey:@"TALKED_TO_ANDRE10"];
    NSInteger ANDRE11 = [prefs integerForKey:@"TALKED_TO_ANDRE11"];
    NSInteger ANDRE12 = [prefs integerForKey:@"TALKED_TO_ANDRE12"];    
    NSInteger ANDRE13 = [prefs integerForKey:@"TALKED_TO_ANDRE13"];
    NSInteger ANDRE14 = [prefs integerForKey:@"TALKED_TO_ANDRE14"];
    NSInteger ANDRE15 = [prefs integerForKey:@"TALKED_TO_ANDRE15"];
    NSInteger ANDRE16 = [prefs integerForKey:@"TALKED_TO_ANDRE16"];
    NSInteger ANDRE17 = [prefs integerForKey:@"TALKED_TO_ANDRE17"];
    NSInteger ANDRE18 = [prefs integerForKey:@"TALKED_TO_ANDRE18"];
    NSInteger ANDRE19 = [prefs integerForKey:@"TALKED_TO_ANDRE19"];
    NSInteger ANDRE20 = [prefs integerForKey:@"TALKED_TO_ANDRE20"];
    NSInteger ANDRE21 = [prefs integerForKey:@"TALKED_TO_ANDRE21"];
    NSInteger ANDRE22 = [prefs integerForKey:@"TALKED_TO_ANDRE22"];    
    NSInteger ANDRE23 = [prefs integerForKey:@"TALKED_TO_ANDRE23"];
    NSInteger ANDRE24 = [prefs integerForKey:@"TALKED_TO_ANDRE24"];
    NSInteger ANDRE25 = [prefs integerForKey:@"TALKED_TO_ANDRE25"];
    NSInteger ANDRE26 = [prefs integerForKey:@"TALKED_TO_ANDRE26"];
    NSInteger ANDRE27 = [prefs integerForKey:@"TALKED_TO_ANDRE27"];
    NSInteger ANDRE28 = [prefs integerForKey:@"TALKED_TO_ANDRE28"];
    NSInteger ANDRE29 = [prefs integerForKey:@"TALKED_TO_ANDRE29"];
    NSInteger ANDRE30 = [prefs integerForKey:@"TALKED_TO_ANDRE30"];
    NSInteger ANDRE31 = [prefs integerForKey:@"TALKED_TO_ANDRE31"];
    NSInteger ANDRE32 = [prefs integerForKey:@"TALKED_TO_ANDRE32"];
    NSInteger ANDRE33 = [prefs integerForKey:@"TALKED_TO_ANDRE33"];
    NSInteger ANDRE34 = [prefs integerForKey:@"TALKED_TO_ANDRE34"];
    NSInteger ANDRE35 = [prefs integerForKey:@"TALKED_TO_ANDRE35"];
    NSInteger ANDRE36 = [prefs integerForKey:@"TALKED_TO_ANDRE36"];
    
    
    NSInteger talkedToAndreCount  =      ANDRE1 +  
    ANDRE2 +  
    ANDRE3 +  
    ANDRE4 +   
    ANDRE5 +   
    ANDRE6 +   
    ANDRE7 +   
    ANDRE8 +   
    ANDRE9 +   
    ANDRE10 +  
    ANDRE11 +  
    ANDRE12 +      
    ANDRE13 +  
    ANDRE14 +  
    ANDRE15 +  
    ANDRE16 +  
    ANDRE17 +  
    ANDRE18 +  
    ANDRE19 +  
    ANDRE20 +  
    ANDRE21 +  
    ANDRE22 +      
    ANDRE23 +  
    ANDRE24 +  
    ANDRE25 +  
    ANDRE26 +  
    ANDRE27 +  
    ANDRE28 +  
    ANDRE29 +  
    ANDRE30 +  
    ANDRE31 +  
    ANDRE32 +  
    ANDRE33 +  
    ANDRE34 +  
    ANDRE35 +  
    ANDRE36 ;
    
    
    
    if (talkedToAndreCount >= 36) {
        //NSLog(@" submit! talked to %d", talkedToAndreCount);

        [self checkAchievement:kTalkToAndre];
    }
    
    return talkedToAndreCount;   
}

+ (int) hctalkToEnemyProgress
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSInteger ARMYHC1 = [prefs integerForKey:@"TALKED_TO_ARMYHC1"];
    NSInteger ARMYHC2 = [prefs integerForKey:@"TALKED_TO_ARMYHC2"];
    NSInteger ARMYHC3 = [prefs integerForKey:@"TALKED_TO_ARMYHC3"];
    NSInteger ARMYHC4 = [prefs integerForKey:@"TALKED_TO_ARMYHC4"];
    NSInteger ARMYHC5 = [prefs integerForKey:@"TALKED_TO_ARMYHC5"];
    NSInteger ARMYHC6 = [prefs integerForKey:@"TALKED_TO_ARMYHC6"];
    NSInteger ARMYHC7 = [prefs integerForKey:@"TALKED_TO_ARMYHC7"];
    NSInteger ARMYHC8 = [prefs integerForKey:@"TALKED_TO_ARMYHC8"];
    NSInteger ARMYHC9 = [prefs integerForKey:@"TALKED_TO_ARMYHC9"];
    NSInteger ARMYHC10 = [prefs integerForKey:@"TALKED_TO_ARMYHC10"];
    NSInteger ARMYHC11 = [prefs integerForKey:@"TALKED_TO_ARMYHC11"];
    NSInteger ARMYHC12 = [prefs integerForKey:@"TALKED_TO_ARMYHC12"];    
    NSInteger ARMYHC13 = [prefs integerForKey:@"TALKED_TO_ARMYHC13"];
    NSInteger ARMYHC14 = [prefs integerForKey:@"TALKED_TO_ARMYHC14"];
    NSInteger ARMYHC15 = [prefs integerForKey:@"TALKED_TO_ARMYHC15"];
    NSInteger ARMYHC16 = [prefs integerForKey:@"TALKED_TO_ARMYHC16"];
    NSInteger ARMYHC17 = [prefs integerForKey:@"TALKED_TO_ARMYHC17"];
    NSInteger ARMYHC18 = [prefs integerForKey:@"TALKED_TO_ARMYHC18"];
    NSInteger ARMYHC19 = [prefs integerForKey:@"TALKED_TO_ARMYHC19"];
    NSInteger ARMYHC20 = [prefs integerForKey:@"TALKED_TO_ARMYHC20"];
    NSInteger ARMYHC21 = [prefs integerForKey:@"TALKED_TO_ARMYHC21"];
    NSInteger ARMYHC22 = [prefs integerForKey:@"TALKED_TO_ARMYHC22"];    
    NSInteger ARMYHC23 = [prefs integerForKey:@"TALKED_TO_ARMYHC23"];
    NSInteger ARMYHC24 = [prefs integerForKey:@"TALKED_TO_ARMYHC24"];
    NSInteger ARMYHC25 = [prefs integerForKey:@"TALKED_TO_ARMYHC25"];
    NSInteger ARMYHC26 = [prefs integerForKey:@"TALKED_TO_ARMYHC26"];
    NSInteger ARMYHC27 = [prefs integerForKey:@"TALKED_TO_ARMYHC27"];
    NSInteger ARMYHC28 = [prefs integerForKey:@"TALKED_TO_ARMYHC28"];
    NSInteger ARMYHC29 = [prefs integerForKey:@"TALKED_TO_ARMYHC29"];
    NSInteger ARMYHC30 = [prefs integerForKey:@"TALKED_TO_ARMYHC30"];
    NSInteger ARMYHC31 = [prefs integerForKey:@"TALKED_TO_ARMYHC31"];
    NSInteger ARMYHC32 = [prefs integerForKey:@"TALKED_TO_ARMYHC32"];
    NSInteger ARMYHC33 = [prefs integerForKey:@"TALKED_TO_ARMYHC33"];
    NSInteger ARMYHC34 = [prefs integerForKey:@"TALKED_TO_ARMYHC34"];
    NSInteger ARMYHC35 = [prefs integerForKey:@"TALKED_TO_ARMYHC35"];
    NSInteger ARMYHC36 = [prefs integerForKey:@"TALKED_TO_ARMYHC36"];
    
    NSInteger CHEFHC1 = [prefs integerForKey:@"TALKED_TO_CHEFHC1"];
    NSInteger CHEFHC2 = [prefs integerForKey:@"TALKED_TO_CHEFHC2"];
    NSInteger CHEFHC3 = [prefs integerForKey:@"TALKED_TO_CHEFHC3"];
    NSInteger CHEFHC4 = [prefs integerForKey:@"TALKED_TO_CHEFHC4"];
    NSInteger CHEFHC5 = [prefs integerForKey:@"TALKED_TO_CHEFHC5"];
    NSInteger CHEFHC6 = [prefs integerForKey:@"TALKED_TO_CHEFHC6"];
    NSInteger CHEFHC7 = [prefs integerForKey:@"TALKED_TO_CHEFHC7"];
    NSInteger CHEFHC8 = [prefs integerForKey:@"TALKED_TO_CHEFHC8"];
    NSInteger CHEFHC9 = [prefs integerForKey:@"TALKED_TO_CHEFHC9"];
    NSInteger CHEFHC10 = [prefs integerForKey:@"TALKED_TO_CHEFHC10"];
    NSInteger CHEFHC11 = [prefs integerForKey:@"TALKED_TO_CHEFHC11"];
    NSInteger CHEFHC12 = [prefs integerForKey:@"TALKED_TO_CHEFHC12"];    
    NSInteger CHEFHC13 = [prefs integerForKey:@"TALKED_TO_CHEFHC13"];
    NSInteger CHEFHC14 = [prefs integerForKey:@"TALKED_TO_CHEFHC14"];
    NSInteger CHEFHC15 = [prefs integerForKey:@"TALKED_TO_CHEFHC15"];
    NSInteger CHEFHC16 = [prefs integerForKey:@"TALKED_TO_CHEFHC16"];
    NSInteger CHEFHC17 = [prefs integerForKey:@"TALKED_TO_CHEFHC17"];
    NSInteger CHEFHC18 = [prefs integerForKey:@"TALKED_TO_CHEFHC18"];
    NSInteger CHEFHC19 = [prefs integerForKey:@"TALKED_TO_CHEFHC19"];
    NSInteger CHEFHC20 = [prefs integerForKey:@"TALKED_TO_CHEFHC20"];
    NSInteger CHEFHC21 = [prefs integerForKey:@"TALKED_TO_CHEFHC21"];
    NSInteger CHEFHC22 = [prefs integerForKey:@"TALKED_TO_CHEFHC22"];    
    NSInteger CHEFHC23 = [prefs integerForKey:@"TALKED_TO_CHEFHC23"];
    NSInteger CHEFHC24 = [prefs integerForKey:@"TALKED_TO_CHEFHC24"];
    NSInteger CHEFHC25 = [prefs integerForKey:@"TALKED_TO_CHEFHC25"];
    NSInteger CHEFHC26 = [prefs integerForKey:@"TALKED_TO_CHEFHC26"];
    NSInteger CHEFHC27 = [prefs integerForKey:@"TALKED_TO_CHEFHC27"];
    NSInteger CHEFHC28 = [prefs integerForKey:@"TALKED_TO_CHEFHC28"];
    NSInteger CHEFHC29 = [prefs integerForKey:@"TALKED_TO_CHEFHC29"];
    NSInteger CHEFHC30 = [prefs integerForKey:@"TALKED_TO_CHEFHC30"];
    NSInteger CHEFHC31 = [prefs integerForKey:@"TALKED_TO_CHEFHC31"];
    NSInteger CHEFHC32 = [prefs integerForKey:@"TALKED_TO_CHEFHC32"];
    NSInteger CHEFHC33 = [prefs integerForKey:@"TALKED_TO_CHEFHC33"];
    NSInteger CHEFHC34 = [prefs integerForKey:@"TALKED_TO_CHEFHC34"];
    NSInteger CHEFHC35 = [prefs integerForKey:@"TALKED_TO_CHEFHC35"];
    NSInteger CHEFHC36 = [prefs integerForKey:@"TALKED_TO_CHEFHC36"];
    
    NSInteger INSPECTORHC1 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC1"];
    NSInteger INSPECTORHC2 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC2"];
    NSInteger INSPECTORHC3 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC3"];
    NSInteger INSPECTORHC4 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC4"];
    NSInteger INSPECTORHC5 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC5"];
    NSInteger INSPECTORHC6 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC6"];
    NSInteger INSPECTORHC7 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC7"];
    NSInteger INSPECTORHC8 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC8"];
    NSInteger INSPECTORHC9 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC9"];
    NSInteger INSPECTORHC10 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC10"];
    NSInteger INSPECTORHC11 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC11"];
    NSInteger INSPECTORHC12 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC12"];    
    NSInteger INSPECTORHC13 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC13"];
    NSInteger INSPECTORHC14 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC14"];
    NSInteger INSPECTORHC15 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC15"];
    NSInteger INSPECTORHC16 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC16"];
    NSInteger INSPECTORHC17 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC17"];
    NSInteger INSPECTORHC18 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC18"];
    NSInteger INSPECTORHC19 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC19"];
    NSInteger INSPECTORHC20 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC20"];
    NSInteger INSPECTORHC21 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC21"];
    NSInteger INSPECTORHC22 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC22"];    
    NSInteger INSPECTORHC23 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC23"];
    NSInteger INSPECTORHC24 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC24"];
    NSInteger INSPECTORHC25 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC25"];
    NSInteger INSPECTORHC26 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC26"];
    NSInteger INSPECTORHC27 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC27"];
    NSInteger INSPECTORHC28 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC28"];
    NSInteger INSPECTORHC29 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC29"];
    NSInteger INSPECTORHC30 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC30"];
    NSInteger INSPECTORHC31 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC31"];
    NSInteger INSPECTORHC32 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC32"];
    NSInteger INSPECTORHC33 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC33"];
    NSInteger INSPECTORHC34 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC34"];
    NSInteger INSPECTORHC35 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC35"];
    NSInteger INSPECTORHC36 = [prefs integerForKey:@"TALKED_TO_INSPECTORHC36"];
    
    NSInteger WORKERHC1 = [prefs integerForKey:@"TALKED_TO_WORKERHC1"];
    NSInteger WORKERHC2 = [prefs integerForKey:@"TALKED_TO_WORKERHC2"];
    NSInteger WORKERHC3 = [prefs integerForKey:@"TALKED_TO_WORKERHC3"];
    NSInteger WORKERHC4 = [prefs integerForKey:@"TALKED_TO_WORKERHC4"];
    NSInteger WORKERHC5 = [prefs integerForKey:@"TALKED_TO_WORKERHC5"];
    NSInteger WORKERHC6 = [prefs integerForKey:@"TALKED_TO_WORKERHC6"];
    NSInteger WORKERHC7 = [prefs integerForKey:@"TALKED_TO_WORKERHC7"];
    NSInteger WORKERHC8 = [prefs integerForKey:@"TALKED_TO_WORKERHC8"];
    NSInteger WORKERHC9 = [prefs integerForKey:@"TALKED_TO_WORKERHC9"];
    NSInteger WORKERHC10 = [prefs integerForKey:@"TALKED_TO_WORKERHC10"];
    NSInteger WORKERHC11 = [prefs integerForKey:@"TALKED_TO_WORKERHC11"];
    NSInteger WORKERHC12 = [prefs integerForKey:@"TALKED_TO_WORKERHC12"];    
    NSInteger WORKERHC13 = [prefs integerForKey:@"TALKED_TO_WORKERHC13"];
    NSInteger WORKERHC14 = [prefs integerForKey:@"TALKED_TO_WORKERHC14"];
    NSInteger WORKERHC15 = [prefs integerForKey:@"TALKED_TO_WORKERHC15"];
    NSInteger WORKERHC16 = [prefs integerForKey:@"TALKED_TO_WORKERHC16"];
    NSInteger WORKERHC17 = [prefs integerForKey:@"TALKED_TO_WORKERHC17"];
    NSInteger WORKERHC18 = [prefs integerForKey:@"TALKED_TO_WORKERHC18"];
    NSInteger WORKERHC19 = [prefs integerForKey:@"TALKED_TO_WORKERHC19"];
    NSInteger WORKERHC20 = [prefs integerForKey:@"TALKED_TO_WORKERHC20"];
    NSInteger WORKERHC21 = [prefs integerForKey:@"TALKED_TO_WORKERHC21"];
    NSInteger WORKERHC22 = [prefs integerForKey:@"TALKED_TO_WORKERHC22"];    
    NSInteger WORKERHC23 = [prefs integerForKey:@"TALKED_TO_WORKERHC23"];
    NSInteger WORKERHC24 = [prefs integerForKey:@"TALKED_TO_WORKERHC24"];
    NSInteger WORKERHC25 = [prefs integerForKey:@"TALKED_TO_WORKERHC25"];
    NSInteger WORKERHC26 = [prefs integerForKey:@"TALKED_TO_WORKERHC26"];
    NSInteger WORKERHC27 = [prefs integerForKey:@"TALKED_TO_WORKERHC27"];
    NSInteger WORKERHC28 = [prefs integerForKey:@"TALKED_TO_WORKERHC28"];
    NSInteger WORKERHC29 = [prefs integerForKey:@"TALKED_TO_WORKERHC29"];
    NSInteger WORKERHC30 = [prefs integerForKey:@"TALKED_TO_WORKERHC30"];
    NSInteger WORKERHC31 = [prefs integerForKey:@"TALKED_TO_WORKERHC31"];
    NSInteger WORKERHC32 = [prefs integerForKey:@"TALKED_TO_WORKERHC32"];
    NSInteger WORKERHC33 = [prefs integerForKey:@"TALKED_TO_WORKERHC33"];
    NSInteger WORKERHC34 = [prefs integerForKey:@"TALKED_TO_WORKERHC34"];
    NSInteger WORKERHC35 = [prefs integerForKey:@"TALKED_TO_WORKERHC35"];
    NSInteger WORKERHC36 = [prefs integerForKey:@"TALKED_TO_WORKERHC36"];
    
    NSInteger talkedToCount  = 0;     
    
    if (ARMYHC1>=1 || CHEFHC1>=1 || INSPECTORHC1>=1 || WORKERHC1>=1) {
        talkedToCount++;
    }
    if (ARMYHC2>=1 || CHEFHC2>=1 || INSPECTORHC2>=1 || WORKERHC2>=1) {
        talkedToCount++;
    }
    if (ARMYHC3>=1 || CHEFHC3>=1 || INSPECTORHC3>=1 || WORKERHC3>=1) {
        talkedToCount++;
    }
    if (ARMYHC4>=1 || CHEFHC4>=1 || INSPECTORHC4>=1 || WORKERHC4>=1) {
        talkedToCount++;
    }
    if (ARMYHC5>=1 || CHEFHC5>=1 || INSPECTORHC5>=1 || WORKERHC5>=1) {
        talkedToCount++;
    }
    if (ARMYHC6>=1 || CHEFHC6>=1 || INSPECTORHC6>=1 || WORKERHC6>=1) {
        talkedToCount++;
    }
    if (ARMYHC7>=1 || CHEFHC7>=1 || INSPECTORHC7>=1 || WORKERHC7>=1) {
        talkedToCount++;
    }
    if (ARMYHC8>=1 || CHEFHC8>=1 || INSPECTORHC8>=1 || WORKERHC8>=1) {
        talkedToCount++;
    }
    if (ARMYHC9>=1 || CHEFHC9>=1 || INSPECTORHC9>=1 || WORKERHC9>=1) {
        talkedToCount++;
    }
    if (ARMYHC10>=1 || CHEFHC10>=1 || INSPECTORHC10>=1 || WORKERHC10>=1) {
        talkedToCount++;
    }
    if (ARMYHC11>=1 || CHEFHC11>=1 || INSPECTORHC11>=1 || WORKERHC11>=1) {
        talkedToCount++;
    }
    if (ARMYHC12>=1 || CHEFHC12>=1 || INSPECTORHC12>=1 || WORKERHC12>=1) {
        talkedToCount++;
    }
    if (ARMYHC13>=1 || CHEFHC13>=1 || INSPECTORHC13>=1 || WORKERHC13>=1) {
        talkedToCount++;
    }
    if (ARMYHC14>=1 || CHEFHC14>=1 || INSPECTORHC14>=1 || WORKERHC14>=1) {
        talkedToCount++;
    }
    if (ARMYHC15>=1 || CHEFHC15>=1 || INSPECTORHC15>=1 || WORKERHC15>=1) {
        talkedToCount++;
    }
    if (ARMYHC16>=1 || CHEFHC16>=1 || INSPECTORHC16>=1 || WORKERHC16>=1) {
        talkedToCount++;
    }
    if (ARMYHC17>=1 || CHEFHC17>=1 || INSPECTORHC17>=1 || WORKERHC17>=1) {
        talkedToCount++;
    }
    if (ARMYHC18>=1 || CHEFHC18>=1 || INSPECTORHC18>=1 || WORKERHC18>=1) {
        talkedToCount++;
    }
    if (ARMYHC19>=1 || CHEFHC19>=1 || INSPECTORHC19>=1 || WORKERHC19>=1) {
        talkedToCount++;
    }
    if (ARMYHC20>=1 || CHEFHC20>=1 || INSPECTORHC20>=1 || WORKERHC20>=1) {
        talkedToCount++;
    }
    if (ARMYHC21>=1 || CHEFHC21>=1 || INSPECTORHC21>=1 || WORKERHC21>=1) {
        talkedToCount++;
    }
    if (ARMYHC22>=1 || CHEFHC22>=1 || INSPECTORHC22>=1 || WORKERHC22>=1) {
        talkedToCount++;
    }
    if (ARMYHC23>=1 || CHEFHC23>=1 || INSPECTORHC23>=1 || WORKERHC23>=1) {
        talkedToCount++;
    }
    if (ARMYHC24>=1 || CHEFHC24>=1 || INSPECTORHC24>=1 || WORKERHC24>=1) {
        talkedToCount++;
    }
    if (ARMYHC25>=1 || CHEFHC25>=1 || INSPECTORHC25>=1 || WORKERHC25>=1) {
        talkedToCount++;
    }
    if (ARMYHC26>=1 || CHEFHC26>=1 || INSPECTORHC26>=1 || WORKERHC26>=1) {
        talkedToCount++;
    }
    if (ARMYHC27>=1 || CHEFHC27>=1 || INSPECTORHC27>=1 || WORKERHC27>=1) {
        talkedToCount++;
    }
    if (ARMYHC28>=1 || CHEFHC28>=1 || INSPECTORHC28>=1 || WORKERHC28>=1) {
        talkedToCount++;
    }
    if (ARMYHC29>=1 || CHEFHC29>=1 || INSPECTORHC29>=1 || WORKERHC29>=1) {
        talkedToCount++;
    }
    if (ARMYHC30>=1 || CHEFHC30>=1 || INSPECTORHC30>=1 || WORKERHC30>=1) {
        talkedToCount++;
    }
    if (ARMYHC31>=1 || CHEFHC31>=1 || INSPECTORHC31>=1 || WORKERHC31>=1) {
        talkedToCount++;
    }
    if (ARMYHC32>=1 || CHEFHC32>=1 || INSPECTORHC32>=1 || WORKERHC32>=1) {
        talkedToCount++;
    }
    if (ARMYHC33>=1 || CHEFHC33>=1 || INSPECTORHC33>=1 || WORKERHC33>=1) {
        talkedToCount++;
    }
    if (ARMYHC34>=1 || CHEFHC34>=1 || INSPECTORHC34>=1 || WORKERHC34>=1) {
        talkedToCount++;
    }
    if (ARMYHC35>=1 || CHEFHC35>=1 || INSPECTORHC35>=1 || WORKERHC35>=1) {
        talkedToCount++;
    }
    if (ARMYHC36>=1 || CHEFHC36>=1 || INSPECTORHC36>=1 || WORKERHC36>=1) {
        talkedToCount++;
    }
    
    if (talkedToCount >= 36) {
        //NSLog(@" submit! talked to %d", talkedToCount);
        
        [self checkAchievement:kTalkToAllEmployeesHardcore];
    }
    
    return talkedToCount;   
}

+ (int) hctalkToAndreProgress
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    
    
    NSInteger ANDREHC1 = [prefs integerForKey:@"TALKED_TO_ANDREHC1"];
    NSInteger ANDREHC2 = [prefs integerForKey:@"TALKED_TO_ANDREHC2"];
    NSInteger ANDREHC3 = [prefs integerForKey:@"TALKED_TO_ANDREHC3"];
    NSInteger ANDREHC4 = [prefs integerForKey:@"TALKED_TO_ANDREHC4"];
    NSInteger ANDREHC5 = [prefs integerForKey:@"TALKED_TO_ANDREHC5"];
    NSInteger ANDREHC6 = [prefs integerForKey:@"TALKED_TO_ANDREHC6"];
    NSInteger ANDREHC7 = [prefs integerForKey:@"TALKED_TO_ANDREHC7"];
    NSInteger ANDREHC8 = [prefs integerForKey:@"TALKED_TO_ANDREHC8"];
    NSInteger ANDREHC9 = [prefs integerForKey:@"TALKED_TO_ANDREHC9"];
    NSInteger ANDREHC10 = [prefs integerForKey:@"TALKED_TO_ANDREHC10"];
    NSInteger ANDREHC11 = [prefs integerForKey:@"TALKED_TO_ANDREHC11"];
    NSInteger ANDREHC12 = [prefs integerForKey:@"TALKED_TO_ANDREHC12"];    
    NSInteger ANDREHC13 = [prefs integerForKey:@"TALKED_TO_ANDREHC13"];
    NSInteger ANDREHC14 = [prefs integerForKey:@"TALKED_TO_ANDREHC14"];
    NSInteger ANDREHC15 = [prefs integerForKey:@"TALKED_TO_ANDREHC15"];
    NSInteger ANDREHC16 = [prefs integerForKey:@"TALKED_TO_ANDREHC16"];
    NSInteger ANDREHC17 = [prefs integerForKey:@"TALKED_TO_ANDREHC17"];
    NSInteger ANDREHC18 = [prefs integerForKey:@"TALKED_TO_ANDREHC18"];
    NSInteger ANDREHC19 = [prefs integerForKey:@"TALKED_TO_ANDREHC19"];
    NSInteger ANDREHC20 = [prefs integerForKey:@"TALKED_TO_ANDREHC20"];
    NSInteger ANDREHC21 = [prefs integerForKey:@"TALKED_TO_ANDREHC21"];
    NSInteger ANDREHC22 = [prefs integerForKey:@"TALKED_TO_ANDREHC22"];    
    NSInteger ANDREHC23 = [prefs integerForKey:@"TALKED_TO_ANDREHC23"];
    NSInteger ANDREHC24 = [prefs integerForKey:@"TALKED_TO_ANDREHC24"];
    NSInteger ANDREHC25 = [prefs integerForKey:@"TALKED_TO_ANDREHC25"];
    NSInteger ANDREHC26 = [prefs integerForKey:@"TALKED_TO_ANDREHC26"];
    NSInteger ANDREHC27 = [prefs integerForKey:@"TALKED_TO_ANDREHC27"];
    NSInteger ANDREHC28 = [prefs integerForKey:@"TALKED_TO_ANDREHC28"];
    NSInteger ANDREHC29 = [prefs integerForKey:@"TALKED_TO_ANDREHC29"];
    NSInteger ANDREHC30 = [prefs integerForKey:@"TALKED_TO_ANDREHC30"];
    NSInteger ANDREHC31 = [prefs integerForKey:@"TALKED_TO_ANDREHC31"];
    NSInteger ANDREHC32 = [prefs integerForKey:@"TALKED_TO_ANDREHC32"];
    NSInteger ANDREHC33 = [prefs integerForKey:@"TALKED_TO_ANDREHC33"];
    NSInteger ANDREHC34 = [prefs integerForKey:@"TALKED_TO_ANDREHC34"];
    NSInteger ANDREHC35 = [prefs integerForKey:@"TALKED_TO_ANDREHC35"];
    NSInteger ANDREHC36 = [prefs integerForKey:@"TALKED_TO_ANDREHC36"];
    
    
    NSInteger talkedToAndreCount  =      
	ANDREHC1 +  
    ANDREHC2 +  
    ANDREHC3 +  
    ANDREHC4 +   
    ANDREHC5 +   
    ANDREHC6 +   
    ANDREHC7 +   
    ANDREHC8 +   
    ANDREHC9 +   
    ANDREHC10 +  
    ANDREHC11 +  
    ANDREHC12 +      
    ANDREHC13 +  
    ANDREHC14 +  
    ANDREHC15 +  
    ANDREHC16 +  
    ANDREHC17 +  
    ANDREHC18 +  
    ANDREHC19 +  
    ANDREHC20 +  
    ANDREHC21 +  
    ANDREHC22 +      
    ANDREHC23 +  
    ANDREHC24 +  
    ANDREHC25 +  
    ANDREHC26 +  
    ANDREHC27 +  
    ANDREHC28 +  
    ANDREHC29 +  
    ANDREHC30 +  
    ANDREHC31 +  
    ANDREHC32 +  
    ANDREHC33 +  
    ANDREHC34 +  
    ANDREHC35 +  
    ANDREHC36 ;
    
    
    
    if (talkedToAndreCount >= 36) {
        
        [self checkAchievement:kTalkToAndreHardcore];
    }
    
    return talkedToAndreCount;   
}

// + (void) updateInput;
// {
//    [keys update];
//    [mouse updateWithParam1:state.mouseX param2:state.mouseY param3:scroll.x param4:scroll.y];
// }


@end

