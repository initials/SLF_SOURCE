#import "WinniTimer.h"

@implementation WinniTimer

@synthesize helpString;
@synthesize type;


+ (id) helpBoxWithOrigin:(CGPoint)Origin  
{
	return [[[self alloc] initWithOrigin:Origin ] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
		
		[self loadGraphicWithParam1:ImgBox param2:YES param3:NO param4:120 param5:60];
        self.width = 120;
        self.height = 60;
        self.fixed=YES;
        self.originalXPos=Origin.x;
        self.originalYPos=Origin.y;
        
        
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
