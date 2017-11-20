#!/usr/bin/perl -w

use strict;
use warnings;
use File::Find;

#take absolute path to directory as commandline argument or throw error and quit'
my $dir = shift or die "\[CRHeader\] Usage: $0 ABSOLUTE_PATH_TO_DIRECTORY\n";
my $counter = 0;

find(\&do, $dir);

print "\[CRHeader\] updated $counter files";

sub do
{
    my $file = $_;
    if ($file =~ /.*\.(java|c)$/){

        my $year = (localtime)[5] + 1900;
        #open file and file.tmp or throw error and quit
        open (current_file, $file) or die "\[CRHeader\] Error opening $file";
        open (tmp_file,">","$file.tmp") or die "\[CRHeader\] Error opening $file.tmp";

        while (<current_file>){
            #parse the file and replace the dates of copyright headers
            my $line =$_;
            if ($line =~ /Copyright.*?aicas GmbH/){
                $line =~ /(19\d\d|20\d\d)/;
                if ($1 && $1 eq $year){
                    print tmp_file " * Copyright $year, aicas GmbH; all rights reserved.\n";
                }elsif(!$1) {
                    print "\[CRHeader\] updating $file\n";
                    $counter++;
                    print tmp_file " * Copyright $year, aicas GmbH; all rights reserved.\n";
                }else{
                    print "\[CRHeader\] updating $file\n";
                    $counter++;
                    print tmp_file " * Copyright $1-$year, aicas GmbH; all rights reserved.\n";
                }
            }else {
                print tmp_file $line;
            }
        }
        #close files, rename file.tmp to file (replacing original file with tmp file)
        close tmp_file;
        close current_file;
        rename("$file.tmp", $file);
    }
}