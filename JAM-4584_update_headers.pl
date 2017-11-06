#!/usr/bin/perl -w

use strict;
use warnings;
use File::Find;

my $dir = shift or die "Usage: $0 ABSOLUTE_PATH_TO_DIRECTORY\n";

find(\&do, $dir);

sub do
{
    my $file = $_;
    if ($file =~ /.*\.(java|c)$/){

        my $year = (localtime)[5] + 1900;
        open (current_file, $file) or die "Error opening $file";
        open (tmp_file,">","$file.tmp") or die "Error opening $file";
        print "$file\n";

        while (<current_file>){

            my $line =$_;
            if ($line =~ /Copyright.*?aicas GmbH/){
                $line =~ /(19\d\d|20\d\d)/;
                if ($1 && $1 eq $year){
                    print tmp_file " * Copyright $year, aicas GmbH; all rights reserved.\n";
                }else {
                    print tmp_file " * Copyright $1-$year, aicas GmbH; all rights reserved.\n";
                }
            }else {
                print tmp_file $line;
            }
        }
        close tmp_file;
        close current_file;
        rename("$file.tmp", $file);
    }
}