//
//  SearchInventoryViewController.m
//  WorkingMan
//
//  Created by Umer Khan on 12/13/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import "SearchInventoryViewController.h"
#import "InventoryClass.h"
#import "Database.h"
#import "CateogryClass.h"
@interface SearchInventoryViewController ()

@end

@implementation SearchInventoryViewController

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
    
    NSString *dbPath;
    NSFileManager *filemgr=[NSFileManager defaultManager];
    NSArray *docspaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsdir=[docspaths objectAtIndex:0];
    dbPath=[docsdir stringByAppendingPathComponent:@"Workbook1.csv"];
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath ] stringByAppendingPathComponent:@"Workbook1.csv"];
    [filemgr copyItemAtPath:databasePathFromApp toPath:dbPath error:nil];
    
    
    
    jpegFiles = [[NSMutableArray alloc] init];
    [self listofCSVfile];
    
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
            [upDateBtn setFrame:CGRectMake(103, 450, 112, 31)];
            
            [TableforCsvListinDocDirectory setFrame:CGRectMake(0, 79, 320, 395)];
        }
    }
	// Do any additional setup after loading the view.
}
-(IBAction)BackButton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)InsertDataFromCSVtoDataBase
{
    
    if (indxPath!=nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        //        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Workbook1" ofType:@"csv"];
        NSString* fileContent = [NSString stringWithFormat:@"%@/%@",documentsDirectory,[jpegFiles objectAtIndex:indxPath.row]];
        NSString* fileContents = [NSString stringWithContentsOfFile:fileContent
                                                           encoding:NSUTF8StringEncoding
                                                              error:NULL];
        
        NSArray* pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
//        NSLog(@"%@",pointStrings);
//        NSLog(@"arr %d ",[pointStrings count]);
        
        Database *db=[[Database alloc]init];
        BOOL checkCsvCount = NO;

        for(int idx = 0; idx < pointStrings.count; idx++)
        {
            // break the string down even further to the columns
            NSString* currentPointString = [pointStrings objectAtIndex:idx];
            NSArray* arr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
//            NSLog(@"count %d",[arr count]);
            
            if ([arr count] < 6) {
                checkCsvCount = YES;
            }
        }

        if (!checkCsvCount) {
            
        
        for(int idx = 0; idx < pointStrings.count; idx++)
        {
            // break the string down even further to the columns
            NSString* currentPointString = [pointStrings objectAtIndex:idx];
            NSArray* arr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
            
            
            NSLog(@"arr %d ",[arr count]);
            
            NSString *nameValue =   [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:0]];
            NSString *Quantity = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:1]];
            NSString *Price =    [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:2]];
            NSString *MaintainenceLevel =     [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:3]];
            NSString *Cat =    [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:4]];
            NSString *SubCat =    [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:5]];
            NSString *MarkUp =    [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:6]];
            NSLog(@" %@  %@ %@ %@ %@ %@",nameValue,Quantity,Price,MaintainenceLevel,Cat,SubCat);
            
            InventoryClass *invt_obj=[[InventoryClass alloc]init];
            invt_obj.Name=nameValue;
            invt_obj.Quantity=Quantity;
            invt_obj.Price=Price;
            invt_obj.maintenanceLevel=MaintainenceLevel;
            invt_obj.Category=Cat;
            invt_obj.SubCategory=SubCat;
            invt_obj.MarkUp = MarkUp;
            
            [self insertCateandSubCate:Cat withSubCate:SubCat];
            
            [db addInventory:invt_obj];
            
            
            
        }

        NSString *nameandEMail = @"Your File Sucessfully Import";
        
        UIAlertView *prompt;
        prompt = [[UIAlertView alloc] initWithTitle:nameandEMail
                                            message:@"" // IMPORTANT
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        prompt.tag = 889;
        
        [prompt show];
    }
        else
        {
            NSString *nameandEMail = @"Please Check CSV Format To Import";
            
            UIAlertView *prompt;
            prompt = [[UIAlertView alloc] initWithTitle:nameandEMail
                                                message:@"" // IMPORTANT
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            
            [prompt show];
        }
    }
    else
    {
        NSString *nameandEMail = @"Please Select File To Import";
        
        UIAlertView *prompt;
        prompt = [[UIAlertView alloc] initWithTitle:nameandEMail
                                            message:@"" // IMPORTANT
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        
        [prompt show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 889) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    }
    
    
}

-(void)insertCateandSubCate:(NSString *)Cat withSubCate:(NSString *)SubCat
{
    
    Database *db=[[Database alloc]init];
    
    NSMutableArray  *pickerArray= [[db getCategory] copy];
    BOOL Match = NO;
    
    CateogryClass *Test_obj= [[CateogryClass alloc] init];
    
    for (int i =0; i<[pickerArray count]; i++) {
        
        CateogryClass *invent_obj= [[CateogryClass alloc] init];
        
        invent_obj =[pickerArray objectAtIndex:i];
        
        NSLog(@" CatName %@",invent_obj.CatName);
        NSLog(@" Cat %@",Cat);
        
        NSString *Catname =invent_obj.CatName;
        NSString *MatchCate  = Cat;
        
        Catname = [Catname uppercaseString];
        MatchCate = [MatchCate uppercaseString];
        
        if ([Catname isEqualToString:MatchCate])
        {
            Match = YES;
            Test_obj = invent_obj;
            break;
        }
        
    }
    
    if (!Match) {
        [db addCategory:Cat];
    }
    else
    {
        //            update
        NSArray *matchArray = Test_obj.subCategories;
        
        BOOL forcheckSubCate = YES;
        
        for (int j =0 ; j < [matchArray count]; j++) {
            
            NSString *SubCatname =[matchArray objectAtIndex:j];
            NSString *SubMatchCate  = SubCat;
            
            SubCatname = [SubCatname uppercaseString];
            SubMatchCate = [SubMatchCate uppercaseString];
            
            
            NSLog(@" SubCatname %@",SubCatname);
            NSLog(@" SubMatchCate %@",SubMatchCate);
            
            if (![SubCatname isEqualToString:SubMatchCate]){ // nothing
                forcheckSubCate = NO;
                break;
            }
            
        }
        
        if (!forcheckSubCate) {
            
            NSMutableArray *mysss = [[NSMutableArray alloc] initWithArray:Test_obj.subCategories];
            [mysss addObject:SubCat];
            
            
            for(int j = 0; j < [mysss count]; j++){
                for( int k = j+1;k < [mysss count];k++){
                    NSString *str1 = [mysss objectAtIndex:j];
                    NSString *str2 = [mysss objectAtIndex:k];
                    if([str1 isEqualToString:str2])
                        [mysss removeObjectAtIndex:k];
                }
            }
            
            NSString *myString = [mysss componentsJoinedByString:@","];
            [db updateSubCategories:myString andCatID:Test_obj.CatId];
            
        }
        
    }
    
    
    
}

-(void)listofCSVfile
{
    NSString *extension = @"csv";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    
    NSLog(@"documentsDirectory %@",contents);
    
    jpegFiles = [NSMutableArray arrayWithCapacity: [contents count]];
    NSString *filename;
    for (filename in contents)
    {
        if ([[filename pathExtension] isEqualToString:extension])
        {
            [jpegFiles addObject: filename];
        }
    }
    //Now the array \"jpegFiles\" contains a list of pathnames to all the images in the documents directory.
    //You could then do this:
    
    NSLog(@"jpegFiles %@",jpegFiles);
    /*    NSMutableArray *images = [NSMutableArray arrayWithCapacity: [jpegFiles count]];
     for (filename in jpegFiles)
     {
     UIImage *image = [UIImage imageWithContentsOfFile: filename];
     [images addObject image];
     }
     */
    
}


#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [jpegFiles count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
//--

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rid;
    rid = [NSString stringWithFormat: @"%d%d",indexPath.row,indexPath.section] ;
    
    UITableViewCell *InvCell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:rid];
    
    
    if (InvCell == nil) {
        InvCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid] ;
    }
    [InvCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [InvCell setBackgroundColor:[UIColor clearColor]];
    
	
	
	UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(10,15, 320, 20)];
	lblTitle.font = [UIFont fontWithName:@"Helvetica" size:12.0];
	lblTitle.backgroundColor = [UIColor clearColor];
	lblTitle.textColor =  [UIColor whiteColor];
	[lblTitle setText:[NSString stringWithFormat:@"%@",[jpegFiles objectAtIndex:indexPath.row]]];
	[InvCell.contentView addSubview:lblTitle];
    
    
    if (indexPath.row==indxPath.row&&indxPath!=nil) {
        UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right.png"]];
        InvCell.accessoryView=img;
    }
    
    else{
        UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right-gray.png"]];
        InvCell.accessoryView=img;
    }
	InvCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
	return InvCell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indxPath != nil&&indxPath.row==indexPath.row){
        
        UIImageView *rightimg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right-gray.png"]];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indxPath];
        cell.accessoryView = rightimg;
        indxPath=nil;
        
    }
    else{
        UIImageView *rightimg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right-gray.png"]];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indxPath];
        cell.accessoryView = rightimg;
        
        UIImageView *rightimg1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right.png"]];
        UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:indexPath];
        cell1.accessoryView = rightimg1;
        indxPath = indexPath;
    }
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
