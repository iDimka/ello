//
//  GanriTableViewCell.h
//  ello
//
//  Created by Dmitry Sazanovich on 27/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ganri.h"


@interface GanriTableViewCell : UITableViewCell {
    UILabel*		_title;
    UILabel*		_ganrCount;	

}

- (void)configCellByGanri:(Ganri*)object;



@end
