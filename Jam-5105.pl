use strict;
use warnings;
use File::Find;

my $dir = "/local/armbruster/hg/Builds/doc/";

find(\&do, $dir);

sub do
{
    my $file = $_;
    local $/ = undef;
    if ($file =~ /.*\.html$/){

        open (current_file, $file) or die "Error opening $file";
        my $file_as_string = <current_file>;
        close current_file;
        if ($file_as_string =~ /<a href=\".*?technotes/is){
            print $file . "\n";
            open (tmp_file, ">", "$file.tmp") or die "Error opening $file";
            $file_as_string =~ s/<a href=.*?technotes/<a href=\"https:\/\/docs\.oracle\.com\/javase\/8\/docs\/technotes/isg;
            print tmp_file $file_as_string;
            close tmp_file;
            rename("$file.tmp", $file);
        }
    }
}