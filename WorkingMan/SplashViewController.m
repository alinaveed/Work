#import "SplashViewController.h"
#import "infoViewcontoller.h"
@interface SplashViewController ()

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}
/*
-(void)LoadTab
{
    UINavigationController *ob = [self.storyboard instantiateViewControllerWithIdentifier:@"TabView"];
    [self.navigationController pushViewController:ob animated:YES];
}*/

-(void)LoadTab
{
    
    infoViewcontoller *coll = [self.storyboard instantiateViewControllerWithIdentifier:@"infoView"];
    
    [self.navigationController pushViewController:coll animated:YES];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            [bckImge setFrame:CGRectMake(0, 0, 320, 480)];
        }
        if(result.height == 568)
        {
           [bckImge setImage:[UIImage imageNamed:@"Default-568h@2x.png"]];
           [bckImge setFrame:CGRectMake(0, 0, 320, 568)];
        }
    }
    
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(LoadTab) userInfo:nil repeats:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
