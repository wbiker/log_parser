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
            if @errors.elems > 0 and @errors[*-1] eq $line {
                next;
            }

            if $current_error.chars > 0 {
                $current_error ~= "\n" ~ $line;
            } else {
                $current_error ~= $line;
            }
        }

        if $line.starts-with("t/") and $current_error {
            @errors.push: $current_error;
            $current_error = "";
            next;
        }

        if $line.starts-with("t/") and $line.ends-with('..') {
            if $current_error {
                $current_error ~= $line;
                @errors.push: $current_error;
                $current_error = "";
                next;
            }

            warn;
            dd @errors;
            @errors[*-1] ~= $line;
            next;
        }
    }

    my $set = bag(@errors);
    say "'$_'" for $set.keys;
}