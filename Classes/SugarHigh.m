#import "SugarHigh.h"

static NSString * ImgBottle = @"sugarHigh.png";

@implementation SugarHigh

+ (id) sugarHighWithOrigin:(CGPoint)Origin
{
	return [[[self alloc] initWithOrigin:Origin] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
		
		[self loadGraphicWithParam1:ImgBottle param2:YES param3:NO param4:48 param5:32];
        [self addAnimationWithParam1:@"flicker" param2:[NSMutableArray intArrayWithSize:4 ints:0,1,2,3] param3:6];    
        [self play:@"flicker"];
        
        self.scale = CGPointMake(10, 10);
        
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
