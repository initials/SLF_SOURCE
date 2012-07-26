//initials. he is a bro.

@interface Grenade : FlxManagedSprite
{
	CGFloat timer;
    int damage;
}

+ (id) grenadeWithOrigin:(CGPoint)Origin;
//- (id) init;
- (id) initWithOrigin:(CGPoint)Origin;

@property CGFloat timer;
@property int damage;


@end
