use v6.d;

use Month;

class Model::Tests {
    has $.db is required;

    method get-projects() {
        my @projects = $!db.get-projects();

        return @projects;
    }

    multi method get-project(Int $project-id) {
        return $!db.get-project($project-id);
    }

    multi method get-project(Int $project-id, Month $month) {
        return $!db.get-project($project-id, $month);
    }

    method get-test-file-data(Int $test-file-id) {
        return $!db.get-test-file-data($test-file-id);
    }
}
