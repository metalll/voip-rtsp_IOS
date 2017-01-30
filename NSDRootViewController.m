//
//  NSDRootViewController.m
//  kxmovie
//
//  Created by NullStackDev on 25.01.17.
//
//

#import "NSDRootViewController.h"
#import "NSDToast.h"
#import "UIColor+NSDColors.h"
#import "NSDIncomingViewController.h"
@interface NSDRootViewController ()
@property NSDToast * toast ;

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, strong) NSMutableString *communicationLog;
@property (nonatomic) BOOL sentPing;
//@property BOOL * isShowToast;
@end

@implementation NSDRootViewController


-(NSString *)title{
    return @"EiagleEye";
}

-(void)dealloc{
    [_account removeObserver:self forKeyPath:@"status"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"Домофон";

    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setBarTintColor:[UIColor lightBackgroundColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor foregroundColor]}];
    [bar setTintColor:[UIColor foregroundColor]];
    
    self.navigationController.navigationItem.title = @"tit";
    
    int toastMargin = _maivView.frame.size.height-60;
    _toast = [[NSDToast alloc] initWithMargin:toastMargin];
    
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
    
    
    // Do any additional setup after loading the view.
//#pragma mark init account
    GSAccountConfiguration *accountconf = [GSAccountConfiguration defaultConfiguration];
    accountconf.address = @"116";
    accountconf.username = @"116";
    accountconf.password = @"a2D8w4NM";
    accountconf.domain = @"79.135.221.94";
    accountconf.ringbackFilename = @"ringtone.wav";
    
    GSConfiguration *configuration = [GSConfiguration defaultConfiguration];
    configuration.account = accountconf;
    configuration.logLevel = 3;
    configuration.consoleLogLevel = 3;
    
    GSUserAgent *agent = [GSUserAgent sharedAgent];
    [agent configure:configuration];
    [agent start];
    
    
    _account = agent.account;
//#pragma mark add Observer;
    _account.delegate = self;
    [_account addObserver:self
              forKeyPath:@"status"
                 options:NSKeyValueObservingOptionInitial
                 context:nil];
    [self didChangeValueForKey:@"account"];
    
    [_account connect];
    
    
    
    
    //[super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GSAccountDelegate


-(void)account:(GSAccount *)account didReceiveIncomingCall:(GSCall *)call{
    
    
    _incomingCall = nil;
    _incomingCall = call;
    
    NSDIncomingViewController * inc = [self.storyboard instantiateViewControllerWithIdentifier:@"incoming"];
    [inc setIncoming:call];
    

    [self.navigationController pushViewController:inc animated:YES];
    
    
    
    
    
}


#pragma mark Toast + AppWillBeDidEnter + KVO
- (void)statusDidChange {
    switch (_account.status) {
        case GSAccountStatusOffline: {
            
            
            [_toast removeFromView:_maivView];
            [_toast displayOnView:_maivView withMessage:@"Нет подключения!" andColor:[UIColor colorWithRed:0.89 green:0.09 blue:0.09 alpha:1.0] andIndicator:NO andFaded:NO];
            
            
        //    [_statusLabel setText:@"Не подключено!"];
           
        } break;
            
        case GSAccountStatusConnecting: {
            
            
            
            [_toast removeFromView:_maivView];
            [_toast displayOnView:_maivView withMessage:@"Подключение..." andColor:[UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:218.0/255.0 alpha:1.0] andIndicator:YES andFaded:NO];

//            
//            [_statusLabel setText:@"Connecting..."];
//            [_connectButton setEnabled:NO];
//            [_disconnectButton setEnabled:NO];
//            [_makeCallButton setEnabled:NO];
        } break;
            
        case GSAccountStatusConnected: {
            [_toast removeFromView:_maivView];
            [_toast displayOnView:_maivView withMessage:@"Подключено" andColor:[UIColor colorWithRed:0.07 green:0.59 blue:0.02 alpha:1.0] andIndicator:NO andFaded:YES];
        } break;
            
        case GSAccountStatusDisconnecting: {
            [_toast removeFromView:_maivView];
            [_toast displayOnView:_maivView withMessage:@"Отключение..." andColor:[UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:218.0/255.0 alpha:1.0] andIndicator:YES andFaded:NO];
        } break;
            
        case GSAccountStatusInvalid: {
            [_toast removeFromView:_maivView];
            [_toast displayOnView:_maivView withMessage:@"Ошибка авторизации!" andColor:[UIColor colorWithRed:0.89 green:0.09 blue:0.09 alpha:1.0] andIndicator:NO andFaded:NO];
        } break;
    }
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"status"])
        [self statusDidChange];
}




- (void)addEvent:(NSString *)event
{
  //  [self.communicationLog appendFormat:@"%@\n", event];
    if (UIApplication.sharedApplication.applicationState == UIApplicationStateActive)
    {
      //  self.txtReceivedData.text = self.communicationLog;
    }
    else
    {
        NSLog(@"App is backgrounded. New event: %@", event);
    }
}





- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventNone:
            // do nothing.
            break;
            
        case NSStreamEventEndEncountered:
            [self addEvent:@"Connection Closed"];
            break;
            
        case NSStreamEventErrorOccurred:
            [self addEvent:[NSString stringWithFormat:@"Had error: %@", aStream.streamError]];
            break;
            
        case NSStreamEventHasBytesAvailable:
            if (aStream == self.inputStream)
            {
                uint8_t buffer[1024];
                NSInteger bytesRead = [self.inputStream read:buffer maxLength:1024];
                NSString *stringRead = [[NSString alloc] initWithBytes:buffer length:bytesRead encoding:NSUTF8StringEncoding];
                stringRead = [stringRead stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                
                [self addEvent:[NSString stringWithFormat:@"Received: %@", stringRead]];
                
                if ([stringRead isEqualToString:@"notify"])
                {
                    UILocalNotification *notification = [[UILocalNotification alloc] init];
                    notification.alertBody = @"New VOIP call";
                    notification.alertAction = @"Answer";
                    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
                }
                else if ([stringRead isEqualToString:@"ping"])
                {
                //    [self.outputStream write:pongString maxLength:strlen((char*)pongString)];
                }
            }
            break;
            
        case NSStreamEventHasSpaceAvailable:
            if (aStream == self.outputStream && !self.sentPing)
            {
                self.sentPing = YES;
                if (aStream == self.outputStream)
                {
               //     [self.outputStream write:pingString maxLength:strlen((char*)pingString)];
                    [self addEvent:@"Ping sent"];
                }
            }
            break;
            
        case NSStreamEventOpenCompleted:
            if (aStream == self.inputStream)
            {
                [self addEvent:@"Connection Opened"];
            }
            break;
            
        default:
            break;
    }
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
