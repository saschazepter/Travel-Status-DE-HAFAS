#!/usr/bin/env perl
use strict;
use warnings;
use 5.020;

use utf8;

use File::Slurp qw(read_file);
use JSON;
use Test::More tests => 61;

use Travel::Status::DE::HAFAS;

my $json
  = JSON->new->utf8->decode( read_file('t/in/DB.Berlin Jannowitzbrücke.json') );

my $status = Travel::Status::DE::HAFAS->new(
	service => 'DB',
	station => 'Berlin Jannowitzbrücke',
	json    => $json
);

is( $status->errcode, undef, 'no error code' );
is( $status->errstr,  undef, 'no error string' );

is(
	$status->get_active_service->{name},
	'Deutsche Bahn',
	'active service name'
);

is( scalar $status->results, 30, 'number of results' );

my @results = $status->results;

# Result 0: Bus

is( $results[0]->date, '02.10.2022', 'result 0: date' );
is(
	$results[0]->datetime->strftime('%Y%m%d %H%M%S'),
	'20221002 170500',
	'result 0: datetime'
);
is( $results[0]->delay, 10, 'result 0: delay' );
ok( !$results[0]->is_cancelled,        'result 0: not cancelled' );
ok( !$results[0]->is_changed_platform, 'result 0: platform not changed' );

for my $res ( $results[0]->line, $results[0]->train ) {
	is( $res, 'Bus  300', 'result 0: line/train' );
}
for my $res ( $results[0]->line_no, $results[0]->train_no ) {
	is( $res, 300, 'result 0: line/train number' );
}

is( $results[0]->operator, undef, 'result 0: no operator' );
is( $results[0]->platform, undef, 'result 0: platform' );

for my $res ( $results[0]->route_end, $results[0]->destination,
	$results[0]->origin )
{
	is( $res, 'Tiergarten, Philharmonie', 'result 0: route start/end' );
}

is( $results[0]->sched_date, '02.10.2022', 'result 0: sched_date' );
is(
	$results[0]->sched_datetime->strftime('%Y%m%d %H%M%S'),
	'20221002 165500',
	'result 0: sched_datetime'
);
is( $results[0]->sched_time, '16:55', 'result 0: sched_time' );
is( $results[0]->time,       '17:05', 'result 0: time' );
is( $results[0]->type,       'Bus',   'result 0: type' );

# Result 2: U-Bahn

is( $results[2]->date, '02.10.2022', 'result 2: date' );
is(
	$results[2]->datetime->strftime('%Y%m%d %H%M%S'),
	'20221002 170000',
	'result 2: datetime'
);
is( $results[2]->delay, 0, 'result 2: delay' );
ok( !$results[2]->is_cancelled,        'result 2: not cancelled' );
ok( !$results[2]->is_changed_platform, 'result 2: platform not changed' );

for my $res ( $results[2]->line, $results[2]->train ) {
	is( $res, 'U      8', 'result 2: line/train' );
}
for my $res ( $results[2]->line_no, $results[2]->train_no ) {
	is( $res, 8, 'result 2: line/train number' );
}

is( $results[2]->operator, undef, 'result 2: no operator' );
is( $results[2]->platform, undef, 'result 2: no platform' );

for my $res ( $results[2]->route_end, $results[2]->destination,
	$results[2]->origin )
{
	is( $res, 'Hermannstr. (S+U), Berlin', 'result 2: route start/end' );
}

is( $results[2]->sched_date, '02.10.2022', 'result 2: sched_date' );
is(
	$results[2]->sched_datetime->strftime('%Y%m%d %H%M%S'),
	'20221002 170000',
	'result 2: sched_datetime'
);
is( $results[2]->sched_time, '17:00', 'result 2: sched_time' );
is( $results[2]->time,       '17:00', 'result 2: time' );
is( $results[2]->type,       'U',     'result 2: type' );

# Result 3: S-Bahn

is( $results[3]->date, '02.10.2022', 'result 3: date' );
is(
	$results[3]->datetime->strftime('%Y%m%d %H%M%S'),
	'20221002 170100',
	'result 3: datetime'
);
is( $results[3]->delay, 0, 'result 3: delay' );
ok( !$results[3]->is_cancelled,        'result 3: not cancelled' );
ok( !$results[3]->is_changed_platform, 'result 3: platform not changed' );

for my $res ( $results[3]->line, $results[3]->train ) {
	is( $res, 'S      3', 'result 3: line/train' );
}
for my $res ( $results[3]->line_no, $results[3]->train_no ) {
	is( $res, 3, 'result 3: line/train number' );
}

is( $results[3]->operator, undef, 'result 3: no operator' );
is( $results[3]->platform, 4,     'result 3: platform' );

for my $res ( $results[3]->route_end, $results[3]->destination,
	$results[3]->origin )
{
	is( $res, 'Berlin-Spandau (S)', 'result 3: route start/end' );
}

is( $results[3]->sched_date, '02.10.2022', 'result 3: sched_date' );
is(
	$results[3]->sched_datetime->strftime('%Y%m%d %H%M%S'),
	'20221002 170100',
	'result 3: sched_datetime'
);
is( $results[3]->sched_time, '17:01', 'result 3: sched_time' );
is( $results[3]->time,       '17:01', 'result 3: time' );
is( $results[3]->type,       'S',     'result 3: type' );
