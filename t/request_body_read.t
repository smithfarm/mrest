# ************************************************************************* 
# Copyright (c) 2014-2022, SUSE LLC
# 
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
# 
# 3. Neither the name of SUSE LLC nor the names of its contributors may be
# used to endorse or promote products derived from this software without
# specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
# ************************************************************************* 

# ------------------------
# t/request_body_read.t
# ------------------------
#
# Test our ability to read the request body
#

#!perl
use 5.012;
use strict;
use warnings;

use App::CELL qw( $CELL $log $meta );
use Data::Dumper;
use HTTP::Request;
use Encode qw( encode_utf8 );
use JSON;
use Test::More;
use Test::Warnings;
use Web::MREST::Test qw( initialize_unit );
use utf8;

sub req {
    my ( $method, $uri, @args ) = @_;
    my $body = encode_utf8( join( ' ', @args ) );
    my $headers = [
        'content-type' => 'application/json',
        'content-length' => length $body,
    ];
    return HTTP::Request->new( $method, $uri, $headers, $body );
}

my $request_body;

my $test = initialize_unit();

my $response = $test->request( req( 'POST', 'echo', '{ "body_text" : "ŘČĹ" }' ) );
my $from_json = JSON->new->utf8(1)->decode( $response->content );
isa_ok( $response, 'HTTP::Response' );
is( $response->code, 200 ); # handler 'MyFoo::test' does not exist
is( $from_json->{'payload'}->{'body_text'}, "ŘČĹ" );

done_testing;
