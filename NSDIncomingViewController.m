//
//  NSDIncomingViewController.m
//  kxmovie
//
//  Created by NullStackDev on 26.01.17.
//
//

#import "NSDIncomingViewController.h"

@interface NSDIncomingViewController ()

@end

@implementation NSDIncomingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // NSError *error;
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"iphone"
                                         ofType:@"mp3"]];
    self.audioPlayer = [[AVPlayer alloc] initWithURL:url];
    [_audioPlayer play];

    
    
    KxMovieViewController *vc;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //  parameters[KxMovieParameterMinBufferedDuration] = @(5.0);
    parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
    
    //rtsp://192.168.10.95:555/Streaming/Channels/102/
    vc = [KxMovieViewController movieViewControllerWithContentPath:@"rtsp://192.168.10.95:555/Streaming/Channels/102/"	 parameters:parameters];
    // [self presentViewController:vc animated:YES completion:nil];
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(0, 0, self.childVc.frame.size.width, self.childVc.frame.size.height);
    [self.childVc addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    //
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"Звонок";
    

    
    
    UITapGestureRecognizer *singleTapCall = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedCall)];
    singleTapCall.numberOfTapsRequired = 1;
    [_call setUserInteractionEnabled:YES];
    [_call addGestureRecognizer:singleTapCall];
    
    
    UITapGestureRecognizer *singleTapDrop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedDrop)];
    singleTapDrop.numberOfTapsRequired = 1;
    [_drop setUserInteractionEnabled:YES];
    [_drop addGestureRecognizer:singleTapDrop];
    
    
    UITapGestureRecognizer *singleTapKey = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedKey)];
    singleTapDrop.numberOfTapsRequired = 1;
    [_key setUserInteractionEnabled:YES];
    [_key addGestureRecognizer:singleTapKey];
    
    [self callStatusDidChange];
    
    
    
    
    // Do any additional setup after loading the view.
}

-(void)tapDetectedDrop{
    static BOOL tapped = NO;
    
    if(!tapped){
        
        [[_incoming account] disconnect];
        [[_incoming account] connect];
        
        
    [_incoming end];
        [self.navigationController popToRootViewControllerAnimated:YES];
        tapped = YES;
    }
}

-(void)tapDetectedCall{
    static BOOL tapped = NO;
    if(!tapped){
    if(_audioPlayer){
        [_audioPlayer pause];
        _audioPlayer = nil;
    }
    // begin calling after 1s
    const double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    __block GSCall *call_ = _incoming;
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [call_ begin];
         tapped = YES;
    });
       
    }
   
}


-(void)tapDetectedKey{
   // [_incoming sendDTMFDigits:0];
    [_incoming sendDTMFDigits:@"0"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setIncoming:(GSCall *)incoming{
    
    [self willChangeValueForKey:@"call"];
    [_call removeObserver:self forKeyPath:@"status"];
    _incoming = incoming;
    [_call addObserver:self
            forKeyPath:@"status"
               options:NSKeyValueObservingOptionInitial
               context:nil];
    [self didChangeValueForKey:@"call"];

}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"status"])
        [self callStatusDidChange];
}


- (void)callStatusDidChange {
    switch (_incoming.status) {
        case GSCallStatusReady: {
            //[_statusLabel setText:@"Ready."];
           // [_hangupButton setEnabled:NO];
        } break;
            
        case GSCallStatusConnecting: {
       //     [_statusLabel setText:@"Connecting..."];
        //    [_hangupButton setEnabled:NO];
        } break;
            
        case GSCallStatusCalling: {
         //   [_statusLabel setText:@"Calling..."];
          //  [_hangupButton setEnabled:YES];
        } break;
            
        case GSCallStatusConnected: {
          //  [_statusLabel setText:@"Connected."];
          //  [_hangupButton setEnabled:YES];
        } break;
            
        case GSCallStatusDisconnected: {
          //  [_statusLabel setText:@"Disconnected."];
          //  [_hangupButton setEnabled:YES];
            if(_audioPlayer){
            [_audioPlayer pause];
            _audioPlayer = nil;
            }
            
            
            //[[_incoming account] disconnect];
            //[[_incoming account] connect];
            
            
            
            // pop view after 2s
            const double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            
            __block id self_ = self;
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [[self_ navigationController] popToRootViewControllerAnimated:YES];

            });
        } break;
    }
}


-(void)dealloc{
    
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
