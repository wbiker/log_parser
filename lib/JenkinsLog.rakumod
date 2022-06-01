grammar JenkinsLog {
    token TOP {
        .*? <finished> .*?
    }

    token finished {
        'Finished:' \s $<status>=<-[\n]>+ \n
    }
}

grammar JenkinsLog::TestSummaryReport {
    token TOP {
        .*? <header> \n <ruler>  \n <test_fail>+ .*?
    }

    token header { 'Test Summary Report' }
    token ruler { '-'+ }
    token test_fail {
        $<test_name>=<-[\s]>+ <-[\n]>+ \n <test_error>+
    }
    token test_error {
        \s+ $<error>=<-[\n]>+ \n
    }
}

class Action::JenkinsLog::TestSummaryReport {
    method TOP($/) {
        make [$<test_fail>>>.made];
    }
    method test_fail($/) {
        make %(
            name => $<test_name>.Str,
            errors => [
                $<test_error>>>.made
            ],
        );
    }
    method test_error($/) {
        make $<error>.Str;
    }
}

