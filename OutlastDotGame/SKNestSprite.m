//
//  SKNestSprite.m
//  OutlastDotGame
//
//  Created by Eric Mcallister on 30/04/2014.
//  Copyright (c) 2014 ERIC. All rights reserved.
//

#import "SKNestSprite.h"

@implementation SKNestSprite
@synthesize constant;
-(void)spawnRandom{
    SKEnemySprite *newEnemy = [SKEnemySprite spriteNodeWithImageNamed:@"Black Circle.png"];
    [newEnemy setSize:CGSizeMake(6*self.constant/40, 6*self.constant/40)];
    [newEnemy setPosition:self.position];
    newEnemy.isDead = NO;
    newEnemy.esize = 1;
    newEnemy.constant = self.constant;
    if(self.children.count == 5){
        [newEnemy makeRed];
    }
    [self.parent addChild:newEnemy];
}
@end
