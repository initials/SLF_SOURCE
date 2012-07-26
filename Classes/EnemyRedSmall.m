
#import "EnemyRedSmall.h"


#define POINTS_FOR_HURT 15
#define POINTS_FOR_KILL 100
#define ORIGINAL_HEALTH 5


@implementation EnemyRedSmall
static NSString * ImgRedBigBadGuy = @"redsmall_sprite1.png";
int counter;




+ (id) enemyRedSmall
{
	return [[[self alloc] init] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin index:(int)Index
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
        [self loadGraphicWithParam1:ImgRedBigBadGuy param2:YES param3:NO param4:24 param5:24];
		//self.width = 24;
		//self.height = 17;
        self.health = ORIGINAL_HEALTH;
        self.dead = YES;
        self.acceleration = CGPointMake(0, 900);
        self.x = -1000;
        self.y = -1000;
        
        index = Index;
		originalHealth = ORIGINAL_HEALTH;
        [self addAnimationWithParam1:@"walk" param2:[NSMutableArray intArrayWithSize:6 ints:0,1,2,3,4,5] param3:8];
        [self play:@"walk"];
        
	}
	
	return self;	
}


- (void) dealloc
{
	[super dealloc];
}

- (void) hurt:(float)Damage
{
    health -= Damage;
    if (health == 0 && self.dead == NO) {
        dead = YES;
        visible = NO;
        x = -100;
        y = -100;
    }
    else {
    }
    
    
}

- (void) resetSwarm:(int)newMovementType
{
    [super resetSwarm:0];
    health = ORIGINAL_HEALTH + FlxG.level-1;
    CGFloat vel = 0;
    if ([FlxU random] > 0.5) {
        vel = -130 + ([FlxU random] * 60);
    }
    else {
        vel = 70 + ([FlxU random] * 60);
    }
    self.velocity = CGPointMake( vel ,0);  //a ? e1 : e2    
}


- (void) update
{   
    
    [super update];
    
	
}


@end
