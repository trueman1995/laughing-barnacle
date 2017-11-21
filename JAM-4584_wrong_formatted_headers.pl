#!/usr/bin/perl -w

# Copyright 2017, aicas GmbH, all rights reserved
# author Felix Armbruster - felix.armbruster@aicas.com

# Updates existing copyright headers to correct year and form 
# If you only want to update existing copyright headers to correct year, or want to add missing headers, see other scripts in this directory
# For further information regarding copyright headers see https://wiki.aicas.burg/wiki/index.php/Source_Code_Guidelines

use strict;
use warnings;
use File::Find;

#take absolute path to directory as commandline argument or throw error and quit
my $dir = shift or die "\[CRHeader\] Usage: $0 ABSOLUTE_PATH_TO_DIRECTORY\n";
my $counter = 0;

find(\&do, $dir);

print "\[CRHeader\] updated $counter files";

sub do
{
    my $file = $_;
    my $year = (localtime)[5] + 1900;
    local $/ = undef;
    if ($file =~ /.*\.(java|c)$/){
        #open file and read it
        open (current_file, $file) or die "Error opening $file";
        my $file_as_string = <current_file>;
        close current_file;

        if ($file_as_string  =~ /(\/\*.{0,150}aicas GmbH.*?\*\/)/s){

            open (tmp_file,">","$file.tmp") or die "Error opening $file";
            $counter++;
            my $first_commit_date = "";

            if ($file_as_string  =~ /Copyright (\d{4})((-|, )(\d{4}))?, aicas/){
                my $tmp_string = $1;
                $tmp_string =~ /(\d{4})/;
                $first_commit_date = $1;
            }else {
                #getting the first commit date from mercurial (very slow, might take long for a large amount of files)
            	my @split = split(/-/, qx(hg log -l1 -r 0:tip --template "{date|isodate}" $file));
                $first_commit_date = $split[0];
            }

            my $replace = "$first_commit_date-$year";

            if ($first_commit_date eq $year){
                $replace = $year;
            }
            if ($file =~ /.*\.java$/){
                $file_as_string =~ s/(\/\*.{0,150}aicas GmbH.*?\*\/)/\/\*------------------------------------------------------------------------\*\n \* Copyright $replace, aicas GmbH; all rights reserved.\n \* This header, including copyright notice, may not be altered or removed.\n \*------------------------------------------------------------------------\*\//s;
            }elsif ($file =~ /.*\.c$/){
                $file_as_string =~ s/(\/\*.{0,150}aicas GmbH.*?\*\/)/\/\***********************************************************************\*\n \* Copyright $replace, aicas GmbH; all rights reserved.\n \* This header, including copyright notice, may not be altered or removed.\n \***********************************************************************\*\//s;
            }
            #closing, printing and replacing updated file
            print "\[CRHeader\] updating $file\n";
            print tmp_file $file_as_string;
            close tmp_file;
            rename("$file.tmp", $file);
        }
    }
}