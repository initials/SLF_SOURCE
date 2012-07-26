//
//  Enemy.h
//  FlxShmup
//
//  Created by Shane Brouwer on 7/04/11.
//  Copyright 2011 Initials. All rights reserved.
//
#import "Enemy.h"
#import "Player.h"

@interface EnemyGhost : Enemy
{
    Player * p;  
    
}

+ (id) enemyGhost;
//- (id) init;
- (id) initWithOrigin:(CGPoint)origin index:(int)Index player:(Player *)player;



@end
