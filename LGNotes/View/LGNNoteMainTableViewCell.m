//
//  NoteMainTableViewCell.m
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "LGNNoteMainTableViewCell.h"
#import "LGNoteConfigure.h"
#import <Masonry/Masonry.h>
#import "LGNNoteTools.h"
#import "LGNNoteModel.h"
#import "NSBundle+Notes.h"

@interface LGNNoteMainTableViewCell ()

@property (nonatomic, strong) UILabel *noteTitleLabel;
@property (nonatomic, strong) UILabel *noteContentLabel;
@property (nonatomic, strong) UILabel *editTimeLabel;
@property (nonatomic, strong) UILabel *sourceLabel;

@end

@implementation LGNNoteMainTableViewCell

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
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.noteTitleLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.sourceLabel.mas_top).offset(-10);
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
}

- (void)configureCellForDataSource:(LGNNoteModel *)dataSource indexPath:(NSIndexPath *)indexPath{
    NSString *subjectName = [NSString stringWithFormat:@"%@ | ",[LGNNoteTools getSubjectImageNameWithSubjectID:dataSource.SubjectID]];
    NSMutableAttributedString *att = [LGNNoteTools attributedStringByStrings:@[subjectName,dataSource.ResourceName] colors:@[kColorInitWithRGB(0, 153, 255, 1),kColorInitWithRGB(0, 153, 255, 1)] fonts:@[@(12),@(12)]];
    self.sourceLabel.attributedText = att;
    self.editTimeLabel.text = [NSString stringWithFormat:@"%@",dataSource.NoteEditTime];
    NSMutableString *contentString = dataSource.NoteContent_Att.mutableString;
    [contentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.noteContentLabel.text = contentString;
    
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
        _noteContentLabel.numberOfLines = 0;
        _noteContentLabel.font = kSYSTEMFONT(14.f);
        _noteContentLabel.textColor = kLabelColorLightGray;
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
        _sourceLabel.numberOfLines = 0;
    }
    return _sourceLabel;
}

@end
