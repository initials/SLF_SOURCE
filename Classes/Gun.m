#import "Gun.h"

static NSString * ImgWeapons = @"guns_40x40.png";

@implementation Gun


+ (id) gunWithOrigin:(CGPoint)Origin
{
	return [[[self alloc] initWithOrigin:Origin] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
		
		[self loadGraphicWithParam1:ImgWeapons param2:YES param3:NO param4:40 param5:40];
        [self addAnimationWithParam1:@"pistol" param2:[NSMutableArray intArrayWithSize:1 ints:0] param3:0];
        [self addAnimationWithParam1:@"machinegun" param2:[NSMutableArray intArrayWithSize:1 ints:1] param3:0];
        [self addAnimationWithParam1:@"shotgun" param2:[NSMutableArray intArrayWithSize:1 ints:2] param3:0];
        [self addAnimationWithParam1:@"bazooka" param2:[NSMutableArray intArrayWithSize:1 ints:3] param3:0];
        [self addAnimationWithParam1:@"dualpistol" param2:[NSMutableArray intArrayWithSize:1 ints:4] param3:0];
        [self addAnimationWithParam1:@"revolver" param2:[NSMutableArray intArrayWithSize:1 ints:5] param3:0];
        [self addAnimationWithParam1:@"flamethrower" param2:[NSMutableArray intArrayWithSize:1 ints:6] param3:0];
        [self addAnimationWithParam1:@"discgun" param2:[NSMutableArray intArrayWithSize:1 ints:7] param3:0];
        [self addAnimationWithParam1:@"mine" param2:[NSMutableArray intArrayWithSize:1 ints:8] param3:0];
        [self addAnimationWithParam1:@"minigun" param2:[NSMutableArray intArrayWithSize:1 ints:9] param3:0];
        [self addAnimationWithParam1:@"katana" param2:[NSMutableArray intArrayWithSize:1 ints:10] param3:0];
        [self addAnimationWithParam1:@"grenadelauncher" param2:[NSMutableArray intArrayWithSize:1 ints:11] param3:0];
        [self addAnimationWithParam1:@"laser" param2:[NSMutableArray intArrayWithSize:1 ints:12] param3:0];
        [self play:@"pistol"];
        
	}
	
	return self;	
}


- (void) dealloc
{
    
	[super dealloc];
}


- (void) update
{   
	[super update];	
}


@end
