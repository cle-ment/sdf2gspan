#!/usr/bin/perl

# split_dataset <num training samples> <in_dataset> <out_train> <out_test>

$size_of_trainingset = @ARGV[0];
$in_dataset = @ARGV[1];
$out_train = @ARGV[2];
$out_test = @ARGV[3];

open(my $f_in_dataset, "<", $in_dataset)
	or die "cannot open $in_dataset: $!";

open(my $f_out_train, ">", $out_train)
	or die "cannot open $out_train: $!";

open(my $f_out_test, ">", $out_test)
	or die "cannot open $out_test: $!";

$training = 1;

while (<$f_in_dataset>) {

	# check if still training or already test set
	if (/t/) {
		($t, $hash, $num, $label) = split /\s+/;
		if ($num > $size_of_trainingset) {
			$training = 0;
		}
	}

	if ($training == 1) {
		print $f_out_train $_;
	} else {
		print $f_out_test $_;
	}

}

close $f_in_dataset;
close $f_out_train;
close $f_out_test;
