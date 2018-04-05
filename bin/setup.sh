#!/bin/bash
set -e

# Install RCM
if ! command -v rcup >/dev/null 2>&1
then
    case "$(uname -s)" in
        Linux*)
            sudo add-apt-repository -y ppa:martin-frost/thoughtbot-rcm && \
            apt-get update && \
            apt-get install -y rcm
            ;;

        Darwin*)
            brew tap thoughtbot/formulae
            brew install rcm
            ;;

        CYGWIN*)
            curl -LO https://thoughtbot.github.io/rcm/dist/rcm-1.3.1.tar.gz && \
            sha=$(sha256 rcm-1.3.1.tar.gz | cut -f1 -d' ') && \
            [ "$sha" = "9c8f92dba63ab9cb8a6b3d0ccf7ed8edf3f0fb388b044584d74778145fae7f8f" ] && \
            tar -xvf rcm-1.3.1.tar.gz && \
            cd rcm-1.3.1 && \
            ./configure --prefix=/usr/local && make && sudo make install
            ;;
        *)
            echo "Platform not supported"
            exit 1
            ;;
    esac
fi

# Use RCM to install dotfiles
env RCRC=$(realpath "${BASH_SOURCE%/*}/../rcrc") rcup -v

