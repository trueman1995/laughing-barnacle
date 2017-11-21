#!/usr/bin/perl -w

# Copyright 2017, aicas GmbH, all rights reserved
# author Felix Armbruster - felix.armbruster@aicas.com

# Adds copyright headers to files lacking a header (using the date of first commit as starting date)
# If you want to correct existing copyright headers to correct form, or update them to correct date, see other scripts in this directory
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

        if ($file_as_string  !~ /aicas GmbH/){

            $counter++;
            open (tmp_file,">","$file.tmp") or die "Error opening $file";
            #get date of first commit from mercurial (very slow, might take a while for a large amount of files)
            my @split = split(/-/, qx(hg log -l1 -r 0:tip --template "{date|isodate}" $file));
            my $first_commit_date = $split[0];
            my $replace = "$first_commit_date-$year";

            if ($first_commit_date eq $year){
                $replace = $year;
            }
            if ($file =~ /.*\.java$/){
                if ($file_as_string !~ /(\/\*.*Copyright.*rights reserved.*\*\/)/is){
                    $file_as_string = "\/\*------------------------------------------------------------------------\*\n \* Copyright $replace, aicas GmbH; all rights reserved.\n \* This header, including copyright notice, may not be altered or removed.\n \*------------------------------------------------------------------------\*\/\n\n" . $file_as_string;
                }else {
                    $file_as_string =~ s/(\/\*.*Copyright.*rights reserved.*?\*\/)/$1\n\n\/\*------------------------------------------------------------------------\*\n \* Copyright $replace, aicas GmbH; all rights reserved.\n \* This header, including copyright notice, may not be altered or removed.\n \*------------------------------------------------------------------------\*\//is;
                }
            }elsif ($file =~ /.*\.c$/){
                if ($file_as_string !~ /(\/\*.*Copyright.*rights reserved.*\*\/)/is){
                    $file_as_string = "\/\***********************************************************************\*\n \* Copyright $replace, aicas GmbH; all rights reserved.\n \* This header, including copyright notice, may not be altered or removed.\n \***********************************************************************\*\/\n\n" . $file_as_string;
                }else {
                    $file_as_string =~ s/(\/\*.*Copyright.*rights reserved.*?\*\/)/$1\n\n\/\***********************************************************************\*\n \* Copyright $replace, aicas GmbH; all rights reserved.\n \* This header, including copyright notice, may not be altered or removed.\n \***********************************************************************\*\//is;
                }
            }
            #printing and replacing updated file
            print "\[CRHeader\] updating $file\n";
            print tmp_file $file_as_string;
            close tmp_file;
            rename("$file.tmp", $file);

        }
    }
}