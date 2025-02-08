# quick method to get JSON object from respose.body
#
def parsed_json
  JSON.parse(response.body)
end
