#! /bin/bash
#
#API docs here: https://support.datacite.org/docs/consuming-citations-and-references

doi="10.7914/SN/II"
api_url="https://api.datacite.org/works/$doi"

# Use curl to fetch metadata from DataCite API
response=$(curl -s $api_url)

# Extract citation count from the JSON response
citation_count=$(echo $response | jq -r '.data.attributes."citation-count"')

# Check if citation_count is null and set to 0 if true
if [ "$citation_count" == "null" ]; then
  citation_count=0
fi

# Print the citation count
echo "Citation count for DOI $doi: $citation_count"
