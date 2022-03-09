unit class JenkinsTest;

has $.name;
has $.count;
has $.starttime;
has %.failed_tests;

submethod BUILD(:%test) {
    $!name = %test<name>;
    $!count = %test<count>;
    my $date = DateTime.new(%test<starttime> ~ "T00:00:00Z");
    $!starttime = $date;
    %!failed_tests = %test<failed_tests>;
}

submethod Str() {
    return
        "$!name\n\tcount: $!count\n"
        ~ (~ "\t" ~ $_ ~"\n" for %!failed_tests.pairs.sort(*.key.Int));
}
