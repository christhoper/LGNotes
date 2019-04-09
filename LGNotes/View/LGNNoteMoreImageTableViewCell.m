//
//  NoteMoreImageTableViewCell.m
//  NoteDemo
//
//  Created by hend on 2019/3/21.
//  Copyright © 2019 hend. All rights reserved.
//

#import "LGNNoteMoreImageTableViewCell.h"
#import "LGNoteConfigure.h"
#import <Masonry/Masonry.h>
#import "LGNNoteTools.h"
#import "LGNNoteModel.h"
#import "NSBundle+Notes.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LGNNoteMoreImageTableViewCell ()

@property (nonatomic, strong) UILabel *noteTitleLabel;
@property (nonatomic, strong) UILabel *editTimeLabel;
@property (nonatomic, strong) UILabel *sourceLabel;

/** 为了性能，不卡顿，不使用集合视图了 */
@property (nonatomic, strong) UIImageView *imageViewLeft;
@property (nonatomic, strong) UIImageView *imageViewCenter;
@property (nonatomic, strong) UIImageView *imageViewRight;

@end

@implementation LGNNoteMoreImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self lg_addSubViews];
    }
    return self;
}


- (void)lg_addSubViews{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.noteTitleLabel];
    [self.contentView addSubview:self.editTimeLabel];
    [self.contentView addSubview:self.sourceLabel];
    [self.contentView addSubview:self.imageViewLeft];
    [self.contentView addSubview:self.imageViewCenter];
    [self.contentView addSubview:self.imageViewRight];
    
    [self lg_setupSubViewsContraints];
}

- (void)lg_setupSubViewsContraints{
    [self.noteTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(21);
    }];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.editTimeLabel);
        make.left.equalTo(self.editTimeLabel.mas_right).offset(20);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(15);
    }];
    [self.editTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.noteTitleLabel);
        make.size.mas_equalTo(CGSizeMake(100, 15));
    }];
    [self.imageViewLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.imageViewCenter.mas_left).offset(-10);
        make.size.equalTo(self.imageViewCenter);
    }];
    [self.imageViewCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.right.equalTo(self.imageViewRight.mas_left).offset(-10);
        make.left.equalTo(self.imageViewLeft.mas_right).offset(10);
        make.width.equalTo(self.imageViewLeft);
//        make.top.equalTo(self.noteTitleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(60);
    }];
    [self.imageViewRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-12);
        make.left.equalTo(self.imageViewCenter.mas_right).offset(10);
        make.size.equalTo(self.imageViewCenter);
    }];
}

- (void)configureCellForDataSource:(LGNNoteModel *)dataSource indexPath:(NSIndexPath *)indexPath{
    NSString *subjectName = [NSString stringWithFormat:@"%@ | ",[LGNNoteTools getSubjectImageNameWithSubjectID:dataSource.SubjectID]];
    NSMutableAttributedString *att = [LGNNoteTools attributedStringByStrings:@[subjectName,dataSource.ResourceName] colors:@[kColorInitWithRGB(0, 153, 255, 1),kColorInitWithRGB(0, 153, 255, 1)] fonts:@[@(12),@(12)]];
    self.sourceLabel.attributedText = att;
    self.editTimeLabel.text = [NSString stringWithFormat:@"%@",dataSource.NoteEditTime];
    
    if ([dataSource.IsKeyPoint isEqualToString:@"1"]) {
        NSTextAttachment *attment = [[NSTextAttachment alloc] init];
        attment.image = [NSBundle lg_imagePathName:@"note_remark_selected"];
        attment.bounds = CGRectMake(5, -3, 15, 15);
        
        NSAttributedString *attmentAtt = [NSAttributedString attributedStringWithAttachment:attment];
        NSMutableAttributedString *att1 = [[NSMutableAttributedString alloc] initWithString:[dataSource.NoteTitle stringByAppendingString:@" "]];
        [att1 appendAttributedString:attmentAtt];
        self.noteTitleLabel.attributedText = att1;
    } else {
        NSMutableAttributedString *att1 = [[NSMutableAttributedString alloc] initWithString:dataSource.NoteTitle];
        self.noteTitleLabel.attributedText = att1;
    }
    
    [self loadImageViewWithImageUrls:dataSource.imgaeUrls];
}

- (void)loadImageViewWithImageUrls:(NSArray *)imageUrls{
    if (imageUrls.count == 3) {
        NSString *url1 = [imageUrls objectAtIndex:0];
        NSString *url2 = [imageUrls objectAtIndex:1];
        NSString *url3 = [imageUrls objectAtIndex:2];
        [self.imageViewLeft sd_setImageWithURL:[NSURL URLWithString:url1] placeholderImage:[NSBundle lg_imageName:@"lg_empty"]];
        [self.imageViewCenter sd_setImageWithURL:[NSURL URLWithString:url2] placeholderImage:[NSBundle lg_imageName:@"lg_empty"]];
        [self.imageViewRight sd_setImageWithURL:[NSURL URLWithString:url3] placeholderImage:[NSBundle lg_imageName:@"lg_empty"]];
        [self showLeftImage:YES showCenterImage:YES showRightImage:YES];
        
    } else if (imageUrls.count == 2) {
        NSString *url1 = [imageUrls objectAtIndex:0];
        NSString *url2 = [imageUrls objectAtIndex:1];
        [self.imageViewLeft sd_setImageWithURL:[NSURL URLWithString:url1] placeholderImage:[NSBundle lg_imageName:@"lg_empty"]];
        [self.imageViewCenter sd_setImageWithURL:[NSURL URLWithString:url2] placeholderImage:[NSBundle lg_imageName:@"lg_empty"]];
        [self showLeftImage:YES showCenterImage:YES showRightImage:NO];
    } else {
        NSString *url1 = [imageUrls objectAtIndex:0];
        [self.imageViewLeft sd_setImageWithURL:[NSURL URLWithString:url1] placeholderImage:[NSBundle lg_imageName:@"lg_empty"]];
        [self showLeftImage:YES showCenterImage:NO showRightImage:NO];
    }
}

- (void)showLeftImage:(BOOL)showLeft showCenterImage:(BOOL)showCenter showRightImage:(BOOL)showRight{
    self.imageViewLeft.hidden = !showLeft;
    self.imageViewCenter.hidden = !showCenter;
    self.imageViewRight.hidden = !showRight;
}

#pragma mark - lazy
- (UILabel *)editTimeLabel{
    if (!_editTimeLabel) {
        _editTimeLabel = [[UILabel alloc] init];
        _editTimeLabel.text = @"8:30~09:19";
        _editTimeLabel.textColor = [UIColor lightGrayColor];
        _editTimeLabel.font = [UIFont systemFontOfSize:10.f];;
    }
    return _editTimeLabel;
}

- (UILabel *)noteTitleLabel{
    if (!_noteTitleLabel) {
        _noteTitleLabel = [[UILabel alloc] init];
        _noteTitleLabel.font = [UIFont systemFontOfSize:15.f];
        _noteTitleLabel.text = @"毛泽东思想，马克思主义，中国特色社会主义核心价值观";
        _noteTitleLabel.numberOfLines = 1;
        _noteTitleLabel.textColor = [UIColor darkGrayColor];
    }
    return _noteTitleLabel;
}

- (UILabel *)sourceLabel{
    if (!_sourceLabel) {
        _sourceLabel = [[UILabel alloc] init];
    }
    return _sourceLabel;
}

- (UIImageView *)imageViewLeft{
    if (!_imageViewLeft) {
        _imageViewLeft = [[UIImageView alloc] init];
        _imageViewLeft.layer.cornerRadius = 5;
        _imageViewLeft.clipsToBounds = YES;
        [_imageViewLeft sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[NSBundle lg_imageName:@"lg_empty"]];
    }
    return _imageViewLeft;
}

- (UIImageView *)imageViewCenter{
    if (!_imageViewCenter) {
        _imageViewCenter = [[UIImageView alloc] init];
        _imageViewCenter.layer.cornerRadius = 5;
        _imageViewCenter.clipsToBounds = YES;
        [_imageViewCenter sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[NSBundle lg_imageName:@"lg_empty"]];
    }
    return _imageViewCenter;
}

- (UIImageView *)imageViewRight{
    if (!_imageViewRight) {
        _imageViewRight = [[UIImageView alloc] init];
        _imageViewRight.layer.cornerRadius = 5;
        _imageViewRight.clipsToBounds = YES;
        [_imageViewRight sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[NSBundle lg_imageName:@"lg_empty"]];
    }
    return _imageViewRight;
}


@end
