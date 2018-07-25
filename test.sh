#!/bin/bash
curl -qs localhost:8080 | pandoc -f html -t markdown
