//
//  ViewController.m
//  SFMT19937

#import "ViewController.h"
#import "SFMT19937.h"

@implementation ViewController

@synthesize txtMin = _txtMin;
@synthesize txtMax = _txtMax;
@synthesize txtResult = _txtResult;
@synthesize txtActive = _txtActive;

- (id)init
{
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        UIBarButtonItem *btnGen = [[UIBarButtonItem alloc] initWithTitle:@"Gen"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self 
                                                                  action:@selector(btnGenOnClicked:)];
        self.navigationItem.rightBarButtonItem = btnGen;
        self.title = @"SFMT19937";
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:nil];	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
	_txtActive = textField;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch ([indexPath indexAtPosition:0]) {
            case 0:
                if ([indexPath indexAtPosition:1] == 0) {
                    _txtMin = [[UITextField alloc] initWithFrame:CGRectMake(130.0, 12.0, 200.0, 50.0)];
                    [cell addSubview:_txtMin];
                    [_txtMin setEnabled:YES];
                    _txtMin.returnKeyType = UIReturnKeyNext;
                    _txtMin.keyboardType = UIKeyboardTypeNumberPad;
                    _txtMin.text = @"0";
                    _txtMin.delegate = self;
                    cell.textLabel.text = @"Min";
                    if ([_txtMin resignFirstResponder]) {
                        [_txtMin becomeFirstResponder];
                    }
                } else if ([indexPath indexAtPosition:1] == 1) {
                    _txtMax = [[UITextField alloc] initWithFrame:CGRectMake(130.0, 12.0, 200.0, 50.0)];
                    [cell addSubview:_txtMax];
                    [_txtMax setEnabled:YES];
                    _txtMax.returnKeyType = UIReturnKeyDone;
                    _txtMax.keyboardType = UIKeyboardTypeNumberPad;
                    _txtMax.text = @"10000";
                    cell.textLabel.text = @"Max";
                }
                break;
                
            case 1:
                if ([indexPath indexAtPosition:1] == 0) {
                    _txtResult = [[UITextField alloc] initWithFrame:CGRectMake(130.0, 12.0, 200.0, 50.0)];
                    [cell addSubview:_txtResult];
                    [_txtResult setEnabled:YES];
                    _txtResult.enabled = NO;
                    cell.textLabel.text = @"Result";
                }
                break;
        }
    }
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{  
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.frame = CGRectMake(0, 163, 106, 53);
    btnDone.adjustsImageWhenHighlighted = NO;
    [btnDone setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
    [btnDone setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
    [btnDone addTarget:self action:@selector(btnDoneOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIWindow* window = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    CGRect keyboardFrame = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect startFrame = CGRectMake(-3.0f, 427.0f + CGRectGetHeight(keyboardFrame), 108.0f, 53.0f);
    CGRect fixedFrame = CGRectMake(-3.0f, 427.0f, 108.0f, 53.0f);
    btnDone.frame = startFrame;
    [window insertSubview:btnDone atIndex:0];
    [UIView beginAnimations:@"showKeyboardButton" context:nil];
    [UIView setAnimationDuration:duration];
    btnDone.frame = fixedFrame;
    
    [UIView commitAnimations];
}

- (void)btnDoneOnClicked:(id)sender 
{
	[_txtActive resignFirstResponder];
    
    [self.view endEditing:YES];
    [UIView beginAnimations:@"hideKeyboardButton" context:nil];
    [UIView setAnimationDuration:0.25f];
    ((UIButton *) sender).frame = CGRectMake(-3.0f, 427.0f + 216.0f, 108.0f, 53.0f);
    [UIView commitAnimations];
    [sender performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3f];
}

- (void)btnGenOnClicked:(id)sender {
    if (!_txtMin.text || !_txtMax.text) {
        return;
    }
    
    int min = _txtMin.text.intValue;
    int max = _txtMax.text.intValue;
    
    if (min < max) {
        int n = [[SFMT19937 instance] nextInt:(max - min)] + min;
        _txtResult.text = [NSString stringWithFormat:@"%d", n];
    }
}

@end
