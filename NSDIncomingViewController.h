//
//  NSDIncomingViewController.h
//  kxmovie
//
//  Created by NullStackDev on 26.01.17.
//
//

#import <UIKit/UIKit.h>

#import "NSDRootViewController.h"
#import "Gossip/Gossip.h"
#import "AVFoundation/AVPlayer.h"
@interface NSDIncomingViewController : UIViewController
@property (strong,nonatomic) GSCall * incoming;

@property (weak, nonatomic) IBOutlet UIView *childVc;
@property (weak, nonatomic) IBOutlet UIImageView *call;
@property(strong,nonatomic) AVPlayer *audioPlayer ;
@property (weak, nonatomic) IBOutlet UIImageView *key;
@property (weak, nonatomic) IBOutlet UIImageView *drop;
@property (weak, nonatomic) IBOutlet UIImageView *write;
@property (weak, nonatomic) IBOutlet UIImageView *redirect;

@property (weak, nonatomic) IBOutlet UIImageView *snarpshot;
@end
