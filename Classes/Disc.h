//initials. he is a bro.

@interface Disc : FlxManagedSprite
{
	CGFloat timer;
    int numberOfBounces;
}

+ (id) discWithOrigin:(CGPoint)Origin;
//- (id) init;
- (id) initWithOrigin:(CGPoint)Origin;
- (void) resetDisc;

@property CGFloat timer;
@property int numberOfBounces;

@end
