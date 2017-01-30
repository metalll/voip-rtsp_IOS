//
//  NSDRootViewController.h
//  kxmovie
//
//  Created by NullStackDev on 25.01.17.
//
//

#import <UIKit/UIKit.h>
#import "Gossip/Gossip.h"
#import "KxMovieViewController.h"

@interface NSDRootViewController : UIViewController<GSAccountDelegate>



@property (strong, nonatomic) IBOutlet UIView *maivView;
@property GSCall * incomingCall;
@property GSAccount * account;
@property (weak, nonatomic) IBOutlet UIView *childVc;



@end
