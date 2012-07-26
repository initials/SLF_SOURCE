#import "Grenade.h"
#define BOUNCE -0.45

static NSString * ImgBullet = @"sodabulb.png";
static NSString * SndGrenadeHitWall = @"grenadeHitWall.caf";

@implementation Grenade


@synthesize timer;
@synthesize damage;

+ (id) grenadeWithOrigin:(CGPoint)Origin;
{
	return [[[self alloc] initWithOrigin:Origin] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
		
		[self loadGraphicWithParam1:ImgBullet param2:YES param3:NO param4:8 param5:8];
		timer = 0.0;
        damage = 1;
        self.acceleration = CGPointMake(0, 900);
        self.drag = CGPointMake(110, 110);
        
        self.dead = YES;
        
	}
	
	return self;	
}

- (void) hitLeftWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
    [FlxG play:SndGrenadeHitWall];
    CGFloat i = self.velocity.x * BOUNCE;
    self.velocity = CGPointMake(i, self.velocity.y);
    //[super hitLeftWithParam1:Contact param2:Velocity];
}

- (void) hitRightWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
    [FlxG play:SndGrenadeHitWall];
    CGFloat i = self.velocity.x * BOUNCE;
    self.velocity = CGPointMake(i, self.velocity.y);
    //[super hitRightWithParam1:Contact param2:Velocity];
}
- (void) hitBottomWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
    if (self.velocity.y > 5) {
        [FlxG play:SndGrenadeHitWall];
    }
    CGFloat i = self.velocity.y * BOUNCE;
    self.velocity = CGPointMake(self.velocity.x, i);
    //[super hitRightWithParam1:Contact param2:Velocity];
}
- (void) hitTopWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
    [FlxG play:SndGrenadeHitWall];
    CGFloat i = self.velocity.y * BOUNCE;
    self.velocity = CGPointMake(self.velocity.x, i);
    //[super hitRightWithParam1:Contact param2:Velocity];
}
- (void) dealloc
{
    
	[super dealloc];
}


- (void) update
{   
//    if ( (self.velocity.x <= .5 && self.velocity.x >= -.5) ) {
//        self.dead = YES;
//        self.x = 1000;
//        self.y = 1000;
//    }
    
    if ( self.y > FlxG.levelHeight ) {
        self.dead = YES;
        self.x = 10000;
        self.y = 10000;
    }
	
	[super update];
	
}


@end
