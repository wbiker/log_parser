# use Grammar::Debugger;
# use Grammar::ErrorReporting;
# use Grammar::PrettyErrors;

grammar FailedTests {
    token TOP {
        .*? <test_prefix>? <tests>+ .*?
    }

    token test_prefix {
        'Failed tests:' \s+
    }
    token tests { <test_number> | <test_range> | <test_exception> }
    token test_number {
        <number> ','? \s*
    }
    token test_range {
        $<range_start>=<number> '-' $<range_end>=<number> ','? \s*
    }
    token number { \d+ }
    token test_exception { \s* <('Parse errors: No plan found in TAP output')> }
}

class Action::FailedTests {
    method TOP($/) {
        make $<tests>>>.made.list
    }

    method tests($/) {
        if $<test_exception> {
            make $<test_exception>.made;
            return;
        }
        make $<test_number>.made ?? $<test_number>.made !! $<test_range>.made;
    }

    method test_number($/) {
        make $<number>.Int
    }

    method test_range($/) {
        make $<range_start>.Int .. $<range_end>.Int
    }

    method test_exception($/) {
        make -1;
    }
}
