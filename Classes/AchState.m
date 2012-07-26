///Users/initials/developer/FlxGK_insideFlixel/FlxGKInsideFlixel.xcodeproj
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

#import "AchState.h"
#import "MenuState.h"


@implementation AchState

@synthesize currentScore;
//@synthesize gameCenterManager;


- (id) init
{
  if ((self = [super init])) {
    self.bgColor = 0xff35353d;
  }
  return self;
}

//- (void) checkAchievements
//{
//	NSString* identifier= NULL;
//	double percentComplete= 0;
//	switch(self.currentScore)
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
//		[self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
//	}
//}


- (void) create
{

    
  helloText = [FlxText textWithWidth:FlxG.width
								text:@"Add"
								font:nil
								size:24.0];
  helloText.color = 0xffffffff;
  helloText.alignment = @"left";
  helloText.x = 0;
  helloText.y = 15;
  [self add:helloText];

    helloText = [FlxText textWithWidth:FlxG.width
                                  text:@"reset"
                                  font:nil
                                  size:24.0];
    helloText.color = 0xffffffff;
    helloText.alignment = @"left";
    helloText.x = 240;
    helloText.y = 15;
    [self add:helloText];	
    
    helloText = [FlxText textWithWidth:FlxG.width
                                  text:@"nslog completed achievements"
                                  font:nil
                                  size:8.0];
    helloText.color = 0xffffffff;
    helloText.alignment = @"left";
    helloText.x = 0;
    helloText.y = 160;
    [self add:helloText];
    helloText = [FlxText textWithWidth:FlxG.width
                                  text:@"new state"
                                  font:nil
                                  size:8.0];
    helloText.color = 0xffffffff;
    helloText.alignment = @"left";
    helloText.x =240;
    helloText.y = 160;
    [self add:helloText];  
}

- (void) dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];

  [super dealloc];
}


- (void) update
{
  
    //Top Left
    if (FlxG.touches.touchesBegan 
        && FlxG.touches.screenTouchBeganPoint.y < FlxG.height/2 
        && FlxG.touches.screenTouchBeganPoint.x < FlxG.width/2) {
        
        [FlxG checkAchievement:kViewCredits];
        

    }
    
    //top right
    if (FlxG.touches.touchesBegan 
        && FlxG.touches.screenTouchBeganPoint.y < FlxG.height/2
        && FlxG.touches.screenTouchBeganPoint.x > FlxG.width/2) {
        [FlxG resetAchievements];
        FlxG.state = [[[MenuState alloc] init] autorelease];
    }    
    
    //bottomleft
    if (FlxG.touches.touchesBegan 
        && FlxG.touches.screenTouchBeganPoint.y > FlxG.height/2 
        && FlxG.touches.screenTouchBeganPoint.x < FlxG.width/2) {
  
        [FlxG retrieveAchievmentMetadata];
        
    }
    
    //bottom right
    if (FlxG.touches.touchesBegan 
        && FlxG.touches.screenTouchBeganPoint.y > FlxG.height/2 
        && FlxG.touches.screenTouchBeganPoint.x > FlxG.width/2) {
        
        [FlxG resetAchievements];
        
        
    }
  [super update];

  
}




@end

