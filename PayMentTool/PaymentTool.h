//
//  PaymentTool.h
//  PayMentTool
//
//  Created by 大橙子 on 2019/7/25.
//  Copyright © 2019 Tomous. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaymentTool : UIView
- (void)callKeyBoard;

@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) BOOL hiddenForgetPWD;
@end

NS_ASSUME_NONNULL_END
