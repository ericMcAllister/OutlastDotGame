//
//  MyScene.m
//  OutlastDotGame
//
//  Created by Eric Mcallister on 29/04/2014.
//  Copyright (c) 2014 ERIC. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene
@synthesize constant;
@synthesize yConstant;
@synthesize score, highScore;
@synthesize isPaused;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        x = 0;
        y = 0;
        dx = 0;
        dy = 0;
        px = 0;
        py = 0;
        hyp = 0;
        self.score = 0;
        self.isPaused = NO;
        self.defaults = [NSUserDefaults standardUserDefaults];
        self.highScore = [self.defaults integerForKey:@"High Score"];
        hero = [SKSpriteNode spriteNodeWithImageNamed:@"Blue Circle.png"];
        self.constant = size.width;
        self.yConstant = size.height;
        [hero setSize:CGSizeMake(20*self.constant/400, 20*self.constant/400)];
        touchPoint = CGPointMake(size.width/2, size.height/2);
        [hero setPosition:touchPoint];
        [self addChild:hero];
        nest = [SKNestSprite spriteNodeWithImageNamed:@"Black Circle.png"];
        [nest setPosition:CGPointMake(size.width/4, size.height/4)];
        [nest setSize:CGSizeMake(self.constant/8, self.constant/8)];
        nest.constant = self.constant/2;
        [self addChild:nest];
        myLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        myLabel.text = @"0, 0";
        myLabel.fontSize = 10;
        CGPoint point = CGPointMake(self.constant/4, self.constant - 20);
        myLabel.position = point;
        [myLabel setFontColor:[UIColor blackColor]];
        [self addChild:myLabel];
        int rannum = arc4random() % 5;
        rannum ++;
        for(int xy = 0; xy < rannum; xy ++){
            float ranx = arc4random() % self.constant;
            float rany = arc4random() % self.yConstant;
            SKNestSprite *nesty = [SKNestSprite spriteNodeWithImageNamed:@"Black Circle.png"];
            [nesty setPosition:CGPointMake(ranx, rany)];
            [nesty setSize:CGSizeMake(self.constant/8, self.constant/8)];
            nesty.constant = self.constant/2;
            [self addChild:nesty];
        }
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        touchPoint = [touch locationInNode:self];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        touchPoint = [touch locationInNode:self];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    if(!self.isPaused){
    [myLabel setText:[NSString stringWithFormat:@"Score: %i, Highscore: %i", self.score, self.highScore]];
    [myLabel setZPosition:foreground];
    x = hero.position.x;
    y = hero.position.y;
    dx = touchPoint.x - x;
    dy = touchPoint.y - y;
    hyp = sqrtf(powf(dx, 2) + powf(dy, 2));
    px = dx/hyp;
    py = dy/hyp;
    float relativeMotionX = 0;
    float relativeMotionY = 0;
    if(hyp <= 2){
    } else if(hero.position.x + px < self.constant/16 || hero.position.x + px > 15*self.constant/16){
        relativeMotionX = px;
        [self randomGenerate];
    } else if(hero.position.x + px >= self.constant/16 && hero.position.x + px <= 15*self.constant/16){
        x += 1.25*px;
    }
    if(hyp <= 2){
    } else if(hero.position.y + py < 5*self.yConstant/16 || hero.position.y + py > 11*self.yConstant/16){
        relativeMotionY = py;
        [self randomGenerate];
    } else if(hero.position.y + py >= 5*self.yConstant/16 && hero.position.y + py <= 11*self.yConstant/16){
        y += 1.25*py;
    }
    for(SKSpriteNode *sprite in self.children){
        if([sprite isKindOfClass:[SKEnemySprite class]] || [sprite isKindOfClass:[SKNestSprite class]] || [sprite isKindOfClass:[SKPointSprite class]]){
            [sprite setPosition:CGPointMake(sprite.position.x - relativeMotionX, sprite.position.y - relativeMotionY)];
            if(sprite.position.x <= -self.constant || sprite.position.x >= 2*self.constant || sprite.position.y <= -self.yConstant || sprite.position.y >= 2*self.yConstant){
                [sprite removeFromParent];
            }
        }
    }
    [hero setPosition:CGPointMake(x, y)];
    for(SKNestSprite *someNest in self.children){
        if([someNest isKindOfClass:[SKNestSprite class]]){
            if(sqrtf(powf(someNest.position.x - hero.position.x, 2) + powf(someNest.position.y - hero.position.y, 2)) <= someNest.size.height/2 + hero.size.height/2){
                [self gameOver];
            }
            int randomNum = arc4random() % 1000;
            if(randomNum == 1){
                [someNest spawnRandom];
            }
            for(SKPointSprite *point in self.children){
                if([point isKindOfClass:[SKPointSprite class]]){
                    [point setZPosition:background];
                    if(sqrtf(powf(point.position.x - hero.position.x, 2) + powf(point.position.y - hero.position.y, 2)) < hero.size.height/2){
                        [point removeFromParent];
                        self.score ++;
                        if(self.score >= self.highScore){
                            self.highScore = self.score;
                            [self.defaults setInteger:self.highScore forKey:@"High Score"];
                            [self.defaults synchronize];
                        }
                        NSLog(@"Score: %i, Highscore: %i", self.score, self.highScore);
                    }
                    if(CGRectContainsPoint(someNest.frame, point.position)){
                        [point removeFromParent];
                    }
                }
            }
        }
    }
    for(SKEnemySprite *enemy in self.children){
        if([enemy isKindOfClass:[SKEnemySprite class]] && !enemy.isDead){
            [enemy setZPosition:middleground];
            [enemy pursuePoint:hero.position];
            for(SKEnemySprite *anotherEnemy in self.children){
                if([anotherEnemy isKindOfClass:[SKEnemySprite class]] && anotherEnemy != enemy){
                    if(sqrtf(powf(enemy.position.x - anotherEnemy.position.x, 2) + powf(enemy.position.y - anotherEnemy.position.y, 2)) <= enemy.size.height/2 && !anotherEnemy.isDead){
                        enemy.esize += anotherEnemy.esize;
                        anotherEnemy.isDead = YES;
                        [anotherEnemy apoptosis];
                        enemy.growing = YES;
                        if(enemy.esize >= 6){
                            [enemy apoptosis];
                        }
                    }
                }
            }
            if(enemy.growing){
                [enemy setSize:CGSizeMake(enemy.size.width + 1, enemy.size.height + 1)];
                if(enemy.size.width >= sqrtf(enemy.esize)*6*self.constant/80){
                    enemy.growing = NO;
                }
            }
            if(sqrtf(powf(enemy.position.x - hero.position.x, 2) + powf(enemy.position.y - hero.position.y, 2)) <= enemy.size.height/2){
                [self gameOver];
            }
        }
    }
    }
}

-(void)randomGenerate{
    float ranx = arc4random() % self.constant;
    ranx += px*self.constant;
    float rany = arc4random() % self.yConstant;
    rany += py*self.yConstant;
    int shouldGenerate = arc4random() % 1000;
    if(shouldGenerate <= 15){
        if(abs(ranx - hero.position.x) >= self.constant/4 || abs(rany - hero.position.y) >= self.constant/4){
            SKNestSprite *newNest = [SKNestSprite spriteNodeWithImageNamed:@"Black Circle.png"];
            [newNest setPosition:CGPointMake(ranx, rany)];
            [newNest setSize:CGSizeMake(self.constant/8, self.constant/8)];
            newNest.constant = self.constant/2;
            [self addChild:newNest];
        }
//        NSLog(@"NEW NEST");
    } else if(shouldGenerate <= 105){
        SKPointSprite *newPoint = [SKPointSprite spriteNodeWithImageNamed:@"Blue Circle.png"];
        [newPoint setPosition:CGPointMake(ranx, rany)];
        [newPoint setSize:CGSizeMake(self.constant/160, self.constant/160)];
        [self addChild:newPoint];
//        NSLog(@"NEW POINT");
    }
}

-(void)gameOver{
    for(SKSpriteNode *node in self.children){
        [node removeFromParent];
    }
    x = 0;
    y = 0;
    dx = 0;
    dy = 0;
    px = 0;
    py = 0;
    hyp = 0;
    self.score = 0;
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.highScore = [self.defaults integerForKey:@"High Score"];
    hero = [SKSpriteNode spriteNodeWithImageNamed:@"Blue Circle.png"];
    [hero setSize:CGSizeMake(20*self.constant/400, 20*self.constant/400)];
    touchPoint = CGPointMake(self.constant/2, self.yConstant/2);
    [hero setPosition:touchPoint];
    [self addChild:hero];
    float ranx = arc4random() % self.constant;
    float rany = arc4random() % self.yConstant;
    nest = [SKNestSprite spriteNodeWithImageNamed:@"Black Circle.png"];
    [nest setPosition:CGPointMake(ranx, rany)];
    [nest setSize:CGSizeMake(self.constant/8, self.constant/8)];
    nest.constant = self.constant/2;
    [self addChild:nest];
    myLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    myLabel.text = @"0, 0";
    myLabel.fontSize = 10;
    CGPoint point = CGPointMake(self.constant/4, self.constant - 20);
    myLabel.position = point;
    [myLabel setFontColor:[UIColor blackColor]];
    [self addChild:myLabel];
    int rannum = arc4random() % 5;
    rannum ++;
    for(int xy = 0; xy < rannum; xy ++){
        float ranx = arc4random() % self.constant;
        float rany = arc4random() % self.yConstant;
        SKNestSprite *nesty = [SKNestSprite spriteNodeWithImageNamed:@"Black Circle.png"];
        [nesty setPosition:CGPointMake(ranx, rany)];
        [nesty setSize:CGSizeMake(self.constant/8, self.constant/8)];
        nesty.constant = self.constant/2;
        [self addChild:nesty];
    }
}

-(void)pause{
    for(SKSpriteNode *child in self.children){
        if(!self.isPaused){
            self.isPaused = YES;
        } else{
            self.isPaused = NO;
        }
    }
}

-(int)returnHighScore{
    return self.highScore;
}
@end
