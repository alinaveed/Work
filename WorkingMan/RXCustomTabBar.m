
#import "RXCustomTabBar.h"

@implementation RXCustomTabBar

@synthesize btn1, btn2, btn3, btn4, btn5, btn6;

-(void)viewDidLoad
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hotSpotMore:)
                                                 name:@"HotSpotTouched"
                                               object:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideTabBar];
    [self addCustomElements];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.view setFrame:CGRectMake(0, 0, 320, 580)];
}


- (void)hideTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}

- (void)hideNewTabBar 
{
    self.btn1.hidden = 1;
    self.btn2.hidden = 1;
    self.btn3.hidden = 1;
    self.btn4.hidden = 1;
    self.btn5.hidden = 1;
    self.btn6.hidden = 1;

}

- (void)showNewTabBar 
{
    self.btn1.hidden = 0;
    self.btn2.hidden = 0;
    self.btn3.hidden = 0;
    self.btn4.hidden = 0;
    self.btn5.hidden = 0;
    self.btn6.hidden = 0;

}

-(void)addCustomElements
{    
  //  if (single.isExecutingThisFirstTime == false)
    //{
      //  single.isExecutingThisFirstTime = true;
    
        int foriPhone5IncreaseVAlue = 0;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            foriPhone5IncreaseVAlue =0;
        }
        if(result.height == 568)
        {
            foriPhone5IncreaseVAlue = 89;
        }
    }

    
        // Initialise our two images
        UIImage *btnImage = [UIImage imageNamed:@"home-deact.png"];
        UIImage *btnImageSelected = [UIImage imageNamed:@"home-act.png"];
        
        self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(20, 438+foriPhone5IncreaseVAlue, 25, 32);
        [btn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
        [btn1 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
        [btn1 setBackgroundImage:btnImage forState:UIControlStateHighlighted];
        [btn1 setTag:0];
        [btn1 setSelected:true]; // Set this button as selected (we will select the others to false as we only want Tab 1 to be selected initially
        
        // Now we repeat the process for the other buttons
        btnImage = [UIImage imageNamed:@"job-deact.png"];
        btnImageSelected = [UIImage imageNamed:@"job-act.png"];
        self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(70, 438+foriPhone5IncreaseVAlue, 17, 32);
        [btn2 setBackgroundImage:btnImage forState:UIControlStateNormal];
        [btn2 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
        [btn2 setBackgroundImage:btnImage forState:UIControlStateHighlighted];
        [btn2 setTag:1];
        
        btnImage = [UIImage imageNamed:@"report-deact.png"];
        btnImageSelected = [UIImage imageNamed:@"report-act.png"];
        self.btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3.frame = CGRectMake(110, 440+foriPhone5IncreaseVAlue, 30, 30);
        [btn3 setBackgroundImage:btnImage forState:UIControlStateNormal];
        [btn3 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
        [btn3 setBackgroundImage:btnImage forState:UIControlStateHighlighted];
        [btn3 setTag:2];
        
        
        btnImage = [UIImage imageNamed:@"inv-deact.png"];
        btnImageSelected = [UIImage imageNamed:@"inv-act.png"];
        self.btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn4.frame = CGRectMake(167, 439+foriPhone5IncreaseVAlue, 41, 32);
        [btn4 setBackgroundImage:btnImage forState:UIControlStateNormal];
        [btn4 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
        [btn4 setBackgroundImage:btnImage forState:UIControlStateHighlighted];
        [btn4 setTag:3];
        
        btnImage = [UIImage imageNamed:@"pick-deact.png"];
        btnImageSelected = [UIImage imageNamed:@"pick-act.png"];
        self.btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn5.frame = CGRectMake(230, 439+foriPhone5IncreaseVAlue, 27, 32);
        [btn5 setBackgroundImage:btnImage forState:UIControlStateNormal];
        [btn5 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
        [btn5 setBackgroundImage:btnImage forState:UIControlStateHighlighted];
        [btn5 setTag:4];
    
        btnImage = [UIImage imageNamed:@"help-deact.png"];
        btnImageSelected = [UIImage imageNamed:@"help-act.png"];
        self.btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn6.frame = CGRectMake(280, 438+foriPhone5IncreaseVAlue, 20, 32);
        [btn6 setBackgroundImage:btnImage forState:UIControlStateNormal];
        [btn6 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
        [btn6 setBackgroundImage:btnImage forState:UIControlStateHighlighted];
        [btn6 setTag:5];
    
    
        UIImage *myImage = [UIImage imageNamed:@"btm-bar.png"];
        UIImageView *myImageView = [[UIImageView alloc] initWithImage:myImage];
        [myImageView setFrame:CGRectMake(0, 430+foriPhone5IncreaseVAlue, 320, 49)];
        [self.view addSubview:myImageView];
    
    
    // Add my new buttons to the view
        [self.view addSubview:btn1];
        [self.view addSubview:btn2];
        [self.view addSubview:btn3];
        [self.view addSubview:btn4];
        [self.view addSubview:btn5];
        [self.view addSubview:btn6];

    
        // Setup event handlers so that the buttonClicked method will respond to the touch up inside event.
        [btn1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn3 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn4 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn5 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn6 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
  //  }
}

- (void)buttonClicked:(id)sender
{    
	int tagNum = [sender tag];
	[self selectTab:tagNum];
}

- (void)hotSpotMore:(NSNotification *)notification {
    
    [self selectTab:[[notification.userInfo objectForKey:@"HelpTopic"]intValue]];
}
- (void)selectTab:(int)tabID
{
	switch(tabID)
	{
		case 0:
			[btn1 setSelected:true];
			[btn2 setSelected:false];
			[btn3 setSelected:false];
			[btn4 setSelected:false];
            [btn5 setSelected:false];
            [btn6 setSelected:false];

			break;
		case 1:
			[btn1 setSelected:false];
			[btn2 setSelected:true];
			[btn3 setSelected:false];
			[btn4 setSelected:false];
            [btn5 setSelected:false];
            [btn6 setSelected:false];

			break;
		case 2:
			[btn1 setSelected:false];
			[btn2 setSelected:false];
			[btn3 setSelected:true];
			[btn4 setSelected:false];
            [btn5 setSelected:false];
            [btn6 setSelected:false];

			break;
		case 3:
			[btn1 setSelected:false];
			[btn2 setSelected:false];
			[btn3 setSelected:false];
			[btn4 setSelected:true];
            [btn5 setSelected:false];
            [btn6 setSelected:false];

			break;
            
        case 4:
			[btn1 setSelected:false];
			[btn2 setSelected:false];
			[btn3 setSelected:false];
			[btn4 setSelected:false];
            [btn5 setSelected:true];
            [btn6 setSelected:false];

			break;
        case 5:
			[btn1 setSelected:false];
			[btn2 setSelected:false];
			[btn3 setSelected:false];
			[btn4 setSelected:false];
            [btn5 setSelected:false];
            [btn6 setSelected:true];
            
			break;
	}
	
	self.selectedIndex = tabID;
}

@end
