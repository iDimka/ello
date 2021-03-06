//
//  GanriTableViewCell.m
//  ello
//
//  Created by Dmitry Sazanovich on 27/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "GanriTableViewCell.h"
#import "Genres.h"
#import "Genre.h"


@implementation GanriTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator]; 
    
    if (self) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, 185, 20)];
		[_title setFont:[UIFont boldSystemFontOfSize:18]];
		[_title setTextColor:[UIColor whiteColor]];
		[_title setBackgroundColor:[UIColor clearColor]];
		
		_ganrCount = [[UILabel alloc] initWithFrame:CGRectMake(190, 15, 185, 20)];
		[_ganrCount setFont:[UIFont systemFontOfSize:13]];
		[_ganrCount setTextColor:[UIColor grayColor]];
		[_ganrCount setBackgroundColor:[UIColor clearColor]];        
		
		[self addSubview:_title];

		[self addSubview:_ganrCount];
		
		UIImageView* bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 75)];
		[bg setImage:[[UIImage imageNamed:@"cellBg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0]];		
		[self setBackgroundView:bg];
		[bg release]; 
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configCellByGanri:(Genre *)object{
	_title.text = object.genreName;
//	_ganrCount.text = [NSString stringWithFormat:@"%D views", object.GanrCount];


}

- (void)dealloc
{
    [super dealloc];
}




@end
