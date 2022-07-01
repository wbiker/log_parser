unit class Month;

has Date $.start-date where *.day == 1;
has Date $.end-date where {$_.day == $_.days-in-month};
has %number-to-name = 
    1 => 'Jannuar',
    2 => 'February',
    3 => 'March',
    4 => 'April',
    5 => 'May',
    6 => 'June',
    7 => 'July',
    8 => 'August',
    9 => 'Septemper',
    10 => 'October',
    11 => 'November',
    12 => 'December';

multi method new(Date $date) {
    my $start-date = Date.new(year => $date.year, month => $date.month, day => 1);
    my $end-date = Date.new(year => $date.year, month => $date.month, day => $date.days-in-month);

    self.bless(:$start-date, :$end-date);
}

multi method new(Int $month-number) {
    my $now = DateTime.now;
    my $start-date = Date.new(year => $now.year, month => $month-number, day => 1);
    my $end-date = Date.new(year => $start-date.year, month => $month-number, day => $start-date.days-in-month);

    self.bless(:$start-date, :$end-date);
}

method start-date-posix() {
    return $!start-date.DateTime.posix;
}

method end-date-posix() {
    return $!end-date.succ.DateTime.posix;
}

method earlier(Int $month) {
    $!start-date = $!start-date.earlier(:$month);
    my $tmp = $!end-date.earlier(:$month);
    $!end-date = DateTime.new(year => $tmp.year, month => $tmp.month, day => $tmp.days-in-month).Date;
}

method later(Int :$month!) {
    $.start-date.later(:$month);
    $.end-date.later(:$month);
}

method month-name() {
    return %!number-to-name{$!start-date.month};
}

method get-month-names() {
    my $loop-month = self.clone;

    my @months;
    for (^6) {
        @months.push: { id => $loop-month.start-date.month, name => $loop-month.month-name }; 

        $loop-month.earlier(1);
    }
    
    return @months;
}