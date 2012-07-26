#import "Explosion.h"

static NSString * ImgBullet = @"explosion_x21.png";


@implementation Explosion


@synthesize timer;
@synthesize damage;

+ (id) explosionWithOrigin:(CGPoint)Origin;
{
	return [[[self alloc] initWithOrigin:Origin] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
		
		[self loadGraphicWithParam1:ImgBullet param2:YES param3:NO param4:128 param5:128];
		timer = 0.0;
        damage = 1;
	}
	
	return self;	
}


- (void) dealloc
{
    
	[super dealloc];
}


- (void) update
{   
    //explosion
    self.alpha -= 0.05;
    if (!self.dead) {
        CGFloat sx = self.scale.x + 0.05;
        CGFloat sy = self.scale.y + 0.05;
        self.scale = CGPointMake(sx, sy);
    }
    if (self.alpha <= 0) {
        self.dead = YES;
        self.x = 1000;
        self.y = 1000;
    }
    
	[super update];
	
}


@end
