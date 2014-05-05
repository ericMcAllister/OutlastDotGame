//
//  SKNestSprite.h
//  OutlastDotGame
//
//  Created by Eric Mcallister on 30/04/2014.
//  Copyright (c) 2014 ERIC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKEnemySprite.h"

@interface SKNestSprite : SKSpriteNode
@property int constant;
-(void)spawnRandom;
@end
