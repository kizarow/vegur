%%% Copyright (c) 2013-2015, Heroku Inc <routing-feedback@heroku.com>.
%%% All rights reserved.
%%%
%%% Redistribution and use in source and binary forms, with or without
%%% modification, are permitted provided that the following conditions are
%%% met:
%%%
%%% * Redistributions of source code must retain the above copyright
%%%   notice, this list of conditions and the following disclaimer.
%%%
%%% * Redistributions in binary form must reproduce the above copyright
%%%   notice, this list of conditions and the following disclaimer in the
%%%   documentation and/or other materials provided with the distribution.
%%%
%%% * The names of its contributors may not be used to endorse or promote
%%%   products derived from this software without specific prior written
%%%   permission.
%%%
%%% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
%%% "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
%%% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%%% A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
%%% OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
%%% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
%%% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
%%% DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
%%% THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
%%% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
%%% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-module(vegur_midjan_translator).

-define(LOGMODULE, vegur_request_log).

-export([run/2]).

run(MiddlewareModule, {Req, Env}) ->
    case MiddlewareModule:execute(Req, Env) of
        {ok, Req1, Env1} ->
            {next, {Req1, Env1}};
        {halt, _Req} = C ->
            %% The request is being halted, After that we run the logging
            %% middleware. The connection _will not_ be reused until
            %% after the logging middleware has run. It would be possible
            %% to flush the response here, but that would not help with
            %% reusing the socket.
            % ok = cowboyku_req:ensure_response(Req, 204),
            {stop, C};
        {halt, _StatusCode, _Req} = C ->
            %% The request is being halted, After that we run the logging
            %% middleware. The connection _will not_ be reused until
            %% after the logging middleware has run. It would be possible
            %% to flush the response here, but that would not help with
            %% reusing the socket.
            % ok = cowboyku_req:ensure_response(Req, 204),
            {stop, C};
        {error, _StatusCode, _Req} = C ->
            % ok = cowboyku_req:ensure_response(Req, StatusCode),
            {stop, C}
    end.
