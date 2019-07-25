//
//  PaymentTool.m
//  PayMentTool
//
//  Created by 大橙子 on 2019/7/25.
//  Copyright © 2019 Tomous. All rights reserved.
//

#import "PaymentTool.h"
#define PWD_COUNT 6
#define HEIGHT [[UIScreen mainScreen] bounds].size.height
#define WIDTH [[UIScreen mainScreen] bounds].size.width
//以2x为基准
#define ScaleW WIDTH/375.0
#define ScaleH HEIGHT/667.0
#define kColorWithRGB(r, g, b) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:1.f]
@interface PaymentTool ()<UITextFieldDelegate>{
    UITextField * pwdTextField;
    CGFloat maxHeight;
    UIButton * forgetBtn;
}
@property (nonatomic, strong) UIView * enterPasswordView;
@property (nonatomic, strong) NSMutableArray * pwdIndicatorArr;
@end
@implementation PaymentTool

- (instancetype)init{
    if(self = [super init]){
        self.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        [self prepare];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)]) {
        [self prepare];
    }
    return self;
}

- (void)prepare{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPosition:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPosition:) name:UIKeyboardWillHideNotification object:nil];
    
    [self addSubview:self.enterPasswordView];
}

- (void)changeContentViewPosition:(NSNotification *)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    NSLog(@"%f", keyBoardEndY);
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        NSLog(@"%@",notification.name);
        if ([notification.name isEqualToString:@"UIKeyboardWillShowNotification"]) {
            //            self.center = CGPointMake(self.center.x, (HEIGHT - keyBoardEndY)/2);
            self.enterPasswordView.center = CGPointMake(self.center.x, keyBoardEndY-maxHeight/2);
        }else{
            //            self.center = CGPointMake(self.center.x, (HEIGHT - keyBoardEndY)/2);
            self.enterPasswordView.center = CGPointMake(self.center.x, (HEIGHT - keyBoardEndY)/2);
        }
    } completion:^(BOOL finished) {
        if ([notification.name isEqualToString:@"UIKeyboardWillHideNotification"]) {
            
            [self removeFromSuperview];
        }
        
    }];
}

- (void)cancalBtnClick{
    if (_type == 0x64) {
        if (_completeHandle) {
            _completeHandle(@"Alert");
        }
        return;
    };
    [pwdTextField resignFirstResponder];
}


- (void)removeSelf{
    //    [self removeFromSuperview];
    [pwdTextField resignFirstResponder];
}

- (void)callKeyBoard{
    [pwdTextField becomeFirstResponder];
}

- (UIView *)enterPasswordView{
    if (!_enterPasswordView) {
        _enterPasswordView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-130*ScaleH, WIDTH, 130*ScaleH)];
        _enterPasswordView.backgroundColor = kColorWithRGB(251, 251, 251);
        UIButton * cancalBtn = [[UIButton alloc] initWithFrame:CGRectMake(16*ScaleW, 9*ScaleH, 18*ScaleH, 18*ScaleH)];
        [cancalBtn setImage:[UIImage imageNamed:@"delete-circular"] forState:UIControlStateNormal];
        [cancalBtn addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
        [_enterPasswordView addSubview:cancalBtn];
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(self.center.x-100*ScaleW, 0, 200*ScaleW, 36*ScaleH)];
        title.text = @"输入密码";
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = kColorWithRGB(51, 51, 51);
        title.font = [UIFont systemFontOfSize:13];
        [_enterPasswordView addSubview:title];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame), WIDTH, 1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_enterPasswordView addSubview:line];
        
        UIView * inputView = [[UIView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(line.frame)+18*ScaleH, WIDTH-80, (WIDTH-80)/6)];
        inputView.backgroundColor = [UIColor whiteColor];
        inputView.layer.borderWidth = 1.f;
        inputView.layer.borderColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.].CGColor;
        [_enterPasswordView addSubview:inputView];
        
        pwdTextField = [[UITextField alloc]initWithFrame:inputView.bounds];
        pwdTextField.hidden = YES;
        pwdTextField.delegate = self;
        pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
        [pwdTextField becomeFirstResponder];
        [inputView addSubview:pwdTextField];
        
        CGFloat width = inputView.bounds.size.width/PWD_COUNT;
        for (int i = 0; i < PWD_COUNT; i ++) {
            UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake(i*width+width*3/8, width*3/8, width/4, width/4)];
            dot.backgroundColor = [UIColor blackColor];
            dot.layer.cornerRadius = width/8;
            dot.clipsToBounds = YES;
            dot.hidden = YES;
            [inputView addSubview:dot];
            [self.pwdIndicatorArr addObject:dot];
            
            if (i == PWD_COUNT-1) {
                continue;
            }
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*width, 0, .5f, inputView.bounds.size.height)];
            line.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.];
            [inputView addSubview:line];
        }
        
        forgetBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 40*ScaleW - 60*ScaleW, CGRectGetMaxY(inputView.frame)+5*ScaleH, 60*ScaleW, 21*ScaleW)];
        [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [forgetBtn setTitleColor:kColorWithRGB(2, 179, 255) forState:UIControlStateNormal];
        [forgetBtn addTarget:self action:@selector(forgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        forgetBtn.titleLabel.font = [UIFont systemFontOfSize:11*ScaleH];
        
        maxHeight = _enterPasswordView.frame.size.height;
        
        [_enterPasswordView addSubview:forgetBtn];
    }
    return _enterPasswordView;
}


- (void)setHiddenForgetPWD:(BOOL)hiddenForgetPWD{
    _hiddenForgetPWD = hiddenForgetPWD;
    forgetBtn.hidden = hiddenForgetPWD;
}

- (void)forgetBtnClick:(UIButton *)sender{
    
    if (_completeHandle) {
        _completeHandle(nil);
    }
    if (_type != 0x64) {
        [self performSelector:@selector(removeSelf) withObject:nil afterDelay:.1f];
    }
}

- (NSMutableArray *)pwdIndicatorArr{
    if (!_pwdIndicatorArr) {
        _pwdIndicatorArr = [[NSMutableArray alloc] init];
    }
    return _pwdIndicatorArr;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField.text.length ==0 && string.length == 0) return NO;
    
    if (textField.text.length >= PWD_COUNT && string.length) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        return NO;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]*$"];
    if (![predicate evaluateWithObject:string]) {
        return NO;
    }
    NSString *totalString;
    if (string.length <= 0) {
        totalString = [textField.text substringToIndex:textField.text.length-1];
    }
    else {
        totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    [self setDotWithCount:totalString.length];
    
    NSLog(@"_____total %@",totalString);
    if (totalString.length == PWD_COUNT) {
        if (_completeHandle) {
            _completeHandle(totalString);
        }
        [self performSelector:@selector(removeSelf) withObject:nil afterDelay:.1f];
    }
    
    return YES;
}

- (void)setDotWithCount:(NSInteger)count {
    for (UILabel *dot in self.pwdIndicatorArr) {
        dot.hidden = YES;
    }
    
    for (int i = 0; i< count; i++) {
        ((UILabel*)[self.pwdIndicatorArr objectAtIndex:i]).hidden = NO;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


@end
