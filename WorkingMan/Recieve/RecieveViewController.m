//
//  RecieveViewController.m
//  WorkingMan
//
//  Created by AliNaveed on 3/5/13.
//  Copyright (c) 2013 Umer Khan. All rights reserved.
//

#import "RecieveViewController.h"
#import "TagCellWithField.h"
@interface RecieveViewController ()

@end

@implementation RecieveViewController
@synthesize obj,getDatafromDic;
@synthesize  getName,getDesc;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)BackButton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (NSNumber *)getMilliseconds
{
    return [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    dbObj=[[Database alloc]init];
    
    LoadView.hidden = YES;
    myBarForPerhourRate.hidden=YES;

    getDatafromDic = [dbObj pickInsertInvoiceData:obj.JobId];
    receiverName = [getDatafromDic valueForKey:@"Receiver Name"];
    receiverAddress = [getDatafromDic valueForKey:@"Receiver Address"];
    perHourRate = [getDatafromDic valueForKey:@"Per Hour Rate"];
    
    receiverCity = [getDatafromDic valueForKey:@"City"];
    receiverState = [getDatafromDic valueForKey:@"State"];
    receiverZip = [getDatafromDic valueForKey:@"Zip"];

//  pickSignature
//  loadImage
    
    
    myRecInvoice = @[@"Receiver Name",@"Receiver Address",@"Per Hour Rate",@"City",@"State",@"Zip"];
    mySenInvoice = @[@"Sender Name",@"Sender Address",@"City",@"State",@"Zip"];
    
    
    getDataforSign = [dbObj pickSignature:obj.JobId];

    [sendSignImage setImage:[self loadImage:[getDataforSign valueForKey:@"receiverName"]]];
    [sendRecImage setImage:[self loadImage:[getDataforSign valueForKey:@"senderName"]]];
    
    [sendRecImage setBackgroundColor:[UIColor whiteColor]];
    [sendSignImage setBackgroundColor:[UIColor whiteColor]];
    

    cell1ForRec = [[NSMutableArray alloc] init];
    cell1ForSen = [[NSMutableArray alloc] init];

       
    for (int i =0 ; i<[myRecInvoice count]; i++) {
        
        TagCellWithField *cell2;
        cell2 = [[[NSBundle mainBundle] loadNibNamed:@"TagCellWithField" owner:nil options:nil] objectAtIndex:0];
        
        [cell2.captionLabel setText:[myRecInvoice objectAtIndex:i]];
        [cell2.valueField setDelegate:self];
        [cell2.valueField setText:[getDatafromDic valueForKey:[myRecInvoice objectAtIndex:i]]];
        [cell1ForRec addObject:cell2];
    }
    
    Company *mycmp =  [[Company alloc] init];
    mycmp =[dbObj GetCompany];

    for (int i =0 ; i<[mySenInvoice count]; i++) {
        
        TagCellWithField *cell2;
        cell2 = [[[NSBundle mainBundle] loadNibNamed:@"TagCellWithField" owner:nil options:nil] objectAtIndex:0];
        
        [cell2.captionLabel setText:[mySenInvoice objectAtIndex:i]];
        [cell2.valueField setDelegate:self];
        
        if (i==0)
           [cell2.valueField setText:mycmp.name];
        if (i==1)
            [cell2.valueField setText:mycmp.add1];
        if (i==2)
            [cell2.valueField setText:mycmp.fax];
        if (i==3)
            [cell2.valueField setText:mycmp.phone];
        if (i==4)
            [cell2.valueField setText:mycmp.email];

        [cell1ForSen addObject:cell2];
        
    }

    [myTableView reloadData];

    [scroll setContentSize:CGSizeMake(0,500)];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if (textField.tag != 9999) {

        //for sender and rec textfield
        NSString *tagStr = [NSString stringWithFormat:@"%d",textField.tag];
        int section=[[tagStr substringToIndex:1] intValue]-1;
        int row=[[tagStr substringFromIndex:1] intValue]-1;
        [myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];

    }
   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    LoadView.hidden = YES;
    ValueUpDown = 0;
     [self FuncitonForimage];
    
}
-(void)FuncitonForimage
{
    /* dir: the directory where your files are */
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
    [dateFormat setDateFormat:@"ss"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    mystamp = [NSString stringWithFormat:@"%@%@",dateString,[self getMilliseconds]];
    
    NSLog(@"Timestamp with Milliseconds: %@", mystamp);
    
    senderImageName =  [NSString stringWithFormat:@"Sendersignature%@.png",mystamp];
    recImageName =  [NSString stringWithFormat:@"Recsignature%@.png",mystamp];
}

-(IBAction)viewReport{
    
    NSString *paths = [[NSFileManager defaultManager] applicationSupportDirectory];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *filelist= [filemgr directoryContentsAtPath: paths];
    
    int count = [filelist count];

    NSLog (@"paths %@",paths);
    NSLog (@"%d",count);
    NSLog(@"%@",filelist);
    
    //for copy all data of text field in a string from reciver section
    for (int i =0 ; i<[cell1ForRec count]; i++) {
        
        TagCellWithField *cell2 =[cell1ForRec objectAtIndex:i];
        if (i==0) {
            receiverName = cell2.valueField.text;
        }

        if (i==1) {
            receiverAddress = cell2.valueField.text;
        }

        if (i==2) {
            perHourRate = cell2.valueField.text;
        }

        if (i==3) {
            receiverCity = cell2.valueField.text;
        }

        if (i==4) {
            receiverState = cell2.valueField.text;
        }
        if (i==5) {
            receiverZip = cell2.valueField.text;
        }


    
    }
    
    
    if([receiverName length]==0 ||
       [receiverAddress length]==0 ||
       [perHourRate length]==0 ||
       [receiverCity length]==0 ||
       [receiverState length]==0 ||
       [receiverZip length]==0)
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"All fields are required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    else
        if(sendSignImage.image == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Signature sendSignImage" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];

    }
    else if(sendRecImage.image == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Signature sendRecImage" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
        
    else{
        
        
        OperationQueue=[NSOperationQueue new];
        [OperationQueue setMaxConcurrentOperationCount:2];
        
        
        NSString *appSupportPath = [[NSFileManager defaultManager] applicationSupportDirectory];
        
        [UIImagePNGRepresentation(sendSignImage.image) writeToFile:[appSupportPath stringByAppendingPathComponent:senderImageName]
                                                        atomically:YES];
        
        [UIImagePNGRepresentation(sendRecImage.image) writeToFile:[appSupportPath stringByAppendingPathComponent:recImageName]
                                                       atomically:YES];

        
        NSInvocationOperation *invocation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(uploadToImageShack:) object:senderImageName];
        
        NSInvocationOperation *invocation_=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(uploadToImageShack:) object:recImageName];
        
        [OperationQueue addObserver: self forKeyPath: @"operations" options: NSKeyValueObservingOptionNew context: NULL];
        [OperationQueue addOperation:invocation ];
        [OperationQueue addOperation:invocation_];

        
        LoadView.hidden = NO;
        [self.view bringSubviewToFront:LoadView];

       

    }
    
}

-(void)calltoNextClass
{
    InvoiceInformation *info=[[InvoiceInformation alloc] init];
    info.RName=receiverName;
    info.RAddress=receiverAddress;
    info.PerHourRate=perHourRate;
    info.RCity=receiverCity;
    info.RState=receiverState;
    info.RZip=receiverZip;
    
    
    coll = [self.storyboard instantiateViewControllerWithIdentifier:@"Invoice"];
    coll.JobForInvoice=obj;
    coll.InvoiceInformationObject=info;
    
    
    [self resetFieldAndHideKeyboard];
    
    

    
    [dbObj pickInsertInvoiceData:obj.JobId
                      andRecName:info.RName
                   andRecAddress:info.RAddress
                  andPerHourRate:info.PerHourRate
                         andCity:info.RCity
                        andState:info.RState
                          andZip:info.RZip];

    [dbObj add_Signature:obj.JobId andRecSig:recImageName andSenSign:senderImageName];
    
    
    LoadView.hidden = YES;
    
    [self.navigationController pushViewController:coll animated:YES];
}
-(void)resetFieldAndHideKeyboard{
    
    
}


#pragma mark - *** JBSignatureControllerDelegate ***

-(void)signatureConfirmed:(UIImage *)signatureImage signatureController:(JBSignatureController *)sender {
	
	// get image and close signature controller
    
    signatureImage=[ImageHelper image:signatureImage fitInSize:CGSizeMake(250, 100)];
	// Example saving the image in the app's application support directory

    //CREATE TABLE "signTable" ("jobid" VARCHAR, "recsign" VARCHAR, "sendersign" VARCHAR)
    [jbsign clearSignature ];


    if ([self.view.subviews containsObject:senderSign]) {

        [sendSignImage setImage:signatureImage];
        [senderSign removeFromSuperview];
    }

    if ([self.view.subviews containsObject:recSignature]) {
      
     [sendRecImage setImage:signatureImage];
     [recSignature removeFromSuperview];
    }
	
}
-(UIImage*)loadImage:(NSString*)imageName {
    
    NSString *appSupportPath = [[NSFileManager defaultManager] applicationSupportDirectory];
    appSupportPath = [appSupportPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",imageName]];
    return [UIImage imageWithContentsOfFile:appSupportPath];
                                                                             
}
-(IBAction)SenderSignFunction{
    [self.view endEditing:YES];
    sendSign = senderImageName;

    senderSign = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    jbsign=[[JBSignatureController alloc]init];
    jbsign.delegate=self;
    [senderSign addSubview:jbsign.view];
    [self.view addSubview:senderSign];
}
-(IBAction)ReciverSignFunction{
    [self.view endEditing:YES];
    sendSign = recImageName;

    recSignature = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    jbsign=[[JBSignatureController alloc]init];
    jbsign.delegate=self;
    [recSignature addSubview:jbsign.view];
    [self.view addSubview:recSignature];
}
-(void)signatureCancelled:(JBSignatureController *)sender {
	[sender clearSignature];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
   	return YES;
}
-(IBAction)toolBarDone{
    myBarForPerhourRate.hidden = YES;
}

//------------------

///Upload Image

- (void)uploadToImageShack:(NSString *)imgeName {
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.imageshack.us/upload_api.php"]];
    NSString *appSupportPath = [[NSFileManager defaultManager] applicationSupportDirectory];
    appSupportPath = [appSupportPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",imgeName]];

    NSString *stringpwth = [NSString stringWithFormat:@"%@",appSupportPath];
    [request setTimeOutSeconds:500];
    [request setFile:stringpwth forKey:@"fileupload"];
    
    
    [request setPostValue:@"ZM7GW9SF472d89191dedb1693c1b23882df3c29a" forKey:@"key"];
    [request setPostValue:@"json" forKey:@"format"];
    [request setDelegate:self];
    [request startAsynchronous];
    
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    NSString *responseStr = [request responseString];
    SBJSON *jsonParser = [SBJSON new];
    NSMutableDictionary  *resultDict = (NSMutableDictionary*)[jsonParser objectWithString:responseStr error:nil];
    

    NSLog(@"Response :  %@", [[resultDict valueForKey:@"links"]valueForKey:@"image_link"]);
    
    NSString *finalURl = [[resultDict valueForKey:@"links"]valueForKey:@"image_link"];
    
    if ( ValueUpDown == 2) {
        
         [[NSUserDefaults standardUserDefaults] setValue:finalURl forKey:@"recSign"];
         [[NSUserDefaults standardUserDefaults] synchronize];
        
         [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(calltoNextClass) userInfo:nil repeats:NO];
    }
    else
    {
          [[NSUserDefaults standardUserDefaults] setValue:finalURl forKey:@"senderSign"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         ValueUpDown = 2;
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"Request Failed");
    NSLog(@"Request Failed Error : %@", [request.error description]);
}
- (void) observeValueForKeyPath:(NSString *) keyPath ofObject:(id) object change:(NSDictionary *) change context:(void *) context{
       if (object == OperationQueue &&[@"operations" isEqual: keyPath])
           {
                   NSArray *operations = [change objectForKey:NSKeyValueChangeNewKey];
            
                   if ([operations count]==0)
                       {
                            NSLog(@"save to db");
//                           
                       }
               }
}

////------Upload Image

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
            return 2;
    
    if (section == 1 )
        return [myRecInvoice count];
    if (section == 2)
            return [mySenInvoice count];
    
    
    //for time Stamp change to dymanic count
    if (section == 3)
        return 1;

    //for  Part change to dymanic count
    if (section == 4)
        return 1;
    
    if (section == 5)
        return 2;
    
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)  {
            return 85;
        }
    }
    
    if (indexPath.section == 5)
    {
        if (indexPath.row == 0){    return 192;}
    }



    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rid;
    rid = [NSString stringWithFormat: @"%d%d-identifirer",indexPath.row,indexPath.section] ;
    

    UITableViewCell *InvCell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:rid];
    if (InvCell == nil) {
        InvCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid] ;
    }
    [InvCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [InvCell setBackgroundColor:[UIColor clearColor]];
    
   if (indexPath.section == 0)
   {
       if (indexPath.row == 0)  {
           [forJobName setFrame:CGRectMake(5, 0, 320, 44)];
           forjobNameField.text = getName;
           forjobNameField.tag = 9999;
           forjobNameDesc.text = getDesc;
           
           [InvCell addSubview:forJobName];
       }
       else  if (indexPath.row == 1)
       {
           [forJobDesc setFrame:CGRectMake(5, 0, 320, 82)];
           [InvCell addSubview:forJobDesc];
       }
   }
    
   if (indexPath.section == 1 )
    {
           TagCellWithField *cell3 ;
           [cell3 setFrame:CGRectMake(0, 0, 320, 199)];
           cell3 = [cell1ForRec objectAtIndex:indexPath.row];
           cell3.valueField.tag = [[NSString stringWithFormat:@"%d%d",indexPath.section+1,indexPath.row+1] intValue];
           return cell3;
    }

    
   if (indexPath.section == 2)
   {
       TagCellWithField *cell3 ;
       [cell3 setFrame:CGRectMake(0, 0, 320, 199)];
        cell3 = [cell1ForSen objectAtIndex:indexPath.row];
       cell3.valueField.tag = [[NSString stringWithFormat:@"%d%d",indexPath.section+1,indexPath.row+1] intValue];
       return cell3;
   }
    
    //for time stamp
    if (indexPath.section == 3)
    {
    }
    
    //for part
    if (indexPath.section == 4)
    {
    }
    
    if (indexPath.section == 5) {
        if (indexPath.row == 0){
        [forJobSignature setFrame:CGRectMake(5, 0, 290, 189)];
        [InvCell addSubview:forJobSignature];
        }
        else if (indexPath.row == 1)
        {
            [viewInvBtn setFrame:CGRectMake(90, 3, 130, 44)];
            [InvCell addSubview:viewInvBtn];
        }
    }
    

    return InvCell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view  endEditing:YES];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0)
        return @"Job Information";
    if (section == 1)
        return @"Receiver Information";

    if (section == 2)
        return @"Sender Information";

    if (section == 3)
        return @"Parts";

    if (section == 4)
        return @"Time on Job";

    if (section == 5)
        return @"Signature";

    return nil;
    
}
/*
 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:n inSection:0];
 [self.tableView scrollToRowAtIndexPath:indexPath
 atScrollPosition:UITableViewScrollPositionTop
 animated:YES];
 */

///-----
@end
