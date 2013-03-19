//
//  JobViewController.m
//  WorkingMan
//
//  Created by Umer Khan on 12/12/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import "JobViewController.h"
#import "StartJobViewController.h"
#import "InvoiceViewController.h"
#import "RecieveViewController.h"
@interface JobViewController ()

@end

@implementation JobViewController

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
   

    dbObj=[[Database alloc]init];
    jobsArray=[[NSMutableArray alloc]init];
    jobsArray=[dbObj getJobList];
     NSLog(@"Job---%@",jobsArray);
    appDelegate =[[UIApplication sharedApplication]delegate];
    
    myBarForPerhourRate.hidden=YES;
    
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

-(void)viewWillAppear:(BOOL)animated{

    if([jobsArray count]>0)
    {
    
        [jobsArray removeAllObjects];
    }
    jobsArray=[dbObj getJobList];
    [jobsTable reloadData];

}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([jobsArray count]>0) {
        return  [jobsArray count];
        
    }
    else
        return 0;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    NSString *rid;
    rid = [NSString stringWithFormat: @"%d%d%@",indexPath.row,indexPath.section,jobsArray] ;
    
    UITableViewCell *cell ;
    JobCell *InvCell=(JobCell*)[tableView dequeueReusableCellWithIdentifier:rid];
    
    
    if (InvCell == nil) {
        InvCell = [[JobCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid] ;
    }
    [InvCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [InvCell setBackgroundColor:[UIColor clearColor]];
    
    
    Job *obj=[jobsArray objectAtIndex:indexPath.row];
    InvCell.lblName.text=obj.Jobname;
    InvCell.lblStatus.text=obj.Status;
   
    cell=InvCell;
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    obj_=[jobsArray objectAtIndex:indexPath.row];
    
    NSLog(@"job status %@",obj_.Status);
    if([obj_.Status isEqualToString:@"Incompleted"] )
    {
    
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        
        
        if([defaults boolForKey:@"isJobInProgress"])
        {
        
            [Helper ShowAlert];
        }
        else{
        
            //start a incompleted job
            StartJobViewController *coll4 = [self.storyboard instantiateViewControllerWithIdentifier:@"startjob"];
            coll4.currentJobId=[obj_.JobId intValue];
            coll4.iscalledFromJob=YES;
            [self.navigationController pushViewController:coll4 animated:YES];
        }
    }
    
    else {
          //push to invoice
       
        NSMutableDictionary *getDatafromDic = [dbObj pickInsertInvoiceData:obj_.JobId];
       /* receiverName.text = [getDatafromDic valueForKey:@"receiverName"];
        receiverAddress.text = [getDatafromDic valueForKey:@"receiverAddress"];
        perHourRate.text = [getDatafromDic valueForKey:@"PerHourRate"];
        
        receiverCity.text = [getDatafromDic valueForKey:@"city"];
        receiverState.text = [getDatafromDic valueForKey:@"state"];
        receiverZip.text = [getDatafromDic valueForKey:@"zip"];
        [popView setHidden:NO];
        */
        
            obj_=[jobsArray objectAtIndex:indexPath.row];
            
            RecieveViewController *coll3 = [self.storyboard instantiateViewControllerWithIdentifier:@"ReViewCon"];
            coll3.obj=obj_;
            coll3.getDatafromDic = getDatafromDic;
        
        //for Editing need a job name and desc
        
            Job *obj=[jobsArray objectAtIndex:indexPath.row];
            coll3.getName =obj.Jobname;
            coll3.getDesc =obj.JobDesc;
        
            [self.navigationController pushViewController:coll3 animated:YES];
       
    }
    
}


-(IBAction)hidePopUp{
    
    
    [self resetFieldAndHideKeyboard];
    [popView setHidden:YES];
    
    
}

-(IBAction)viewReport
{
    
    if([receiverAddress.text length]==0 || [receiverCity.text length]==0 || [receiverName.text length]==0 || [perHourRate.text length]==0 || [receiverAddress.text length]==0 || [receiverState.text length]==0 || [receiverZip.text length]==0)
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"All fields are required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        
        
    }
    else{
        
        InvoiceInformation *info=[[InvoiceInformation alloc] init];
        info.RName=receiverName.text;
        info.RAddress=receiverAddress.text;
        info.PerHourRate=perHourRate.text;
        info.RCity=receiverCity.text;
        info.RState=receiverState.text;
        info.RZip=receiverZip.text;
        
        coll = [self.storyboard instantiateViewControllerWithIdentifier:@"Invoice"];
        coll.JobForInvoice=obj_;
        coll.InvoiceInformationObject=info;
        
        
        
        [popView setHidden:YES];
        [self resetFieldAndHideKeyboard];
        
        
        [dbObj pickInsertInvoiceData:obj_.JobId andRecName:info.RName andRecAddress:info.RAddress andPerHourRate:info.PerHourRate andCity:info.RCity andState:info.RState andZip:info.RZip];
        
        
        jbsign=[[JBSignatureController alloc]init];
        jbsign.delegate=self;
        [self.view addSubview:jbsign.view];

        
        
    }
}

-(void)resetFieldAndHideKeyboard{
    
    
    receiverAddress.text=@"";
    receiverName.text=@"";
    perHourRate.text=@"";
    
    receiverCity.text=@"";
    receiverState.text=@"";
    receiverZip.text=@"";
    
    
    [receiverAddress resignFirstResponder];
    [receiverCity resignFirstResponder];
    [receiverName resignFirstResponder];
    [perHourRate resignFirstResponder];
    
    [receiverCity resignFirstResponder];
    [receiverState resignFirstResponder];
    [receiverZip resignFirstResponder];
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if([textField isEqual:perHourRate]){
        myBarForPerhourRate.hidden=NO;
        [perHourRate becomeFirstResponder];
	}
    
    if(   [textField isEqual:receiverCity]
       || [textField isEqual:receiverState]
       || [textField isEqual:receiverZip])
    {
    	[scroll setContentOffset:CGPointMake(0,60) animated:YES];
    }
    else
    {
        [scroll setContentOffset:CGPointMake(0,0) animated:YES];
    }
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if([textField isEqual:receiverName]){
        [receiverAddress becomeFirstResponder];
        
	}
    if([textField isEqual:receiverAddress]){
        myBarForPerhourRate.hidden=NO;
        [perHourRate becomeFirstResponder];
	}
    
    if([textField isEqual:receiverCity]){
        [receiverState becomeFirstResponder];
	}
    
    if([textField isEqual:receiverState]){
        [receiverZip becomeFirstResponder];
	}
    
    if([textField isEqual:receiverZip]){
        [receiverZip resignFirstResponder];
        [scroll setContentOffset:CGPointMake(0,0) animated:YES];
	}
    
    
   	return NO;
}

#pragma mark - *** JBSignatureControllerDelegate ***

/**
 * Example usage of signatureConfirmed:signatureController:
 * @author Jesse Bunch
 **/
-(void)signatureConfirmed:(UIImage *)signatureImage signatureController:(JBSignatureController *)sender {
	
	// get image and close signature controller
	
    //	// I replaced the view just to show it works...
    //	UIImageView *imageview = [[UIImageView alloc] initWithImage:signatureImage];
    //	[imageview setContentMode:UIViewContentModeCenter];
    //	[imageview sizeToFit];
    //	[imageview setTransform:sender.view.transform];
    //	sender.view = imageview;
	
    
    signatureImage=[ImageHelper image:signatureImage fitInSize:CGSizeMake(250, 100)];
	// Example saving the image in the app's application support directory
	NSString *appSupportPath = [[NSFileManager defaultManager] applicationSupportDirectory];
    
	[UIImagePNGRepresentation(signatureImage) writeToFile:[appSupportPath stringByAppendingPathComponent:@"signature.png"] atomically:YES];
	
    
    NSLog(@"path %@",[appSupportPath stringByAppendingPathComponent:@"signature.png"]);
    [jbsign clearSignature ];
    [jbsign.view removeFromSuperview];
    [self.navigationController pushViewController:coll animated:YES];
    
    
	
}

/**
 * Example usage of signatureCancelled:
 * @author Jesse Bunch
 **/
-(void)signatureCancelled:(JBSignatureController *)sender {
	
	// close signature controller
	
	// Clear the sig for now
	[sender clearSignature];
	
}



-(IBAction)toolBarDone
{
    myBarForPerhourRate.hidden = YES;
    [perHourRate resignFirstResponder];
    [receiverCity becomeFirstResponder];
}



-(IBAction)IncompleteJob
{
    StartJobViewController *coll_ = [self.storyboard instantiateViewControllerWithIdentifier:@"startjob"];
    [self.navigationController pushViewController:coll_ animated:YES];
}
-(IBAction)EndJob
{
    InvoiceViewController *coll_ = [self.storyboard instantiateViewControllerWithIdentifier:@"Invoice"];
    [self.navigationController pushViewController:coll_ animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
