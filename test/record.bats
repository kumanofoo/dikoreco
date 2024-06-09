#!/usr/bin/env bats

LOGFILE="${HOME}/.dikoreco.log"

teardown() {
    rm -f rectest*.m4a
    rm -f ${LOGFILE}
    rm -f m4atag.json
    rm -f list.txt
}

@test "Show usage" {
    rm -f ${LOGFILE}
    
    run ./dikoreco
    [ "$status" -eq 1 ]
    [ "$output" = "$(cat test/dikoreco.help)" ]
}

@test "Parsing recording time failed" {
    rm -f ${LOGFILE}
    
    result="$(./dikoreco rectest ooo RN1; grep -c "failed recording time" ${LOGFILE})"
    [ "$result" -eq 1 ]
}

@test "Unknown channel" {
    rm -f ${LOGFILE}
    
    result="$(./dikoreco rectest 1 XYZ; grep -c "failed to record" ${LOGFILE})"
    [ "$result" -eq 1 ]
}

@test "Record sound from Radiko" {
    rm -f rectest*.m4a
    rm -f ${LOGFILE}
    
    run ./dikoreco rectest 1 RN1
    [ "$status" -eq 0 ]

    result="$(grep -c "finish ./rectest_" ${LOGFILE})"
    [ "$result" -eq 1 ]
    
    result="$(file rectest*.m4a | grep -c "Apple iTunes")"
    [ "$result" -eq 1 ]
}

@test "Record sound from Radiko with m4atag" {
    rm -f rectest*.m4a
    rm -f ${LOGFILE}
    cp test/m4atag_normal.json m4atag.json
    
    run ./dikoreco rectest 1 RN1
    [ "$status" -eq 0 ]
    
    result="$(grep -c "finish ./rectest_" ${LOGFILE})"
    [ "$result" -eq 1 ]
    
    result="$(file rectest*.m4a | grep -c "Apple iTunes")"
    [ "$result" -eq 1 ]

    result="$(./m4atag -s rectest*.m4a | grep -c -e personality -e program -e year -e genre -e title -e encoder)"
    [ "$result" -eq 6 ]
}


