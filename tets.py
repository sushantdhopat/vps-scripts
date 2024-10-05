import requests
import sys

# Define the path to the file containing the raw HTTP request headers
request_headers_file = 'req.txt'

# Read the raw HTTP request headers from the file
with open(request_headers_file, 'r') as f:
    raw_request_headers = f.read()

# Split the raw request headers into lines
request_lines = raw_request_headers.strip().split('\n')

# Parse the request method and path from the first line
request_line = request_lines[0].strip().split()
request_method = request_line[0]
request_path = request_line[1]

# Extract the host from the headers
host_header = [line for line in request_lines if line.startswith('Host:')][0]
host = host_header.split(':')[1].strip()

# Create the URL for the request
url = f'https://{host}{request_path}'

# Create a dictionary to store the headers
headers = {}

# Iterate through the request headers and add them to the headers dictionary
for line in request_lines[1:]:
    key, value = line.split(':', 1)
    headers[key.strip()] = value.strip()

# Add the "Authorization: Bearer" header to the headers dictionary if needed
# Replace 'YOUR_ACCESS_TOKEN_HERE' with your actual bearer token
headers['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjY1MTksImlhdCI6MTY5NDU5NjE1NywiZXhwIjoxNjk3MTg4MTU3fQ.Rie5IrvQslH_1L3WqgageDmE-0BGSs2lUWQn0J9_MOw'

# Create a session for making requests
auth = requests.Session()

try:
    # Send the authenticated request with the provided headers
    response = auth.request(request_method, url, headers=headers)
    
    # Print the response details
    print('URL:', response.url)
    print('Status Code:', response.status_code)
    print('Content Length:', len(response.content))
    print('\nResponse Headers:')
    for key, value in response.headers.items():
        print(f'{key}: {value}')
    
    # Print the response content if needed
    # print('\nResponse Content:')
    # print(response.text)

except requests.exceptions.RequestException as e:
    print('Error occurred:', str(e))

