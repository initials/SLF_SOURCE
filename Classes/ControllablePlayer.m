#import "ControllablePlayer.h"

#define MOVE_SPEED_ON_SUGAR_HIGH 235;
#define JUMP_HEIGHT_ON_SUGAR_HIGH 0.250;
#define MOVE_SPEED_REGULAR 200;
#define JUMP_HEIGHT_REGULAR 0.175;

static NSString * ImgPlayer = @"chars_50x50.png";
static NSString * SndJump = @"jump.caf";

@implementation ControllablePlayer

CGFloat moveSpeed = MOVE_SPEED_REGULAR;
CGFloat jumpHeight = JUMP_HEIGHT_REGULAR;

@synthesize jumpLimit;
@synthesize jump;
@synthesize ableToStartJump;
@synthesize isControlledByPlayer;

+ (id) controllablePlayerWithOrigin:(CGPoint)Origin
{
	return [[[self alloc] initWithOrigin:Origin] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
        [self loadGraphicWithParam1:ImgPlayer param2:YES param3:NO param4:50 param5:50];
		
		//gravity
		self.acceleration = CGPointMake(0, 1500);
		
		self.drag = CGPointMake(1900, 1900);
        
        self.width = 10;
        self.height = 30;        
        self.offset = CGPointMake(20, 20);
        self.originalXPos = Origin.x;
        self.originalYPos = Origin.y;
        
        jump=0;
        
        maxVelocity.x = 300;
        maxVelocity.y = 430;
        
        [self addAnimationWithParam1:@"run" param2:[NSMutableArray intArrayWithSize:6 ints:6,7,8,9,10,11] param3:16];
        [self addAnimationWithParam1:@"runWithGun" param2:[NSMutableArray intArrayWithSize:6 ints:42,43,44,45,46,47] param3:16];
        [self addAnimationWithParam1:@"idle" param2:[NSMutableArray intArrayWithSize:1 ints:50] param3:0];
        [self addAnimationWithParam1:@"talk" param2:[NSMutableArray intArrayWithSize:6 ints:1,48,1,49,1,50] param3:12];
        [self addAnimationWithParam1:@"jump" param2:[NSMutableArray intArrayWithSize:3 ints:46,47,46] param3:4 param4:YES];
        
        [self play:@"idle"];
		
	}
	
	return self;	
}


- (void) dealloc
{
	
	[super dealloc];
}

- (void) hitBottomWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
    ableToStartJump = YES;
    jump = 0;
    //if (!FlxG.touches.touching) jump = 0;
    
    [super hitBottomWithParam1:Contact param2:Velocity];
    self.y = roundf(self.y);
    
    
}


- (void) update
{   
    
    if (FlxG.touches.vcpLeftArrow && !self.dead) {
        self.velocity = CGPointMake(-moveSpeed, self.velocity.y);
        self.scale = CGPointMake(-1, 1);
    } 
    if (FlxG.touches.vcpRightArrow && !self.dead) {
        self.velocity = CGPointMake(moveSpeed, self.velocity.y);
        self.scale = CGPointMake(1, 1);
    } 
    
    //jumping Mario Style
    if(jump >= 0 && FlxG.touches.vcpButton2 && !self.dead )
    {
        // first press of jump
        if (jump==0) {
            //            if (!FlxG.touches.newTouch) {
            //                return;
            //            }
            [FlxG play:SndJump withVolume:0.3];
            
        }
        jump += FlxG.elapsed;
        if(jump > jumpHeight) jump = -1; //You can't jump for more than 0.175 seconds or whatever is set to jumpHeight
    }
    else jump = -1;
    
    if (jump > 0)
    {
        if(jump < 0.095)
            velocity.y = -maxVelocity.y*0.55; //This is the minimum speed of the jump
        else
            velocity.y = -maxVelocity.y; //The general acceleration of the jump
    } 
    
    
    //air dash
    //    if (FlxG.touches.swipedUp) {
    //        self.velocity = CGPointMake(2000, self.velocity.y);
    //    } else if (FlxG.touches.swipedDown) {
    //        self.velocity = CGPointMake(-2000, self.velocity.y);
    //    } 
    
    if (self.scale.x > 0) {
        if (self.velocity.x > 1 && onFloor) {
            [self play:@"run"];
            
        }
        else if (!onFloor) {
            [self play:@"jump"];
        }
        
        else {
            [self play:@"idle"];
        }
    }
    
    //facing left
    if (self.scale.x < 0) {
        if (self.velocity.x < -1 && onFloor) {
            //[self play:@"runWithGun"];
            [self play:@"run"];
            
            
        }
        else if (!onFloor) {
            [self play:@"jump"];
        }
        else {
            [self play:@"idle"];
        }
    }
    
    if (self.y > FlxG.levelHeight) {
        self.dead = YES;
    }
	
	[super update];
	
}


@end
