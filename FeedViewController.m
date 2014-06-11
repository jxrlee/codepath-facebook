//
//  FeedViewController.m
//  facebook
//
//  Created by Joseph Lee on 6/9/14.
//  Copyright (c) 2014 mn8. All rights reserved.
//

#import "FeedViewController.h"
#import "TTTAttributedLabel.h"

@interface FeedViewController ()
@property (weak, nonatomic) IBOutlet UIView *postContainer;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UIView *actionBar;
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (weak, nonatomic) IBOutlet UILabel *postText;
@property (weak, nonatomic) IBOutlet UIImageView *menuBar;
- (IBAction)onLikeButton:(id)sender;
- (IBAction)onCommentButton:(id)sender;
- (IBAction)onShareButton:(id)sender;
- (IBAction)onTap:(id)sender;
- (void)willShowKeyboard:(NSNotification *)notification;
- (void)willHideKeyboard:(NSNotification *)notification;

@end

@implementation FeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Register the methods for the keyboard hide/show events
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    // post container
    self.postContainer.layer.cornerRadius = 2;
    self.postImage.layer.cornerRadius = 2;
    self.postContainer.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.postContainer.layer.shadowOffset = CGSizeMake(1.0,1.0);
    self.postContainer.layer.shadowRadius = 1;
    self.postContainer.layer.shadowOpacity = 1;
    
    // like, comment, share bar
    self.actionBar.layer.borderColor = [[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.1] CGColor];
    self.actionBar.layer.borderWidth = 1;

    NSString *html = @"From collarless shirts to high-waisted pants, <b>#Her</b>'s costume designer, Casey Storm, explains how he created his fashion looks for the future: <a href='http://bit.ly/1jV9zM8'>http://bit.ly/1jV9zM8</a>";
    
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:@"http://bit.ly/1jV9zM8"];
    [str addAttribute: NSLinkAttributeName value: @"http://bit.ly/1jV9zM8" range: NSMakeRange(0, str.length)];
    
    // Apply some inline CSS
    NSString *styledHtml = [self styledHTMLwithHTML:html];
    
    // Generate an attributed string from the HTML
    NSAttributedString *attributedText = [self attributedStringWithHTML:styledHtml];
    
    // append
    [[attributedText mutableCopy] appendAttributedString: str];
    
    self.postText.attributedText = attributedText;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)onLikeButton:(id)sender {
    UIButton *button = (UIButton*)sender;
    button.selected = !button.isSelected;
}

- (IBAction)onCommentButton:(id)sender {
    UIButton *button = (UIButton*)sender;
    button.selected = !button.isSelected;
}

- (IBAction)onShareButton:(id)sender {
    UIButton *button = (UIButton*)sender;
    button.selected = !button.isSelected;
}

- (IBAction)onTap:(id)sender {
    
    [self.view endEditing:YES];
    
    
}


    /*CGRect oldFrame = self.commentBar.frame;
    CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y - 200, oldFrame.size.width, oldFrame.size.height);
    self.commentBar.frame = newFrame;*/


- (void)willShowKeyboard:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the keyboard height and width from the notification
    // Size varies depending on OS, language, orientation
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"Height: %f Width: %f", kbSize.height, kbSize.width);
    
    // Get the animation duration and curve from the notification
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    // Move the view with the same duration and animation curve so that it will match with the keyboard animation
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         self.commentImageView.frame = CGRectMake(0, self.view.frame.size.height - kbSize.height - self.commentImageView.frame.size.height, self.commentImageView.frame.size.width, self.commentImageView.frame.size.height);
                     }
                     completion:nil];
}

- (void)willHideKeyboard:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the animation duration and curve from the notification
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    // Move the view with the same duration and animation curve so that it will match with the keyboard animation
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         self.commentImageView.frame = CGRectMake(0, self.view.frame.size.height - self.commentImageView.frame.size.height - self.menuBar.frame.size.height, self.commentImageView.frame.size.width, self.commentImageView.frame.size.height);
                     }
                     completion:nil];
}

- (NSString *)styledHTMLwithHTML:(NSString *)HTML {
    NSString *style = @"<meta charset=\"UTF-8\"><style> body { font-family: 'Helvetica'; font-size: 14px; } b {font-weight: '600'; }</style>";
    
    return [NSString stringWithFormat:@"%@%@", style, HTML];
}

- (NSAttributedString *)attributedStringWithHTML:(NSString *)HTML {
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType };
    return [[NSAttributedString alloc] initWithData:[HTML dataUsingEncoding:NSUTF8StringEncoding] options:options documentAttributes:NULL error:NULL];
}

@end
