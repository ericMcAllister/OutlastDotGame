//
//  ViewController.h
//  OutlastDotGame
//

//  Copyright (c) 2014 ERIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>
#import <Social/Social.h>
#import "MyScene.h"

@interface ViewController : UIViewController{
    MyScene *scene;
}
-(IBAction)pause;
-(IBAction)shareTw;
-(IBAction)shareFb;
@property (nonatomic, retain) UIButton *pauseButton, *twButton, *fbButton;

@end
