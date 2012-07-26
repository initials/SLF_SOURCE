
@interface WinniTimer : FlxText
{
    
}

+ (id) winniTimerWithWidth:(unsigned int)Width text:(NSString *)Text font:(NSString *)Font size:(float)Size modelScale:(float)ModelScale;
- (id) initWithX:(float)X y:(float)Y width:(unsigned int)Width text:(NSString *)Text modelScale:(float)ModelScale;

@end
