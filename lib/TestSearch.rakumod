role TestSearch {
    has @.tests;

    method check(@tests) {...}
}

class AndTest does TestSearch {
    has TestSearch $.test is required;
    has TestSearch $.other-test is required;

    method check(@tests) {
        my @test-search = $!test.check(@tests);
        return $!other-test.check(@test-search);
    }
}

class OrTest does TestSearch {
    has TestSearch $.test is required;
    has TestSearch $.other-test is required;

    method check(@tests) {
        my @first-tests = $!test.check(@tests);
        my @other-tests = $!other-test.check(@tests);

        for @other-tests -> $test {
            if not $test (elem) @first-tests {
                @tests.push: $test;
            }
        }

        return @first-tests;
    }
}

class TestCount does TestSearch {
    has $.threshold is required;

    method check(@tests) {
        my @matchedTests;
        for @tests -> $test {
            @matchedTests.push: $test if $test.count >= $!threshold;
        }

        return @matchedTests;
    }
}

class TestName does TestSearch {
    has $.name is required;

    submethod TWEAK() {
        $!name = $!name.lc.trim;
    }

    method check(@tests) {
        my @matchedTests;
        for @tests -> $test {
            @matchedTests.push: $test if $test.name.lc.trim.contains($!name);
        }
        return @matchedTests;
    }
}

class TestStarttime does TestSearch {
    has $.starttime is required;

    method check(@tests) {
        my @matchedTests;
        for @tests -> $test {
            @matchedTests.push: $test if $test.starttime >= $!starttime;
        }
        return @matchedTests;
    }
}

class TestWithoutErrors does TestSearch {
    method check(@tests) {
        my @matched-tests;
        for @tests -> $test {
            if $test.errors.elems > 0 {
                @matched-tests.push: $test;
            }
        }

        return @matched-tests;
    }
}
