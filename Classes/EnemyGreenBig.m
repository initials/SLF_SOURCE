
#import "EnemyGreenBig.h"

#define ORIGINAL_HEALTH 10


@implementation EnemyGreenBig
static NSString * ImgGreenBigBadGuy = @"badguy_big_sprite1.png";
int counter;




+ (id) enemyGreenBig
{
	return [[[self alloc] init] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin index:(int)Index
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
        [self loadGraphicWithParam1:ImgGreenBigBadGuy param2:YES param3:NO param4:44 param5:44];
        
        //[self createGraphicWithParam1:22 param2:22 param3:0xffff0000];

		self.width = 34;
		self.height = 34;
        self.offset = CGPointMake(8,8);
        self.health = ORIGINAL_HEALTH;
        self.dead = YES;
        self.acceleration = CGPointMake(0, -2000);
        self.x = 1000;
        self.y = 1000;

        index = Index;
		originalHealth = ORIGINAL_HEALTH;
        
        [self addAnimationWithParam1:@"walk" param2:[NSMutableArray intArrayWithSize:12 ints:0,1,2,3,4,5,6,7,8,9,10,11] param3:16];
        [self addAnimationWithParam1:@"run" param2:[NSMutableArray intArrayWithSize:6 ints:12,13,14,15,16,17] param3:24];
        [self addAnimationWithParam1:@"runPreview" param2:[NSMutableArray intArrayWithSize:6 ints:12,13,14,15,16,17] param3:16];
        [self play:@"walk"];
		
        
	}
	
	return self;	
}


- (void) dealloc
{
	[super dealloc];
}

//- (void) hurt:(float)Damage
//{
//    //NSLog(@"health of hurt enemy: %f", self.health);
//    [super hurt:Damage];
//    
//    
//}

- (void) resetSwarm:(int)newMovementType
{
    [super resetSwarm:0];
    health = ORIGINAL_HEALTH ;
    CGFloat vel = 0;
    if ([FlxU random] > 0.5) {
        vel = -80 + ([FlxU random] * 20);
    }
    else {
        vel = 60 + ([FlxU random] * 20);
    }
    self.velocity = CGPointMake( vel ,0);  //a ? e1 : e2    
}


- (void) update
{   
    
    [super update];
    
	
}


@end
