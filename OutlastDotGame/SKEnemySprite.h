//
//  SKEnemySprite.h
//  OutlastDotGame
//
//  Created by Eric Mcallister on 30/04/2014.
//  Copyright (c) 2014 ERIC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKPointSprite.h"

@interface SKEnemySprite : SKSpriteNode
-(void)pursuePoint:(CGPoint)point;
-(void)makeRed;
-(void)apoptosis;
@property float x;
@property float y;
@property float dx;
@property float dy;
@property float px;
@property float py;
@property float hyp;
@property int esize;
@property BOOL isRed;
@property BOOL isDead;
@property BOOL growing;
@property int constant;
@end
