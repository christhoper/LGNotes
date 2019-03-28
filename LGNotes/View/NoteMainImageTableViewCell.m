//
//  NoteMainImageTableViewCell.m
//  NoteDemo
//
//  Created by hend on 2019/3/20.
//  Copyright © 2019 hend. All rights reserved.
//

#import "NoteMainImageTableViewCell.h"
#import "LGNoteConfigure.h"
#import <Masonry/Masonry.h>
#import "NoteTools.h"
#import "NoteModel.h"
#import "NSBundle+Notes.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NoteMainImageTableViewCell ()

@property (nonatomic, strong) UILabel *noteTitleLabel;
@property (nonatomic, strong) UILabel *noteContentLabel;
@property (nonatomic, strong) UILabel *editTimeLabel;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UIImageView *noteImageView;

@end

@implementation NoteMainImageTableViewCell

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
    [self.contentView addSubview:self.noteContentLabel];
    [self.contentView addSubview:self.editTimeLabel];
    [self.contentView addSubview:self.sourceLabel];
    [self.contentView addSubview:self.noteImageView];
    
    [self lg_setupSubViewsContraints];
}

- (void)lg_setupSubViewsContraints{
    [self.noteTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(21);
    }];
    [self.noteContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.noteTitleLabel);
        make.top.height.equalTo(self.noteImageView);
        make.right.equalTo(self.noteImageView.mas_left).offset(-10);
        
    }];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.editTimeLabel);
        make.left.equalTo(self.editTimeLabel.mas_right).offset(20);
        make.height.mas_equalTo(15);
    }];
    [self.editTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.noteTitleLabel);
        make.height.mas_equalTo(15);
    }];
    CGFloat imageWidth = (kMain_Screen_Width - 30)/3;
    [self.noteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(imageWidth, 60));
        make.right.equalTo(self.contentView).offset(-10);
    }];
}

- (void)configureCellForDataSource:(NoteModel *)dataSource indexPath:(NSIndexPath *)indexPath{
    NSString *subjectName = [NSString stringWithFormat:@"%@ | ",[NoteTools getSubjectImageNameWithSubjectID:dataSource.SubjectID]];
    NSMutableAttributedString *att = [NoteTools attributedStringByStrings:@[subjectName,dataSource.ResourceName] colors:@[kColorInitWithRGB(0, 153, 255, 1),kColorInitWithRGB(0, 153, 255, 1)] fonts:@[@(12),@(12)]];
    self.sourceLabel.attributedText = att;
    self.editTimeLabel.text = [NSString stringWithFormat:@"%@",dataSource.NoteEditTime];
    
    NSMutableString *contentString = dataSource.NoteContent_Att.mutableString;
    [contentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.noteContentLabel.text = contentString;
    
    NSString *imageUrl = [dataSource.imgaeUrls objectAtIndex:0];
    [self.noteImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[NSBundle lg_imageName:@"lg_empty"] options:SDWebImageRefreshCached];
    
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

- (UILabel *)noteContentLabel{
    if (!_noteContentLabel) {
        _noteContentLabel = [[UILabel alloc] init];
        _noteContentLabel.text = @"荷塘月色内容";
        _noteContentLabel.font = kSYSTEMFONT(14.f);
        _noteContentLabel.numberOfLines = 0;
    }
    return _noteContentLabel;
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

- (UIImageView *)noteImageView{
    if (!_noteImageView) {
        _noteImageView = [[UIImageView alloc] init];
        [_noteImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[NSBundle lg_imageName:@"lg_empty"]];
    }
    return _noteImageView;
}



@end
