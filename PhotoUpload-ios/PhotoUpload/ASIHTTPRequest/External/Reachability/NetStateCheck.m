//
//  NetStateCheck.m
//  economicInfo
//
//  Created by gurdjieff on 12-12-4.
//
//

#import "NetStateCheck.h"

static NetStateCheck * NetStateInstance = nil;
@implementation NetStateCheck

- (BOOL)updateInterfaceWithReachability
{
    NetworkStatus lpNetstatus=[mpHostReach currentReachabilityStatus];
    if(lpNetstatus == NotReachable) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                      message:NSLocalizedString(@"网络故障，请检查你的网络是否可用", nil)
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        [alert show];
        [alert release];
        return NO;
    }
    
    return YES;
}

- (void) netStateChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability];
}

-(void)initNetStateCheck
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(netStateChanged:)
                                                 name: @"NetworkReachabilityChangedNotification"
                                               object: nil];
    //	mpHostReach = [[Reachability reachabilityWithHostName:@"192.168.123.44"] retain];
    mpHostReach = [[Reachability reachabilityWithHostName:@"www.baidu.com"] retain];
	[mpHostReach startNotifier];
}

-(id)init
{
    if ((self = [super init])) {
        [self initNetStateCheck];
    }
    return self;
}

+(id)shareNetStateCheck
{
    if (NetStateInstance == nil) {
        NetStateInstance = [[NetStateCheck alloc] init];
    }
    return NetStateInstance;
}

+(void)initNetState
{
    [self shareNetStateCheck];
}

+(BOOL)checkNetWorkState
{
    return [[NetStateCheck shareNetStateCheck] updateInterfaceWithReachability];
}

-(void)dealloc
{
    [mpHostReach release], mpHostReach = nil;
    [super dealloc];
}

@end
