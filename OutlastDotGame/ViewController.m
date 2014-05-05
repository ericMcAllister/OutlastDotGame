//
//  ViewController.m
//  OutlastDotGame
//
//  Created by Eric Mcallister on 29/04/2014.
//  Copyright (c) 2014 ERIC. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize pauseButton, twButton, fbButton;

- (void)viewDidLoad{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    skView.backgroundColor = [UIColor whiteColor];
    
    // Create and configure the scene.
    scene = [[MyScene alloc] initWithSize:skView.frame.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.backgroundColor = [UIColor whiteColor];
    
    // Present the scene.
    [skView presentScene:scene];
    self.pauseButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.height*7/8, self.view.frame.size.width/8, self.view.frame.size.height/10, self.view.frame.size.height/10)];
    [self.pauseButton setBackgroundImage:[UIImage imageNamed:@"Blue Circle"] forState:UIControlStateNormal];
    [self.pauseButton addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.pauseButton];
    self.twButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.height/3, self.view.frame.size.width/2, self.view.frame.size.height/10, self.view.frame.size.height/10)];
    [self.twButton setBackgroundImage:[UIImage imageNamed:@"Blue Circle"] forState:UIControlStateNormal];
    [self.twButton addTarget:self action:@selector(shareTw) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.twButton];
    self.fbButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.height*2/3, self.view.frame.size.width/2, self.view.frame.size.height/10, self.view.frame.size.height/10)];
    [self.fbButton setBackgroundImage:[UIImage imageNamed:@"Blue Circle"] forState:UIControlStateNormal];
    [self.fbButton addTarget:self action:@selector(shareFb) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.fbButton];
    [self.fbButton setHidden:YES];
    [self.twButton setHidden:YES];
    [self.fbButton setEnabled:NO];
    [self.fbButton setEnabled:NO];
}

-(IBAction)pause{
    [scene pause];
    if(self.twButton.isHidden){
        [self.fbButton setHidden:NO];
        [self.twButton setHidden:NO];
        [self.fbButton setEnabled:YES];
        [self.fbButton setEnabled:YES];
    } else{
        [self.fbButton setHidden:YES];
        [self.twButton setHidden:YES];
        [self.fbButton setEnabled:NO];
        [self.fbButton setEnabled:NO];
    }
}

-(IBAction)shareTw{
    int high = [scene returnHighScore];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Yes! %i! #outlast", high]];
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                default:
                    break;
            }
        }];
        [self presentViewController:mySLComposerSheet animated:YES completion:^(){
        }];
    }
}

-(IBAction)shareFb{
    int high = [scene returnHighScore];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Yes! %i! #outlast", high]];
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                default:
                    break;
            }
        }];
        [self presentViewController:mySLComposerSheet animated:YES completion:^(){
        }];
    }
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
