#!/usr/bin/env bats

setup() {
    rm -f ./m4atag.json
    rm -f test/rectest_1970-01-01.m4a
    rm -f test/rectest_*_1970-01-01.m4a
}

teardown() {
    rm -f ./m4atag.json
    rm -f test/rectest_1970-01-01.m4a
    rm -f test/rectest_*_1970-01-01.m4a
}

@test "Show usage" {
    run ./m4atag -h
    [ "$status" -eq 0 ]
    [ "$output" = "$(cat test/m4atag.help)" ]
}

@test "Show m4a tag" {
    cp test/rectest_1970-01-01.m4a.orig test/rectest_1970-01-01.m4a
    
    run ./m4atag -s test/rectest_1970-01-01.m4a
    [ "$status" -eq 0 ]
    [ "$output" = "$(cat test/rectest_1970-01-01.orig.tag)" ]
}

@test "Run without tag information" {
    cp test/rectest_1970-01-01.m4a.orig test/rectest_1970-01-01.m4a
    
    run ./m4atag test/rectest_1970-01-01.m4a
    [ "$status" -eq 0 ]
    
    run ./m4atag -s test/rectest_1970-01-01.m4a
    [ "$status" -eq 0 ]
    [ "$output" = "$(cat test/rectest_1970-01-01.orig.tag)" ]
}

@test "Add m4a tag with tag information" {
    cp test/rectest_1970-01-01.m4a.orig test/rectest_1970-01-01.m4a
    cp test/m4atag_normal.json ./m4atag.json
    
    run ./m4atag test/rectest_1970-01-01.m4a
    [ "$status" -eq 0 ]
    
    run ./m4atag -s test/rectest_1970-01-01.m4a
    [ "$status" -eq 0 ]
    [ "$output" = "$(cat test/rectest_1970-01-01.new.tag)" ]
}

@test "Add m4a tag with artwork" {
    cp test/m4atag_normal_with_artwork.json ./m4atag.json
    for f in png jpg jpeg; do
	cp test/rectest_1970-01-01.m4a.orig test/rectest_${f}_1970-01-01.m4a
	run ./m4atag test/rectest_${f}_1970-01-01.m4a
	[ "$status" -eq 0 ]

	run ./m4atag -s test/rectest_${f}_1970-01-01.m4a
	[ "$status" -eq 0 ]
	[ "$output" = "$(cat test/rectest_${f}_1970-01-01.new.tag)" ]
    done
}

@test "JSON syntax error" {
    cp test/m4atag_error.json ./m4atag.json
    
    run ./m4atag
    [ "$status" -eq 1 ]
}

@test "Ignore non-support format" {
    run ./m4atag -s test/rectest_1970-01-01.aac
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}
