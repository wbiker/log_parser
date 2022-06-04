use v6.d;

class Model::Tests {
    has $.db is required;

    method get-projects() {
        my @projects = $!db.get-projects();

        return @projects;
    }

    method get-project(Int $project-id) {
        return $!db.get-project($project-id);
    }
}
