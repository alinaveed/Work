//
//  JobFormViewController.m
//  WorkingMan
//
//  Created by Ali Naveed on 1/13/13.
//  Copyright (c) 2013 Umer Khan. All rights reserved.
//

#import "JobFormViewController.h"
#import "StartJobViewController.h"
#import "Database.h"

@interface JobFormViewController ()

@end

@implementation JobFormViewController

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
    
     formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
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
    
	// Do any additional setup after loading the view.
}
-(IBAction)BackButton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)startjob{

    if (dbObj==nil) {
        dbObj=[[Database alloc]init];
        
    }
    else{
    
        dbObj=nil;
        dbObj=[[Database alloc]init];

    }
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];


    if([defaults boolForKey:@"isJobInProgress"])
    {
        
        [Helper ShowAlert];
    }
    else{
        
        
      
        if([jobDesc.text length]== 0 || [jobNamefield.text length] == 0)
        {
            NSString *errorName = @"Please Enter all fields";
            [self AlertFunction:errorName];
        }

        else
        {
      
        
        
        Job *jobObj=[[Job alloc]init];
        jobObj.Jobname=jobNamefield.text;
        jobObj.JobDesc=jobDesc.text;
        jobObj.Status=@"Incompleted";
        jobObj.hours=@"";
        jobObj.startTime=[formatter stringFromDate: [NSDate date] ];
        jobObj.endTime=@"";
        
        
        [dbObj addJob:jobObj];
        
        
        
        StartJobViewController *coll = [self.storyboard instantiateViewControllerWithIdentifier:@"startjob"];
        coll.currentJobId=[dbObj getJobCount];
        coll.iscalledFromJob=NO;
        [self.navigationController pushViewController:coll animated:YES];
            
        }
      
    }


 
       

}

-(void)AlertFunction:(NSString *)msg
{
    
    NSString *errorFound = @"";
    NSString *Okbtn = @"OK";
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:errorFound message:msg delegate:self cancelButtonTitle:Okbtn otherButtonTitles:nil];
    
    [alert show];
    
}
-(IBAction)hideBar{
    bar.hidden=YES;
    [jobDesc resignFirstResponder];
    [jobNamefield resignFirstResponder];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    bar.hidden=NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
 
    [textField resignFirstResponder];
	return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView{

    bar.hidden=NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
