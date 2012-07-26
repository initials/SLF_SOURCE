#import "Disc.h"

static NSString * ImgBullet = @"bottleCap.png";

@implementation Disc


@synthesize timer;
@synthesize numberOfBounces;


+ (id) discWithOrigin:(CGPoint)Origin
{
	return [[[self alloc] initWithOrigin:Origin] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
		
		[self loadGraphicWithParam1:ImgBullet param2:YES param3:NO param4:14 param5:4];
        [self addAnimationWithParam1:@"play" param2:[NSMutableArray intArrayWithSize:3 ints:0,1,2] param3:8];
        [self play:@"play"];
		timer = 0.0;
        numberOfBounces=0;
        acceleration = CGPointMake(0, 200);
	}
	
	return self;	
}

- (void) hitLeftWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
    numberOfBounces++;
    CGFloat i = self.velocity.x * -1;
    self.velocity = CGPointMake(i, 0);
    //[super hitLeftWithParam1:Contact param2:Velocity];
    
    if (numberOfBounces>=2) {
        self.y = 1000;
        self.dead = YES;
        numberOfBounces=0;
        //return;
    }

}

- (void) hitRightWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
    
    numberOfBounces++;
    CGFloat i = self.velocity.x * -1;
    self.velocity = CGPointMake(i, 0);
    //[super hitRightWithParam1:Contact param2:Velocity];
    
    if (numberOfBounces>=2) {
        self.y = 1000;
        self.dead = YES;
        numberOfBounces=0;
        //return;
    }

}

- (void) hitBottomWithParam1:(FlxObject *)Contact param2:(float)Velocity
{
    numberOfBounces++;
    CGFloat i = self.velocity.y * -1;
    self.velocity = CGPointMake(self.velocity.x/2, i/2);
    //[super hitRightWithParam1:Contact param2:Velocity];
    
    if (numberOfBounces>=2) {
        self.y = 1000;
        self.dead = YES;
        numberOfBounces=0;
        //return;
    } 
    
}

- (void) resetDisc
{
    //self.dead = NO;
    //numberOfBounces=0;
    
}



- (void) dealloc
{
    
	[super dealloc];
}


- (void) update
{   
	//NSLog(@" disc x %f y %f", self.x, self.y);
	[super update];
	
}


@end
