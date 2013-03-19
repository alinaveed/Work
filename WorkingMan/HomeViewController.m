//
//  HomeViewController.m
//  WorkingMan
//
//  Created by Umer Khan on 12/12/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import "HomeViewController.h"
#import "StartJobViewController.h"
#import "JobFormViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appdelegate=[[UIApplication sharedApplication]delegate];
    //navBar = [[self navigationController] navigationBar];
    //UIImage *backgroundImage = [UIImage imageNamed:@"top-bar@2x.png"];
    //[navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            [bckImge setFrame:CGRectMake(0, 0, 320, 480)];
        }
        if(result.height == 568)
        {
            [bckImge setFrame:CGRectMake(0, 0, 320, 568)];
        }
    }
 
    NSLog(@"Home---");
	// Do any additional setup after loading the view.
}






-(IBAction)job
{
    NSDictionary *itemDetails = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"HelpTopic", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HotSpotTouched" object:nil userInfo:itemDetails];
    [self.tabBarController setSelectedIndex:1];
}

-(IBAction)report
{
    NSDictionary *itemDetails = [[NSDictionary alloc] initWithObjectsAndKeys:@"2", @"HelpTopic", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HotSpotTouched" object:nil userInfo:itemDetails];

    [self.tabBarController setSelectedIndex:2];
}

-(IBAction)inventory
{
    NSDictionary *itemDetails = [[NSDictionary alloc] initWithObjectsAndKeys:@"3", @"HelpTopic", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HotSpotTouched" object:nil userInfo:itemDetails];

    [self.tabBarController setSelectedIndex:3];
}

-(IBAction)pickup
{
    NSDictionary *itemDetails = [[NSDictionary alloc] initWithObjectsAndKeys:@"4", @"HelpTopic", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HotSpotTouched" object:nil userInfo:itemDetails];

    [self.tabBarController setSelectedIndex:4];
}

-(IBAction)help
{
    NSDictionary *itemDetails = [[NSDictionary alloc] initWithObjectsAndKeys:@"5", @"HelpTopic", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HotSpotTouched" object:nil userInfo:itemDetails];

    [self.tabBarController setSelectedIndex:5];
}

-(IBAction)StartaNewJob{

    
    if([appdelegate.IsJobInProgress isEqualToString:@"1"])
    {
        
        [Helper ShowAlert];
    }

    else{
    
    JobFormViewController *coll = [self.storyboard instantiateViewControllerWithIdentifier:@"JobForm"];
    [self.navigationController pushViewController:coll animated:YES];
    }

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
