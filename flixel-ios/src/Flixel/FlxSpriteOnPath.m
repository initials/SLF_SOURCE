@implementation FlxSpriteOnPath

@synthesize limitX;
@synthesize limitY;
@synthesize _movementType;

@synthesize _pathSpeed;
@synthesize _currentPathSpeed;
@synthesize _isAnimated;


BOOL requiresXMovement;
BOOL requiresYMovement;


+ (id) flxSpriteOnPathWithOrigin:(CGPoint)Origin withSpeed:(float)Speed  withLimits:(CGPoint)Limits  withMovementType:(int)MovementType  isAnimated:(BOOL)animated
{
	return [[[self alloc] initWithOrigin:Origin withSpeed:Speed withLimits:CGPointMake(Limits.x, Limits.y)  withMovementType:MovementType isAnimated:animated] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin withSpeed:(float)Speed   withLimits:(CGPoint)Limits  withMovementType:(int)MovementType  isAnimated:(BOOL)animated
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
        originalXPos = Origin.x;
        originalYPos = Origin.y;
        limitX = Limits.x;
        limitY = Limits.y;
        _movementType = MovementType;
        _pathSpeed = Speed;
        _currentPathSpeed = Speed;
        _isAnimated = animated;
        
        //movement type 1 : moving from the start. oscillates.
        //movement type 2 : wait until block is jumped on - horizontal - oscillate
        //movement type 3 : wait until block is jumped on - vert - major bug because character doesn't stick
        //movement type 4 : wait until block is jumped on - End at end of path.
        //movement type 5 : wait until block is jumped on - move back when not jumped on.
        
        if (originalXPos==limitX) {
            self.velocity = CGPointMake(0, Speed);
        } else  if (originalYPos==limitY) {
            self.velocity = CGPointMake(Speed, 0);
        }
        else {
            self.velocity = CGPointMake(Speed, Speed);
        }
        
        
        if (_isAnimated) {
            width=40;
            height=20;
            [self addAnimationWithParam1:@"stop" param2:[NSMutableArray intArrayWithSize:1 ints:0] param3:0 param4:NO];
            [self addAnimationWithParam1:@"right" param2:[NSMutableArray intArrayWithSize:5 ints:1,2,3,4,1] param3:8 param4:YES];
            [self addAnimationWithParam1:@"left" param2:[NSMutableArray intArrayWithSize:5 ints:5,6,7,8,5] param3:8 param4:YES];
            [self play:@"stop"];


        }
        
        
        

        
	}
	
	return self;	
}

- (void) dealloc
{
	
	[super dealloc];
}

//movement type 1 : moving from the start. oscillates.
// moves up and left, left to right within the bounds.

- (void) advancePath
{
    if (limitX!=originalXPos) {
        if (self.x >= limitX ) {    
            self.x = limitX-1;
            CGFloat i = self.velocity.x * -1;
            self.velocity = CGPointMake(i, self.velocity.y);
            
            if(_isAnimated)
                [self play:@"left"];
            
        } else if (self.x <= originalXPos) {
            self.x = originalXPos+1;
            CGFloat i = self.velocity.x * -1;
            self.velocity = CGPointMake(i, self.velocity.y);
            
            if(_isAnimated)
                [self play:@"right"];
        }
    }
    //else { self.velocity = CGPointMake(self.velocity.x, 0); }
    if (limitY!=originalYPos) {
        if (self.y >= limitY ) {    
            self.y = limitY-1;
            CGFloat ii = self.velocity.y * -1;
            self.velocity = CGPointMake(self.velocity.x, ii);
        } else if (self.y <= originalYPos) {
            self.y = originalYPos+1;
            CGFloat ii = self.velocity.y * -1;
            self.velocity = CGPointMake(self.velocity.x, ii);   
        }
    }

}

//movement type 2 : wait until block is jumped on - horizontal - oscillate

- (void) advancePathType2
{
    self.velocity = CGPointMake(_currentPathSpeed, 0);
    if (limitX!=originalXPos) {
        if (self.x >= limitX ) {    
            self.x = limitX-1;
            self.velocity = CGPointMake(_pathSpeed*-1, 0);
            _currentPathSpeed=_pathSpeed*-1;
            if(_isAnimated)
                [self play:@"left"];
        } else if (self.x <= originalXPos) {
            self.x = originalXPos+1;
            self.velocity = CGPointMake(_pathSpeed, 0);  
            _currentPathSpeed=_pathSpeed;
            if(_isAnimated)
                [self play:@"right"];

        }
    }
}

//movement type 3 : wait until block is jumped on - vert - major bug because character doesn't stick

- (void) advancePathType3
{
    self.velocity = CGPointMake(0, _currentPathSpeed);

    if (limitY!=originalYPos) {
        if (self.y >= limitY ) {    
            self.y = limitY-1;
            self.velocity = CGPointMake(0, _pathSpeed*-1);
            _currentPathSpeed=_pathSpeed*-1;

        } else if (self.y <= originalYPos) {
            self.y = originalYPos+1;
            self.velocity = CGPointMake(0, _pathSpeed); 
            _currentPathSpeed=_pathSpeed;

        }
    }
}

//movement type 4 : wait until block is jumped on - End at end of path.

- (void) advancePathType4
{
    if (self.x < limitX ) {
        self.velocity = CGPointMake(_currentPathSpeed, 0);
        if(_isAnimated)
            [self play:@"left"];
    } 
    else  {
        self.velocity = CGPointMake(0, 0);
        if(_isAnimated)
            [self play:@"stop"];
    }
    
}


- (void) advancePathType5
{
    self.velocity = CGPointMake(0, _currentPathSpeed);
    
    if (limitY!=originalYPos) {
        if (self.y >= limitY ) {    
            self.y = limitY-1;
            self.velocity = CGPointMake(0, _pathSpeed*-1);
            _currentPathSpeed=_pathSpeed*-1;
            
        } else if (self.y <= originalYPos) {
            self.y = originalYPos+1;
            self.velocity = CGPointMake(0, _pathSpeed); 
            _currentPathSpeed=_pathSpeed;
            
        }
    }
}


- (void) update
{   
    //NSLog(@"mt %d, onTop %d", _movementType, self.onTop);

    if (_movementType==1) {
        [self advancePath];
    }
    
    else if (_movementType==2 ) {
        if (self.onTop) {
            [self advancePathType2];
            if (self.velocity.x<0) [self play:@"left"];
            if (self.velocity.x>0) [self play:@"right"];

        } else {
            self.velocity=CGPointMake(0, 0);
            if(_isAnimated)
                [self play:@"stop"];
        }
    }    
    else if (_movementType==3 ) {
        if (self.onTop) {
            [self advancePathType3];
        } else {
            self.velocity=CGPointMake(0, 0);
            if(_isAnimated)
                [self play:@"stop"];
        }
    } 
    
    else if (_movementType==4 ) {
        if (self.onTop) {
            [self advancePathType4];
            if (self.velocity.x<0) [self play:@"left"];
            if (self.velocity.x>0) [self play:@"right"];
        } else {
            self.velocity=CGPointMake(0, 0);
            if(_isAnimated)
                [self play:@"stop"];
        }
    } 
    
    else if (_movementType==5 ) {
        if (self.onTop) {
            if (self.x >= self.limitX) {
                self.x = self.limitX;
                self.velocity=CGPointMake(0, 0);
                if(_isAnimated)
                    [self play:@"stop"];
            }
            else {
                self.velocity = CGPointMake(_pathSpeed, 0);
            }
        } 
        
        else if (!self.onTop) {

            if (self.x <= self.originalXPos) {
                self.x = self.originalXPos;
                self.velocity=CGPointMake(0, 0);
                if(_isAnimated)
                    [self play:@"stop"];
            }
            else {
                self.velocity = CGPointMake(_pathSpeed*-1, 0);
            }
        }         
    } 
    
    else if (_movementType==6 ) {
        if (self.onTop) {
            self.velocity=CGPointMake(_pathSpeed, 0);

            _movementType=1;
        }
        else if (!self.onTop) {
            self.velocity=CGPointMake(0, 0);
        }
    } 
        
	[super update];
	
}


@end
