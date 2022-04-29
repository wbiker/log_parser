unit class SimpleLogParser;

method parse(@lines) {
    my $tests = False;
    my $error_found = False;
    my @errors;
    my $current_error = "";

    for @lines -> $line {
        if $line.contains('prove -l -I../lib') {
            $tests = True;
            next;
        }

        next unless $tests;

        if $line ~~ /'Test Summary Report'/ {
            $tests = False;
            last;
        }

        if not $line.starts-with("t/") {
            $current_error ~= $line ~ "\n";
        }

        if $line.starts-with("t/") and $current_error {
            @errors.push: $current_error;
            $current_error = "";
            next;
        }
    }

    .say for @errors;
}