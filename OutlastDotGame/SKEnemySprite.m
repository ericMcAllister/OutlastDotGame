//
//  SKEnemySprite.m
//  OutlastDotGame
//
//  Created by Eric Mcallister on 30/04/2014.
//  Copyright (c) 2014 ERIC. All rights reserved.
//

#import "SKEnemySprite.h"

@implementation SKEnemySprite
@synthesize x, y, dx, dy, px, py, hyp;
@synthesize isRed, isDead, growing;
@synthesize esize, constant;
-(void)pursuePoint:(CGPoint)point{
    if(!self.isDead){
        self.x = self.position.x;
        self.y = self.position.y;
        self.dx = point.x - self.x;
        self.dy = point.y - self.y;
        self.hyp = sqrtf(powf(self.dx, 2) + powf(self.dy, 2));
        if(hyp >= 2){
            self.px = self.dx/self.hyp;
            self.py = self.dy/self.hyp;
            self.x += 1.05*self.px/self.esize;
            self.y += 1.05*self.py/self.esize;
//          NSLog(@"%f, %f", point.x, point.y);
            [self setPosition:CGPointMake(x, y)];
        }
    }
}
-(void)makeRed{
    
}
-(void)apoptosis{
    for(int a = 0; a < 2*self.esize - 1; a ++){
        int h = self.size.height;
        int ranx = arc4random() % h;
        int rany = arc4random() % h;
        if(sqrtf(powf(self.size.width/2 - ranx, 2) + powf(self.size.width/2 - rany, 2)) <= self.size.width/2){
        ranx += self.position.x - self.size.width/2;
        rany += self.position.y - self.size.height/2;
        SKPointSprite *point = [SKPointSprite spriteNodeWithImageNamed:@"Blue Circle.png"];
        [point setSize:CGSizeMake(self.constant/80, self.constant/80)];
        [point setPosition:CGPointMake(ranx, rany)];
        [self.parent addChild:point];
        }
    }
    [self removeFromParent];
//    [self dealloc];
}
@end
