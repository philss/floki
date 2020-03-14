#!/bin/sh

set -e

parser_name=$1

MIX_ENV=test mix test.with_parser.$parser_name --color
