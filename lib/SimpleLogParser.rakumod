unit class SimpleLogParser;

method parse(@lines) {
    my $tests = False;
    my $error_found = False;

    for @lines -> $line {
        if $line.contains('prove -l -I../lib') {
            $tests = True;
            next;
        }

        next unless $tests;

        next if $line ~~ /\s 'ok' $/;

        if $line ~~ /'#' \s+ 'Failed test'/ {
            $error_found = True;
            say $line;
            next;
        }

        if $line ~~ /'...' \s* $/ {
            $error_found = False;
            say $line;
            next;
        }

        say $line if $error_found;
    }
}