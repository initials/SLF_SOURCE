
#import "EnemyGreenSmall.h"

#define ORIGINAL_HEALTH 2


@implementation EnemyGreenSmall
static NSString * ImgGreenBigBadGuy = @"badguy_small_sprite1.png";
int counter;




+ (id) enemyGreenSmall
{
	return [[[self alloc] init] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin index:(int)Index
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
        [self loadGraphicWithParam1:ImgGreenBigBadGuy param2:YES param3:NO param4:24 param5:24];
		//self.width = 24;
		//self.height = 17;
        self.health = ORIGINAL_HEALTH;
        self.dead = YES;
        self.acceleration = CGPointMake(0, 0);
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
//    health -= Damage;
//    if (health == 0 && self.dead == NO) {
//        dead = YES;
//        visible = NO;
//        x = -100;
//        y = -100;
//    }
//    else {
//    }
//    
//    
//}

- (void) resetSwarm:(int)newMovementType
{
    
    [super resetSwarm:0];
    health = ORIGINAL_HEALTH;
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
