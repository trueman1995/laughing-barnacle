#!/usr/bin/perl -w

use strict;
use warnings;
use File::Find;

my $dir = "/local/armbruster/hg/Jamaica-8/jamaica";

find(\&do, $dir);

sub do
{
    my $file = $_;
    my $year = (localtime)[5] + 1900;
    local $/ = undef;
    if ($file =~ /.*\.(java|c)$/){

        open (current_file, $file) or die "Error opening $file";
        my $file_as_string = <current_file>;
        close current_file;

        if ($file_as_string  =~ /(\/\*.{0,150}aicas GmbH.*?\*\/)/s){

            open (tmp_file,">","$file.tmp") or die "Error opening $file";
            print "$file\n";
            my $first_commit_date = "";

            if ($file_as_string  =~ /Copyright (\d{4})((-|, )(\d{4}))?, aicas/){
                my $tmp_string = $1;
                $tmp_string =~ /(\d{4})/;
                $first_commit_date = $1;
            }else{
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

            print tmp_file $file_as_string;
            close tmp_file;
            rename("$file.tmp", $file);
        }
    }
}