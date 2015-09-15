#! /bin/bash
mvn exec:exec >> imageServer.log 2>&1 &
exit 0
