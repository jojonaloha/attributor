//
//  TextStatsViewController.m
//  Attributor
//
//  Created by Jonathan Jordan on 9/6/14.
//  Copyright (c) 2014 Metal Toad Media. All rights reserved.
//

#import "TextStatsViewController.h"

@interface TextStatsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *colorfulCharactersLabel;
@property (weak, nonatomic) IBOutlet UILabel *outlinedCharactersLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCharactersLabel;
@property (weak, nonatomic) IBOutlet UILabel *whitespaceCharactersLabel;
@property (weak, nonatomic) IBOutlet UILabel *alphanumericCharactersLabel;
@end

@implementation TextStatsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setTextToAnalyze:(NSAttributedString *)textToAnalyze
{
    _textToAnalyze = textToAnalyze;
    
    if (self.view.window) [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (NSAttributedString *)charactersWithAttribute:(NSString *)attributeName
{
    NSMutableAttributedString *characters = [[NSMutableAttributedString alloc] init];
    
    int index = 0;
    while (index < [self.textToAnalyze length]) {
        NSRange range;
        id value = [self.textToAnalyze attribute:attributeName atIndex:index effectiveRange:&range];
        if (value) {
            [characters appendAttributedString:[self.textToAnalyze attributedSubstringFromRange:range]];
            index = range.location + range.length;
        }
        else {
            index++;
        }
    }
    
    return characters;
}

- (NSString *)charactersMatchingRegex:(NSString *)pattern
{
    NSString *characters = @"";
    NSError *error;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [expression matchesInString:self.textToAnalyze.string options:0 range:NSMakeRange(0, [self.textToAnalyze length])];
    for (NSTextCheckingResult *match in matches) {
        NSRange wordRange = [match rangeAtIndex:0];
        characters = [characters stringByAppendingString:[self.textToAnalyze.string substringWithRange:wordRange]];
    }
    return characters;
}

- (void)updateUI
{
    self.colorfulCharactersLabel.text = [NSString stringWithFormat:@"%d colorful characters", [[self charactersWithAttribute:NSForegroundColorAttributeName] length]];
    self.outlinedCharactersLabel.text = [NSString stringWithFormat:@"%d outlined characters", [[self charactersWithAttribute:NSStrokeWidthAttributeName] length]];
    self.whitespaceCharactersLabel.text = [NSString stringWithFormat:@"%d white-space character", [[self charactersMatchingRegex:@"\\s"] length]];
    self.alphanumericCharactersLabel.text = [NSString stringWithFormat:@"%d alpha-numeric character", [[self charactersMatchingRegex:@"[a-z0-9]+"] length]];
    self.totalCharactersLabel.text = [NSString stringWithFormat:@"%d total characters", [self.textToAnalyze.string length]];
}

@end
