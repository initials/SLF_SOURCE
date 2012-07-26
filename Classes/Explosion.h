//initials. he is a bro.

@interface Explosion : FlxManagedSprite
{
	CGFloat timer;
    int damage;
}

+ (id) explosionWithOrigin:(CGPoint)Origin;
//- (id) init;
- (id) initWithOrigin:(CGPoint)Origin;

@property CGFloat timer;
@property int damage;


@end
