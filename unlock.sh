#!/bin/sh

# Key generated with command:
# $ gpg --symmetric --cipher-algo AES256 --output - -- .git/git-crypt/keys/default | base64

KEY="jA0ECQMCgOpTOUmQNPzr0sAFAWk8ivQyFZDFlQGY3wwV6SRIpIQbnnFqWxmg0URNseCzvXh5XeAw
vnOCNCUZoRaBsEXYqu0wNEDWQEt3vfbR6scIrpsBwNm1VsiXxZGtHzXS3Ygor0MZeT2kiO8hLiXZ
LlIk0bRNVTshWstMYSS5df2EvQ0jm6q9T6wPq/rvhgOQ0YJUcHRDc/co6F+RQkDHoN2sjD8IlcHV
sKRFrPHRdM1bMuizpyaVclpdipSI5lqg0S1S6hg3BPZy8cQf7w6J8Tq7PGk="

GPG_TTY=$(tty)  # Needed so we can decrypt from stdin.
export GPG_TTY

echo "$KEY" | base64 -d | gpg -d | git crypt unlock -

