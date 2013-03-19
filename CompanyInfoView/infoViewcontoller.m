//
//  infoViewcontoller.m
//  invoiveBuddy
//
//  Created by imranhashmi on 1/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "infoViewcontoller.h"
#import "Database.h"
#import "AppDelegate.h"
//#import "ContactVIewController.h"
#import "Company.h"

@implementation infoViewcontoller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.navigationItem setTitle:@"Company Details"];

    
    [scroll_view setContentSize:CGSizeMake(320, 450)];
    appDelegate=[[UIApplication sharedApplication]delegate];
   // appDelegate.company_infor_array=[[NSMutableArray alloc]init];
    
    
        
    
//    Database *db_obj=[[Database alloc]init];
    //appDelegate.company_infor_array=[db_obj GetCompany];
   // NSLog(@"db mai kia hai %@",[db_obj GetCompany]);
    
    defaults=[NSUserDefaults standardUserDefaults];
       //if([defaults boolForKey:@"first time"] ==YES )
    if([[defaults valueForKey:@"company"] isEqualToString:@"YES"])
    {
        NSLog(@"default YES hai");
        UINavigationController *ob = [self.storyboard instantiateViewControllerWithIdentifier:@"TabView"];
        [self.navigationController pushViewController:ob animated:YES];
    }
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:email];
}

-(IBAction)next{
    
    [name becomeFirstResponder];
    

    if([name.text isEqualToString:@""]||[zip.text isEqualToString:@""] || [address.text isEqualToString:@""]|| [city.text isEqualToString:@""] ||[state.text isEqualToString:@""] )
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Name,address,city,state and zip must be entered" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else{

            [self inser_into_db];
    }

}
-(void)inser_into_db{

// name    == name
// address == add1
// city    == fax
// state   == phone
// zip     == email
    
    Company *comp_class=[[Company alloc]init];
    comp_class.name=name.text;
    comp_class.add1=address.text;
    comp_class.phone =  state.text;
    comp_class.fax= city.text;
    comp_class.email=zip.text;
    comp_class.add2= @"add2";
    comp_class.country=@"United States";
    comp_class.cell =  @"Cell";

    
    
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"company"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    Database *db_obj=[[Database alloc]init];
    [db_obj add_company:comp_class];

    UINavigationController *ob = [self.storyboard instantiateViewControllerWithIdentifier:@"TabView"];
    
    [self.navigationController pushViewController:ob animated:YES];

}
-(IBAction)hide{

    


}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
	if([textField isEqual:zip]){
		[scroll_view setContentOffset:CGPointMake(0,40) animated:YES];
	}
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if([textField isEqual:name]){
        [address becomeFirstResponder];
				
	}
    if([textField isEqual:address]){
        [city becomeFirstResponder];
		
	}
    
    if([textField isEqual:city]){
        [state becomeFirstResponder];
		
		
	}
    if([textField isEqual:state]){
        [zip becomeFirstResponder];
	}

    if([textField isEqual:zip]){
        
        [zip resignFirstResponder];
        [scroll_view setContentOffset:CGPointMake(0,0) animated:YES];
	}


   
   	return NO;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
   // return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
