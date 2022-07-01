unit class Week;

has Date $.start-date where *.day-of-week == 1;
has Date $.end-date; # where *.day-of-week == 7;

multi method new(Date $date) {
    my $temp-date = $date.clone;

    while $temp-date.day-of-week != 1 {
        $temp-date = $temp-date.earlier(day => 1);
    }

    self.bless(start-date => $temp-date, end-date => $temp-date.later(week => 1));
}

multi method new(Date $start-date, Date $end-date) {
    self.bless(start-date => $start-date, end-date => $end-date);
}

method earlier(Int :$week!) {
    $!start-date = $!start-date.earlier(week => $week);
    $!end-date = $!end-date.earlier(week => $week);
}

method later(Int :$week!) {
    $.start-date.later(week => $week);
    $.end-date.later(week => $week);
}