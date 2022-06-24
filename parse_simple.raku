use SimpleLogParser;

sub MAIN($log) {
    my @loglines = $log.IO.lines;

    SimpleLogParser.new.parse(@loglines);
}
