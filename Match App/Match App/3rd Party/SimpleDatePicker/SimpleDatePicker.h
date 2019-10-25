//
//  SimpleDatePicker.h
//  Match App
//
//  Created by Michal Ziobro on 24/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SimpleDatePickerDelegate <NSObject>

- (void)simpleDatePickerValueChanged:(NSDate *)date;

- (void)simpleDatePickerDidDismissWithDate:(NSDate *)date;
- (void)simpleDatePickerDidDismiss;

@optional
- (NSDate *)simpleDatePickerSelectedDate;
- (void)simpleDatePickerDidDismissWithTime:(NSDate *)date;

@end

@interface SimpleDatePicker : UIView

+ (void)presentInViewController:(UIViewController *)viewController withDelegate: (id<SimpleDatePickerDelegate>)delegate dateMin: (NSDate *) dateMin andDateMax: (NSDate *) dateMax;
+ (void)presentTimePickerInViewController:(UIViewController *)viewController withDelegate:(id<SimpleDatePickerDelegate>)delegate;
@end

@interface SimpleDatePickerOwner : NSObject

@property (nonatomic, weak) IBOutlet SimpleDatePicker *decoupledView; 

@end
