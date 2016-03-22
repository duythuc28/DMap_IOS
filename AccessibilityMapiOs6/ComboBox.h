//
//  ComboBox.h
//
//  Created by Dor Alon on 12/17/11.
//  http://doralon.net

#import <UIKit/UIKit.h>

@interface ComboBox : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    UIPickerView* pickerView;
    NSMutableArray *dataArray;
}

-(void) setComboData:(NSMutableArray*) data; //set the picker view items
-(void) clearData;
-(void) assignData:(NSString*)name;
-(void) assignFirstReponder;

@property (retain, nonatomic) NSString* selectedText; //the UITextField text
@property IBOutlet UITextField* textField;
@end
