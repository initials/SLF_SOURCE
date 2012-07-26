
#import "EnemyGhost.h"

#define ORIGINAL_HEALTH 2


@implementation EnemyGhost
static NSString * ImgGhost = @"ghost_sprite21.png";
int counter;
CGFloat moveTimer;




+ (id) enemyGhost
{
	return [[[self alloc] initWithOrigin:Origin index:Index] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin index:(int)Index player:(Player *)player
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
        [self loadGraphicWithParam1:ImgGhost param2:YES param3:NO param4:16 param5:14];
		//self.width = 24;
		//self.height = 17;
        self.health = ORIGINAL_HEALTH;
        self.dead = YES;
        self.acceleration = CGPointMake(0, 0);
        self.x = 1000;
        self.y = 1000;
        
        index = Index;
		originalHealth = ORIGINAL_HEALTH;
        p = [player retain];
        
        [self addAnimationWithParam1:@"walk" param2:[NSMutableArray intArrayWithSize:1 ints:0] param3:0];
        [self addAnimationWithParam1:@"run" param2:[NSMutableArray intArrayWithSize:1 ints:1] param3:0];
        [self play:@"walk"];
        

	}
	
	return self;	
}


- (void) dealloc
{
	[p release];
	p = nil;
    
	[super dealloc];
}

- (void) hurt:(float)Damage
{
    [super hurt:Damage];
    self.acceleration = CGPointMake(0, 1200);
    
    
}

- (void) resetSwarm:(int)newMovementType
{
    
    //[super resetSwarm:0];
    health = ORIGINAL_HEALTH;
    CGFloat vel = 0;
    if ([FlxU random] > 0.5) {
        vel = -80 + ([FlxU random] * 20);
    }
    else {
        vel = 60 + ([FlxU random] * 20);
    }
    self.velocity = CGPointMake( vel , -50);  //a ? e1 : e2  
    
    self.acceleration = CGPointMake(0, 0);
    [self play:@"walk"];
	self.visible = YES;
	self.dead = NO;
    self.angularVelocity = 0;
    self.angle = 0;
    self.x = FlxG.width/2;
    self.y = 0;
    
}


- (void) update
{   
    moveTimer += FlxG.elapsed;
    if (moveTimer>1.15 && !self.dead) {
        moveTimer = 0;
        CGFloat dx = self.x-p.x;
        CGFloat dy = self.y-p.x;
        if (dx>0 && dy >0) {
            self.velocity = CGPointMake(-25, -25);
        } else if (dx>0 && dy < 0) {
            self.velocity = CGPointMake(-25, 25);
        } else if (dx<0 && dy >0) {
            self.velocity = CGPointMake(25, -25);
        } else if (dx<0 && dy <0) {
            self.velocity = CGPointMake(25, 25);
        }
        if ([FlxU random] < 0.05) {
            self.velocity = CGPointMake(self.velocity.x, -60);
        }
        
        
    }
    if (onFloor) {
        self.velocity = CGPointMake(self.velocity.x, -30);

    }
    
    [super update];
    
	
}


@end
