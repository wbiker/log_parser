use DBIish;

unit class Exporter::Sqlite;

has $.dbh = DBIish.connect('SQLite', :database<tests.sqlite3>);

method drop-table() {
    $.dbh.execute(q:to/STATEMENT/);
        DROP TABLE IF EXISTS builds;
        STATEMENT

    $.dbh.execute(q:to/STATEMENT/);
        DROP TABLE IF EXISTS test_files;
        STATEMENT

    $.dbh.execute(q:to/STATEMENT/);
        DROP TABLE IF EXISTS test_numbers;
        STATEMENT
}

method create-table() {
    $.dbh.execute(q:to/STATEMENT/);
    CREATE TABLE IF NOT EXISTS builds (
        id INTEGER PRIMARY KEY,
        number INTEGER,
        status TEXT
    );
    STATEMENT

    $.dbh.execute(q:to/STATEMENT/);
    CREATE TABLE IF NOT EXISTS test_files (
        id INTEGER PRIMARY KEY,
        name TEXT
    );
    STATEMENT

    $.dbh.execute(q:to/STATEMENT/);
    CREATE TABLE IF NOT EXISTS test_numbers (
        id INTEGER PRIMARY KEY,
        build_id INTEGER,
        test_id INTEGER,
        number INTEGER,
        date INTEGER
    );
    STATEMENT
}

method get-builds() {
    my $sth = $.dbh.execute('SELECT * FROM builds');

    my @builds = $sth.allrows(:array-of-hash);
    $sth.dispose;

    return @builds;
}

method get-build(Int $number) {
    my $sth = $.dbh.execute('SELECT * from builds where number = ?', $number);
    my %build = $sth.row(:hash);
    $sth.dispose;

    return %build;
}

method store-build(Int $number, Str $status) {
    $.dbh.execute('INSERT INTO builds (number, status) VALUES (?, ?)', $number, $status);

    return self.get-build($number)<id>;
}

method get-test-file-id(Str $name) {
    my $sth = $.dbh.execute('SELECT id FROM test_files where name = ?', $name);
    my %test-file = $sth.row(:hash);
    return %test-file<id> if %test-file.elems;

    $.dbh.execute('INSERT INTO test_files (name) VALUES (?)', $name);

    return $.dbh.execute('SELECT id FROM test_files where name = ?', $name).row[0];
}

method store-test-number(Int $build_id, Int $test_file_id, Int $number, Int $date) {
   $.dbh.execute('INSERT INTO test_numbers (build_id, test_id, number, date) VALUES (?, ?, ?, ?)', $build_id, $test_file_id, $number, $date);
}

method get-tests($startdate, $name, $build) {
    my @tests;
    if $name {
       @tests = $.dbh.execute('SELECT * from test_files where name = ?', $name).allrows(:array-of-hash)
    } elsif $build {
        my $build_info = $.dbh.execute('SELECT id from builds where number = ?', $build.Int);
        $build_info = $build_info.row(:hash);
        return unless $build_info.elems;

        my @test_numbers = $.dbh.execute('SELECT * from test_numbers JOIN test_files ON test_id = test_files.id where build_id = ?', $build_info<id>).allrows(:array-of-hash);
        my @all_data;
        my %test_number;
        for @test_numbers {
            %test_number{$_<name>}{$_<number>}.push: "{DateTime.new($_<date>).Date}({$build})";
        }
        for %test_number.kv -> $name, $numbers {
            @all_data.push: { test => $name, numbers => $numbers };
        }

        return @all_data;
    } else {
        @tests = $.dbh.execute('SELECT * from test_files order by name').allrows(:array-of-hash)
    }

    my $epoch = 0;
    if $startdate {
        $epoch = DateTime.new($startdate ~ 'T00:00:00Z').posix;
    }

    my $sth = $.dbh.prepare('SELECT num.number, num.date, build.number as build FROM test_numbers as num JOIN builds as build On build.id = num.build_id where test_id = ? and date >= ? order by num.number ASC, num.date DESC, build.number DESC');
    my @all_data;
    for @tests -> %test_file {
        my @test_numbers = $sth.execute(%test_file<id>, $epoch).allrows(:array-of-hash);
        if @test_numbers {
            my %test_number;
            for @test_numbers -> $number {
                %test_number{$number<number>}.push: "{DateTime.new($number<date>).Date}({$number<build>})";
            }
            @all_data.push: { test => %test_file<name>, numbers => %test_number };
        }
    }

    return @all_data;
}
