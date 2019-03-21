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
        make.top.equalTo(self.noteImageView);
        make.right.equalTo(self.noteImageView.mas_left).offset(10);
    }];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.noteTitleLabel);
        make.height.mas_equalTo(15);
    }];
    [self.editTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.sourceLabel);
        make.left.equalTo(self.sourceLabel.mas_right).offset(20);
        make.height.mas_equalTo(15);
    }];
    [self.noteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(120, 60));
        make.right.equalTo(self.contentView).offset(-10);
    }];
}

- (void)configureCellForDataSource:(NoteModel *)dataSource indexPath:(NSIndexPath *)indexPath{
    NSString *subjectName = [NoteTools getSubjectImageNameWithSubjectID:dataSource.SubjectID];
    [subjectName stringByAppendingString:@" | "];
    NSMutableAttributedString *att = [NoteTools attributedStringByStrings:@[subjectName,dataSource.ResourceName] colors:@[kLabelColorLightGray,kColorInitWithRGB(0, 153, 255, 1)] fonts:@[@(12),@(12)]];
    self.sourceLabel.attributedText = att;
    //    self.noteTitleLabel.text = dataSource.NoteTitle;
    self.editTimeLabel.text = [NSString stringWithFormat:@"%@",dataSource.NoteEditTime];
    
    self.noteContentLabel.attributedText = dataSource.NoteContent_Att;
    //    if (dataSource.ResourceID) {
    //        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:dataSource.NoteTitle];
    //        self.noteTitleLabel.attributedText = att;
    //    } else {
    NSTextAttachment *attment = [[NSTextAttachment alloc] init];
    attment.image = [NSBundle lg_imagePathName:@"note_remark_selected"];
    attment.bounds = CGRectMake(5, -3, 15, 15);
    
    NSAttributedString *attmentAtt = [NSAttributedString attributedStringWithAttachment:attment];
    NSMutableAttributedString *att1 = [[NSMutableAttributedString alloc] initWithString:[dataSource.NoteTitle stringByAppendingString:@" "]];
    [att1 appendAttributedString:attmentAtt];
    self.noteTitleLabel.attributedText = att1;
    //    }
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
        _noteTitleLabel.numberOfLines = 3;
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
