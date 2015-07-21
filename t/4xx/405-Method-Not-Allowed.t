# ************************************************************************* 
# Copyright (c) 2014-2015-2015, SUSE LLC
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
# t/405-Method-Not-Allowed.t
# ------------------------
#
# Send HTTP requests to trigger "405 Method Not Allowed" (i.e., negative tests only)
#

#!perl
use 5.012;
use strict;
use warnings FATAL => 'all';

use App::CELL qw( $log $site );
use Data::Dumper;
use Test::Deep;
use Test::More;
use Web::MREST::Test qw( initialize_unit llreq );

my $test = initialize_unit();
my ( $request, $response );

#
# check MREST_SUPPORTED_HTTP_METHODS
#
cmp_deeply( 
    $site->MREST_SUPPORTED_HTTP_METHODS, 
    bag( qw( GET PUT POST DELETE TRACE CONNECT OPTIONS ) ),
    'does MREST_SUPPORTED_HTTP_METHODS contain what we expect',
);

#
# 'bugreport' is defined for 'GET' only, so we check that all remaining
# methods produce 405
#
foreach my $method ( qw( PUT POST DELETE TRACE CONNECT OPTIONS ) ) {
    $response = $test->request( llreq( $method, 'bugreport' ) );
    my $response_code = $response->code;
    is( $response_code, 405 );
    if ( $response_code != 405 ) {
        diag( "Received response code $response_code, which is not 405! Bailing out." );
        BAIL_OUT(0);
    }
    is( $response->header( 'allow' ), 'GET' );
}

done_testing;
