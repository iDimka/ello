 
#import "MKEntryPanel.h"
#import <QuartzCore/QuartzCore.h>
 
@interface MKEntryPanel (PrivateMethods)
+ (MKEntryPanel*) panel;
@end


@implementation DimView

- (id)initWithParent:(UIView*) aParentView onTappedSelector:(SEL) tappedSel{
    self = [super initWithFrame:[aParentView bounds]];
    if (self) {
        // Initialization code
        parentView = aParentView;
        onTapped = tappedSel;
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.0;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [parentView performSelector:onTapped];
}

- (void)dealloc{
    [super dealloc];
}

@end

@implementation MKEntryPanel
@synthesize closeBlock = _closeBlock;
@synthesize titleLabel = _titleLabel;
@synthesize entryField = _entryField;
@synthesize backgroundGradient = _backgroundGradient;
@synthesize dimView = _dimView;
 
+ (MKEntryPanel*) panel{
    MKEntryPanel *panel =  (MKEntryPanel*) [[[UINib nibWithNibName:@"MKEntryPanel" bundle:nil] 
                                           instantiateWithOwner:self options:nil] objectAtIndex:0];

    
	//	
	
    panel.backgroundGradient.image = [[UIImage imageNamed:@"TopBar"] stretchableImageWithLeftCapWidth:1 topCapHeight:5];
 	 
//	[panel.entryField butto
//	[panel.entryField setBorderStyle:UITextBorderStyleRoundedRect];
	  
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionPush;	
	transition.subtype = kCATransitionFromBottom;
	[panel.layer addAnimation:transition forKey:nil];
	
    
    return panel;
}
- (void)awakeFromNib {

}
/*
- (void)addDot:(id)sender{
	_entryField.text = [NSString stringWithFormat:@"%@.", _entryField.text];
}
*/
+ (void) showPanelWithTitle:(NSString*) title inView:(UIView*) view onTextEntered:(CloseBlock) editingEndedBlock{
    MKEntryPanel *panel = [MKEntryPanel panel];
    panel.closeBlock = editingEndedBlock;
    panel.titleLabel.text = title;
    [panel.entryField becomeFirstResponder];
//	[panel.entryField setAddDelegate:panel];
	 
    panel.dimView = [[[DimView alloc] initWithParent:panel onTappedSelector:@selector(cancelTapped:)] autorelease];
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	[panel.dimView.layer addAnimation:transition forKey:nil];
    panel.dimView.alpha = 0.8;
    [view addSubview:panel.dimView];
    [view addSubview:panel];
}

- (id)addonButtonAction:(id)sender{
	if ([_entryField.text rangeOfString:@"."].location != NSNotFound) {
		return nil;
	}
	_entryField.text = [NSString stringWithFormat:@"%@.", _entryField.text];
	return nil;
}
- (void)textFieldDidBeginEditing:(AMTextFieldNumberPad *)textField{
	
//	[textField  setButtonIcon:ButtonIconKeyboard];
//	textField.buttonImage = [UIImage imageNamed:@"kbdot.png"];
 
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	if (range.location == 0 && range.length == 1)_btnOk.enabled = NO;
	else _btnOk.enabled = YES;
	return YES;
	NSString *regEx = @"[0-9]+?\\.?[0-9]?";  
	NSPredicate* predIsTime = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
	return [predIsTime evaluateWithObject:[NSString stringWithFormat:@"%@%@", textField.text, string]];
}
- (IBAction) textFieldDidEndOnExit:(UITextField *)textField {
        
    [self performSelectorOnMainThread:@selector(hidePanel) withObject:nil waitUntilDone:YES];    
    self.closeBlock(self.entryField.text);
}

- (IBAction) doneAction:(id)sender{
	
    [self performSelectorOnMainThread:@selector(hidePanel) withObject:nil waitUntilDone:YES];    
    self.closeBlock(self.entryField.text);
}
- (IBAction) cancelAction:(id)sender{ 
    [self performSelectorOnMainThread:@selector(hidePanel) withObject:nil waitUntilDone:YES];  
}
- (void) cancelTapped:(id) sender{
    [self performSelectorOnMainThread:@selector(hidePanel) withObject:nil waitUntilDone:YES];    
}
- (void) hidePanel{
    [self.entryField resignFirstResponder];
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionPush;	
	transition.subtype = kCATransitionFromTop;
	[self.layer addAnimation:transition forKey:nil];
    self.frame = CGRectMake(0, -self.frame.size.height, 320, self.frame.size.height); 
    
    transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	self.dimView.alpha = 0.0;
	[self.dimView.layer addAnimation:transition forKey:nil];
    
    [self.dimView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.40];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.45];
}

- (void)dealloc{
    [super dealloc];
}

@end


